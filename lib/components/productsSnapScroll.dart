// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, no_logic_in_create_state, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jumia/DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProductsSnapScroll extends StatefulWidget {
  const ProductsSnapScroll(
      {Key? key,
      required this.orderByField,
      required this.count,
      required this.startWith})
      : super(key: key);
  final String orderByField;
  final int count;
  final String startWith;
  @override
  State<ProductsSnapScroll> createState() => _ProductsSnapScrollState();
}

class _ProductsSnapScrollState extends State<ProductsSnapScroll> {
  _ProductsSnapScrollState();

  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  @override
  void initState() {
    super.initState();
    addloadingToprefs();
  }

  addloadingToprefs() async {
    final prefs = await SharedPreferences.getInstance();
    widget.startWith == ""
        ? await prefs.setBool("${widget.orderByField}_loading", true)
        : await prefs.setBool("${widget.startWith}_loading", true);
  }

  setLoadingToDone() async {
    final prefs = await SharedPreferences.getInstance();
    widget.startWith == ""
        ? await prefs.setBool("${widget.orderByField}_loading", false)
        : await prefs.setBool("${widget.startWith}_loading", false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getQueryProductsStream(
        widget.orderByField,
        widget.count,
        widget.startWith,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {}
        if (!snapshot.hasData) {
          return FittedBox(
            child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: (Colors.grey[100])!,
                child: Container(
                    padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                    height: MediaQuery.of(context).size.width / 3,
                    child: Image(
                      image: defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform == TargetPlatform.iOS
                          ? const AssetImage("images/wideloading.png")
                          : const AssetImage("../../images/wideloading.png"),
                    ))),
          );
        }
        // if (snapshot.connectionState == ConnectionState.done) {
        //   setLoadingToDone();
        // }
        // Map<String, dynamic> productData = snapshot.data!.data() as Map<String, dynamic>;
        final data = snapshot.requireData;
        return Container(
          // color: Colors.white,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Product(
                  productData: data.docs[index].data(),
                  index: index,
                );
              }),
        );
      },
    );
  }
}

class Product extends StatelessWidget {
  const Product({Key? key, required this.productData, required this.index})
      : super(key: key);
  final Map<String, dynamic> productData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return //product card
        Stack(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 100),
                          imageUrl: productData['imgurl'],
                          placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: (Colors.grey[100])!,
                              child: Container(
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
                        Container(
                            padding: const EdgeInsetsDirectional.only(
                                start: 10, end: 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    productData["engname"],
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  300
                                              ? 14
                                              : 10,
                                    ),
                                    maxLines: 1,
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
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        300
                                                    ? 16
                                                    : 12,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                          )
                                        //price after offer
                                        : Text(
                                            'EGP ${((double.parse(productData['price']) - (double.parse(productData['price']) * (double.parse(productData['offer']) / 100)))).toStringAsFixed(2)}',
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        300
                                                    ? 16
                                                    : 12,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                          ),
                                  ),
                                ]))
                      ],
                    ),
                  ),
                ),
                //offer badge
                productData['offer'] == 0 ||
                        productData['offer'] == "0" ||
                        productData['offer'] == ""
                    ? const Text("")
                    : Padding(
                        padding: MediaQuery.of(context).size.width > 300
                            ? EdgeInsetsDirectional.only(start: 10, top: 10)
                            : EdgeInsetsDirectional.only(start: 4, top: 4),
                        child: Container(
                          width:
                              MediaQuery.of(context).size.width > 300 ? 42 : 25,
                          height:
                              MediaQuery.of(context).size.width > 300 ? 30 : 15,
                          padding: MediaQuery.of(context).size.width > 300
                              ? EdgeInsets.all(4)
                              : EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(254, 239, 222, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          child: Center(
                            child: Text(
                              '-${productData['offer']}%',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 300
                                          ? 14
                                          : 8),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        //inkwell
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              print(" card $index Tappped!!!!!!!!!!!!!!!!!!!!!!!!!!!!1");
            },
          ),
        ))
      ],
    );
  }
}
