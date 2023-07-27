import 'package:flutter/material.dart';
import 'package:flutterfirebase/firebase_auth.dart';
import 'package:flutterfirebase/home_screen_page.dart';
import 'package:flutterfirebase/phone_sign_up.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen(){
    if(currentUser != null){
      Get.to(()=>HomePage());
    }else{
      Get.to(()=>PhoneSignUp());
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500),(){
      changeScreen();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
        child: Center(child: ClipOval(child: Image.asset('assets/logo.png'))));
  }
}
