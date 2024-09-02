// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print
import 'package:easy_localization/easy_localization.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/app_cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/product_detail/componnent/full_slider.dart';
import 'package:rayan_store/screens/product_detail/componnent/similar.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import '../../mock.dart';
import '../cart/cart.dart';
import 'componnent/add_to_cart.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String lang = '';
  int count = 1;
  String currency = '';
  bool login = false;
  bool click = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      login = preferences.getBool('login') ?? false;
    });
  }

  size() {
    count = 1;
    AppCubit.get(context).sizeselected = null;
    AppCubit.get(context).sizeSelection(selected: null, title: null);
    AppCubit.get(context).colorselected = null;
    AppCubit.get(context).colorSelection(selected: null, title: null);
  }

  @override
  void initState() {
    getLang();
    size();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return BlocConsumer<HomeCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: h * 0.04,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: state is! SingleProductLoaedingState ? (lang == 'en')
                  ? Text(
                      HomeCubit.get(context).singleProductModel!.data!.titleEn!,
                      style: TextStyle(
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  : Text(
                      HomeCubit.get(context).singleProductModel?.data?.titleAr??"",
                      style: TextStyle(
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ) : Container(),
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            body: ConditionalBuilder(
                condition: state is! SingleProductLoaedingState,
                builder: (context) => Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.01),
                                    child: SizedBox(
                                      width: w,
                                      height: h * 0.65,
                                      child: (HomeCubit.get(context)
                                              .singleProductModel!
                                              .data!
                                              .images!
                                              .isNotEmpty)
                                          ? Swiper(
                                              pagination: const SwiperPagination(
                                                  builder:
                                                      DotSwiperPaginationBuilder(
                                                          color: Colors.white38,
                                                          activeColor:
                                                              Colors.white),
                                                  alignment:
                                                      Alignment.bottomCenter),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return InkWell(
                                                  focusColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => FullSliderScreen(
                                                                login: login,
                                                                productId: HomeCubit
                                                                        .get(
                                                                            context)
                                                                    .singleProductModel!
                                                                    .data!
                                                                    .id
                                                                    .toString(),
                                                                image: HomeCubit
                                                                        .get(
                                                                            context)
                                                                    .singleProductModel!
                                                                    .data!
                                                                    .images!)));
                                                  },
                                                  child: Container(
                                                    color: Colors.white,
                                                    child:
                                                        customCachedNetworkImage(
                                                      url: EndPoints.IMAGEURL +
                                                          HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .images![i]
                                                              .img!,
                                                      fit: BoxFit.cover,
                                                      context: context,
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: HomeCubit.get(context)
                                                  .singleProductModel!
                                                  .data!
                                                  .images!
                                                  .length,
                                              autoplay: true,
                                              autoplayDelay: 5000,
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => FullSliderScreen(
                                                            image: const [],
                                                            login: login,
                                                            productId: HomeCubit
                                                                    .get(context)
                                                                .singleProductModel!
                                                                .data!
                                                                .id
                                                                .toString(),
                                                            productImage: HomeCubit.get(context).singleProductModel!.data!.img!)));
                                              },
                                              child: Container(
                                                color: Colors.white,
                                                child: customCachedNetworkImage(
                                                    url: EndPoints.IMAGEURL2 +
                                                        HomeCubit.get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .img!,
                                                    context: context,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () => Navigator.pop(context),
                                  //   child: Padding(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: w * 0.02),
                                  //     child: Icon(
                                  //       Icons.arrow_back_ios,
                                  //       color: Colors.black,
                                  //       size: w * 0.07,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: h * 0.01, horizontal: w * 0.04),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: h * 0.01,
                                              horizontal: w * 0.01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (lang == 'en')
                                                  ? Text(
                                                      HomeCubit.get(context)
                                                          .singleProductModel!
                                                          .data!
                                                          .titleEn!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          fontSize: w * 0.06,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    )
                                                  : Text(
                                                      HomeCubit.get(context)
                                                          .singleProductModel!
                                                          .data!
                                                          .titleAr!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          fontSize: w * 0.06,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                              InkWell(
                                                onTap: () async {
                                                  if (!click) {
                                                    setState(() {
                                                      click = true;
                                                    });
                                                    Share.share(
                                                        "https://rayan-storee.com/$lang/product/${HomeCubit.get(context).singleProductModel!.data!.id!}",
                                                        subject: "");
                                                    await Future.delayed(
                                                        const Duration(milliseconds: 2500));
                                                    setState(() {
                                                      click = false;
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.share,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.015,
                                                    ),
                                                    Text(
                                                      translateString(
                                                          "Share", "مشاركة"),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          fontSize: w * 0.04,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.03,
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getProductprice(
                                                    currency: currency,
                                                    productPrice:
                                                        HomeCubit.get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .price!),
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.05,
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                children: [
                                                  (HomeCubit.get(context)
                                                      .singleProductModel!
                                                      .data!
                                                      .hasOffer ==
                                                      1)
                                                      ? Text(
                                                    getProductprice(
                                                        currency: currency,
                                                        productPrice: HomeCubit
                                                            .get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .beforePrice),
                                                    style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      decoration:
                                                      TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                      Colors.red[700],
                                                      color: Colors.red[700],
                                                      fontFamily:
                                                      (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                    ),
                                                  )
                                                      : Container(),
                                                  SizedBox(
                                                    width: w * 0.05,
                                                  ),
                                                  favouriteButton(
                                                      context: context,
                                                      login: login,
                                                      productId:
                                                      HomeCubit.get(context)
                                                          .singleProductModel!
                                                          .data!
                                                          .id
                                                          .toString()),
                                                ],
                                              )
                                            ]
                                        ),
                                        SizedBox(
                                          height: h * 0.03,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.01),
                                          child: Row(
                                            children: [
                                              Text(
                                                translateString('description : ', 'وصف المنتج : '),
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.042,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              (lang == 'en')
                                                  ? Text(
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionEn!,
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.04,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: Colors.black),
                                              )
                                                  : Text(
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionAr!,
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.04,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: h * 0.03,
                                    ),
                                    (HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isEmpty)
                                        ? Text(
                                            LocalKeys.PRODUCT_UNAVAILABLE.tr(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontSize: w * 0.045,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.red[700]),
                                          )
                                        : Container(),
                                    (HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isEmpty)
                                        ? SizedBox(
                                            height: h * 0.03,
                                          )
                                        : Container(),
                                    (HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isNotEmpty)
                                        ? sizeColorSelection(
                                            context: context,
                                            w: w,
                                            h: h,
                                            lang: lang,
                                            size: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .sizes!,
                                            productId: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .id
                                                .toString())
                                        : Container(),
                                    SizedBox(
                                      height: h * 0.04,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: h * 0.015),
                                          child: Text(
                                            LocalKeys.QTY.tr(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontSize: w * 0.04),
                                          ),
                                        ),
                                        BlocConsumer<DataBaseCubit,
                                                DatabaseStates>(
                                            builder: (context, state) {
                                              return Container(
                                                width: w * 0.4,
                                                height: h * 0.055,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.015),
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    BlocConsumer<CartCubit,
                                                            CartState>(
                                                        builder:
                                                            (context, state) {
                                                      return SizedBox(
                                                        width: 40,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            if (AppCubit.get(
                                                                            context)
                                                                        .sizeselected !=
                                                                    null &&
                                                                AppCubit.get(
                                                                            context)
                                                                        .colorselected !=
                                                                    null) {
                                                              CartCubit.get(context).checkProductQty(
                                                                  context:
                                                                      context,
                                                                  productId: HomeCubit.get(context).singleProductModel!.data!.id.toString(),
                                                                  productQty: count
                                                                      .toString(),
                                                                  sizeId: prefs.getString('size_id').toString(),
                                                                  colorId: prefs.getString('color_id').toString());
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  textColor: Colors.white,
                                                                  backgroundColor: Colors.red,
                                                                  gravity: ToastGravity.TOP,
                                                                  toastLength: Toast.LENGTH_LONG,
                                                                  msg: LocalKeys.ATTRIBUTES.tr());
                                                            }
                                                          },
                                                          child:
                                                              Icon(Icons.add),
                                                        ),
                                                      );
                                                    }, listener:
                                                            (context, state) {
                                                      if (state
                                                              is CheckProductAddcartSuccessState &&
                                                          count <
                                                              CartCubit.get(
                                                                      context)
                                                                  .totalQuantity) {
                                                        setState(() {
                                                          count++;
                                                          print(count);
                                                        });
                                                      } else if (state
                                                          is CheckProductAddcartErroState) {
                                                        setState(() {
                                                          count = count;
                                                        });
                                                      }
                                                    }),
                                                    Text(
                                                      count.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          fontSize: w * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                      child: InkWell(
                                                          onTap: () async {
                                                            if (count == 1) {
                                                              setState(() {
                                                                count = 1;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                count--;
                                                              });
                                                            }
                                                          },
                                                          child: const Icon(
                                                              Icons.remove)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            listener: (context, state) {}),
                                      ],
                                    ),
                                    // ignore: prefer_const_constructors
                                    SizedBox(
                                      height: h * 0.04,
                                    ),
                                    if(currency != 'OMR')
                                    TabbyPresentationSnippet(
                                      price: getProductPriceTabby(currency: currency, productPrice: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .price!),
                                      currency: currency == 'BHD' ? Currency.bhd : currency == 'QAR' ? Currency.qar : currency == 'AED' ? Currency.aed : currency == 'SAR' ? Currency.sar : Currency.kwd,
                                      lang: lang == 'en' ? Lang.en :Lang.ar,
                                    ),
                                    SizedBox(
                                      height: h * 0.04,
                                    ),
                                    BlocConsumer<DataBaseCubit, DatabaseStates>(
                                        builder: (context, state) => InkWell(
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                if (HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .sizes!
                                                    .isNotEmpty) {
                                                  if (DataBaseCubit.get(context)
                                                          .isexist[HomeCubit
                                                              .get(context)
                                                          .singleProductModel!
                                                          .data!
                                                          .id] ==
                                                      true) {
                                                    Navigator.push(
                                                        context, MaterialPageRoute(builder: (context) => const Cart()));
                                                  } else {
                                                    if (AppCubit.get(context)
                                                                .colorselected ==
                                                            null ||
                                                        AppCubit.get(context)
                                                                .sizeselected ==
                                                            null) {
                                                      Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.black,
                                                          gravity:
                                                              ToastGravity.TOP,
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          msg: LocalKeys
                                                              .ATTRIBUTES
                                                              .tr());
                                                    } else if (AppCubit.get(
                                                                context)
                                                            .colorselected ==
                                                        null) {
                                                      Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.black,
                                                          gravity:
                                                              ToastGravity.TOP,
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          msg:
                                                              "you should select color");
                                                    } else {
                                                      DataBaseCubit.get(context).inserttoDatabase(
                                                          sizeOption: int.parse(prefs
                                                              .getString(
                                                                  'sizeOption')
                                                              .toString()),
                                                          colorOption: int.parse(prefs
                                                              .getString(
                                                                  'colorOption')
                                                              .toString()),
                                                          productId: HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .id!,
                                                          productNameEn: HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .titleEn!,
                                                          productNameAr:
                                                              HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .titleAr!,
                                                          productDescEn: HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .descriptionEn!,
                                                          productDescAr: HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .descriptionAr!,
                                                          productQty: count,
                                                          productPrice: HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .price,
                                                          productImg: HomeCubit.get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .img!,
                                                          sizeId: int.parse(prefs.getString('size_id').toString()),
                                                          colorId: int.parse(prefs.getString('color_id').toString()));
                                                      Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.black,
                                                          gravity:
                                                              ToastGravity.TOP,
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          msg: LocalKeys.ADD_CAR
                                                              .tr());
                                                    }
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.red,
                                                      gravity: ToastGravity.TOP,
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      msg: LocalKeys
                                                          .PRODUCT_UNAVAILABLE
                                                          .tr());
                                                }
                                              },
                                              child: Container(
                                                width: w,
                                                height: h * 0.058,
                                                color: Colors.black,
                                                child: Center(
                                                  child: (DataBaseCubit.get(
                                                                  context)
                                                              .isexist[HomeCubit
                                                                  .get(context)
                                                              .singleProductModel!
                                                              .data!
                                                              .id!] ==
                                                          true)
                                                      ? Text(
                                                          translateString('Show cart', 'مشاهدة السلة'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  (lang == 'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  w * 0.045),
                                                        )
                                                      : Text(
                                                          LocalKeys.ADD_CART
                                                              .tr(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  (lang == 'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  w * 0.05),
                                                        ),
                                                ),
                                              ),
                                            ),
                                        listener: (context, state) {}),
                                    SizedBox(
                                      height: h * 0.04,
                                    ),
                                    (HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .relatedProducts!
                                            .isNotEmpty)
                                        ? SimilarProduct(
                                            similar: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .relatedProducts!,
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: h * 0.1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // addtoCartHeader(
                        //     context: context,
                        //     w: w,
                        //     h: h,
                        //     count: count,
                        //     currency: currency,
                        //     lang: lang),
                      ],
                    ),
                fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    )));
      },
    );
  }
}
