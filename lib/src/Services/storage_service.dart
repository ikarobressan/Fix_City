import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFile(String fileName, String filePath) async {
    File file = File(filePath);

    try {
      await firebaseStorage.ref('files/$fileName').putFile(file);
      // Obter o URL após o upload
      final url = await firebaseStorage.ref('files/$fileName').getDownloadURL();
      log('Uploaded!');
      return url;
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
