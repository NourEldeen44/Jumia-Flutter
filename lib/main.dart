// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jumia/DataBase.dart';
import 'package:jumia/screens/home.dart';
import 'package:jumia/screens/splashScreen.dart';
import 'package:jumia/screens/user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBiCTNxlH-u7l48pyYCoqsi2ABZRoIyITo",
            appId: "1:567754490733:web:bdc0cd0f4ab4d09945d064",
            messagingSenderId: "567754490733",
            projectId: "jumia-db"));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key key = UniqueKey();
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  bool insplashScreen = true;
  int btmSelectedIndex = 0;
  List screens = [Home(), SplashScreen(), Home(), UserScreen(), Home()];
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    setState(() {
      insplashScreen = false;
    });
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return insplashScreen
        ? SplashScreen()
        : Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1),
              body: screens[btmSelectedIndex],
              // Bottom Bar
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: btmSelectedIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.format_list_bulleted_outlined),
                      label: "Categories"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.cast), label: "Feed"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline), label: "Account"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.help_outline), label: "Help"),
                ],
                elevation: 2,
                selectedItemColor: Colors.orange,
                unselectedItemColor: Colors.black,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                unselectedFontSize: 12,
                selectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                onTap: (int index) {
                  setState(() {
                    btmSelectedIndex = index;
                  });
                },
              ),
              appBar: AppBar(
                elevation: 0,
                title: const Text(
                  "Jumia",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // Restart.restartApp();
                    setState(() {
                      key = UniqueKey();
                    });
                  }),
            ));
  }
}
