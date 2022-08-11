// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jumia/DataBase.dart';
import 'package:jumia/main.dart';
import 'package:jumia/screens/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  void initState() {
    super.initState();
    getProductFromCart();
  }

  getProductFromCart() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    Map<String, dynamic> cart = {};
    List cartValues = [];
    List cartKeys = [];
    for (var key in keys) {
      cart = {...cart, key: prefs.get(key)}; //unneeded till now
      cartValues = [...cartValues, prefs.getInt(key)];
      cartKeys = [...cartKeys, key];
    }
    setState(() {
      productCount = cartValues[widget.index];
      productID = cartKeys[widget.index];
    });
  }

  int productCount = 1;
  String productID = "";
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  @override
  Widget build(BuildContext context) {
    return productID == ""
        ? Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * .2,
            color: Colors.white,
          )
        : StreamBuilder(
            stream: db.getSingleDocumentStream(productID),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child: Icon(Icons.error));
              }
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  // child: CircularProgressIndicator(),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * .2,
                    color: Colors.white,
                  ),
                );
              }
              final productData = snapshot.data!.data();
              return Container(
                height: MediaQuery.of(context).size.width * .2,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 100),
                        imageUrl: productData['imgurl'],
                        placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: (Colors.grey[100])!,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Image(
                                  image: defaultTargetPlatform ==
                                              TargetPlatform.android ||
                                          defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                      ? const AssetImage("images/loading.png")
                                      : const AssetImage(
                                          "../../images/loading.png"),
                                ))),
                      ),
                    ),
                    //Price and total info
                    Container(
                      child: Expanded(
                        flex: 3,
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //total
                              Container(
                                child: productData['offer'] == "0" ||
                                        productData['offer'] == "" ||
                                        productData['offer'] == 0
                                    ?
                                    //with no offer
                                    Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            end: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5),
                                        child: Text(
                                          "Total: ${(double.parse(productData['price']) * productCount).toStringAsFixed(2)} EGP",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    :
                                    //with offer
                                    Text(
                                        "Total: ${(((double.parse(productData['price']) - (double.parse(productData['price']) * (double.parse(productData['offer']) / 100))) * productCount).toStringAsFixed(2))} EGP",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              //price
                              FittedBox(
                                child: productData['offer'] == 0 ||
                                        productData['offer'] == "0" ||
                                        productData['offer'] == ""
                                    //price witout offer
                                    ? Text(
                                        'EGP ${double.parse(productData['price']).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    300
                                                ? 17
                                                : 12,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      )
                                    //price after offer
                                    : Row(
                                        children: [
                                          //withoffer
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(end: 4),
                                            child: Text(
                                              'EGP ${((double.parse(productData['price']) - (double.parse(productData['price']) * (double.parse(productData['offer']) / 100)))).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              300
                                                          ? 17
                                                          : 12,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                            ),
                                          ),
                                          //without offer
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(end: 4),
                                            child: Text(
                                              'EGP ${double.parse(productData['price']).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              300
                                                          ? 14
                                                          : 12,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              maxLines: 1,
                                            ),
                                          ),
                                          //offer badge
                                          productData['offer'] == 0 ||
                                                  productData['offer'] == "0" ||
                                                  productData['offer'] == ""
                                              ? const Text("")
                                              : Padding(
                                                  padding: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width >
                                                          300
                                                      ? EdgeInsetsDirectional
                                                          .only(
                                                              start: 10,
                                                              top: 10)
                                                      : EdgeInsetsDirectional
                                                          .only(
                                                              start: 4, top: 4),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                300
                                                            ? 30
                                                            : 25,
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                300
                                                            ? 20
                                                            : 15,
                                                    padding: EdgeInsets.all(1),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Color
                                                                    .fromRGBO(
                                                                        254,
                                                                        239,
                                                                        222,
                                                                        1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            3))),
                                                    child: Center(
                                                      child: Text(
                                                        '-${productData['offer']}%',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    300
                                                                ? 12
                                                                : 8),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                              ),
                              //Remove Button
                              InkWell(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove(productID).then((value) {
                                    Fluttertoast.showToast(
                                        msg: "Deleted From Cart");
                                    Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              MyHomePage(
                                            title: "jumia demo",
                                            firstLoad: false,
                                            btmSelectedIndex: 2,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ));
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.orange,
                                      size: 14,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //product controller
                    Container(
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsetsDirectional.only(start: 8, end: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: MaterialButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final keys = prefs.getKeys();
                                    for (var key in keys) {
                                      if (key == productID) {
                                        int productPlusOne =
                                            prefs.getInt(productID)! + 1;
                                        await prefs
                                            .setInt(productID, productPlusOne)
                                            .then((value) {
                                          // setState(() {
                                          //   productCount = prefs.getInt(key)!;
                                          // });
                                        });
                                      }
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              MyHomePage(
                                            title: "jumia demo",
                                            firstLoad: false,
                                            btmSelectedIndex: 2,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ));
                                  },
                                  color: Colors.orange,
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width >=
                                                    400
                                                ? 30
                                                : 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    productCount.toString(),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >=
                                                    400
                                                ? 20
                                                : 13,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Expanded(
                                flex: 1,
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (productCount > 1) {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final keys = prefs.getKeys();
                                      for (var key in keys) {
                                        if (key == productID) {
                                          int productMinusOne =
                                              prefs.getInt(productID)! - 1;
                                          await prefs
                                              .setInt(
                                                  productID, productMinusOne)
                                              .then((value) {
                                            // setState(() {
                                            //   productCount = prefs.getInt(key)!;
                                            // });
                                          });
                                        }
                                      }
                                      Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                MyHomePage(
                                              title: "jumia demo",
                                              firstLoad: false,
                                              btmSelectedIndex: 2,
                                            ),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ));
                                    }
                                  },
                                  color: productCount > 1
                                      ? Colors.orange
                                      : Color.fromARGB(255, 228, 199, 155),
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >=
                                                    400
                                                ? 30
                                                : 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
