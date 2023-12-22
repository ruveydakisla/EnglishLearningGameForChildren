import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupFB extends ConsumerStatefulWidget {
  const SignupFB({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupFBState();
}

class _SignupFBState extends ConsumerState<SignupFB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RegisterScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(
            clientId:
                ' 522327777003-l4pc8d9fq1lvrquobpq3d0c4d883osq0.apps.googleusercontent.com ')
      ],
    ));
  }
}
