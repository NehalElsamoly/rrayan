// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/allproducts/new_product/new_product.dart';
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/section_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../product_detail/componnent/add_to_cart.dart';

class NewProducts extends StatefulWidget {
  final List newItem;

  const NewProducts({Key? key, required this.newItem}) : super(key: key);
  @override
  _NewProductsState createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
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

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
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
                        productId: widget.newItem[index].id.toString());
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
                                      widget.newItem[index].img.toString(),
                                  context: context,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          (widget.newItem[index].hasOffer == 1)
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
                                    " %${(((widget
                                        .newItem[index]
                                        .beforePrice - widget
                                        .newItem[index].price) / widget
                                        .newItem[index]
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
                                          widget.newItem[index].titleEn,
                                          widget.newItem[index].titleAr),
                                      textAlign:
                                      TextAlign.start,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: w * 0.035,fontWeight: FontWeight.bold),
                                      overflow: TextOverflow
                                          .ellipsis)),
                              SizedBox(height: h*0.01,),
                              (widget.newItem[index].hasOffer == 1) ?
                              SizedBox(
                                height: h*0.031,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (widget.newItem[index].hasOffer == 1)
                                        Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice:
                                              widget
                                                  .newItem[index]
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
                              if (widget.newItem[index].hasOffer == 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.newItem[index].hasOffer == 1)
                                      Text(getProductprice(
                                          currency: currency,
                                          productPrice:
                                          widget.newItem[index].price),
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
                                    if (widget.newItem[index].availability == 0)
                                      Text(translateString('Sold Out', 'نفذت'),
                                          style: TextStyle(
                                              fontFamily: 'Bahij',
                                              fontWeight: FontWeight.bold,
                                              fontSize: w * 0.03,
                                              color: Colors.red[700])),
                                  ],
                                ),
                              if (widget.newItem[index].hasOffer == 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.newItem[index].hasOffer == 0)
                                      Text(getProductprice(
                                          currency: currency,
                                          productPrice:
                                          widget.newItem[index].price),
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
                                    if (widget.newItem[index].availability == 0)
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
                                  widget.newItem[index].id
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
        itemCount: widget.newItem.length > 4 ? 4 : widget.newItem.length);
  }
}
