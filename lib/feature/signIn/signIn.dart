import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/auth_services.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/feature/navbar/top_navbar.dart';
import 'package:flutter_application/feature/signup/signup_view.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/widget/buttons/custom_elevated_button.dart';
import 'package:flutter_application/product/widget/textfields/text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends _SignInPageAbstract {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConstants.appName,
          style: GoogleFonts.sevillana(),
        ),
        centerTitle: true,
      ),
      backgroundColor: ColorConstants.white,
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ImageConstants.signInImg.toImg,
              CustomTextField(
                labelText: StringConstants.email,
                controller: emailController,
                type: TextInputType.emailAddress,
                action: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                labelText: StringConstants.password,
                controller: passwordController,
                obsecure: true,
              ),
              const SizedBox(
                height: 50,
              ),
              CustomElevatedButton(
                buttonText: StringConstants.signIn,
                onPressed: signInUser,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(
                              color: ColorConstants.ottomanRed, width: 3))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Sign In with Google',
                        style: context.general.textTheme.bodyMedium!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(width: 40, child: IconConstants.googleIcon.toImg)
                    ],
                  ),
                  onPressed: () {
                    CloudServices().signUpWithGoogle();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t you have account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupView()));
                      },
                      child: const Text('Sign Up'))
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

abstract class _SignInPageAbstract extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showLoading = false;

  Future<void> signInUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Validate fields first')));
    } else {
      setState(() {
        showLoading = true;
      });
      await AuthServices().loginUserFirebase(
          emailController.text, passwordController.text, context);

      emailController.clear();
      passwordController.clear();
      setState(() {
        showLoading = false;
      });
    }
  }
}
