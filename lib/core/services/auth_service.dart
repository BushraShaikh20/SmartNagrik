import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/authority_model.dart';
import '../../models/citizen_model.dart';
import '../../models/field_officer_model.dart';
import '../../models/user_model.dart';
import '../constants/firestore_constants.dart';
import '../enums/user_role.dart';
import '../errors/firebase_exception_handler.dart';
import 'firebase_service.dart';

class _AccountRecord {
  final String email;
  final String phone;
  final String password;
  final UserModel user;

  _AccountRecord({
    required this.email,
    required this.phone,
    required this.password,
    required this.user,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
        'user': user.toMap(),
      };

  factory _AccountRecord.fromJson(Map<String, dynamic> json) {
    final userMap = Map<String, dynamic>.from(json['user'] as Map);
    return _AccountRecord(
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      user: _userFromMap(userMap),
    );
  }
}

UserModel _userFromMap(Map<String, dynamic> map) {
  final role = UserRole.fromString(map['role'] as String?);
  switch (role) {
    case UserRole.authority:
      return AuthorityModel.fromMap(map);
    case UserRole.fieldOfficer:
      return FieldOfficerModel.fromMap(map);
    case UserRole.citizen:
      return CitizenModel.fromMap(map);
    case UserRole.guest:
      return UserModel.fromMap(map);
  }
}

class AuthService extends ChangeNotifier {
  static const _localAccountsKey = 'sn_local_accounts_v1';
  static const _guestKey = 'sn_guest_profile_v1';

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _verificationId;
  int? _resendToken;

  final Map<String, _AccountRecord> _accounts = {};

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  UserRole get currentRole => _currentUser?.role ?? UserRole.citizen;
  String? get errorMessage => _errorMessage;
  bool get firebaseReady => FirebaseService.isReady;

  List<UserModel> get fieldOfficers {
    final fromMemory = _accounts.values
        .map((e) => e.user)
        .where((u) => u.role == UserRole.fieldOfficer)
        .toList();
    if (_currentUser?.role == UserRole.fieldOfficer &&
        fromMemory.every((u) => u.id != _currentUser!.id)) {
      fromMemory.add(_currentUser!);
    }
    return fromMemory;
  }

