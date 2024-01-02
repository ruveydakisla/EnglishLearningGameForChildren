import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:flutter_application/product/constants/image_constants.dart';
import 'package:kartal/kartal.dart';

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
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Çıkış yap işlemleri
                  // Örneğin:
                  // FirebaseAuth.instance.signOut();
                  Navigator.pop(
                      context); // Profil sayfasından çıkış yaptıktan sonra geri dönmek istiyorsanız
                },
                child: const Text('Çıkış Yap'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
