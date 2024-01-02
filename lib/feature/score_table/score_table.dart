import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/image_constants.dart';
import 'package:kartal/kartal.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    return users.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No users found');
          } else {
            final List<Map<String, dynamic>> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final String name = user['name'] ?? '';
                final String avatarUrl = user['avatar'] ?? '';
                final int score = user['score'] ?? 0;

                return ScoreTable(
                  avatarUrl: avatarUrl,
                  name: name,
                  score: score,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ScoreTable extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int score;

  const ScoreTable({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
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
              ImageConstants.cupImg
                  .toImg // Örnek olarak lokal bir resim ekledim, siz kendi yolunuzu belirtmelisiniz.
            ],
          ),
        ),
      ),
    );
  }
}