  AuthService() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _loadLocalAccounts();
    if (firebaseReady) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous) {
        _currentUser = await _profileFromFirebase(user);
        notifyListeners();
        return;
      }
    }
  }

  Future<void> _loadLocalAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localAccountsKey);
      if (raw == null || raw.isEmpty) return;
      final list = jsonDecode(raw) as List<dynamic>;
      for (final item in list) {
        final record =
            _AccountRecord.fromJson(Map<String, dynamic>.from(item as Map));
        if (record.email.isNotEmpty) {
          _accounts[record.email.toLowerCase()] = record;
        }
        if (record.phone.isNotEmpty) {
          _accounts[_digits(record.phone)] = record;
        }
      }
    } catch (_) {}
  }

  Future<void> _persistLocalAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final unique = <String, _AccountRecord>{};
    for (final record in _accounts.values) {
      unique[record.user.id] = record;
    }
    await prefs.setString(
      _localAccountsKey,
      jsonEncode(unique.values.map((e) => e.toJson()).toList()),
    );
  }

  String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  String normalizePhone(String input) {
    final digits = _digits(input);
    if (digits.length == 10) return '+91$digits';
    if (digits.length == 12 && digits.startsWith('91')) return '+$digits';
    if (input.trim().startsWith('+')) return '+$digits';
    return '+$digits';
  }

  UserModel _buildUser({
    required String id,
    required String fullName,
    required String email,
    required String phone,
    required UserRole role,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    switch (role) {
      case UserRole.authority:
        return AuthorityModel(
          id: id,
          fullName: fullName,
          email: email,
          phone: phone,
          photoUrl: photoUrl,
          createdAt: now,
          departmentId: '',
          designation: '',
          jurisdiction: '',
        );
      case UserRole.fieldOfficer:
        return FieldOfficerModel(
          id: id,
          fullName: fullName,
          email: email,
          phone: phone,
          photoUrl: photoUrl,
          createdAt: now,
          departmentId: '',
          departmentName: '',
        );
      case UserRole.guest:
        return UserModel(
          id: id,
          fullName: fullName,
          email: email,
          phone: phone,
          photoUrl: photoUrl,
          role: UserRole.guest,
          createdAt: now,
        );
      case UserRole.citizen:
        return CitizenModel(
          id: id,
          fullName: fullName,
          email: email,
          phone: phone,
          photoUrl: photoUrl,
          createdAt: now,
        );
    }
  }

  String _roleMismatchMessage(UserRole expected, UserRole actual) {
    return 'This account is registered as ${actual.label}. Please use the ${actual.label} login.';
  }

  Future<bool> loginAsCitizen({
    required String emailOrPhone,
    required String password,
  }) {
    return loginWithEmailOrPhone(
      emailOrPhone: emailOrPhone,
      password: password,
      expectedRole: UserRole.citizen,
    );
  }

  Future<bool> loginAsAuthority({
    required String emailOrPhone,
    required String password,
  }) {
    return loginWithEmailOrPhone(
      emailOrPhone: emailOrPhone,
      password: password,
      expectedRole: UserRole.authority,
    );
  }

  Future<bool> loginAsFieldOfficer({
    required String emailOrPhone,
    required String password,
  }) {
    return loginWithEmailOrPhone(
      emailOrPhone: emailOrPhone,
      password: password,
      expectedRole: UserRole.fieldOfficer,
    );
  }

  Future<bool> loginWithEmailOrPhone({
    required String emailOrPhone,
    required String password,
    required UserRole expectedRole,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (firebaseReady) {
        final identifier = emailOrPhone.trim();
        if (!identifier.contains('@')) {
          _fail('Use email & password here, or continue with mobile OTP.');
          return false;
        }
        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: identifier,
          password: password,
        );
        final user = cred.user;
        if (user == null) {
          _fail('Unable to sign in. Please try again.');
          return false;
        }
        final profile = await _profileFromFirebase(user);
        if (profile.role != expectedRole) {
          await FirebaseAuth.instance.signOut();
          _fail(_roleMismatchMessage(expectedRole, profile.role));
          return false;
        }
        _currentUser = profile;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      return _loginLocal(
        emailOrPhone: emailOrPhone,
        password: password,
        expectedRole: expectedRole,
      );
    } on FirebaseAuthException catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    } catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    }
  }

  bool _loginLocal({
    required String emailOrPhone,
    required String password,
    required UserRole expectedRole,
  }) {
    final normalized = emailOrPhone.trim().toLowerCase();
    final digits = _digits(emailOrPhone);
    final record = _accounts[normalized] ??
        (digits.length >= 10 ? _accounts[digits] : null);

    if (record == null) {
      _fail('No account found. Please register first.');
      return false;
    }
    if (record.password != password) {
      _fail('Incorrect password. Please try again.');
      return false;
    }
    if (record.user.role != expectedRole) {
      _fail(_roleMismatchMessage(expectedRole, record.user.role));
      return false;
    }
    _currentUser = record.user;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<bool> registerCitizen({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) {
    return registerAccount(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: UserRole.citizen,
    );
  }

  Future<bool> registerAccount({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (firebaseReady) {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final user = cred.user;
        if (user == null) {
          _fail('Unable to create account. Please try again.');
          return false;
        }
        await user.updateDisplayName(fullName.trim());
        final profile = _buildUser(
          id: user.uid,
          fullName: fullName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: role,
          photoUrl: user.photoURL,
        );
        await _saveProfile(profile);
        _currentUser = profile;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      final normalized = email.trim().toLowerCase();
      if (_accounts.containsKey(normalized)) {
        _fail('An account with this email already exists. Please log in.');
        return false;
      }
      final profile = _buildUser(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: role,
      );
      final record = _AccountRecord(
        email: email.trim(),
        phone: phone.trim(),
        password: password,
        user: profile,
      );
      _accounts[normalized] = record;
      final digits = _digits(phone);
      if (digits.length >= 10) {
        _accounts[digits] = record;
      }
      await _persistLocalAccounts();
      _currentUser = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    } catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    }
  }

  Future<bool> loginWithGoogle(UserRole expectedRole) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!firebaseReady) {
        _fail('Google Sign-In requires the SmartNagrik Firebase project.');
        return false;
      }

      UserCredential cred;
      if (kIsWeb) {
        cred = await FirebaseAuth.instance
            .signInWithPopup(GoogleAuthProvider());
      } else {
        final googleUser = await GoogleSignIn.instance.authenticate();
        final googleAuth = googleUser.authentication;
        final idToken = googleAuth.idToken;
        if (idToken == null) {
          _fail('Google Sign-In was cancelled.');
          return false;
        }
        cred = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(idToken: idToken),
        );
      }

      final user = cred.user;
      if (user == null) {
        _fail('Google Sign-In failed.');
        return false;
      }

      var profile = await _maybeExistingProfile(user.uid);
      if (profile == null) {
        profile = _buildUser(
          id: user.uid,
          fullName: user.displayName?.trim() ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          role: expectedRole,
          photoUrl: user.photoURL,
        );
        await _saveProfile(profile);
      } else if (profile.role != expectedRole) {
        await FirebaseAuth.instance.signOut();
        if (!kIsWeb) {
          await GoogleSignIn.instance.signOut();
        }
        _fail(_roleMismatchMessage(expectedRole, profile.role));
        return false;
      }

      _currentUser = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    } catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    }
  }

  Future<bool> sendPhoneOtp(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (!firebaseReady) {
      _fail('OTP login requires the SmartNagrik Firebase project.');
      return false;
    }

    final completer = Completer<bool>();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: normalizePhone(phone),
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (!completer.isCompleted) completer.complete(true);
          } catch (e) {
            if (!completer.isCompleted) completer.complete(false);
            _errorMessage = FirebaseExceptionHandler.messageFor(e);
          }
        },
        verificationFailed: (e) {
          _errorMessage = FirebaseExceptionHandler.messageFor(e);
          if (!completer.isCompleted) completer.complete(false);
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          if (!completer.isCompleted) completer.complete(true);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
      final sent = await completer.future.timeout(
        const Duration(seconds: 70),
        onTimeout: () => _verificationId != null,
      );
      _isLoading = false;
      if (!sent && _errorMessage == null) {
        _errorMessage = 'Could not send OTP. Please check the number.';
      }
      notifyListeners();
      return sent;
    } catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    }
  }

  Future<bool> verifyPhoneOtp({
    required String smsCode,
    required UserRole expectedRole,
    String? fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!firebaseReady || _verificationId == null) {
        _fail('OTP session expired. Please request a new code.');
        return false;
      }
      final cred = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode.trim(),
      );
      final result =
          await FirebaseAuth.instance.signInWithCredential(cred);
      final user = result.user;
      if (user == null) {
        _fail('Invalid OTP. Please try again.');
        return false;
      }

      var profile = await _maybeExistingProfile(user.uid);
      if (profile == null) {
        profile = _buildUser(
          id: user.uid,
          fullName: (fullName ?? user.displayName ?? '').trim(),
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          role: expectedRole,
          photoUrl: user.photoURL,
        );
        await _saveProfile(profile);
      } else if (profile.role != expectedRole) {
        await FirebaseAuth.instance.signOut();
        _fail(_roleMismatchMessage(expectedRole, profile.role));
        return false;
      }

      _currentUser = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    } catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (!firebaseReady) {
        _fail('Password reset requires the SmartNagrik Firebase project.');
        return false;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    } catch (e) {
      _fail(FirebaseExceptionHandler.messageFor(e));
      return false;
    }
  }

  Future<void> continueAsGuest() async {
    UserModel guest;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_guestKey);
      if (raw != null && raw.isNotEmpty) {
        guest = UserModel.fromMap(
            Map<String, dynamic>.from(jsonDecode(raw) as Map));
      } else {
        guest = UserModel(
          id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
          fullName: '',
          email: '',
          phone: '',
          role: UserRole.guest,
          createdAt: DateTime.now(),
        );
        await prefs.setString(_guestKey, jsonEncode(guest.toMap()));
      }
    } catch (_) {
      guest = UserModel(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        fullName: '',
        email: '',
        phone: '',
        role: UserRole.guest,
        createdAt: DateTime.now(),
      );
    }

    if (firebaseReady) {
      try {
        await FirebaseAuth.instance.signInAnonymously();
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          guest = guest.copyWith(id: uid);
        }
      } catch (_) {}
    }

    _currentUser = guest;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> beginRoleSwitch() async {
    await logout();
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      photoUrl: photoUrl ?? _currentUser!.photoUrl,
    );
    notifyListeners();

    if (_currentUser!.role == UserRole.guest) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_guestKey, jsonEncode(_currentUser!.toMap()));
    }

    if (firebaseReady &&
        FirebaseAuth.instance.currentUser != null &&
        _currentUser!.role != UserRole.guest) {
      await _saveProfile(_currentUser!);
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(fullName.trim());
    } else {
      _accounts.updateAll((key, value) {
        if (value.user.id == _currentUser!.id) {
          return _AccountRecord(
            email: email,
            phone: phone,
            password: value.password,
            user: _currentUser!,
          );
        }
        return value;
      });
      await _persistLocalAccounts();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _verificationId = null;
    _errorMessage = null;
    try {
      if (FirebaseService.isReady) {
        await FirebaseAuth.instance.signOut();
      }
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<UserModel> _profileFromFirebase(User user) async {
    final existing = await _maybeExistingProfile(user.uid);
    if (existing != null) return existing;
    final created = _buildUser(
      id: user.uid,
      fullName: user.displayName?.trim() ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      role: UserRole.citizen,
      photoUrl: user.photoURL,
    );
    await _saveProfile(created);
    return created;
  }

  Future<UserModel?> _maybeExistingProfile(String uid) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection(FirestoreConstants.colUsers)
          .doc(uid)
          .get();
      if (!snap.exists || snap.data() == null) return null;
      final data = snap.data()!;
      data['id'] = uid;
      return _userFromMap(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveProfile(UserModel user) async {
    await FirebaseFirestore.instance
        .collection(FirestoreConstants.colUsers)
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<List<UserModel>> fetchFieldOfficers() async {
    if (firebaseReady) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(FirestoreConstants.colUsers)
            .where('role', isEqualTo: UserRole.fieldOfficer.name)
            .get();
        return snap.docs.map((d) {
          final data = d.data();
          data['id'] = d.id;
          return _userFromMap(data);
        }).toList();
      } catch (_) {}
    }
    return fieldOfficers;
  }

  void _fail(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }
}
