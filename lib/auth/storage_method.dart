import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    try {
      // Create a unique file path
      Reference ref = _storage
          .ref()
          .child(childName)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;

      // Get the download URL
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}