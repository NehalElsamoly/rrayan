import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';


class AppWidget{
  static createProgressDialog(BuildContext context, String msg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:Colors.white,
            content: Row(
              children: [
                CircularProgressIndicator(
                  color: mainColor,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  msg,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                )
              ],
            ),
          );
        });
  }

}