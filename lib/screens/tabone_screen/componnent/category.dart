// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/allproducts/all_offers/all_offers.dart';
import 'package:rayan_store/screens/category/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySection extends StatefulWidget {
  final List catItem;

  const CategorySection({Key? key, required this.catItem}) : super(key: key);
  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
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
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: w,
      height: h * 0.22,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.catItem.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Column(
                    children: [
                      SizedBox(
                        width: w*0.3,
                        height: h * 0.17,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: customCachedNetworkImage(
                              url: EndPoints.IMAGEURL2 +
                                  widget.catItem[index].imageUrl,
                              context: context,
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: h*0.01,),
                      Align(
                        alignment:  (lang == 'en') ? Alignment.topLeft : Alignment.topRight,
                        child: (lang == 'en')
                            ? Center(
                              child: Text(
                                widget.catItem[index].nameEn,
                                maxLines: 3,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    color: Colors.black,
                                    fontSize: w * 0.028),
                                overflow: TextOverflow.clip,
                              ),
                            )
                            : Center(
                              child: Text(
                                widget.catItem[index].nameAr,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: w * 0.035,fontWeight: FontWeight.bold,

                                    fontFamily: 'Almarai',
                                    color: Colors.black,
                                    ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesSection(
                              mainCat: (lang == 'en') ? widget.catItem[index].nameEn : widget.catItem[index].nameAr,
                                  mainCatId:
                                      widget.catItem[index].id.toString(),
                                  subCategory:
                                      widget.catItem[index].categoriesSub,
                                )));
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                width: w * 0.02,
              ),
            ),
            SizedBox(
              width: w * 0.01,
            ),
            InkWell(
              child: Column(
                children: [
                  SizedBox(
                    width: w*0.3,
                    height: h * 0.17,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:  customCachedNetworkImage(
                          url:
                          "https://img.freepik.com/free-vector/offer-deals-banner-red-background_1017-27332.jpg?t=st=1650986981~exp=1650987581~hmac=929c4dbc40ddddbe5aa3f45a1b90256a52590418dc1e9ad5379ddf5f56cbd408&w=740",
                          context: context,
                          fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(height: h*0.01,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Center(
                      child: Text(
                        LocalKeys.HOME_OFFER.tr(),
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                            color: Colors.black,
                            fontSize: w * 0.028),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllOffersScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
