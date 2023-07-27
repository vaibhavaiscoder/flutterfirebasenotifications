import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterfirebase/firebase_auth.dart';
import 'package:flutterfirebase/phone_sign_up.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class HomeController extends GetxController {

  var userNameController = TextEditingController();
  var userEmailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  // Rx<File?> selectedImage = Rx<File?>(null);
  var profileImgPath = ''.obs;
  var profileImgLink = '';


  Future<void> selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImgPath.value = pickedImage.path;
    }
  }

  uploadImage()async{
    var name = basename(profileImgPath.value);
    var destination = 'userImages/${currentUser!.uid}/$name';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    var d = await ref.getDownloadURL();
    profileImgLink = d;
  }


  // Check if category already exists
  // var querySnapshot = await userFirestore
  //     .collection(userCollection)
  //     .where('id', isEqualTo: currentUser!.uid)
  //     .get();

  addUserToDb(context) async {
    var userName = userNameController.text.trim();
    var userEmail = userEmailController.text.trim();

    var store = userFirestore.collection(userCollection).doc();
    await store.set({
      'name': userName,
      'email': userEmail,
      'img': profileImgLink,
      'id': currentUser!.uid,
    });

    userNameController.clear();
    userEmailController.clear();
    profileImgPath.value = '';
    profileImgLink = '';
    VxToast.show(context, msg: 'user added');
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData() {
    return userFirestore.collection('users').snapshots();
  }

  logout() async{
    await userAuthentication.signOut();
    Get.offAll(()=>PhoneSignUp());

  }
}

