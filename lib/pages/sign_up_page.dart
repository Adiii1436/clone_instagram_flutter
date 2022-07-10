import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final AuthMethods _auth = AuthMethods();
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    SvgPicture.asset(
                      'assets/icons/ic_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.explicit.bing.net%2Fth%3Fid%3DOIP.M-q5nj6oSJv9sGxzz5yioQHaGI%26pid%3DApi&f=1"),
                              ),
                        Positioned(
                            bottom: -10,
                            left: 55,
                            child: IconButton(
                                splashRadius: 15,
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: blueColor,
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hintText: "Enter username",
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _emailController,
                        hintText: "Enter email",
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: "Enter password",
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _bioController,
                      hintText: "Enter bio",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: () async {
                        String res = await _auth.signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            username: _usernameController.text,
                            bio: _bioController.text,
                            file: _image!);
                        print(res);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            color: blueColor),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text('Sign up'),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
