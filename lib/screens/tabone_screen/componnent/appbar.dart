// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:rayan_store/screens/cart/cart.dart';

import '../../../app_cubit/app_cubit.dart';
import '../../../app_cubit/appstate.dart';
import '../../notifications/noti.dart';
import '../../profile/cubit/userprofile_cubit.dart';
import '../../searchScreen/search_screen.dart';

class AppBarHome {
  late int currentindex;
  static PreferredSizeWidget app_bar_home(BuildContext context,
      {required String lang,required bool login}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return AppBar(

      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      //centerTitle: true,
      elevation: 0.0,
      toolbarHeight: h * 0.06,
      title:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      login?


        Text(
        ' مرحبا, ${ UserprofileCubit.get(context)
            ?.userModel?.name??""} ',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ):Text("مرحبا...."),
          Text(
            'RAYAN STORE',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size(w, h * 0.07),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: BlocConsumer<AppCubit, AppCubitStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: mainColor,
                    ),
                    badgeAnimation: const badges.BadgeAnimation.slide(
                      animationDuration: Duration(
                        seconds: 1,
                      ),
                    ),
                    badgeContent: Text(
                      login ? BlocProvider.of<AppCubit>(context).count == null
                          ? "0"
                          : BlocProvider.of<AppCubit>(context).count.toString() : "0",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    position: badges.BadgePosition.topStart(start: 3),
                    child: IconButton(
                      icon: SvgPicture.asset('assets/icons/notify.svg'),
                      padding: EdgeInsets.zero,
                      focusColor: Colors.white,
                      onPressed: () {
                        if(login){
                          BlocProvider.of<AppCubit>(context).notifyShow();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notifications()));
                        }else{
                          Fluttertoast.showToast(
                              msg: LocalKeys.MUST_LOGIN.tr(),
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
                },
                child: Container(
                  height:0.06*h,
                  width: 0.7*w,
                  decoration: BoxDecoration(
                      color: const Color(0xffF3F3F3),
                      borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 0.45*w,
                          //height: 7.h,
                          child: Text(translateString('search', 'عمَ تبحث؟'),
                            style: TextStyle(color: Colors.black,fontSize: w*0.033,fontWeight: FontWeight.w100,fontFamily: 'Bahij',),
                          ),
                        ),
                        const Icon(Icons.search,color: Colors.black,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const Cart()));
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                      builder: (context, state) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: mainColor,
                          ),
                          badgeAnimation: const badges.BadgeAnimation.slide(
                            animationDuration: Duration(
                              seconds: 1,
                            ),
                          ),
                          badgeContent:
                          (DataBaseCubit.get(context).cart.isNotEmpty)
                              ? Text(
                            DataBaseCubit.get(context)
                                .cart
                                .length
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                              : const Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          position: badges.BadgePosition.topStart(start: -8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: InkWell(
                              focusColor: Colors.white,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Cart()));
                              },
                              child: SvgPicture.asset('assets/icons/cart.svg'),
                            ),
                          ),
                        ),
                      ),
                      listener: (context, state) {})),
            ),
          ],
        ),
      ),
    );
  }
}
