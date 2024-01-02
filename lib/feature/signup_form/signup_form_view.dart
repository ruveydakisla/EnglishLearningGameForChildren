import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/auth_services.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/feature/avatar_choose_page.dart/avatar_chose.dart';
import 'package:flutter_application/product/constants/string_constants.dart';
import 'package:flutter_application/product/widget/buttons/custom_elevated_button.dart';
import 'package:flutter_application/product/widget/textfields/text_field.dart';

class SignupFormView extends StatefulWidget {
  const SignupFormView({super.key});

  @override
  _SignupFormViewState createState() => _SignupFormViewState();
}

class _SignupFormViewState extends State<SignupFormView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              StringConstants.appName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "It's easier to sing up new",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              type: TextInputType.emailAddress,
              labelText: StringConstants.email,
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              obsecure: true,
              labelText: StringConstants.password,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              buttonText: StringConstants.signUp,
              onPressed: registerUser,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Validate fields first')));
    } else {
      setState(() {
        showLoading = true;
      });
      await AuthServices().registerUserInFirebase(
          emailController.text, passwordController.text, context);

      CloudServices()
          .saveDataToFirebase(1, '', context, 0, emailController.text);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChooseYourAvatar(
                    mail: emailController.text.toString(),
                  )));

      setState(() {
        showLoading = false;
      });
    }
  }
}
