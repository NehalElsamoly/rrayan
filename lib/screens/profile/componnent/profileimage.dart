import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rayan_store/screens/orders/orders.dart';
import 'package:rayan_store/screens/profile/componnent/profile_header.dart';
import 'package:rayan_store/screens/profile/componnent/profile_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_cubit/app_cubit.dart';
import '../../../app_cubit/appstate.dart';
import '../../../generated/local_keys.dart';
import '../../auth/login.dart';
import '../../bottomnav/homeScreen.dart';

class ProfileImage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final bool isLogin;
  const ProfileImage(
      {Key? key,
      required this.userName,
      required this.isLogin,
      required this.userEmail})
      : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
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
    return Center(
      child: BlocConsumer<AppCubit, AppCubitStates>(
        builder: (context, state) => Column(
          children: [
            Center(
              child: Container(
                width: double.infinity,
              //  height: 30.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProfileHeaderComponnent(
                            press: () => (widget.isLogin)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Orders()),
                                  )
                                : Fluttertoast.showToast(
                                    msg: LocalKeys.MUST_LOGIN.tr(),
                                    textColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP),
                            title: LocalKeys.MY_ORDERS.tr(),
                            image: "assets/icon rayan/Group 928.png"),
                        ProfileHeaderComponnent(
                            press: () => (widget.isLogin)
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen(index: 1)),
                                    (route) => false)
                                : Fluttertoast.showToast(
                                    msg: LocalKeys.MUST_LOGIN.tr(),
                                    textColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP),
                            title: LocalKeys.MY_FAV.tr(),
                            image: "assets/icon rayan/Group 906.png"),
                        ProfileHeaderComponnent(
                            press: () => (widget.isLogin)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileSettingScreen(
                                        userEmail:
                                            (widget.userEmail != 'null')
                                                ? widget.userEmail
                                                : '',
                                        userName: widget.userName,
                                      ),
                                    ),
                                  )
                                : Fluttertoast.showToast(
                                    msg: LocalKeys.MUST_LOGIN.tr(),
                                    textColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP),
                            title: LocalKeys.UPDATE_PROFILE.tr(),
                            image: "assets/icon rayan/Group 926.png"),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
            ),
            // Center(
            //   child: (AppCubit.get(context).image == null)
            //       ? const CircleAvatar(
            //           backgroundColor: Colors.black,
            //           radius: 55,
            //           child: CircleAvatar(
            //               backgroundColor: Colors.white,
            //               radius: 47,
            //               child: Center(
            //                 child: Icon(
            //                   Icons.insert_photo_outlined,
            //                   size: 50,
            //                   color: Colors.black87,
            //                 ),
            //               )),
            //         )
            //       : CircleAvatar(
            //           backgroundColor: const Color(0xffFB68AA),
            //           radius: 55,
            //           backgroundImage: FileImage(
            //             AppCubit.get(context).image!,
            //           ),
            //           child: const CircleAvatar(
            //               backgroundColor: Colors.white,
            //               radius: 47,
            //               child: Center(
            //                 child: Icon(
            //                   Icons.insert_photo_outlined,
            //                   size: 48,
            //                   color: Colors.black87,
            //                 ),
            //               )),
            //         ),
            // ),

            // Padding(
            //   padding: EdgeInsets.only(
            //       top: h * 0.1,
            //       left: w * 0.35,
            //       right: w * 0.12),
            //   child: Align(
            //     alignment:
            //         AlignmentDirectional
            //             .bottomCenter,
            //     child: InkWell(
            //       onTap: () async {
            //         AppCubit.get(context)
            //             .getImage();
            //       },
            //       child: CircleAvatar(
            //         radius: w * 0.04,
            //         backgroundColor:
            //             Colors.white,
            //         child: Image.asset(
            //             "assets/icons/Path-20.png"),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        listener: (context, state) {},
      ),
    );
  }
}
