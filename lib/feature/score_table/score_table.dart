import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:kartal/kartal.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  late Future<List<Map<String, dynamic>>> allUsers;

  @override
  void initState() {
    super.initState();
    allUsers = getAllUsers();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    // Kullanıcıları puanlarına göre sırala
    final sortedUsers = users.docs.map((doc) => doc.data()).toList()
      ..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return sortedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkKnight,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: allUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("User Didn't find");
            } else {
              final List<Map<String, dynamic>> users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final String name = user['name'] ?? '';
                  final String avatarUrl = user['avatar'] ?? '';
                  final int score = user['score'] ?? 0;

                  final List<String> medalIcons = [
                    IconConstants.goldMedal.value,
                    IconConstants.silverMedal.value,
                    IconConstants.bronzeMedal.value,
                  ];

                  //medal icon show
                  Widget medalIcon;
                  if (index == 0) {
                    medalIcon = Image.network(medalIcons[0]);
                  } else if (index == 1) {
                    medalIcon = Image.network(medalIcons[1]);
                  } else if (index == 2) {
                    medalIcon = Image.network(medalIcons[2]);
                  } else {
                    medalIcon = const SizedBox(
                      width: 35,
                    ); //
                  }

                  return ScoreTable(
                    avatarUrl: avatarUrl,
                    name: name,
                    score: score,
                    medalIcon: medalIcon,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ScoreTable extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int score;
  final Widget medalIcon;

  const ScoreTable({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.score,
    required this.medalIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        color: Colors.amber.shade100.withAlpha(150),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(avatarUrl),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.general.textTheme.headlineSmall,
                  ),
                  Text(score.toString()),
                ],
              ),
              medalIcon,
            ],
          ),
        ),
      ),
    );
  }
}
