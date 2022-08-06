// ignore_for_file: prefer_final_fields, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jumia/DataBase.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _userConfirmController = TextEditingController();
  String state = "loading";
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // print('User is currently signed out!');
        setState(() {
          state = "login";
        });
      } else {
        // print('User is signed in!');
        setState(() {
          state = "account";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return state == "loading"
        ? Center(child: CircularProgressIndicator())
        : state == "login"
            ? ListView(
                children: [
                  //email input
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _userEmailController,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            labelText: "E-mail",
                            hintText: "E-mail",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange, width: 2))),
                      )),
                  //password input
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _userPasswordController,
                        obscureText: true,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            labelText: "password",
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange, width: 2))),
                      )),
                  //login button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MaterialButton(
                      color: Colors.orange,
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: _userEmailController.text,
                            password: _userPasswordController.text,
                          );
                          // if (userCredential.user != null) {
                          print(userCredential.user?.uid);
                          // }

                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "LogIn",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  //go to register button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MaterialButton(
                      color: Colors.orange,
                      onPressed: () {
                        setState(() {
                          state = "register";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "new To Jumia? Register now!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : state == "register"
                //Register Screen
                ? ListView(
                    children: [
                      //name input
                      Container(
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            controller: _userNameController,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                labelText: "Your Name",
                                hintText: "Your Name",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2))),
                          )),
                      //email input
                      Container(
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            controller: _userEmailController,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                labelText: "E-mail",
                                hintText: "E-mail",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2))),
                          )),
                      //password input
                      Container(
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            controller: _userPasswordController,
                            obscureText: true,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                labelText: "password",
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2))),
                          )),
                      //confirm password input
                      Container(
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            controller: _userConfirmController,
                            obscureText: true,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                labelText: "Confirm Password",
                                hintText: "Confirm Password",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2))),
                          )),
                      //register button
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MaterialButton(
                          color: Colors.orange,
                          onPressed: () async {
                            RegExp emailPattern =
                                RegExp("[a-z0-9]+@[a-z]+.[a-z]{2,3}");
                            RegExp passwordPattern =
                                RegExp("^[a-zA-Z0-9!@#\$%^&*<>?|/;:`~=]{6,}\$");
                            if (!emailPattern
                                .hasMatch(_userEmailController.text)) {
                              Fluttertoast.showToast(msg: "Unvalid E-mail");
                            } else if (!passwordPattern
                                .hasMatch(_userPasswordController.text)) {
                              Fluttertoast.showToast(
                                msg: "Password must be at least 6 chars",
                              );
                            } else if (_userPasswordController.text !=
                                _userConfirmController.text) {
                              Fluttertoast.showToast(
                                  msg: "Inncorrect Confirm Password");
                            } else {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                  email: _userEmailController.text,
                                  password: _userPasswordController.text,
                                );
                                // print(userCredential.user?.uid);
                                //add the user to firestore
                                Map<String, dynamic> userData = {
                                  "useremail": userCredential.user?.email,
                                  "password": _userPasswordController.text,
                                  "username": _userNameController.text,
                                  "favourites": "",
                                  "orders": "",
                                };
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(userCredential.user?.uid)
                                    .set(userData);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  Fluttertoast.showToast(
                                      msg: "The password provided is too weak");
                                } else if (e.code == 'email-already-in-use') {
                                  Fluttertoast.showToast(
                                      msg:
                                          'The account already exists for that email.');
                                }
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      //go to register button
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MaterialButton(
                          color: Colors.orange,
                          onPressed: () {
                            setState(() {
                              state = "login";
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Have an Account? Login",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : state == "account"
                    ? AccountScreen()
                    : Text("err");
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection('users'));
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: db.getSingleDocumentStream(uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Icon(
            Icons.error,
            color: Colors.red,
            size: 15,
          ));
        }
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          child: Center(
              child: Column(
            children: [
              Text(
                'Welcome ${snapshot.data!.data()["username"]} !',
                style: TextStyle(color: Colors.orange, fontSize: 20),
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MaterialButton(
                    color: Colors.orange,
                    onPressed: () async {
                      FirebaseAuth.instance.signOut().then((value) =>
                          Fluttertoast.showToast(
                              msg: "Signed Out Successfully"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sign out",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )),
            ],
          )),
        );
      },
    );
  }
}
