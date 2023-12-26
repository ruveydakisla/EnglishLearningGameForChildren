import 'package:flutter/material.dart';
import 'package:flutter_application/feature/signIn/signIn.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';
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
    const sizedBoxMedium = SizedBox(height: 40);
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.signUp),
      ),
      body: Container(
        padding: PagePadding.smallPadding.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringConstants.appName,
              style: context.general.textTheme.headlineMedium,
            ),
            sizedBoxSmall,
            Text(
              StringConstants.bestEnglish,
              style: context.general.textTheme.bodyMedium,
            ),
            ImageConstants.iLovePlay.toImg,
            sizedBoxMedium,
            _SignUpButton(
                text: StringConstants.continueWithGoogle,
                icon: IconConstants.googleIcon.toImg),
            sizedBoxSmall,
            _SignUpButton(
              icon: IconConstants.facebookIcon.toImg,
              text: StringConstants.continueWithFacebook,
            ),
            sizedBoxSmall,
            _SignUpButton(
                text: StringConstants.continueWithEmail,
                icon: IconConstants.emailIcon.toImg),
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
  });

  final String text;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30, height: 30, child: icon),
            const SizedBox(
              width: 20,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class PagePadding {
  static const Padding smallPadding = Padding(padding: EdgeInsets.all(20));
}
