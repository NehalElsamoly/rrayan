import 'package:flutter/material.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:easy_localization/easy_localization.dart'as localized;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../product_detail.dart';
import 'add_to_cart.dart';

class SimilarProduct extends StatefulWidget {
  final List similar;

  const SimilarProduct({Key? key, required this.similar}) : super(key: key);

  @override
  State<SimilarProduct> createState() => _SimilarProductState();
}

class _SimilarProductState extends State<SimilarProduct> {
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
    String sale = (lang == 'en') ? 'OFF' : 'خصم';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          LocalKeys.SIMILAR_PRODUCT.tr(),
          style: TextStyle(
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        SizedBox(
          height: h * 0.015,
        ),
        GridView.builder(
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
                        productId: widget.similar[index].id.toString());
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
                                      widget.similar[index].img.toString(),
                                  context: context,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          (widget.similar[index].hasOffer == 1)
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
                                  " %${(((widget.similar[index]
                                      .beforePrice -widget.similar[index].price) / widget.similar[index]
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
                                          widget.similar[index].titleEn,
                                          widget.similar[index].titleAr),
                                      textAlign:
                                      TextAlign.start,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: w * 0.035,fontWeight: FontWeight.bold),
                                      overflow: TextOverflow
                                          .ellipsis)),
                              SizedBox(height: h*0.01,),
                              (widget.similar[index].hasOffer == 1) ?
                              SizedBox(
                                height: h*0.031,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (widget.similar[index].hasOffer == 1)
                                        Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice:
                                              widget.similar[index]
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
                              if (widget.similar[index].hasOffer == 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.similar[index].hasOffer == 1)
                                      Text(getProductprice(
                                          currency: currency,
                                          productPrice:
                                          widget.similar[index].price),
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
                                  ],
                                ),
                              if (widget.similar[index].hasOffer == 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.similar[index].hasOffer == 0)
                                      Text(getProductprice(
                                          currency: currency,
                                          productPrice:
                                          widget.similar[index].price),
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
                                  widget.similar[index].id
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
            itemCount: widget.similar.length),
        SizedBox(
          height: h * 0.05,
        ),

        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextAnimator(
                'Rayan store is the best place for shipping',
                style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.04,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0
                ),
                incomingEffect:
                WidgetTransitionEffects.incomingScaleDown(),
                characterDelay: const Duration(milliseconds: 50),
                atRestEffect: WidgetRestingEffects.wave(),
                //outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
