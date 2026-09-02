import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickFromCamera() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return file?.path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return file?.path;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> pickMultiFromGallery() async {
    try {
      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return files.map((f) => f.path).toList();
    } catch (e) {
      return [];
    }
  }
}
