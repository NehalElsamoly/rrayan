// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart_product/conponent.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../../componnent/http_services.dart';
import '../model/copoun_model.dart';

class RayanCartBody extends StatefulWidget {
  final int cartLength;
  static String lang = '';
  static String currency = '';
  static num finalPrice = 0;
  static num discount = 0.0;

  const RayanCartBody({Key? key,required this.cartLength}) : super(key: key);
  @override
  State<RayanCartBody> createState() => _RayanCartBodyState();
}

class _RayanCartBodyState extends State<RayanCartBody> {
  String lang = '';
  String currency = '';
  TextEditingController controller = TextEditingController();
  RoundedLoadingButtonController btncontroller =
      RoundedLoadingButtonController();
  CopounModel? copounModel;
  bool isCopoun = false;
  Future<CopounModel?> getCheckcobon(
      {required String cobon,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    try {
      var response = await http
          .post(Uri.parse(EndPoints.CHECK_COBON + "?coupon_code=$cobon"));
      var data = jsonDecode(response.body);
      print(response.body);
      if (data['status'] == 1) {
        controller.success();
        setState(() {
          copounModel = CopounModel.fromJson(data);
          isCopoun = true;
        });
        RayanCartBody.discount =
            (copounModel!.data!.percentage! * RayanCartBody.finalPrice) / 100;
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pop(context);
        return copounModel;
      } else {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Fluttertoast.showToast(
            msg: data['message'].toString(),
            textColor: Colors.white,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        Navigator.pop(context);
      }
    } catch (error) {
      print("errrrrrrrrrrrrrrrrrrrrrrrrrro " + error.toString());
    }
    return copounModel;
  }

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    RayanCartBody.finalPrice = 0;
    setState(
      () {
        RayanCartBody.lang = preferences.getString('language').toString();
        lang = preferences.getString('language').toString();
        RayanCartBody.currency = preferences.getString('currency').toString();
        currency = preferences.getString('currency').toString();
        for (var item in DataBaseCubit.get(context).cart) {
          RayanCartBody.finalPrice += item['productPrice'] * item['productQty'];
        }
      },
    );
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return BlocConsumer<DataBaseCubit, DatabaseStates>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            primary: true,
            shrinkWrap: true,
            padding:
                EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.02),
            children: [
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: DataBaseCubit.get(context).cart.length,
                itemBuilder: (context, index) {
                  return buildCartIem(
                    title: (RayanCartBody.lang == 'en')
                        ? DataBaseCubit.get(context).cart[index]['productNameEn']
                        : DataBaseCubit.get(context).cart[index]['productNameAr'],
                    price: DataBaseCubit.get(context).cart[index]
                            ['productPrice'] *
                        DataBaseCubit.get(context).counter[
                            DataBaseCubit.get(context).cart[index]['productId']],
                    description: (RayanCartBody.lang == 'en')
                        ? DataBaseCubit.get(context).cart[index]['productDescEn']
                        : DataBaseCubit.get(context).cart[index]['productDescAr'],
                    image: DataBaseCubit.get(context).cart[index]['productImg'],
                    qty: (DataBaseCubit.get(context).counter[
                                DataBaseCubit.get(context).cart[index]
                                    ['productId']] ==
                            null)
                        ? DataBaseCubit.get(context).cart[index]['productQty']
                        : DataBaseCubit.get(context).counter[
                            DataBaseCubit.get(context).cart[index]['productId']],
                    context: context,
                    decreaseqty: () {
                      if (DataBaseCubit.get(context).cart.isEmpty) {
                        setState(() {
                          RayanCartBody.finalPrice = 0;
                        });
                      }
                      if (DataBaseCubit.get(context).counter[
                              DataBaseCubit.get(context).cart[index]
                                  ['productId']] ==
                          1) {
                        DataBaseCubit.get(context).deletaFromDB(
                          id: DataBaseCubit.get(context).cart[index]['productId'],
                        );
                        setState(() {
                          RayanCartBody.finalPrice -= DataBaseCubit.get(context)
                              .cart[index]['productPrice'];
                        });
                      } else {
                        setState(() {
                          DataBaseCubit.get(context).counter[
                                  DataBaseCubit.get(context).cart[index]
                                      ['productId']] =
                              int.parse(DataBaseCubit.get(context)
                                      .cart[index]['productQty']
                                      .toString()) -
                                  1;
                          RayanCartBody.finalPrice -= DataBaseCubit.get(context)
                              .cart[index]['productPrice'];
                          if (RayanCartBody.finalPrice < 0 ||
                              DataBaseCubit.get(context).cart.isEmpty) {
                            RayanCartBody.finalPrice = 0;
                          }
                        });
                      }
                      DataBaseCubit.get(context).updateDatabase(
                        productId: DataBaseCubit.get(context).cart[index]
                            ['productId'],
                        productQty: DataBaseCubit.get(context).counter[
                            DataBaseCubit.get(context).cart[index]['productId']]!,
                      );
                    },
                    increaseqty: BlocConsumer<CartCubit, CartState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () async {
                            CartCubit.get(context).checkProductQty(
                                context: context,
                                productId: DataBaseCubit.get(context)
                                    .cart[index]['productId']
                                    .toString(),
                                productQty: DataBaseCubit.get(context)
                                    .cart[index]['productQty']
                                    .toString(),
                                sizeId: DataBaseCubit.get(context)
                                    .cart[index]['sizeId']
                                    .toString(),
                                colorId: DataBaseCubit.get(context)
                                    .cart[index]['colorId']
                                    .toString());
                          },
                          child: Icon(
                            Icons.add,
                            size: w * 0.06,
                          ),
                        );
                      },
                      listener: (context, state) {
                        if (state is CheckProductAddcartSuccessState &&
                            DataBaseCubit.get(context).counter[
                                    DataBaseCubit.get(context).cart[index]
                                        ['productId']]! <=
                                CartCubit.get(context).totalQuantity) {
                          setState(() {
                            RayanCartBody.finalPrice += DataBaseCubit.get(context)
                                .cart[index]['productPrice'];
                          });
                        } else if (state is CheckProductAddcartSuccessState &&
                            DataBaseCubit.get(context).counter[
                                    DataBaseCubit.get(context).cart[index]
                                        ['productId']]! >
                                CartCubit.get(context).totalQuantity) {
                          setState(() {
                            RayanCartBody.finalPrice = RayanCartBody.finalPrice;
                          });
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: h * 0.03,
                ),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              cobonButton(
                context: context,
              ),
              SizedBox(
                height: h * 0.05,
              ),
              Row(
                children: [
                  Text(
                    LocalKeys.PRICE.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.04,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    getProductprice(
                        currency: RayanCartBody.currency,
                        productPrice: RayanCartBody.finalPrice),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.04,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: h * 0.03,
              ),
              BlocConsumer<HomeCubit, AppCubitStates>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Text(
                          LocalKeys.SHIPPING.tr(),
                          style: TextStyle(
                            color: (HomeCubit.get(context)
                                        .settingModel!
                                        .data!
                                        .isFreeShop! ==
                                    0)
                                ? Colors.black
                                : Colors.red,
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.04,
                          ),
                        ),
                        const Spacer(),
                        (HomeCubit.get(context).settingModel!.data!.isFreeShop! ==
                                0)
                            ? Text(
                                LocalKeys.DEPEND_CITY.tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: (RayanCartBody.lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.04,
                                ),
                              )
                            : Text(
                                LocalKeys.FREE_SHIPPING.tr(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: (RayanCartBody.lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.04,
                                ),
                              )
                      ],
                    );
                  },
                  listener: (context, state) {}),
              SizedBox(
                height: h * 0.03,
              ),
              (isCopoun)
                  ? Row(
                      children: [
                        Text(
                          LocalKeys.DISCOUNT.tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.04,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          getProductprice(
                              currency: RayanCartBody.currency,
                              productPrice: double.parse(
                                  ((RayanCartBody.finalPrice *
                                              copounModel!.data!.percentage!) /
                                          100)
                                      .toStringAsFixed(2))),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.04,
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: h * 0.03,
              ),
              myDiv(height: 1),
              SizedBox(
                height: h * 0.03,
              ),
              BlocConsumer<CartCubit, CartState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Row(
                    children: [
                      Text(
                        LocalKeys.TOTAL_PRICE.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.04,
                        ),
                      ),
                      const Spacer(),
                      (isCopoun)
                          ? Text(
                              getProductprice(
                                  currency: RayanCartBody.currency,
                                  productPrice: (RayanCartBody.finalPrice -
                                      (RayanCartBody.finalPrice *
                                              copounModel!.data!.percentage!) /
                                          100)),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: (RayanCartBody.lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.04,
                              ),
                            )
                          : Text(
                              getProductprice(
                                  currency: RayanCartBody.currency,
                                  productPrice: RayanCartBody.finalPrice),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: (RayanCartBody.lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.04,
                              ),
                            ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              if(currency != 'OMR')
                TabbyPresentationSnippet(
                  price: getProductPriceTabby(currency: currency, productPrice: RayanCartBody.finalPrice),
                  currency: currency == 'BHD' ? Currency.bhd : currency == 'QAR' ? Currency.qar : currency == 'AED' ? Currency.aed : currency == 'SAR' ? Currency.sar : Currency.kwd,
                  lang: lang == 'en' ? Lang.en :Lang.ar,
                ),
              const SizedBox(
                height: 10,
              ),
              payButton(context: context, cartLength: widget.cartLength),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget cobonButton({required BuildContext context}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final formKey = GlobalKey<FormState>();
    return InkWell(
      onTap: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w * 0.05)),
                      title: BlocConsumer<CartCubit, CartState>(
                          builder: (context, state) => Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(LocalKeys.ADD_COBON.tr()),
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: controller,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: LocalKeys.ADD_COBON.tr(),
                                        border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: mainColor)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: mainColor)),
                                        errorBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: mainColor)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                    ),
                                    SizedBox(
                                      height: h * 0.03,
                                    ),
                                    RoundedLoadingButton(
                                        controller: btncontroller,
                                        color: Colors.black,
                                        successColor: Colors.green,
                                        errorColor: Colors.red,
                                        disabledColor: Colors.white,
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                              'cobon', controller.text);
                                          getCheckcobon(
                                              cobon: controller.text,
                                              context: context,
                                              controller: btncontroller);
                                        },
                                        borderRadius: 5,
                                        child: Text(
                                          LocalKeys.SEND.tr(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                              ),
                          listener: (context, state) async {}),
                    );
                  },
                ));
      },
      child: Container(
        padding: (RayanCartBody.lang == 'en')
            ? EdgeInsets.only(
                left: w * 0.04,
              )
            : EdgeInsets.only(
                right: w * 0.04,
              ),
        height: h * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w * 0.01),
            color: Colors.black,
            border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocalKeys.ADD_COBON.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
                fontFamily: (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
              ),
            ),
            // const Spacer(),
            // Container(
            //   height: h * 0.08,
            //   width: w * 0.3,
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(w * 0.04),
            //       border: Border.all(color: Colors.pinkAccent)),
            //   child: Center(
            //     child: Text(
            //       '',
            //       style: TextStyle(
            //         fontSize: w * 0.04,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black,
            //         fontFamily:
            //             (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
