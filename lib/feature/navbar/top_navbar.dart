import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/games_view.dart';
import 'package:flutter_application/product/constants/color_constants.dart';

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
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

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
                  text: 'Favorites'),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorites Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}
