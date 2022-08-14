// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jumia/DataBase.dart';
import 'package:jumia/screens/cart.dart';
import 'package:jumia/screens/categories.dart';
import 'package:jumia/screens/home.dart';
import 'package:jumia/screens/splashScreen.dart';
import 'package:jumia/screens/user.dart';

Future main() async {
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    Fluttertoast.showToast(
        msg: "you Have a new notification!",
        textColor: Colors.white,
        backgroundColor: Colors.orange[400]);
  }

  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      title: 'Jumia Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(
        title: 'Jumia Demo Home Page',
        firstLoad: true,
        btmSelectedIndex: 0,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.firstLoad,
      required this.btmSelectedIndex})
      : super(key: key);
  final bool firstLoad;
  final int btmSelectedIndex;
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
  List screens = [Home(), Categories(), Cart(), UserScreen(), Home()];

  @override
  void initState() {
    super.initState();
    setState(() {
      btmSelectedIndex = widget.btmSelectedIndex;
    });
    // navigateToHome();
  }

  //fromsplash to home
  navigateToHome() async {
    if (widget.firstLoad) {
      await Future.delayed(Duration(seconds: 3), () {});
      setState(() {
        insplashScreen = false;
      });
    } else {
      setState(() {
        insplashScreen = false;
      });
    }
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return
        // insplashScreen
        //     ? SplashScreen()
        //     :
        Directionality(
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
                      icon: Icon(Icons.shopping_cart_checkout), label: "Cart"),
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
                    setState(() {
                      // Restart.restartApp();
                      key = UniqueKey();
                    });
                  }),
            ));
  }
}
