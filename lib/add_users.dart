
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfirebase/home_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AddUsers extends StatelessWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Add User"),

        actions: [
              TextButton(
              onPressed: () async {
                if (controller.formKey.currentState!.validate()) {
                  await controller.uploadImage();
                  await controller.addUserToDb(context);
                  Get.back();
                }
              },
              child: Text('save',style: TextStyle(color: Colors.white),),)
        ],

      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.heightBox,
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
                  ],
                  controller: controller.userNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                10.heightBox,
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z@\s]")),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  controller: controller.userEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                10.heightBox,
                const Divider(color: Colors.white,),
                Text("Choose user image"),
                10.heightBox,
                Obx(
                      ()=> Center(
                    child: GestureDetector(
                      onTap: controller.selectImage,
                      child: controller.profileImgPath.isNotEmpty
                          ? Image.file(
                        File(controller.profileImgPath.value),
                        width: 100,
                        height: 100,
                      )
                          : Icon(
                        Icons.add,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
