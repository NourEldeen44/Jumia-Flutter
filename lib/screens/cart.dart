// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jumia/DataBase.dart';
import 'package:jumia/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    getcartCount();
    getCartTotal();
    getProductFromCart();
  }

  payWithPayPal() async {
    // final request = BraintreeCreditCardRequest(
    //     cardNumber: '4111111111111111',
    //     expirationMonth: '12',
    //     expirationYear: '2021',
    //     cvv: '367');
    // BraintreePaymentMethodNonce? result = await Braintree.tokenizeCreditCard(
    //   '<Insert your tokenization key or client token here>',
    //   request,
    // );
    // print(result!.nonce);
    // final request = BraintreePayPalRequest(amount: '13.37');

    // BraintreePaymentMethodNonce? result = await Braintree.requestPaypalNonce(
    //   'access_token\$sandbox\$3bb8ktrtr5g7ycd3\$d740ceb19f26a146af6e79d5e05ad505',
    //   request,
    // );
    // if (result != null) {
    //   // Fluttertoast.showToast(msg: 'Nonce: ${result.nonce}');
    //   print("!!!!!!!!!!!!!!1");
    //   print(result);
    // } else {
    //   Fluttertoast.showToast(msg: 'PayPal flow was canceled.');
    //   print("!!!!!!!!!!!!1");
    // }
    Fluttertoast.showToast(msg: "Payment Methods isnt setted up yet!");
  }

  getCartTotal() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List cartValues = [];
    List<String> cartKeys = [];
    // List products = [];
    double totalPrices = 0;
    //get from cart
    for (var key in keys) {
      cartValues = [...cartValues, prefs.getInt(key)];
      cartKeys = [...cartKeys, key];
    }
    //get from database
    for (var i = 0; i < keys.length; i++) {
      FirebaseFirestore.instance
          .collection("products")
          .doc(cartKeys[i])
          .get()
          .then((res) {
        // products = [...products, res.data()];
        if (res.data()!["offer"] == "0" ||
            res.data()!["offer"] == 0 ||
            res.data()!["offer"] == "") {
          totalPrices =
              totalPrices + double.parse(res.data()!["price"]) * cartValues[i];
        } else {
          totalPrices = totalPrices +
              ((double.parse(res.data()!['price']) -
                      (double.parse(res.data()!['price']) *
                          (double.parse(res.data()!['offer']) / 100))) *
                  cartValues[i]);
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!1");
          print(res.data()!["price"]);
        }
      }).then((value) {
        setState(() {
          cartTotalPrice = totalPrices;
        });
      });
    }
  }

  getProductFromCart() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    Map<String, dynamic> cart = {};
    for (var key in keys) {
      cart = {...cart, key: prefs.get(key)}; //unneeded till now
      setState(() {
        cartValues = [...cartValues, prefs.getInt(key)];
        cartKeys = [...cartKeys, key];
        print("!!!!!!!!!!!!!!!!!!!!!!!!11");
        print(cartValues);
      });
    }
    // setState(() {
    //   cartValues[index] = cartValues[widget.index];
    //   cartKeys[index] = cartKeys[widget.index];
    // });
  }

  getcartCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartCount = prefs.getKeys().length;
    });
  }

  List cartValues = [];
  List cartKeys = [];
  // int productCount= 1;
  // String productID= "";
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  int cartCount = 0;
  double cartTotalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return cartCount == 0
        ? const Center(
            child: Text(
              "Your Cart Is Empty",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        : cartKeys.length < 1
            ? CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(
                    height: 101,
                    child: Column(
                      children: [
                        Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding:
                                EdgeInsetsDirectional.only(top: 8, bottom: 8),
                            child: Text(
                              "Total Cart: ${cartTotalPrice.toStringAsFixed(2)} EGP",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8),
                          child: MaterialButton(
                              height: 50,
                              color: Colors.orange,
                              onPressed: (() {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "please Login to Perform Your Order");
                                } else {
                                  //paypal payment
                                  payWithPayPal();
                                }
                              }),
                              child: Text(
                                "Check Out",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartCount,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SizedBox(
                              // child: CartProduct(index: index),
                              child: cartKeys[index] == ""
                                  ? Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .2,
                                      color: Colors.white,
                                    )
                                  : StreamBuilder(
                                      stream: db.getSingleDocumentStream(
                                          cartKeys[index]),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Icon(Icons.error));
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                          return Center(
                                            // child: CircularProgressIndicator(),
                                            child: Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                        final productData =
                                            snapshot.data!.data();
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .2,
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration(
                                                      milliseconds: 500),
                                                  fadeOutDuration: Duration(
                                                      milliseconds: 100),
                                                  imageUrl:
                                                      productData['imgurl'],
                                                  placeholder: (context, url) =>
                                                      Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey,
                                                          highlightColor:
                                                              (Colors
                                                                  .grey[100])!,
                                                          child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              child: Image(
                                                                image: defaultTargetPlatform ==
                                                                            TargetPlatform
                                                                                .android ||
                                                                        defaultTargetPlatform ==
                                                                            TargetPlatform
                                                                                .iOS
                                                                    ? const AssetImage(
                                                                        "images/loading.png")
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //total
                                                        Container(
                                                          child: productData['offer'] ==
                                                                      "0" ||
                                                                  productData[
                                                                          'offer'] ==
                                                                      "" ||
                                                                  productData[
                                                                          'offer'] ==
                                                                      0
                                                              ?
                                                              //with no offer
                                                              Padding(
                                                                  padding: EdgeInsetsDirectional.only(
                                                                      end: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          5),
                                                                  child: Text(
                                                                    "Total: ${(double.parse(productData['price']) * cartValues[index]).toStringAsFixed(2)} EGP",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              :
                                                              //with offer
                                                              Text(
                                                                  "Total: ${(((double.parse(productData['price']) - (double.parse(productData['price']) * (double.parse(productData['offer']) / 100))) * cartValues[index]).toStringAsFixed(2))} EGP",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                        ),
                                                        //price
                                                        FittedBox(
                                                          child: productData[
                                                                          'offer'] ==
                                                                      0 ||
                                                                  productData[
                                                                          'offer'] ==
                                                                      "0" ||
                                                                  productData[
                                                                          'offer'] ==
                                                                      ""
                                                              //price witout offer
                                                              ? Text(
                                                                  'EGP ${double.parse(productData['price']).toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize: MediaQuery.of(context).size.width >
                                                                              300
                                                                          ? 17
                                                                          : 12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  maxLines: 1,
                                                                )
                                                              //price after offer
                                                              : Row(
                                                                  children: [
                                                                    //withoffer
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                              .only(
                                                                          end:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        'EGP ${((double.parse(productData['price']) - (double.parse(productData['price']) * (double.parse(productData['offer']) / 100)))).toStringAsFixed(2)}',
                                                                        style: TextStyle(
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            fontSize: MediaQuery.of(context).size.width > 300
                                                                                ? 17
                                                                                : 12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    //without offer
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                              .only(
                                                                          end:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        'EGP ${double.parse(productData['price']).toStringAsFixed(2)}',
                                                                        style: TextStyle(
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            fontSize: MediaQuery.of(context).size.width > 300
                                                                                ? 14
                                                                                : 12,
                                                                            color:
                                                                                Colors.grey,
                                                                            decoration: TextDecoration.lineThrough),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    //offer badge
                                                                    productData['offer'] == 0 ||
                                                                            productData['offer'] ==
                                                                                "0" ||
                                                                            productData['offer'] ==
                                                                                ""
                                                                        ? const Text(
                                                                            "")
                                                                        : Padding(
                                                                            padding: MediaQuery.of(context).size.width > 300
                                                                                ? EdgeInsetsDirectional.only(start: 10, top: 10)
                                                                                : EdgeInsetsDirectional.only(start: 4, top: 4),
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.of(context).size.width > 300 ? 30 : 25,
                                                                              height: MediaQuery.of(context).size.width > 300 ? 20 : 15,
                                                                              padding: EdgeInsets.all(1),
                                                                              decoration: const BoxDecoration(color: Color.fromRGBO(254, 239, 222, 1), borderRadius: BorderRadius.all(Radius.circular(3))),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '-${productData['offer']}%',
                                                                                  style: TextStyle(color: Colors.orange, fontSize: MediaQuery.of(context).size.width > 300 ? 12 : 8),
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
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            await prefs
                                                                .remove(
                                                                    cartKeys[
                                                                        index])
                                                                .then((value) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Deleted From Cart");
                                                              Navigator
                                                                  .pushReplacement(
                                                                      context,
                                                                      PageRouteBuilder(
                                                                        pageBuilder: (context,
                                                                                animation1,
                                                                                animation2) =>
                                                                            MyHomePage(
                                                                          title:
                                                                              "jumia demo",
                                                                          firstLoad:
                                                                              false,
                                                                          btmSelectedIndex:
                                                                              2,
                                                                        ),
                                                                        transitionDuration:
                                                                            Duration.zero,
                                                                        reverseTransitionDuration:
                                                                            Duration.zero,
                                                                      ));
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Remove",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .orange),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: Colors
                                                                    .orange,
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
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(
                                                                start: 8,
                                                                end: 8),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              final prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              final keys = prefs
                                                                  .getKeys();
                                                              for (var key
                                                                  in keys) {
                                                                if (key ==
                                                                    cartKeys[
                                                                        index]) {
                                                                  int productPlusOne =
                                                                      prefs.getInt(
                                                                              cartKeys[index])! +
                                                                          1;
                                                                  await prefs
                                                                      .setInt(
                                                                          cartKeys[
                                                                              index],
                                                                          productPlusOne)
                                                                      .then(
                                                                          (value) {
                                                                    // setState(() {
                                                                    //   cartValues[index] = prefs.getInt(key)!;
                                                                    // });
                                                                  });
                                                                }
                                                              }
                                                              setState(() {
                                                                cartValues[
                                                                        index] =
                                                                    cartValues[
                                                                            index] +
                                                                        1;
                                                                if (productData[
                                                                            "offer"] ==
                                                                        "0" ||
                                                                    productData[
                                                                            "offer"] ==
                                                                        0 ||
                                                                    productData[
                                                                            "offer"] ==
                                                                        "") {
                                                                  cartTotalPrice =
                                                                      cartTotalPrice +
                                                                          double.parse(
                                                                              productData["price"]);
                                                                } else {
                                                                  cartTotalPrice = cartTotalPrice +
                                                                      ((double.parse(productData[
                                                                              'price']) -
                                                                          (double.parse(productData['price']) *
                                                                              (double.parse(productData['offer']) / 100))));
                                                                }
                                                              });
                                                            },
                                                            color:
                                                                Colors.orange,
                                                            child: Text(
                                                              "+",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      MediaQuery.of(context).size.width >=
                                                                              400
                                                                          ? 30
                                                                          : 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                                child: Text(
                                                              cartValues[index]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      MediaQuery.of(context).size.width >=
                                                                              400
                                                                          ? 20
                                                                          : 13,
                                                                  color: Colors
                                                                      .orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))),
                                                        Expanded(
                                                          flex: 1,
                                                          child: MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              if (cartValues[
                                                                      index] >
                                                                  1) {
                                                                final prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                final keys = prefs
                                                                    .getKeys();
                                                                for (var key
                                                                    in keys) {
                                                                  if (key ==
                                                                      cartKeys[
                                                                          index]) {
                                                                    int productMinusOne =
                                                                        prefs.getInt(cartKeys[index])! -
                                                                            1;
                                                                    await prefs
                                                                        .setInt(
                                                                            cartKeys[
                                                                                index],
                                                                            productMinusOne)
                                                                        .then(
                                                                            (value) {
                                                                      // setState(() {
                                                                      //   cartValues[index] = prefs.getInt(key)!;
                                                                      // });
                                                                    });
                                                                  }
                                                                }
                                                                setState(() {
                                                                  cartValues[
                                                                          index] =
                                                                      cartValues[
                                                                              index] -
                                                                          1;
                                                                  if (productData[
                                                                              "offer"] ==
                                                                          "0" ||
                                                                      productData[
                                                                              "offer"] ==
                                                                          0 ||
                                                                      productData[
                                                                              "offer"] ==
                                                                          "") {
                                                                    cartTotalPrice =
                                                                        cartTotalPrice -
                                                                            double.parse(productData["price"]);
                                                                  } else {
                                                                    cartTotalPrice =
                                                                        cartTotalPrice -
                                                                            ((double.parse(productData['price']) -
                                                                                (double.parse(productData['price']) * (double.parse(productData['offer']) / 100))));
                                                                  }
                                                                });
                                                              }
                                                            },
                                                            color: cartValues[
                                                                        index] >
                                                                    1
                                                                ? Colors.orange
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        228,
                                                                        199,
                                                                        155),
                                                            child: Text(
                                                              "-",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      MediaQuery.of(context).size.width >=
                                                                              400
                                                                          ? 30
                                                                          : 12,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                    ),
                            ),
                          );
                        }),
                  ),
                ],
              );
  }
}
