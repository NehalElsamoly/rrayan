// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/address/add_address.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/cart/cart_product/body.dart';

Widget buildCartIem(
    {required String title,
    required String description,
    required String image,
    required num price,
    required int qty,
    required Widget increaseqty,
    required VoidCallback decreaseqty,
    required BuildContext context}) {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;

  return Container(
    width: w,
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              EndPoints.IMAGEURL2 + image,
              width: w * 0.3,
              height: h * 0.29,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: w * 0.07,
            ),
            SizedBox(
              width: w*0.4,
              height: h * 0.29,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: w * 0.04,
                      fontFamily: (RayanCartBody.lang == 'en')
                          ? 'Nunito'
                          : 'Almarai',
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Text(getProductprice(
                      currency: RayanCartBody.currency,
                      productPrice: price),style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: w * 0.045,
                    fontFamily: (RayanCartBody.lang == 'en')
                        ? 'Nunito'
                        : 'Almarai',
                  ),),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  SizedBox(
                    width: w * 0.63,
                    child: Text(
                      description,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        fontSize: w * 0.04,
                        fontFamily:
                            (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Row(
                    children: [
                      increaseqty,
                      SizedBox(
                        width: w * 0.025,
                      ),
                      Text(
                        '$qty',
                        style: TextStyle(
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Alamari',
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: w * 0.025,
                      ),
                      InkWell(
                          onTap: decreaseqty,
                          child: Icon(
                            Icons.remove,
                            size: w * 0.06,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget myDiv({
  required double height,
}) =>
    Container(
      width: double.infinity,
      height: height,
      color: Colors.black54,
    );

Widget payButton({required BuildContext context, required final  cartLength}) {
  var w = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddressInfo(cartLength: cartLength,)));
    },
    child: Container(
      height: 55,
      decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(w * 0.01)),
      child: Center(
          child: Text(
        LocalKeys.CHECKOUT.tr(),
        style: TextStyle(
            fontSize: w * 0.05,
            fontFamily: (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
            fontWeight: FontWeight.bold,
            color: Colors.white),
      )),
    ),
  );
}
