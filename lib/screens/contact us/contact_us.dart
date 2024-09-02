import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../componnent/constants.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String language = '';
  final formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  List<FocusNode> listFocus = List<FocusNode>.generate(5, (_) => FocusNode());
  List<TextEditingController> listEd =
      List<TextEditingController>.generate(5, (_) => TextEditingController());

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      language = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    List<String> hint = language == 'en'
        ? ['Full name', 'E-mail', 'phone number', 'Title', 'Message']
        : [
            'الاسم بالكامل',
            'البريد الاكتروني',
            'رقم الهاتف',
            'العنوان',
            'المحتوى'
          ];
    return Form(
      key: formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              LocalKeys.CONTACT_US.tr(),
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: Colors.white,
                  fontFamily: (language == 'en') ? 'Nunito' : 'Almarai',
                  fontWeight: FontWeight.bold),
            ),
            leading: BackButton(
              color: Colors.white,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Center(
            child: SizedBox(
              width: w * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: List.generate(listFocus.length, (index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.03,
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: listEd[index],
                              focusNode: listFocus[index],
                              textInputAction: index == 4
                                  ? TextInputAction.newline
                                  : TextInputAction.next,
                              keyboardType: index == 1
                                  ? TextInputType.emailAddress
                                  : index == 4
                                      ? TextInputType.multiline
                                      : TextInputType.text,
                              inputFormatters: index != 1
                                  ? null
                                  : [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r"[0-9 a-z  @ .]")),
                                    ],
                              maxLines: index != 4 ? 1 : 6,
                              onEditingComplete: () {
                                listFocus[index].unfocus();
                                if (index < listEd.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(listFocus[index + 1]);
                                }
                              },
                              validator: (value) {
                                if (index == 1) {
                                  if (value!.length < 4 ||
                                      !value.endsWith('.com') ||
                                      '@'.allMatches(value).length != 1) {
                                    return LocalKeys.VALID_EMAIL.tr();
                                  }
                                }
                                if (index != 1) {
                                  if (value!.isEmpty) {
                                    return LocalKeys.VALID.tr();
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form(),
                                errorBorder: form(),
                                focusedErrorBorder: form(),
                                hintText: hint[index],
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily:
                                      (language == 'en') ? 'Nunito' : 'Almarai',
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    BlocConsumer<UserprofileCubit, UserprofileState>(
                        builder: (context, state) => RoundedLoadingButton(
                              controller: btnController,
                              successColor: mainColor,
                              color: Colors.black,
                              borderRadius: 5,
                              disabledColor: mainColor,
                              errorColor: Colors.red,
                              onPressed: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (formKey.currentState!.validate()) {
                                  UserprofileCubit.get(context).contactUs(
                                      name: listEd[0].text,
                                      email: listEd[1].text,
                                      phone: listEd[2].text,
                                      title: listEd[3].text,
                                      message: listEd[4].text,
                                      controller: btnController,
                                      context: context);
                                } else {
                                  btnController.error();
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  btnController.stop();
                                }
                              },
                              child: SizedBox(
                                width: w * 0.9,
                                height: h * 0.07,
                                child: Center(
                                    child: Text(
                                  LocalKeys.SEND.tr(),
                                  style: TextStyle(
                                      fontFamily: (language == 'en')
                                          ? 'Nunito'
                                          : 'Almarai',
                                      color: Colors.white,
                                      fontSize: w * 0.05),
                                )),
                              ),
                            ),
                        listener: (context, state) {}),
                    SizedBox(
                      height: h * .05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
