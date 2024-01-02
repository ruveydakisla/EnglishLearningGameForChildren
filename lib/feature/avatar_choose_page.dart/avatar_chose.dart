import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/feature/signIn/signIn.dart';
import 'package:flutter_application/product/constants/avatar_constants.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:flutter_application/product/widget/textfields/text_field.dart';
import 'package:kartal/kartal.dart';

class ChooseYourAvatar extends StatefulWidget {
  const ChooseYourAvatar({Key? key, required this.mail}) : super(key: key);
  final String mail;
  @override
  State<ChooseYourAvatar> createState() => _ChooseYourAvatarState();
}

class _ChooseYourAvatarState extends State<ChooseYourAvatar> {
  final TextEditingController _controller = TextEditingController();
  int selectedAvatarIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.softPeach,
      appBar: AppBar(
        backgroundColor: ColorConstants.softPeach,
        title: const Text('Choose Your Avatar'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _AvatarCard(
                          img: AvatarConstants.avatar1.value,
                          isSelected: selectedAvatarIndex == 0,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 0;
                            });
                          },
                        ),
                        _AvatarCard(
                          img: AvatarConstants.avatar2.value,
                          isSelected: selectedAvatarIndex == 1,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 1;
                            });
                          },
                        ),
                        _AvatarCard(
                          img: AvatarConstants.avatar3.value,
                          isSelected: selectedAvatarIndex == 2,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _AvatarCard(
                          img: AvatarConstants.avatar4.value,
                          isSelected: selectedAvatarIndex == 3,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 3;
                            });
                          },
                        ),
                        _AvatarCard(
                          img: AvatarConstants.avatar5.value,
                          isSelected: selectedAvatarIndex == 4,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 4;
                            });
                          },
                        ),
                        _AvatarCard(
                          img: AvatarConstants.avatar6.value,
                          isSelected: selectedAvatarIndex == 5,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 5;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _AvatarCard(
                          img: AvatarConstants.avatar7.value,
                          isSelected: selectedAvatarIndex == 6,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 6;
                            });
                          },
                        ),
                        _AvatarCard(
                          img: AvatarConstants.avatar8.value,
                          isSelected: selectedAvatarIndex == 7,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 7;
                            });
                          },
                        ),
                        _AvatarCard(
                          img: AvatarConstants.avatar9.value,
                          isSelected: selectedAvatarIndex == 8,
                          onTap: () {
                            setState(() {
                              selectedAvatarIndex = 8;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Enter your name',
                      style: context.general.textTheme.bodyLarge,
                    ),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Ruveyda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedAvatarIndex != -1) {
                          await CloudServices().updateUserNameAndAvatar(
                            widget.mail ?? 'boş',
                            _controller.text.toString(),
                            AvatarConstantsExtension.getAvatarUrl(
                                selectedAvatarIndex),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an avatar.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Okey'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Future<void> saveDataToFirebase() async {
  //   try {
  //     await Firebase.initializeApp();
  //     final firestore = FirebaseFirestore.instance;

  //     if (selectedAvatarIndex != -1) {
  //       final selectedAvatarUrl =
  //           AvatarConstantsExtension.getAvatarUrl(selectedAvatarIndex);

  //       await firestore.collection('users').add({
  //         'name': _controller.text,
  //         'avatarUrl': selectedAvatarUrl,
  //         'score': 0
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Data saved to Firebase.'),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Please select an avatar.'),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error saving data to Firebase: $e');
  //   }
  // }
}

class _AvatarCard extends StatelessWidget {
  const _AvatarCard({
    Key? key,
    required this.img,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String img;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Card(
          color: isSelected ? Colors.blue : Colors.amber.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(img),
          ),
        ),
      ),
    );
  }
}
