import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:firepost1/services/prefs_service.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static final folder = "post_images";

  static Future<String> uploadPostImage(File image) async{
    String? uid = await Prefs.loadUserId();
    String? img_name = uid! + "_" + DateTime.now().toString();
    Reference reference = _storage.child(folder).child(img_name);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    if(taskSnapshot != null){
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }

    return "null";
  }

}