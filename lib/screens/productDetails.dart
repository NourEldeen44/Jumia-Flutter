// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jumia/DataBase.dart';
import 'package:jumia/components/productsSnapScroll.dart';
import 'package:jumia/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    super.initState();
    getUserFavourites();
  }

  getUserFavourites() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((res) => setState(() {
                userFavourites = [...res.data()!["favourites"]];
              }))
          .then((value) {
        if (userFavourites.contains(widget.productID)) {
          productIsFavourite = true;
        }
      });
    }
  }

  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  List userFavourites = [];
  bool productIsFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: db.getSingleDocumentStream(widget.productID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Icon(
                Icons.error,
                size: 15,
                color: Colors.red,
              ));
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            Map<String, dynamic> productData = snapshot.data!.data();

            return Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * .5,
                        width: MediaQuery.of(context).size.width * .5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl: productData['imgurl'],
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Image(
                                      image: defaultTargetPlatform ==
                                                  TargetPlatform.android ||
                                              defaultTargetPlatform ==
                                                  TargetPlatform.iOS
                                          ? const AssetImage(
                                              "images/loading.png")
                                          : const AssetImage(
                                              "../../images/loading.png"),
                                    ))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //details
                  Container(
                    color: Colors.white,
                    padding: EdgeInsetsDirectional.only(start: 15, end: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //freeshipping badge
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 4),
                            child: Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: 3, end: 3, top: 1, bottom: 1),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text(
                                "Free Shipping*",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 9),
                              ),
                            ),
                          ),
                          //product name
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 8),
                            child: Text(
                              productData['engname'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          //product brand
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 8),
                            child: Text(
                              'Brand: ${productData['brand']}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                          ),
                          FittedBox(
                            child: productData['offer'] == 0 ||
                                    productData['offer'] == "0" ||
                                    productData['offer'] == ""
                                //price witout offer
                                ? Text(
                                    'EGP ${double.parse(productData['price']).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize:
                                            MediaQuery.of(context).size.width >
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
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 4),
                                        child: Text(
                                          'EGP ${((double.parse(productData['price']) - (double.parse(productData['price']) * (double.parse(productData['offer']) / 100)))).toStringAsFixed(2)}',
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
                                        ),
                                      ),
                                      //without offer
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 4),
                                        child: Text(
                                          'EGP ${double.parse(productData['price']).toStringAsFixed(2)}',
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      300
                                                  ? 14
                                                  : 12,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          maxLines: 1,
                                        ),
                                      ),
                                      //offer badge
                                      productData['offer'] == 0 ||
                                              productData['offer'] == "0" ||
                                              productData['offer'] == ""
                                          ? const Text("")
                                          : Padding(
                                              padding: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      300
                                                  ? EdgeInsetsDirectional.only(
                                                      start: 10, top: 10)
                                                  : EdgeInsetsDirectional.only(
                                                      start: 4, top: 4),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        300
                                                    ? 30
                                                    : 25,
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        300
                                                    ? 20
                                                    : 15,
                                                padding: EdgeInsets.all(1),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        254, 239, 222, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                3))),
                                                child: Center(
                                                  child: Text(
                                                    '-${productData['offer']}%',
                                                    style: TextStyle(
                                                        color: Colors.orange,
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
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 8.0),
                            child: FittedBox(
                              child: Text(
                                "Order rom Jumia express items and get free shipping.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          //rating icons
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          end: 8),
                                      child: IconButton(
                                          onPressed: () async {
                                            if (FirebaseAuth
                                                        .instance.currentUser !=
                                                    null &&
                                                !userFavourites.contains(
                                                    widget.productID)) {
                                              setState(() {
                                                userFavourites = [
                                                  ...userFavourites,
                                                  widget.productID
                                                ];
                                                productIsFavourite = true;
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .update({
                                                "favourites": [
                                                  ...userFavourites,
                                                ]
                                              }).then((res) =>
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Added Successfully"));
                                            } else if (FirebaseAuth
                                                    .instance.currentUser ==
                                                null) {
                                              Fluttertoast.showToast(
                                                  msg: "You must Login First");
                                            }
                                          },
                                          icon: Icon(
                                            productIsFavourite
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border,
                                            color: Colors.orange,
                                          )),
                                    ),
                                    Icon(
                                      Icons.share,
                                      size: 17,
                                      color: Colors.orange,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "ratings (148): ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue),
                                    ),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 15),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 15),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 15),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 15),
                                    Icon(Icons.star,
                                        color: Color.fromRGBO(220, 220, 220, 1),
                                        size: 15),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  //related products
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.only(
                              top: 4,
                              bottom: 4,
                              start: 4,
                              end: MediaQuery.of(context).size.width * .7),
                          width: double.infinity,
                          color: Color.fromRGBO(245, 245, 245, 1),
                          child: FittedBox(
                            child: Text(
                              "Customers also view",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width > 300
                                ? (MediaQuery.of(context).size.width / 3) + 65
                                : (MediaQuery.of(context).size.width / 3) + 53,
                            child: ProductsSnapScroll(
                              orderByField: "category",
                              count: 10,
                              startWith: productData["category"],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomBar(
          productID: widget.productID,
        ));
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();
    checkProductInCart();
  }

  checkProductInCart() async {
    final prefs = await SharedPreferences.getInstance();
    // final keys = prefs.getKeys();
    if (prefs.getInt(widget.productID) != null) {
      setState(() {
        productInCart = true;
        inCartCount = prefs.getInt(widget.productID)!;
      });
    }
    // for (var key in keys) {
    //   if (key == widget.productID) {
    //     int productPlusOne = prefs.getInt(widget.productID)! + 1;
    //     await prefs.setInt(widget.productID, productPlusOne).then((value) =>
    //         Fluttertoast.showToast(
    //             msg: prefs.getInt(widget.productID).toString()));
    //   }
    // }
  }

  bool productInCart = false;
  int inCartCount = 0;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: productInCart && inCartCount > 0
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * .60,
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
                                  if (key == widget.productID) {
                                    int productPlusOne =
                                        prefs.getInt(widget.productID)! + 1;
                                    await prefs
                                        .setInt(
                                            widget.productID, productPlusOne)
                                        .then((value) {
                                      setState(() {
                                        productInCart = true;
                                        inCartCount = prefs.getInt(key)!;
                                      });
                                    });
                                  }
                                }
                              },
                              height: 50,
                              color: Colors.orange,
                              child: Text(
                                "+",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Center(
                                  child: Text(
                                inCartCount.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ))),
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final keys = prefs.getKeys();
                                for (var key in keys) {
                                  if (key == widget.productID) {
                                    int productMinusOne =
                                        prefs.getInt(widget.productID)! - 1;
                                    await prefs
                                        .setInt(
                                            widget.productID, productMinusOne)
                                        .then((value) {
                                      setState(() {
                                        productInCart = true;
                                        inCartCount = prefs.getInt(key)!;
                                        //remove empty elements from cart
                                        if (inCartCount == 0) {
                                          prefs.remove(widget.productID);
                                        }
                                      });
                                    });
                                  }
                                }
                              },
                              height: 50,
                              color: Colors.orange,
                              child: Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ))
                  //Add to cart button
                  : MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * .60,
                      height: 50,
                      color: Colors.orange,
                      onPressed: () async {
                        //addtocart
                        final prefs = await SharedPreferences.getInstance();
                        //if product in cart
                        if (prefs.getInt(widget.productID) == null) {
                          await prefs.setInt(widget.productID, 1).then((value) {
                            setState(() {
                              productInCart = true;
                              inCartCount = 1;
                            });
                            Fluttertoast.showToast(msg: "ADDED TO CART");
                          });
                        }
                        //if product first time to cart
                        else {
                          final keys = prefs.getKeys();
                          for (var key in keys) {
                            if (key == widget.productID) {
                              int productPlusOne =
                                  prefs.getInt(widget.productID)! + 1;
                              await prefs
                                  .setInt(widget.productID, productPlusOne)
                                  .then((value) {
                                setState(() {
                                  productInCart = true;
                                  inCartCount = prefs.getInt(key)!;
                                });
                                Fluttertoast.showToast(msg: "ADDED TO CART");
                              });
                            }
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "ADD TO CART",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * .15,
                  height: 50,
                  color: Colors.white,
                  onPressed: () {},
                  child: Icon(
                    Icons.call,
                    color: Colors.orange,
                  )),
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * .15,
                  height: 50,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: "Jumia Demo Home Page",
                                  firstLoad: false,
                                  btmSelectedIndex: 0,
                                )));
                  },
                  child: Icon(
                    Icons.home_outlined,
                    color: Colors.orange,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
