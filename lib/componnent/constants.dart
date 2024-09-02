// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color mainColor = const Color(0xfffe4194);
Color mainColor2 = const Color(0xffff979c);

///////////////////////////////////////////////////////////////////////

homeBottomSheet({context, child}) {
  var w = MediaQuery.of(context).size.width;

  return showModalBottomSheet(
    isDismissible: true,
    context: context,
    builder: (context) => child,
  );
}
////////////////////////////////////////////////////////////////////////////////////

customCachedNetworkImage(
    {required String url, required context, required BoxFit fit}) {
  try {
    // ignore: unnecessary_null_comparison
    if (url == null || url == "") {
      return Icon(
        Icons.error,
        color: HexColor("#AB0D03"),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Grey shadow with some transparency
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Change the offset as needed
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // Ensure the border radius is applied to the image as well
          child: (Uri.parse(url).isAbsolute)
              ? CachedNetworkImage(
            imageUrl: url,
            fit: fit,
        //    scale: 40.sp,
            // placeholder: (context, url) => SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.02,
            //   height: MediaQuery.of(context).size.height * 0.02,
            //   child: Image.asset(
            //     "assets/icons/LOGO.png",
            //     fit: BoxFit.contain,
            //   ),
            // ),
              placeholder: (context, url) =>Center(child: CircularProgressIndicator(                    color: mainColor,
              )),
            errorWidget: (context, url, error) {
              return Image.asset(
                      "assets/icons/LOGO.png",
                      fit: BoxFit.contain,
                    );
            },
          )
              :  Image.asset(
            "assets/icons/LOGO.png",
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  } catch (e) {
    print(e.toString());
  }
}

///////////////////////////////////////////////////////////////////////////////

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

late SharedPreferences prefs;
Future startShared() async {
  prefs = await SharedPreferences.getInstance();
}
////////////////////////////////////////////////////////////

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

//////////////////////////////////////////////////////////////////////////////////////

getProductprice({required String currency, required num productPrice}) {
  String ratio = prefs.getString("ratio").toString();
  num ratioPrice = num.parse(ratio);
  String price = "";

  if (currency != 'KWD') {
    num finalPrice = productPrice / ratioPrice;
    price = finalPrice.toStringAsFixed(2).toString() + " " + currency;
    return price;
  } else {
    num finalPrice = productPrice;
    price = finalPrice.toStringAsFixed(2).toString() + " " + currency;
    return price;
  }
}
//////////////////////////////////////////////////////////////////////

getProductPriceTabby({required String currency, required num productPrice}) {
  String ratio = prefs.getString("ratio").toString();
  num ratioPrice = num.parse(ratio);
  String price = "";

  if (currency != 'KWD') {
    num finalPrice = productPrice / ratioPrice;
    price = finalPrice.toStringAsFixed(2).toString();
    return price;
  } else {
    num finalPrice = productPrice;
    price = finalPrice.toStringAsFixed(2).toString();
    return price;
  }
}

//////////////////////////////////////////////////////////////////////

getfinalPrice(
    {required num productPrice, required String currency, required int count}) {
  String ratio = prefs.getString("ratio").toString();
  num ratioPrice = num.parse(ratio);

  if (currency != 'KWD') {
    num subPrice = productPrice / ratioPrice;
    num finalPrice = subPrice * count;

    return finalPrice.toStringAsFixed(2);
  } else {
    num subPrice = productPrice;
    num finalPrice = subPrice * count;
    return finalPrice.toStringAsFixed(2);
  }
}
///////////////////////////////////////////////////

String translateString(String a, String b) {
  return prefs.getString('language').toString() == 'en' ? a : b;
}

//////////////////////////////////////////////////////////////////////////////////////

getShippingprice(
    {required String currency,
    required num shippingPrice,
    required int cartLength}) {
  String ratio = prefs.getString("ratio").toString();
  num ratioPrice = num.parse(ratio);
  String price = "";
  num shippingVal = 0;
  if (currency != 'KWD') {
    if (cartLength == 1) {
      num finalPrice = 10 / ratioPrice;
      price = finalPrice.toStringAsFixed(2).toString() + " " + currency;
      return price;
    } else if (cartLength != 1) {
      shippingVal = 10 + (9 * (cartLength - 1));
      num finalPrice = shippingVal / ratioPrice;
      price = finalPrice.toStringAsFixed(2).toString() + " " + currency;
      return price;
    }
  } else {
    num finalPrice = shippingPrice;
    price = finalPrice.toStringAsFixed(2).toString() + " " + currency;
    return price;
  }
}

//////////////////////////////////////////////////////////////////////
String? appName;
String? packageName;
String? version;
String? buildNumber;
