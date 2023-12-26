import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/auth_services.dart';
import 'package:flutter_application/feature/navbar/top_navbar.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/widget/buttons/custom_elevated_button.dart';
import 'package:flutter_application/product/widget/textfields/text_field.dart';

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
        title: const Text(StringConstants.signIn),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              labelText: StringConstants.email,
              controller: emailController,
              type: TextInputType.emailAddress,
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
              height: 20,
            ),
            CustomElevatedButton(
              buttonText: StringConstants.signIn,
              onPressed: signInUser,
            ),
          ],
        ),
      ),
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
