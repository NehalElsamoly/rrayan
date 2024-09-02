// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/allproducts/model/newproduct_model.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../product_detail/componnent/add_to_cart.dart';

class NewProductScreen extends StatefulWidget {
  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  late ScrollController scrollController;
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List products = [];
  String lang = '';
  String currency = '';
  bool login = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      login = preferences.getBool('login') ?? false;
    });
  }

  void firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });
    try {
      var response = await http
          .get(Uri.parse(EndPoints.BASE_URL + "new_arrive?page=$page"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        NewproductModel newproductModel = NewproductModel.fromJson(data);
        setState(() {
          products = newproductModel.data!.newArrivals!.dataItems!;
        });
      }
    } catch (error) {
      print("product error ----------------------" + error.toString());
    }
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 15) {
      setState(() {
        isLoadMoreRunning = true;
        page++;
      });
      List fetchedPosts = [];
      try {
        var response = await http
            .get(Uri.parse(EndPoints.BASE_URL + "new_arrive?page=$page"));
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          NewproductModel newproductModel = NewproductModel.fromJson(data);
          setState(() {
            fetchedPosts = newproductModel.data!.newArrivals!.dataItems!;
          });
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            products.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (error) {
        print("product error ----------------------" + error.toString());
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    getLang();
    firstLoad();
    scrollController = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    String sale = (lang == 'en') ? 'OFF' : 'خصم';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: h*0.05,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          LocalKeys.HOME_NEW.tr(),
          style: TextStyle(
              color: Colors.black, fontSize: w * 0.04, fontFamily: 'Nunito'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.01),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                builder: ((context, state) => badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: mainColor,
                  ),
                  badgeAnimation: const badges.BadgeAnimation.slide(
                    animationDuration: Duration(
                      seconds: 1,
                    ),
                  ),
                      badgeContent: (DataBaseCubit.get(context).cart.isNotEmpty)
                          ? Text(
                              DataBaseCubit.get(context).cart.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.03,
                              ),
                            )
                          : Text(
                              "0",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.03,
                              ),
                            ),
                      position: badges.BadgePosition.topStart(start: w * 0.007),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        focusColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Cart()));
                        },
                      ),
                    )),
                listener: (context, state) {},
              ),
            ),
          ),
          SizedBox(
            width: w * 0.05,
          ),
        ],
      ),
      body: isFirstLoadRunning
          ? Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric( horizontal: w * 0.03),
              child: Column(
                children: [
                  (products.isNotEmpty)
                      ? Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.01, horizontal: w * 0.01),
                            child: Card(
                              elevation: 0.5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  HomeCubit.get(context).getProductdata(
                                      productId: products[index].id.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail()));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                          child: Container(
                                            width: w * 0.45,
                                            height: h * 0.28,
                                            color: Colors.white,
                                            child: customCachedNetworkImage(
                                                url: EndPoints.IMAGEURL2 +
                                                    products[index].img.toString(),
                                                context: context,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        (products[index].hasOffer == 1)
                                            ? Positioned(
                                          top: h*0.02,
                                          right: lang == 'en' ? w*0.02 :w*0.33,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(3)
                                            ),
                                            height: h*0.031,
                                            child: Center(
                                              child: Text(
                                                " %${(((products[index]
                                                    .beforePrice -products[index].price) / products[index]
                                                    .beforePrice ) * 100).toInt()} ",
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                    'Bahij',
                                                    fontSize: w * 0.028,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: SizedBox(
                                        width: w * 0.41,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: w * 0.44,
                                                height: h*0.048,
                                                child: Text(
                                                    translateString(
                                                        products[index].titleEn,
                                                        products[index].titleAr),
                                                    textAlign:
                                                    TextAlign.start,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: w * 0.035,fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow
                                                        .ellipsis)),
                                            SizedBox(height: h*0.01,),
                                            (products[index].hasOffer == 1) ?
                                            SizedBox(
                                              height: h*0.031,
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    if (products[index].hasOffer == 1)
                                                      Text(
                                                        getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                            products[index]
                                                                .beforePrice),
                                                        style: TextStyle(
                                                            fontSize: w * 0.04,
                                                            // decorationThickness:
                                                            // w * 0.1,
                                                            backgroundColor: Colors.transparent,
                                                            decoration: TextDecoration
                                                                .lineThrough,
                                                            decorationColor: Colors.red,
                                                            color: Colors.red
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      width: w * 0.02,
                                                    ),
                                                  ]),
                                            ) : SizedBox(height: h*0.031,),
                                            if (products[index].hasOffer == 1)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if (products[index].hasOffer == 1)
                                                    Text(getProductprice(
                                                        currency: currency,
                                                        productPrice:
                                                        products[index].price),
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'Bahij',
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            w * 0.04,
                                                            color: Colors
                                                                .black)),
                                                  if (products[index].availability == 0)
                                                    Text(translateString('Sold Out', 'نفذت'),
                                                        style: TextStyle(
                                                            fontFamily: 'Bahij',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: w * 0.03,
                                                            color: Colors.red[700])),
                                                ],
                                              ),
                                            if (products[index].hasOffer == 0)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if (products[index].hasOffer == 0)
                                                    Text(getProductprice(
                                                        currency: currency,
                                                        productPrice:
                                                        products[index].price),
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'Bahij',
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            w * 0.04,
                                                            color: Colors
                                                                .black)),
                                                  if (products[index].availability == 0)
                                                    Text(translateString('Sold Out', 'نفذت'),
                                                        style: TextStyle(
                                                            fontFamily: 'Bahij',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: w * 0.03,
                                                            color: Colors.red[700])),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xffF1F1F1),
                                      width: w*0.45,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            favouriteButton(
                                                context: context,
                                                login: login,
                                                productId:
                                                products[index].id
                                                    .toString()),
                                            InkWell(
                                              child: Container(
                                                height: h*0.05,
                                                width: w*0.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    translateString('Buy Now', 'اشتر الآن'),
                                                    style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                      fontFamily: 'Bahij',
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 0.005*h,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: w * 0.01,
                            mainAxisSpacing: w * 0.02,
                            crossAxisCount: 2,
                            mainAxisExtent: h*0.49,),
                          itemCount: products.length)
                  )
                      : Padding(
                          padding: EdgeInsets.only(top: h * 0.3),
                          child: Center(
                            child: Text(
                              LocalKeys.NO_PRODUCT.tr(),
                              style: TextStyle(
                                  color: mainColor,
                                  fontFamily:
                                      (lang == 'en') ? 'Nunito' : 'Almarai',
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                  if (isLoadMoreRunning == true)
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                    ),

                  // When nothing else to load
                  if (hasNextPage == false)
                    Container(
                      padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          LocalKeys.NO_MORE_PRODUCT.tr(),
                          style: TextStyle(
                              fontFamily:
                                  (lang == 'en') ? 'Nunito' : 'Alamrai'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
