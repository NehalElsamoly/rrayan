import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileItem extends StatefulWidget {
  final VoidCallback press;
  final String title;
  final String image;
  const ProfileItem(
      {Key? key, required this.press, required this.title, required this.image})
      : super(key: key);

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  int? selected;
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
    double w = MediaQuery.of(context).size.width;
    return ListTile(
      onTap: widget.press,
      title: Text(
        widget.title,
        style: TextStyle(
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            fontSize: w * 0.04,
            color: Colors.black,
            fontWeight: FontWeight.w100),
      ),
      leading: Image.asset(
        widget.image,
        color: Colors.black,
        height: 30,
        width: 30,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: w * 0.03,
        color: Colors.black,
      ),
    );
  }
}
