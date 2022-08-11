// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jumia/DataBase.dart';
import 'package:jumia/components/productsSnapScroll.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  String focused = "food";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Navigator
        Expanded(
          flex: 1,
          child: Ink(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                        //NAVS
                        children: [
                          //food CatNav
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: focused == "food"
                                      ? Color.fromRGBO(0, 0, 0, .075)
                                      : Colors.transparent,
                                  border: focused == "food"
                                      ? Border(
                                          right: BorderSide(
                                              color: Colors.orange, width: 4))
                                      : Border(
                                          right: BorderSide(
                                              color: Colors.transparent,
                                              width: 4))),
                              child: InkWell(
                                child: Center(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "SuperMarket",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    focused = "food";
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          //fashion CatNav
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: focused == "fashion"
                                      ? Color.fromRGBO(0, 0, 0, .075)
                                      : Colors.transparent,
                                  border: focused == "fashion"
                                      ? Border(
                                          right: BorderSide(
                                              color: Colors.orange, width: 4))
                                      : Border(
                                          right: BorderSide(
                                              color: Colors.transparent,
                                              width: 4))),
                              child: InkWell(
                                child: Center(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Fashion",
                                        style: TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    focused = "fashion";
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          //Electronics CatNav
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: focused == "electronics"
                                      ? Color.fromRGBO(0, 0, 0, .075)
                                      : Colors.transparent,
                                  border: focused == "electronics"
                                      ? Border(
                                          right: BorderSide(
                                              color: Colors.orange, width: 4))
                                      : Border(
                                          right: BorderSide(
                                              color: Colors.transparent,
                                              width: 4))),
                              child: InkWell(
                                child: Center(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Electronics",
                                        style: TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    focused = "electronics";
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          //gamming CatNav
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: focused == "gamming"
                                      ? Color.fromRGBO(0, 0, 0, .075)
                                      : Colors.transparent,
                                  border: focused == "gamming"
                                      ? Border(
                                          right: BorderSide(
                                              color: Colors.orange, width: 4))
                                      : Border(
                                          right: BorderSide(
                                              color: Colors.transparent,
                                              width: 4))),
                              child: InkWell(
                                child: Center(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Gaming",
                                        style: TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    focused = "gamming";
                                  });
                                },
                              ),
                            ),
                          ),
                        ])),
              ],
            ),
          ),
        ),
        //Cat View
        Expanded(
          flex: 4,
          child: Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 20, end: 10, top: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: StreamBuilder<QuerySnapshot>(
                stream: db.getQueryProductsStream("category", 100, focused),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Icon(
                        Icons.error,
                        size: 15,
                        color: Colors.red,
                      ),
                    );
                  }
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.requireData;
                  return Container(
                      // color: Colors.white,
                      child: GridView.builder(
                          itemCount: data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  // mainAxisSpacing: 40,
                                  crossAxisCount:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? 2
                                          : 3),
                          itemBuilder: (context, index) {
                            return GridTile(
                              child: FittedBox(
                                child: Product(productData: {
                                  ...data.docs[index].data(),
                                  "id": data.docs[index].id
                                }, index: index),
                              ),
                            );
                          }));
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
