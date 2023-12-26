import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/feature/navbar/top_navbar.dart';
import 'package:flutter_application/main.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> registerUserInFirebase(
      String email, String password, BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> loginUserFirebase(
      String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login successfully')));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MyAppp())); // MyApp sayfasına yönlendirme
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login failed. Check your email and password.')));
    }
  }
}
