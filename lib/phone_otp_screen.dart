import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfirebase/phone_controller.dart';
import 'package:get/get.dart';


class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PhoneSignUpController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify you otp'),
      ),
      body: Form(
        key: formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // TextFormField(
          //   controller: controller.otpController[index],
          //   decoration: InputDecoration(
          //     labelText: 'otp',
          //   ),
          //   obscureText: true,
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return 'Please enter otp';
          //     }
          //     // Add additional password validation if needed
          //     return null;
          //   },
          // ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                    (index) => SizedBox(
                  width: 40,
                  child: TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.number,
                    controller: controller.otpController[index],
                    cursorColor: Colors.grey,
                    onChanged: (value) {
                      if (value.length == 1 && index <= 4) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        // FocusScope.of(context).previousFocus();
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        // VxToast.show(
                        //   context,
                        //   msg: 'Please enter a value',
                        //   position: VxToastPosition.center,
                        // );
                        // return 'Empty';
                      } else if (value.length != 1) {
                        Get.snackbar('Error', 'Please Enter 1 value');
                        // return 'Empty';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:  BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      // helperText: '',
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if(formKey.currentState!.validate()){
                controller.verifyOtp(context);
              }
              else{
                Get.snackbar('Error', 'Failed to Login');
              }
            },
            child: Text('Login'),
          ),
        ]),
      ),
    );
  }
}
