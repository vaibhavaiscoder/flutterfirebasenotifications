import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/firebase_auth.dart';
import 'package:flutterfirebase/home_screen_page.dart';
import 'package:flutterfirebase/main.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';


class PhoneSignUpController extends GetxController{
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  // TextEditingController otpController = TextEditingController();
  var otpController = List.generate(6, (index) => TextEditingController());



  // auth variables
  late final PhoneVerificationCompleted phoneVerificationCompleted;
  late final PhoneVerificationFailed phoneVerificationFailed;
  late PhoneCodeSent phoneCodeSent;
  String verificationID = '';

  //sendOtp method
  sendOtp(context) async {
    phoneVerificationCompleted = (PhoneAuthCredential credential) async {
      await phoneAuthentication.signInWithCredential(credential);
    };
    phoneVerificationFailed = (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        // print('The provided phone number is not valid.');
        Get.snackbar("The provided phone number is not valid", "please check entered number",
            snackPosition: SnackPosition.BOTTOM);
      }
    };
    phoneCodeSent = (String verificationId, int? resendToken) {
      verificationID = verificationId;
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {}
  }

  //verify otp
  verifyOtp(context) async {
    String otp = '';

    // getting all textfield data
    for (var i = 0; i < otpController.length; i++) {
      otp += otpController[i].text;
    }

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otp);


      // getting user
      final User? user =
          (await userAuthentication.signInWithCredential(phoneAuthCredential)).user;
      if (user != null) {
        // Check if user exists in database
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          // User exists, keep the existing image URL
          String imageUrl = snapshot['imageUrl'] ?? '';
          await FirebaseFirestore.instance
              .collection(userCollection)
              .doc(user.uid)
              .set({
            'id': user.uid,
            'imageUrl': imageUrl,
            'phone': phoneController.text.toString(),
          });
        } else {
          // User doesn't exist, store data with an empty image URL
          await FirebaseFirestore.instance
              .collection(userCollection)
              .doc(user.uid)
              .set({
            'id': user.uid,
            'imageUrl': '',
            'phone': phoneController.text.toString(),
          });
        }

        //showing toast of login
        VxToast.show(context, msg: 'Logged in');
        Get.offAll(()=>const HomePage(),transition: Transition.downToUp);
      }

    }catch(e){
      Get.snackbar('Error', 'Login Failed',
          snackPosition: SnackPosition.BOTTOM);
    }
  }


}