// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/about_us/about_us.dart';
import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
import 'package:rayan_store/screens/contact%20us/contact_us.dart';
import 'package:rayan_store/screens/country/country.dart';
import 'package:rayan_store/screens/profile/componnent/profileimage.dart';
import 'package:rayan_store/screens/profile/componnent/profileitem.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/profile/delete_account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login.dart';
import 'componnent/user_lang.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? selected;
  String lang = '';
  bool isLogin = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      isLogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    deleteUserAccount(appversion: version);
    super.initState();
  }

  List<String> icons = [
    "assets/icon rayan/Group 931.png",
    "assets/about.png",
    "assets/icons/command.png",
    "assets/icon rayan/Group 927.png",
    "assets/icon rayan/Group 923.png",
    "assets/icon rayan/Group 934.png",
    "assets/icon rayan/Group 925.png",
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,
            toolbarHeight: h*0.05,
            elevation: 0,
            centerTitle: true,title: Text(
            (isLogin)
                ? UserprofileCubit.get(context)
                .userModel!
                .name!
                : LocalKeys.PROFILE.tr(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily:
                (lang == 'en') ? 'Nunito' : 'Almarai',
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )
          ),
          body: BlocConsumer<UserprofileCubit, UserprofileState>(
              builder: (context, state) {
                return ConditionalBuilder(
                    condition: state is! GetAllInfoLoadinState,
                    builder: (context) => Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height:10.h),
                                ProfileImage(
                                  isLogin: isLogin,
                                  userEmail: (isLogin)
                                      ? UserprofileCubit.get(context)
                                          .userModel!
                                          .email
                                          .toString()
                                      : '',
                                  userName: (isLogin)
                                      ? UserprofileCubit.get(context)
                                          .userModel!
                                          .name!
                                      : '',
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ProfileItem(
                                            press: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserLanguageSelection())),
                                            title: LocalKeys.LANG.tr(),
                                            image:
                                                "assets/icon rayan/Group 935.png"),
                                        ProfileItem(
                                            press: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Country(2))),
                                            title: LocalKeys.COUNTRY.tr(),
                                            image: "assets/icons/flag.png"),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            UserprofileCubit.get(context)
                                                .allinfoModel!
                                                .data!
                                                .length,
                                            (index) => ProfileItem(
                                                press: () {
                                                  UserprofileCubit.get(
                                                          context)
                                                      .getSingleInfo(
                                                          infoItemId:
                                                              UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .allinfoModel!
                                                                  .data![
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AboutUs((lang ==
                                                                  'en')
                                                              ? UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .allinfoModel!
                                                                  .data![
                                                                      index]
                                                                  .pageTitleEn!
                                                              : UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .allinfoModel!
                                                                  .data![
                                                                      index]
                                                                  .pageTitleAr!)));
                                                },
                                                title: (lang == 'en')
                                                    ? UserprofileCubit.get(
                                                            context)
                                                        .allinfoModel!
                                                        .data![index]
                                                        .pageTitleEn!
                                                    : UserprofileCubit.get(
                                                            context)
                                                        .allinfoModel!
                                                        .data![index]
                                                        .pageTitleAr!,
                                                image: icons[index]),
                                          ),
                                        ),
                                        ProfileItem(
                                            press: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ContactUsScreen())),
                                            title: LocalKeys.CONTACT_US.tr(),
                                            image: "assets/suport.png"),
                                        (isLogin)
                                            ? BlocConsumer<AuthcubitCubit,
                                                    AuthcubitState>(
                                                builder: (context, state) {
                                                  return ProfileItem(
                                                      press: () async {
                                                        AuthcubitCubit.get(
                                                                context)
                                                            .logout(
                                                                context:
                                                                    context);
                                                      },
                                                      title: LocalKeys.LOG_OUT
                                                          .tr(),
                                                      image:
                                                          "assets/icon rayan/Group 922.png");
                                                },
                                                listener: (context, state) {})
                                            : ProfileItem(
                                          press: () async {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const Login()),
                                                    (route) => false);
                                          },
                                          title: LocalKeys.LOG_IN
                                              .tr(),
                                          image:
                                          "assets/icon rayan/Group 922.png"),
                                        (isLogin && isDeleted)
                                            ? BlocConsumer<AuthcubitCubit,
                                                    AuthcubitState>(
                                                builder: (context, state) {
                                                  return ProfileItem(
                                                      press: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DeleteAccountScreen()));
                                                      },
                                                      title: translateString(
                                                          "Delete Account",
                                                          "حذف الحساب"),
                                                      image:
                                                          "assets/icon rayan/Group 922.png");
                                                },
                                                listener: (context, state) {})
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ));
              },
              listener: (context, state) {})),
    );
  }
}
