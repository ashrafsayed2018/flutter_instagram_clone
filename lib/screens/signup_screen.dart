import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_method.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_feild_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List selectedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
      _emailController.text,
      _usernameController.text,
      _passwordController.text,
      _bioController.text,
      _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context, 0xFFFF0000);
    } else {
      showSnackBar(res, context, 0XFF009900);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // svg image
                Image.asset(
                  'assets/images/instagram-logo.png',
                  color: primaryColor,
                  width: 120,
                ),
                const SizedBox(
                  height: 64,
                ),
                // circular widget to accept and show our selected file
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://i.pinimg.com/736x/cb/45/72/cb4572f19ab7505d552206ed5dfb3739.jpg"),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 78,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                // text input feild box for username
                TextFeildInput(
                  textEditingController: _usernameController,
                  hintText: "enter your username",
                  textInputType: TextInputType.text,
                ),

                const SizedBox(
                  height: 24,
                ),
                // text input feild box for email
                TextFeildInput(
                  textEditingController: _emailController,
                  hintText: "enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                // text input feild box for password
                TextFeildInput(
                  textEditingController: _passwordController,
                  hintText: "enter your password",
                  textInputType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFeildInput(
                  textEditingController: _bioController,
                  hintText: "enter your bio",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text("Signup"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                // transitioning to signup page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Already have an account "),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
