// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import '../DataBase.dart';
import '../components/productsSnapScroll.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Key key = UniqueKey();
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.width > 300
                  ? (MediaQuery.of(context).size.width / 3) + 65
                  : (MediaQuery.of(context).size.width / 3) + 53,
              child: ProductsSnapScroll(
                orderByField: "offer",
                count: 10,
                startWith: "",
              )),
          SizedBox(
              height: MediaQuery.of(context).size.width > 300
                  ? (MediaQuery.of(context).size.width / 3) + 65
                  : (MediaQuery.of(context).size.width / 3) + 53,
              child: ProductsSnapScroll(
                orderByField: "category",
                count: 10,
                startWith: "electronics",
              )),
          Text("data")
        ],
      ),
      appBar: AppBar(
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
    );
  }
}
