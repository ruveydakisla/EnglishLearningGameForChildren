import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

import '../signIn/signIn.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  late final mail;
  late Future<Map<String, dynamic>?> userr;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    userr = CloudServices().getUserDataByEmail(mail);
  }

  Future<void> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    mail = user!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkKnight,
      body: ListView(
        children: [
          Column(
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: userr,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('User data not found');
                  } else {
                    final userData = snapshot.data!;
                    final String name = userData['name'] ?? '';
                    final String avatarUrl = userData['avatar'] ?? '';
                    final int score = userData['score'] ?? 0;

                    return Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Center(child: Image.network(avatarUrl)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          name,
                          style: context.general.textTheme.bodyLarge!
                              .copyWith(color: ColorConstants.cremeDeMenth),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 100, child: ImageConstants.cupImg.toImg),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 100,
                          width: 500,
                          child: Card(
                            color: Colors.amber.withAlpha(120),
                            child: Center(
                              child: Text(
                                score.toString(),
                                style: GoogleFonts.bungeeSpice().copyWith(
                                    color: ColorConstants.darkKnight,
                                    fontSize: 50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.actOfWrath),
                  onPressed: () async {
                    // Çıkış yap işlemleri
                    await FirebaseAuth.instance.signOut();

                    // Navigator'ı kullanarak SignInPage'e yönlendirme
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Log out',
                        style: context.general.textTheme.bodyLarge!.copyWith(
                            color: ColorConstants.cremeDeMenth, fontSize: 20),
                      ),
                      SizedBox(
                          height: 50, child: IconConstants.logOutIcon.toImg)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
