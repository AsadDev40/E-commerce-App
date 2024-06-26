// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myshop/provider/auth_provider.dart';
import 'package:myshop/provider/file_upload_provider.dart';
import 'package:myshop/provider/image_picker.dart';
import 'package:myshop/screens/profile_screen.dart';
import 'package:myshop/utils/utils.dart';
import 'package:myshop/widgets/constants.dart';
import 'package:myshop/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends HookWidget {
  final String userid;
  final String imagepath;
  final String username;
  final String email;
  final String address;
  const EditProfilePage(
      {super.key,
      required this.imagepath,
      required this.address,
      required this.username,
      required this.email,
      required this.userid});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final fileprovider = Provider.of<FileUploadProvider>(context);
    final authpro = Provider.of<AuthProvider>(context);

    final emailController = useTextEditingController(text: email);

    final usernameController = useTextEditingController(text: username);
    final addressController = useTextEditingController(text: address);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius:
                          65, // Adjust the radius to control the size of the circle
                      backgroundImage: imageProvider.selectedImage != null
                          ? FileImage(imageProvider.selectedImage!)
                          : NetworkImage(imagepath),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Choose Profile Photo',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            await imageProvider
                                                .pickImageFromCamera();
                                            Utils.back(context);
                                          },
                                          icon: const Icon(
                                            Icons.camera,
                                            size: 30,
                                            color: Colors.purple,
                                          ),
                                          label: const Text(
                                            'Camera',
                                            style:
                                                TextStyle(color: Colors.purple),
                                          ),
                                        ),
                                        TextButton.icon(
                                            onPressed: () async {
                                              await imageProvider
                                                  .pickImageFromGallery();
                                              Utils.back(context);
                                            },
                                            icon: const Icon(
                                              Icons.image,
                                              color: Colors.purple,
                                            ),
                                            label: const Text('Gallery',
                                                style: TextStyle(
                                                    color: Colors.purple)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 30,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: usernameController,
                  hintText: 'Enter Username:',
                  hintStyle: const TextStyle(fontSize: 15, color: PrimaryColor),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                  textStyle: const TextStyle(color: PrimaryColor),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  hintText: 'Enter Address:',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: PrimaryColor,
                  ),
                  textStyle: const TextStyle(color: PrimaryColor),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter Email:',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: PrimaryColor,
                  ),
                  textStyle: const TextStyle(color: PrimaryColor),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                child: const Text('UPDATE PROFILE',
                    style: TextStyle(color: Colors.purple)),
                onPressed: () async {
                  EasyLoading.show();
                  if (imageProvider.selectedImage != null) {
                    await fileprovider.updateFile(
                        file: imageProvider.selectedImage as File,
                        oldImageUrl: imagepath,
                        folder: 'profileimage',
                        name: 'user-image-$userid');
                    await authpro.updateUserProfile(usernameController.text,
                        emailController.text, addressController.text);
                  } else {
                    await authpro.updateUserProfile(usernameController.text,
                        emailController.text, addressController.text);
                  }
                  EasyLoading();

                  EasyLoading.dismiss();
                  Utils.navigateTo(context, const Profilescreen());
                  imageProvider.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
