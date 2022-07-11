import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/pages/sign_up_page.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _auth = AuthMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await _auth.loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      _snackBar(res);
    }
  }

  void _snackBar(String content) {
    showSnackBar(context, content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            height: 50,
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
          InkWell(
            onTap: loginUser,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: blueColor),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Don't have an account?"),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignupPage()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                        color: blueColor, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ]),
      )),
    );
  }
}
