import 'package:flutter/foundation.dart';
import '../../models/authority_model.dart';
import '../../models/citizen_model.dart';
import '../../models/field_officer_model.dart';
import '../../models/user_model.dart';
import '../enums/user_role.dart';

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
}

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  UserRole get currentRole => _currentUser?.role ?? UserRole.citizen;
  String? get errorMessage => _errorMessage;

  // Registered Accounts Database
  final Map<String, _AccountRecord> _accounts = {};

  AuthService() {
    _seedRegisteredAccounts();
    _currentUser = null; // Clean session - user must login
  }

  void _seedRegisteredAccounts() {
    // Registered Citizen
    final citizen = CitizenModel(
      id: 'usr_rohan_101',
      fullName: 'Rohan Sharma',
      email: 'rohan.sharma@example.com',
      phone: '',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
    _accounts['rohan.sharma@example.com'] = _AccountRecord(
      email: 'rohan.sharma@example.com',
      phone: '',
      password: 'password123',
      user: citizen,
    );

    // Registered Municipal Authority
    final authority = AuthorityModel(
      id: 'admin_nagpur_01',
      fullName: 'Admin Commissioner',
      email: 'admin@smartnagrik.gov.in',
      phone: '',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      departmentId: 'MUNICIPAL_CORP',
      designation: 'Municipal Commissioner',
      jurisdiction: 'Nagpur Municipal Area',
    );
    _accounts['admin@smartnagrik.gov.in'] = _AccountRecord(
      email: 'admin@smartnagrik.gov.in',
      phone: '',
      password: 'admin123',
      user: authority,
    );

    // Registered Field Officer
    final officer = FieldOfficerModel(
      id: 'officer_rajesh_01',
      fullName: 'Rajesh Patil',
      email: 'rajesh.patil@smartnagrik.gov.in',
      phone: '',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      departmentId: 'ROAD_MAINTENANCE',
      departmentName: 'Roads & Infrastructure',
    );
    _accounts['rajesh.patil@smartnagrik.gov.in'] = _AccountRecord(
      email: 'rajesh.patil@smartnagrik.gov.in',
      phone: '',
      password: 'officer123',
      user: officer,
    );
  }

  Future<bool> loginAsCitizen({
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final normalized = emailOrPhone.trim().toLowerCase();
    final record = _accounts[normalized];

    if (record == null) {
      _isLoading = false;
      _errorMessage = 'No account found with this email. Please register first.';
      notifyListeners();
      return false;
    }

    if (record.password != password) {
      _isLoading = false;
      _errorMessage = 'Incorrect password. Please try again.';
      notifyListeners();
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
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final normalized = email.trim().toLowerCase();
    if (_accounts.containsKey(normalized)) {
      _isLoading = false;
      _errorMessage = 'An account with this email already exists. Please log in.';
      notifyListeners();
      return false;
    }

    final newCitizen = CitizenModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );

    _accounts[normalized] = _AccountRecord(
      email: email,
      phone: phone,
      password: password,
      user: newCitizen,
    );

    _currentUser = newCitizen;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<bool> loginAsAuthority({
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final normalized = emailOrPhone.trim().toLowerCase();
    final record = _accounts[normalized];

    if (record == null || record.user is! AuthorityModel) {
      _isLoading = false;
      _errorMessage = 'Invalid municipal authority credentials.';
      notifyListeners();
      return false;
    }

    if (record.password != password) {
      _isLoading = false;
      _errorMessage = 'Incorrect password for municipal authority account.';
      notifyListeners();
      return false;
    }

    _currentUser = record.user;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<bool> loginAsFieldOfficer({
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final normalized = emailOrPhone.trim().toLowerCase();
    final record = _accounts[normalized];

    if (record == null || record.user is! FieldOfficerModel) {
      _isLoading = false;
      _errorMessage = 'Invalid field officer credentials.';
      notifyListeners();
      return false;
    }

    if (record.password != password) {
      _isLoading = false;
      _errorMessage = 'Incorrect password for field officer account.';
      notifyListeners();
      return false;
    }

    _currentUser = record.user;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final googleCitizen = CitizenModel(
      id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Google User',
      email: 'user.google@smartnagrik.app',
      phone: '',
      createdAt: DateTime.now(),
    );

    _currentUser = googleCitizen;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    _currentUser = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Guest Citizen',
      email: 'guest@smartnagrik.app',
      phone: '',
      role: UserRole.guest,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void switchRole(UserRole role) {
    switch (role) {
      case UserRole.authority:
        _currentUser = _accounts['admin@smartnagrik.gov.in']?.user;
      case UserRole.fieldOfficer:
        _currentUser = _accounts['rajesh.patil@smartnagrik.gov.in']?.user;
      case UserRole.guest:
        continueAsGuest();
      case UserRole.citizen:
        _currentUser = _accounts['rohan.sharma@example.com']?.user;
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
