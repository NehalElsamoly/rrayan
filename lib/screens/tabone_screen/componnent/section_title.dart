import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final VoidCallback press;
  const SectionTitle({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  _SectionTitleState createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
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
    return Padding(
      padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          InkWell(
            onTap: widget.press,
            child: Text(
              LocalKeys.SEE_ALL.tr(),
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.bold,
                  color: mainColor),
            ),
          )
        ],
      ),
    );
  }
}
