// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product_detail/componnent/add_to_cart.dart';
import 'cubit/favourite_cubit.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  String lang = '';
  String currency = '';
  bool isLogin = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      isLogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    FavouriteCubit.get(context).getWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: h*0.06,
          title: Text(
            LocalKeys.FAV.tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.04,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
          //centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.01),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                  builder: (context, state) => badges.Badge(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        : const Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                    position: badges.BadgePosition.topStart(start: 6),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                        size: 25,
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
                  ),
                  listener: (context, state) {},
                ),
              ),
            ),
            SizedBox(
              width: w * 0.05,
            ),
          ],
        ),
        body: BlocConsumer<FavouriteCubit, FavouriteState>(
            builder: (context, state) {
          return (isLogin)
              ? ConditionalBuilder(
                  condition: state is! GetFavouriteLoadingState,
                  builder: (context) => ListView(
                    primary: true,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        vertical: h * 0.03, horizontal: w * 0.03),
                    children: [
                      SizedBox(
                        height: h * 0.01,
                      ),
                      (FavouriteCubit.get(context)
                              .wishlistModel!
                              .data!
                              .isNotEmpty)
                          ?  GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
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
                                          productId: FavouriteCubit.get(context)
                                              .wishlistModel!
                                              .data![index].id.toString());
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
                                                        FavouriteCubit.get(context)
                                                            .wishlistModel!
                                                            .data![index].img.toString(),
                                                    context: context,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            (FavouriteCubit.get(context)
                                                .wishlistModel!
                                                .data![index].hasOffer == 1)
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
                                                    " %${(((FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index]
                                                        .beforePrice -FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index].price) / FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index]
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
                                                            FavouriteCubit.get(context)
                                                                .wishlistModel!
                                                                .data![index].titleEn!,
                                                            FavouriteCubit.get(context)
                                                                .wishlistModel!
                                                                .data![index].titleAr!),
                                                        textAlign:
                                                        TextAlign.start,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: w * 0.035,fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                                SizedBox(height: h*0.01,),
                                                (FavouriteCubit.get(context)
                                                    .wishlistModel!
                                                    .data![index].hasOffer == 1) ?
                                                SizedBox(
                                                  height: h*0.031,
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        if (FavouriteCubit.get(context)
                                                            .wishlistModel!
                                                            .data![index].hasOffer == 1)
                                                          Text(
                                                            getProductprice(
                                                                currency: currency,
                                                                productPrice:
                                                                FavouriteCubit.get(context)
                                                                    .wishlistModel!
                                                                    .data![index]
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
                                                if (FavouriteCubit.get(context)
                                                    .wishlistModel!
                                                    .data![index].hasOffer == 1)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      if (FavouriteCubit.get(context)
                                                          .wishlistModel!
                                                          .data![index].hasOffer == 1)
                                                        Text(getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                            FavouriteCubit.get(context)
                                                                .wishlistModel!
                                                                .data![index].price),
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
                                                      if (FavouriteCubit.get(context)
                                                          .wishlistModel!
                                                          .data![index].availability == 0)
                                                        Text(translateString('Sold Out', 'نفذت'),
                                                            style: TextStyle(
                                                                fontFamily: 'Bahij',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: w * 0.03,
                                                                color: Colors.red[700])),
                                                    ],
                                                  ),
                                                if (FavouriteCubit.get(context)
                                                    .wishlistModel!
                                                    .data![index].hasOffer == 0)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      if (FavouriteCubit.get(context)
                                                          .wishlistModel!
                                                          .data![index].hasOffer == 0)
                                                        Text(getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                            FavouriteCubit.get(context)
                                                                .wishlistModel!
                                                                .data![index].price),
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
                                                      if (FavouriteCubit.get(context)
                                                          .wishlistModel!
                                                          .data![index].availability == 0)
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
                                          color: const Color(0xffF1F1F1),
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
                                                    login: isLogin,
                                                    productId:
                                                    FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index].id
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
                              itemCount: FavouriteCubit.get(context)
                                  .wishlistModel!
                                  .data!.length)
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
                    ],
                  ),
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/3099609.jpg",
                        height: h * 0.35,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Center(
                      child: Text(
                        LocalKeys.MUST_LOGIN.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            fontSize: w * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
        }, listener: (context, state) {
          if (state is GetFavouriteSuccessState) {
            print("-------------------------------------------------------");
          } else if (state is GetFavouriteLoadingState) {
            print("loading---------------------------------");
          }
        }));
  }
}
