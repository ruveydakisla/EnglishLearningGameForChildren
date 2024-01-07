import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/feature/signIn/signIn.dart';
import 'package:flutter_application/feature/signup_form/signup_form_view.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    const sizedBoxSmall = SizedBox(height: 20);
    // const sizedBoxMedium = SizedBox(height: 40);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: PagePadding.smallPadding.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringConstants.appName,
              style: GoogleFonts.pacifico(fontSize: 30),
            ),
            sizedBoxSmall,
            Text(
              StringConstants.bestEnglish,
              style: context.general.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
            ImageConstants.iLovePlay.toImg,
            sizedBoxSmall,
            _SignUpButton(
              text: StringConstants.continueWithGoogle,
              icon: IconConstants.googleIcon.toImg,
              onTap: () {
                CloudServices().signUpWithGoogle();
              },
            ),
            sizedBoxSmall,
            _SignUpButton(
                text: StringConstants.continueWithEmail,
                icon: IconConstants.emailIcon.toImg,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupFormView()));
                }),
            sizedBoxSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(StringConstants.alreadyHaveAccount),
                TextButton(
                  onPressed: goLogin,
                  child: const Text(StringConstants.signIn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void goLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignInPage()));
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  final String text;
  final Image icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: OutlinedButton(
        onPressed: onTap ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30, height: 30, child: icon),
            const SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: context.general.textTheme.bodyMedium
                  ?.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class PagePadding {
  static const Padding smallPadding = Padding(padding: EdgeInsets.all(20));
}
