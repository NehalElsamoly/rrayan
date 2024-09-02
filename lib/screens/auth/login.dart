// ignore_for_file: avoid_print, unnecessary_string_interpolations
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
import 'package:rayan_store/screens/auth/sign_upScreen.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'confirm_phone.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool select = true;
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  bool isVisible = false;
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
    double h = MediaQuery.of(context).size.height;
    print([3, Navigator.canPop(context)]);
    return PreferredSize(
        preferredSize: Size(w, h),
        child: Stack(children: [
          Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
                color: Colors.white,
                // image: DecorationImage(
                //     image: AssetImage("assets/icons/Bitmap.png"),
                //     fit: BoxFit.fill)
            ),
          ),
          BlocConsumer<AuthcubitCubit, AuthcubitState>(
              builder: (context, state) {
                return Form(
                    key: _formKey,
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Container(
                                width: w,
                                height: h,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/Rectangle.png"),
                                        fit: BoxFit.fill)),
                                padding: EdgeInsets.only(top: h * 0.07),
                                child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: h * 0.085,
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/icons/Group 30.png",
                                          width: w * 0.6,
                                          height: h * 0.2,
                                          fit: BoxFit.contain,
                                        )),
                                        SizedBox(
                                          height: h * 0.02,
                                        ),
                                        SizedBox(
                                          width: w,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: w * 0.05),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: h * 0.06,
                                                ),
                                                Text(
                                                  LocalKeys.LOG_IN.tr(),
                                                  style: TextStyle(
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: w * 0.035),
                                                ),
                                                SizedBox(
                                                  height: h * 0.01,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: w * 0.03,
                                                      right: w * 0.03),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 3,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                            blurRadius: 3)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(5)),
                                                  child: TextFormField(
                                                    controller:
                                                        editingController1,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                    cursorColor: Colors.black,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: focusNode1,
                                                    onEditingComplete: () {
                                                      focusNode1.unfocus();
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              focusNode2);
                                                    },
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                      errorStyle: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          color: Colors.white),
                                                      hintText:
                                                          LocalKeys.PHONE.tr(),
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          color:
                                                              Colors.black45),
                                                      labelStyle: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                                Text(
                                                  LocalKeys.PASSWORD.tr(),
                                                  style: TextStyle(
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: w * 0.035),
                                                ),
                                                SizedBox(
                                                  height: h * 0.01,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: w * 0.03,
                                                      right: w * 0.03),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 3,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                            blurRadius: 3)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(5)),
                                                  child: TextFormField(
                                                    controller:
                                                        editingController2,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                    obscureText:
                                                        (isVisible == true)
                                                            ? false
                                                            : true,
                                                    cursorColor: Colors.black,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: focusNode2,
                                                    onEditingComplete: () {
                                                      focusNode2.unfocus();
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Field required")));
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                        suffixIcon: InkWell(
                                                          child: (isVisible ==
                                                                  true)
                                                              ? const Icon(
                                                                  Icons
                                                                      .visibility_outlined,
                                                                  color: Colors
                                                                      .black,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .visibility_off_outlined,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          onTap: () {
                                                            setState(() {
                                                              isVisible = true;
                                                            });
                                                          },
                                                        ),
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        errorStyle: TextStyle(
                                                            fontFamily:
                                                                (lang == 'en')
                                                                    ? 'Nunito'
                                                                    : 'Almarai',
                                                            color:
                                                                Colors.white),
                                                        hintText: LocalKeys
                                                            .PASSWORD
                                                            .tr(),
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                (lang == 'en')
                                                                    ? 'Nunito'
                                                                    : 'Almarai',
                                                            color:
                                                                Colors.black45),
                                                        fillColor:
                                                            Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                                InkWell(
                                                  child: Text(
                                                    LocalKeys.FORGET_PASSWORD
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      color: Colors.black,
                                                      fontSize: w * 0.035,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ConfirmPhone()));
                                                  },
                                                ),
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                                RoundedLoadingButton(
                                                  successColor: mainColor,
                                                  color: mainColor,

                                                  disabledColor: mainColor,
                                                  controller: _btnController,
                                                  borderRadius: 5,
                                                  height: h * 0.07,
                                                  errorColor: Colors.red,
                                                  valueColor: Colors.white,
                                                  onPressed: () async {
                                                    AuthcubitCubit.get(context)
                                                        .login(

                                                            controller:
                                                                _btnController,
                                                            email:
                                                                editingController1
                                                                    .text,
                                                            password:
                                                                editingController2
                                                                    .text,
                                                            context: context);
                                                  },
                                                  child: Container(
                                                    // width: w * 9,
                                                    // height: h * 0.07,
                                                    color:Colors.white,
                                                    child: Center(
                                                        child: Text(
                                                      LocalKeys.LOGBUTTON.tr(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          color: Colors.black,
                                                          fontSize: w * 0.05,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      child: Text(
                                                        LocalKeys.VISITOR.tr(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          color: Colors.black,
                                                          fontSize: w * 0.045,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomeScreen(
                                                                              index: 0,
                                                                            )),
                                                                (route) =>
                                                                    false);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      LocalKeys.NOT_HAVE_ACCOUNT
                                                          .tr(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        color: Colors.black,
                                                        fontSize: w * 0.035,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.01,
                                                    ),
                                                    InkWell(
                                                      child: Text(
                                                        LocalKeys.REGISTER.tr(),
                                                        style: TextStyle(
                                                          color: mainColor,
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          fontSize: w * 0.035,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SignupScreen()));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: h * 0.02,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                )))));
              },
              listener: (context, state) {}),
        ]));
  }
}
