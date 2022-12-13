import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  Future<String> UploadFile({required File file}) async {
    print(file);
    final storageRef = FirebaseStorage.instance.ref();
    final imgRef = storageRef.child("${Uuid().v4()}.");
    await imgRef.putFile(file);
    String storageUrl = await imgRef.getDownloadURL();

    return storageUrl;
  }
}
