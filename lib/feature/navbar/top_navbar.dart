import 'package:flutter/material.dart';
import 'package:flutter_application/feature/education/educations.dart';
import 'package:flutter_application/feature/game/games_view.dart';
import 'package:flutter_application/feature/profile_dart/profile.dart';
import 'package:flutter_application/feature/score_table/score_table.dart';
import 'package:flutter_application/product/constants/index.dart';

import '../../product/services/sound_service.dart';

class MyAppp extends StatelessWidget {
  const MyAppp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _tabs = [
    const GamesView(),
    const Education(),
    const AllUsersPage(),
    const Profile(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.cremeDeMenth,
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.network(
                        'https://cdn-icons-png.flaticon.com/128/1855/1855685.png?uid=R132188031&semt=ais'),
                  ),
                  text: 'Games'),
              Tab(
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.network(
                        'https://cdn-icons-png.flaticon.com/128/2843/2843321.png?uid=R132188031&semt=ais'),
                  ),
                  text: 'Education'),
              Tab(
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.network(
                        'https://cdn-icons-png.flaticon.com/128/1872/1872241.png'),
                  ),
                  text: 'Scores'),
              Tab(
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.network(
                        'https://cdn-icons-png.flaticon.com/128/1072/1072869.png?uid=R132188031'),
                  ),
                  text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}
