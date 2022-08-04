// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shimmer/shimmer.dart';
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
  List carouselUrls = [
    "https://eg.jumia.is/cms/29-22/UNs/Tv-Gaming-Electronics/GIF/Slider-Desktop-EN_.gif",
    "https://eg.jumia.is/cms/29-22/UNs/Floats/Slider-Desktop-EN_-(1).jpg",
    "https://eg.jumia.is/cms/29-22/UNs/Hair-Care/Slider-Desktop-EN_.jpg",
    "https://eg.jumia.is/cms/29-22/UNs/Pet-Supplies/Slider-Desktop-EN_-(2).jpg",
    "https://eg.jumia.is/cms/29-22/UNs-Deals/Hair-Care/Slider/Braun-Slider-Desktop-EN__copy_6.jpg",
    "https://eg.jumia.is/cms/ja-22/games/2.gif",
    "https://eg.jumia.is/cms/27-22/Banks/ValU/Slider-Desktop-EN__copy_2-(3).jpg",
  ];
  List salesSnapScrollUrls = [
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/Flash_sales_EN.png",
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/Free_shipping_EN.png",
    "https://eg.jumia.is/cms/ja-22/quicklinks/EN/games_(General)_en.png",
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/1_day_offers_EN.png",
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/JPAy_AR.png",
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/Orange_Points_EN.png",
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/Food_AR.png",
    "https://eg.jumia.is/cms/23-22/Thumbnails/EN/Global_EN_copy.png",
    "https://eg.jumia.is/cms/29-22/Thumbnail/TVs,_Gaming_&_Electronics-3.png",
    "https://eg.jumia.is/cms/29-22/Thumbnail/Floats,_Pools_&Water_Fun-3.png",
    "https://eg.jumia.is/cms/29-22/Thumbnail/Hair_Care-3.png",
    "https://eg.jumia.is/cms/29-22/Thumbnail/Pet_Supplies-3.png",
  ];
  int carouselCurrentIndex = 0;
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //CAROUSEL
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                    top: 4,
                    bottom: 4,
                    start: MediaQuery.of(context).size.width * .25,
                    end: MediaQuery.of(context).size.width * .25),
                width: double.infinity,
                color: Color.fromRGBO(254, 226, 204, 1),
                child: FittedBox(
                  child: Text(
                    "Free Shipping Nationwide",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              CarouselSlider(
                  carouselController: carouselController,
                  items: carouselUrls.map((url) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 4, end: 4, top: 8, bottom: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 0),
                              fadeOutDuration: Duration(milliseconds: 0),
                              imageUrl: url,
                              placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: (Colors.grey[100])!,
                                  child: Center(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: Image(
                                          image: defaultTargetPlatform ==
                                                      TargetPlatform.android ||
                                                  defaultTargetPlatform ==
                                                      TargetPlatform.iOS
                                              ? const AssetImage(
                                                  "images/wideloading.png")
                                              : const AssetImage(
                                                  "../../images/wideloading.png"),
                                        )),
                                  )),
                            ),
                          ),
                        ),
                        Positioned.fill(
                            child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 4, end: 4, top: 4, bottom: 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (() {}),
                            ),
                          ),
                        ))
                      ],
                    );
                  }).toList(),
                  options: CarouselOptions(
                    onPageChanged: ((index, reason) {
                      setState(() {
                        carouselCurrentIndex = index;
                      });
                    }),
                    height: MediaQuery.of(context).size.width * .430,
                    autoPlay: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 200),
                    autoPlayInterval: const Duration(seconds: 5),
                  )),
              SizedBox(
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselUrls.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => carouselController.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        // curve: Curves.bounceInOut,
                        width: carouselCurrentIndex == entry.key ? 7 : 5,
                        height: carouselCurrentIndex == entry.key ? 7 : 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: carouselCurrentIndex == entry.key
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        //end Carousel
        //sales SnapScroll
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8),
          child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.width / 5,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: salesSnapScrollUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 100),
                        imageUrl: salesSnapScrollUrls[index],
                        placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: (Colors.grey[100])!,
                            child: SizedBox(
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
                    );
                  })),
        ), //end salessnapscroll
        //free shipping
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8),
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(4),
              child: FittedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(seconds: 0),
                    fadeOutDuration: Duration(seconds: 0),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 12,
                    ),
                    imageUrl:
                        "https://eg.jumia.is/cms/31-22/FreeShipping-General/1152x252_-EN-(51).jpg",
                    placeholder: (context, url) => FittedBox(
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: (Colors.grey[100])!,
                          child: Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: 20, end: 20),
                              height: MediaQuery.of(context).size.width / 3,
                              child: Image(
                                image: defaultTargetPlatform ==
                                            TargetPlatform.android ||
                                        defaultTargetPlatform ==
                                            TargetPlatform.iOS
                                    ? const AssetImage("images/wideloading.png")
                                    : const AssetImage(
                                        "../../images/wideloading.png"),
                              ))),
                    ),
                  ),
                ),
              )),
        ), //end free shipping
        //best offer
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8),
          child: Column(
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                    top: 4,
                    bottom: 4,
                    start: 4,
                    end: MediaQuery.of(context).size.width * .55),
                width: double.infinity,
                color: Colors.red,
                child: FittedBox(
                  child: Text(
                    "Flash Sales Every Day",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.width > 300
                      ? (MediaQuery.of(context).size.width / 3) + 65
                      : (MediaQuery.of(context).size.width / 3) + 53,
                  child: ProductsSnapScroll(
                    orderByField: "offer",
                    count: 10,
                    startWith: "",
                  )),
            ],
          ),
        ),
        //end best offer
        //amazing deals
        Padding(
          padding: EdgeInsetsDirectional.only(top: 8),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsDirectional.only(
                      top: 4,
                      bottom: 4,
                      start: MediaQuery.of(context).size.width * .33,
                      end: MediaQuery.of(context).size.width * .33),
                  width: double.infinity,
                  color: Color.fromRGBO(254, 226, 204, 1),
                  child: FittedBox(
                    child: Text(
                      "Amazing Deals!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl:
                                "https://eg.jumia.is/cms/31-22/UNs-Deals/Women-Fashion/Floor/Shein_-Floor-Desktop_-EN__copy_4.jpg",
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
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
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl:
                                "https://eg.jumia.is/cms/31-22/UNs-Deals/Women-Fashion/Floor/Desert_-Floor-Desktop_-EN__copy_4.jpg",
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
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
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsetsDirectional.only(top: 8),
            child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl:
                                "https://eg.jumia.is/cms/31-22/UNs-Deals/Men-Fashion/floors/new/Activ-Floor-Desktop_-EN__copy_4.jpg",
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
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
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl:
                                "https://eg.jumia.is/cms/31-22/UNs-Deals/Men-Fashion/floors/AEO_-Floor-Desktop_-EN__copy_4.jpg",
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
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
                      ),
                    ),
                  ],
                ))),
        //end amazing deals
        //fashion snapscroll
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
                color: Color.fromRGBO(254, 226, 204, 1),
                child: FittedBox(
                  child: Column(
                    children: [
                      Text(
                        "Fashion's Sale",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Up to 50% Off",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
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
                    startWith: "fashion",
                  )),
            ],
          ),
        ), //end fashion snapscroll
        //electrinics sale
        Padding(
            padding: EdgeInsetsDirectional.only(top: 8),
            child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl:
                                "https://eg.jumia.is/cms/31-22/UNs-Deals/Home/floors/new/Air_Conditioners-Floor-Desktop_-EN__copy_4.jpg",
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
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
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl:
                                "https://eg.jumia.is/cms/31-22/UNs-Deals/Home/floors/new/Fans-Floor-Desktop_-EN__copy_4.jpg",
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: SizedBox(
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
                      ),
                    ),
                  ],
                ))), //end electronics sales
        //electronics snapscroll
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8),
          child: Column(
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                    top: 4,
                    bottom: 4,
                    start: 4,
                    end: MediaQuery.of(context).size.width * .65),
                width: double.infinity,
                color: Color.fromRGBO(254, 226, 204, 1),
                child: FittedBox(
                  child: Column(
                    children: [
                      Text(
                        "Electronics's Sale",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Up to 17% Off",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
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
                    startWith: "electronics",
                  )),
            ],
          ),
        ), //end electronics snapscroll
        //explore whats new
        Padding(
            padding: EdgeInsetsDirectional.only(top: 8),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsDirectional.only(
                      top: 4,
                      bottom: 4,
                      start: MediaQuery.of(context).size.width * .25,
                      end: MediaQuery.of(context).size.width * .25),
                  width: double.infinity,
                  color: Color.fromRGBO(254, 226, 204, 1),
                  child: FittedBox(
                    child: Text(
                      "Explore what's new!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 100),
                                imageUrl:
                                    "https://eg.jumia.is/cms/31-22/Jumia-mart-shipping/new/Mart_-_378x252_EN_-(1).jpg",
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        baseColor: Colors.grey,
                                        highlightColor: (Colors.grey[100])!,
                                        child: SizedBox(
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
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 100),
                                imageUrl:
                                    "https://eg.jumia.is/cms/31-22/Jumia-mart-shipping/new/Alex_378x252_EN-(1).jpg",
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        baseColor: Colors.grey,
                                        highlightColor: (Colors.grey[100])!,
                                        child: SizedBox(
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
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 100),
                                imageUrl:
                                    "https://eg.jumia.is/cms/31-22/Jumia-mart-shipping/new/Sahel_-_378x252_EN-(1).jpg",
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        baseColor: Colors.grey,
                                        highlightColor: (Colors.grey[100])!,
                                        child: SizedBox(
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
                      ],
                    )),
              ],
            )), //end explore whats new
        //gaming snapscroll
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
                color: Color.fromRGBO(254, 226, 204, 1),
                child: FittedBox(
                  child: Column(
                    children: [
                      Text(
                        "Gaming's Sale",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Up to 63% Off",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
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
                    startWith: "gamming",
                  )),
            ],
          ),
        ), // end gamming snapscroll
        //view cats
        Padding(
            padding: EdgeInsetsDirectional.only(top: 8),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsDirectional.only(
                      top: 4,
                      bottom: 4,
                      start: MediaQuery.of(context).size.width * .33,
                      end: MediaQuery.of(context).size.width * .33),
                  width: double.infinity,
                  color: Color.fromRGBO(254, 226, 204, 1),
                  child: FittedBox(
                    child: Text(
                      "Explore Categories",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 100),
                                    imageUrl:
                                        "https://eg.jumia.is/cms/31-22/UN-icons/Artboard_1_copy-(4).png",
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: (Colors.grey[100])!,
                                            child: SizedBox(
                                                child: Image(
                                              image: defaultTargetPlatform ==
                                                          TargetPlatform
                                                              .android ||
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.iOS
                                                  ? const AssetImage(
                                                      "images/loading.png")
                                                  : const AssetImage(
                                                      "../../images/loading.png"),
                                            ))),
                                  ),
                                ),
                                FittedBox(child: Text("Supermarket"))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 100),
                                    imageUrl:
                                        "https://eg.jumia.is/cms/31-22/UN-icons/Artboard_1_copy_11-(2).png",
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: (Colors.grey[100])!,
                                            child: SizedBox(
                                                child: Image(
                                              image: defaultTargetPlatform ==
                                                          TargetPlatform
                                                              .android ||
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.iOS
                                                  ? const AssetImage(
                                                      "images/loading.png")
                                                  : const AssetImage(
                                                      "../../images/loading.png"),
                                            ))),
                                  ),
                                ),
                                FittedBox(child: Text("Fashion"))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 100),
                                    imageUrl:
                                        "https://eg.jumia.is/cms/31-22/UN-icons/Artboard_1_copy_4-(5).png",
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: (Colors.grey[100])!,
                                            child: SizedBox(
                                                child: Image(
                                              image: defaultTargetPlatform ==
                                                          TargetPlatform
                                                              .android ||
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.iOS
                                                  ? const AssetImage(
                                                      "images/loading.png")
                                                  : const AssetImage(
                                                      "../../images/loading.png"),
                                            ))),
                                  ),
                                ),
                                FittedBox(child: Text("Electronics"))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 100),
                                    imageUrl:
                                        "https://eg.jumia.is/cms/31-22/UN-icons/Artboard_1_copy_8-(3).png",
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: (Colors.grey[100])!,
                                            child: SizedBox(
                                                child: Image(
                                              image: defaultTargetPlatform ==
                                                          TargetPlatform
                                                              .android ||
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.iOS
                                                  ? const AssetImage(
                                                      "images/loading.png")
                                                  : const AssetImage(
                                                      "../../images/loading.png"),
                                            ))),
                                  ),
                                ),
                                FittedBox(child: Text("Gaming"))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
        Center(
            child: Text(
          "Footer!",
          style: TextStyle(fontSize: 20),
        ))
      ],
    );
  }
}
