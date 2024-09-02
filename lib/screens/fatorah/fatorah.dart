import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_cubit/app_cubit.dart';
import '../bottomnav/homeScreen.dart';
import '../cart/cart_product/body.dart';
import '../orders/cubit/order_cubit.dart';

class FatorahScreen extends StatefulWidget {
  const FatorahScreen({Key? key}) : super(key: key);

  @override
  State<FatorahScreen> createState() => _FatorahScreenState();
}

class _FatorahScreenState extends State<FatorahScreen> {
  String currency = '';
  String lang = '';
  GlobalKey? imageKey;

  ScreenshotController screenshotController = ScreenshotController();

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
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
    DateTime now = DateTime.now();
    DateTime date = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context)
                        .notifyCount();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(index: 0)),
                            (route) => false);
                  },
                  icon: const Icon(
                    Icons.close,color:Colors.white
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return ConditionalBuilder(
                condition: state is SaveOrderSuccessState,
                builder: (context) {
                  return Column(
                    children: [
                      // Davinci(
                      //   builder: (key) {
                      //     imageKey = key;
                      //     return Container(
                      //       color: Colors.white,
                      //       child: Column(
                      //         children: [
                      //           Center(
                      //             child: SizedBox(
                      //               width: w * 0.2,
                      //               height: h * 0.15,
                      //               child: Image.asset(
                      //                 "assets/LOGO.png",
                      //                 fit: BoxFit.contain,
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.015,
                      //           ),
                      //           Text(
                      //             translateString(
                      //                 "Thank you for shopping from Rayan store",
                      //                 "شكرا لتسوقكم من ريان استور"),
                      //             style: TextStyle(
                      //                 fontFamily:
                      //                     (prefs.getString('lang')! == 'en')
                      //                         ? 'Nunito'
                      //                         : 'Almarai',
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: w * 0.05),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Container(
                      //             width: w * 0.6,
                      //             height: h * 0.05,
                      //             decoration: BoxDecoration(
                      //               color: mainColor,
                      //               borderRadius:
                      //                   BorderRadius.circular(w * 0.03),
                      //             ),
                      //             child: Center(
                      //               child: Text(
                      //                 translateString(
                      //                     "invoice number  ${CartCubit.get(context).fatorrahModel!.order!.id!}",
                      //                     "رقم الفاتورة  ${CartCubit.get(context).fatorrahModel!.order!.id!}"),
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.white,
                      //                     fontSize: w * 0.04),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.03,
                      //           ),
                      //           Row(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               RichText(
                      //                 text: TextSpan(
                      //                   children: [
                      //                     TextSpan(
                      //                       text: translateString(
                      //                           "Payment method ",
                      //                           "طريقة الدفع "),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: Colors.black87,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                     TextSpan(
                      //                       text: translateString(
                      //                           "Knet", "كي نت "),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: mainColor,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               (CartCubit.get(context)
                      //                           .fatorrahModel!
                      //                           .order!
                      //                           .invoiceId !=
                      //                       null)
                      //                   ? RichText(
                      //                       text: TextSpan(
                      //                         children: [
                      //                           TextSpan(
                      //                             text: translateString(
                      //                                 "My fatoorah code ",
                      //                                 "كود ماي فاتوره "),
                      //                             style: TextStyle(
                      //                                 fontFamily:
                      //                                     (prefs.getString(
                      //                                                 'lang')! ==
                      //                                             'en')
                      //                                         ? 'Nunito'
                      //                                         : 'Almarai',
                      //                                 fontWeight:
                      //                                     FontWeight.w400,
                      //                                 color: Colors.black87,
                      //                                 fontSize: w * 0.035),
                      //                           ),
                      //                           TextSpan(
                      //                             text:
                      //                                 "${OrderCubit.get(context).singleOrderModel!.order!.invoiceLink}",
                      //                             style: TextStyle(
                      //                                 fontFamily:
                      //                                     (prefs.getString(
                      //                                                 'lang')! ==
                      //                                             'en')
                      //                                         ? 'Nunito'
                      //                                         : 'Almarai',
                      //                                 fontWeight:
                      //                                     FontWeight.w400,
                      //                                 color: mainColor,
                      //                                 fontSize: w * 0.035),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     )
                      //                   : const SizedBox(),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.015,
                      //           ),
                      //           const Divider(
                      //             thickness: 1,
                      //             color: Colors.grey,
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.015,
                      //           ),
                      //           Center(
                      //             child: RichText(
                      //               text: TextSpan(
                      //                 children: [
                      //                   TextSpan(
                      //                     text: translateString(
                      //                         "Order date :  ",
                      //                         "تاريخ الطلب : "),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black87,
                      //                         fontSize: w * 0.035),
                      //                   ),
                      //                   TextSpan(
                      //                     text: " " +
                      //                         CartCubit.get(context)
                      //                             .fatorrahModel!
                      //                             .order!
                      //                             .createdAt!
                      //                             .substring(0, 10)
                      //                             .toString() +
                      //                         " ",
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: mainColor,
                      //                         fontSize: w * 0.035),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Container(
                      //             height: h * 0.05,
                      //             color: mainColor,
                      //             child: Center(
                      //               child: Text(
                      //                 translateString(
                      //                     "Order detail ", "تفاصيل الطلب "),
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.white,
                      //                     fontSize: w * 0.04),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.03,
                      //           ),
                      //           Row(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceEvenly,
                      //             children: [
                      //               Container(
                      //                 height: h * 0.04,
                      //                 width: w * 0.4,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   border: Border.all(color: mainColor),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translateString(
                      //                         "Quantity   ${CartCubit.get(context).fatorrahModel!.order!.totalQuantity!}   pieces ",
                      //                         "الكمية  ${CartCubit.get(context).fatorrahModel!.order!.totalQuantity!} قطعة "),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black54,
                      //                         fontSize: w * 0.03),
                      //                   ),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 height: h * 0.04,
                      //                 width: w * 0.4,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   border: Border.all(color: mainColor),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translateString(
                      //                         "price  ${CartCubit.get(context).fatorrahModel!.order!.totalPrice!} ${prefs.getString('currency').toString()} ",
                      //                         "إجمالي الطلب  ${CartCubit.get(context).fatorrahModel!.order!.totalPrice!} ${prefs.getString('currency').toString()} "),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black54,
                      //                         fontSize: w * 0.03),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Row(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceEvenly,
                      //             children: [
                      //               BlocConsumer<HomeCubit, AppCubitStates>(
                      //                 listener: (context, state) {},
                      //                 builder: (context, state) {
                      //                   return Container(
                      //                     height: h * 0.04,
                      //                     width: w * 0.4,
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.white,
                      //                       border:
                      //                           Border.all(color: mainColor),
                      //                     ),
                      //                     child: Center(
                      //                       child: (HomeCubit.get(context)
                      //                                   .settingModel!
                      //                                   .data!
                      //                                   .isFreeShop ==
                      //                               0)
                      //                           ? Text(
                      //                               translateString(
                      //                                   "shipping ${num.parse(CartCubit.get(context).deliveryModel!.value!)} ${prefs.getString('currency').toString()} ",
                      //                                   "سعر الشحن  ${num.parse(CartCubit.get(context).deliveryModel!.value!)} ${prefs.getString('currency').toString()}"),
                      //                               style: TextStyle(
                      //                                   fontFamily:
                      //                                       (prefs.getString(
                      //                                                   'lang')! ==
                      //                                               'en')
                      //                                           ? 'Nunito'
                      //                                           : 'Almarai',
                      //                                   fontWeight:
                      //                                       FontWeight.w400,
                      //                                   color: Colors.black54,
                      //                                   fontSize: w * 0.03),
                      //                             )
                      //                           : Text(
                      //                               LocalKeys.FREE_SHIPPING
                      //                                   .tr(),
                      //                               style: TextStyle(
                      //                                 color: Colors.red,
                      //                                 fontFamily:
                      //                                     (prefs.getString(
                      //                                                 'lang')! ==
                      //                                             'en')
                      //                                         ? 'Nunito'
                      //                                         : 'Almarai',
                      //                                 fontWeight:
                      //                                     FontWeight.bold,
                      //                                 fontSize: w * 0.04,
                      //                               ),
                      //                             ),
                      //                     ),
                      //                   );
                      //                 },
                      //               ),
                      //               Container(
                      //                 height: h * 0.04,
                      //                 width: w * 0.4,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   border: Border.all(color: mainColor),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translateString(
                      //                         "discount ${RayanCartBody.discount.toString()}  ${prefs.getString('currency').toString()}",
                      //                         "الخصم  ${RayanCartBody.discount.toString()}  ${prefs.getString('currency').toString()}"),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black54,
                      //                         fontSize: w * 0.03),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Container(
                      //             height: h * 0.04,
                      //             width: w * 0.85,
                      //             decoration: BoxDecoration(
                      //               color: Colors.white,
                      //               border: Border.all(color: mainColor),
                      //             ),
                      //             child: Center(
                      //               child: Text(
                      //                 translateString(
                      //                     "Total price  ${CartCubit.get(context).fatorrahModel!.order!.totalPrice!}  ${prefs.getString('currency').toString()}",
                      //                     " الإجمالي  ${CartCubit.get(context).fatorrahModel!.order!.totalPrice!}  ${prefs.getString('currency').toString()}"),
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.black54,
                      //                     fontSize: w * 0.03),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Container(
                      //             height: h * 0.05,
                      //             color: Colors.black,
                      //             child: Center(
                      //               child: Text(
                      //                 translateString(
                      //                     "Order Images ", "صور الطلب "),
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.white,
                      //                     fontSize: w * 0.04),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           SingleChildScrollView(
                      //             scrollDirection: Axis.horizontal,
                      //             child: Row(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: List.generate(
                      //                 CartCubit.get(context)
                      //                     .fatorrahModel!
                      //                     .order!
                      //                     .orderItems!
                      //                     .length,
                      //                 (index) => Container(
                      //                   width: w * 0.2,
                      //                   height: h * 0.09,
                      //                   margin: EdgeInsets.only(
                      //                       left: w * 0.02, right: w * 0.02),
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     border:
                      //                         Border.all(color: mainColor),
                      //                     borderRadius:
                      //                         BorderRadius.circular(w * 0.02),
                      //                     image: DecorationImage(
                      //                         image: NetworkImage(
                      //                             EndPoints.IMAGEURL2 +
                      //                                 CartCubit.get(context)
                      //                                     .fatorrahModel!
                      //                                     .order!
                      //                                     .orderItems![index]
                      //                                     .product!
                      //                                     .img!),
                      //                         fit: BoxFit.cover),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Container(
                      //             height: h * 0.05,
                      //             color: mainColor,
                      //             child: Center(
                      //               child: Text(
                      //                 translateString("User details ",
                      //                     "معلومات  المستخدم "),
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.white,
                      //                     fontSize: w * 0.04),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Row(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 translateString(
                      //                     "User name ", "اسم المستخدم "),
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.black87,
                      //                     fontSize: w * 0.035),
                      //               ),
                      //               Text(
                      //                 CartCubit.get(context)
                      //                     .fatorrahModel!
                      //                     .order!
                      //                     .name!,
                      //                 style: TextStyle(
                      //                     fontFamily:
                      //                         (prefs.getString('lang')! ==
                      //                                 'en')
                      //                             ? 'Nunito'
                      //                             : 'Almarai',
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Colors.black87,
                      //                     fontSize: w * 0.035),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Row(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               RichText(
                      //                 text: TextSpan(
                      //                   children: [
                      //                     TextSpan(
                      //                       text: translateString(
                      //                           "user type ",
                      //                           "نوع المستخدم "),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: Colors.black87,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                     (prefs.getBool('login') == true)
                      //                         ? TextSpan(
                      //                             text: translateString(
                      //                                 "app user",
                      //                                 "مستخدم للتطبيق"),
                      //                             style: TextStyle(
                      //                                 fontFamily:
                      //                                     (prefs.getString(
                      //                                                 'lang')! ==
                      //                                             'en')
                      //                                         ? 'Nunito'
                      //                                         : 'Almarai',
                      //                                 fontWeight:
                      //                                     FontWeight.w400,
                      //                                 color: mainColor,
                      //                                 fontSize: w * 0.035),
                      //                           )
                      //                         : TextSpan(
                      //                             text: translateString(
                      //                                 "visitor", "زائر"),
                      //                             style: TextStyle(
                      //                                 fontFamily:
                      //                                     (prefs.getString(
                      //                                                 'lang')! ==
                      //                                             'en')
                      //                                         ? 'Nunito'
                      //                                         : 'Almarai',
                      //                                 fontWeight:
                      //                                     FontWeight.w400,
                      //                                 color: mainColor,
                      //                                 fontSize: w * 0.035),
                      //                           ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               RichText(
                      //                 text: TextSpan(
                      //                   children: [
                      //                     TextSpan(
                      //                       text: translateString(
                      //                           "phone number  ", "الهاتف  "),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: Colors.black87,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                     TextSpan(
                      //                       text: CartCubit.get(context)
                      //                           .fatorrahModel!
                      //                           .order!
                      //                           .phone
                      //                           .toString(),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: mainColor,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           (CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .email !=
                      //                   null)
                      //               ? Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     Text(
                      //                       translateString(
                      //                           "Email ", " الإيميل "),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: Colors.black87,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                     Text(
                      //                       CartCubit.get(context)
                      //                           .fatorrahModel!
                      //                           .order!
                      //                           .email
                      //                           .toString(),
                      //                       style: TextStyle(
                      //                           fontFamily: (prefs.getString(
                      //                                       'lang')! ==
                      //                                   'en')
                      //                               ? 'Nunito'
                      //                               : 'Almarai',
                      //                           fontWeight: FontWeight.w400,
                      //                           color: Colors.black87,
                      //                           fontSize: w * 0.035),
                      //                     ),
                      //                   ],
                      //                 )
                      //               : const SizedBox(),
                      //           (CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .email !=
                      //                   null)
                      //               ? SizedBox(
                      //                   height: h * 0.02,
                      //                 )
                      //               : const SizedBox(),
                      //           Row(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceEvenly,
                      //             children: [
                      //               Container(
                      //                 height: h * 0.04,
                      //                 width: w * 0.3,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   border:
                      //                       Border.all(color: Colors.grey),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translateString(
                      //                         "Country ${CartCubit.get(context).fatorrahModel!.order!.country!.nameEn!}",
                      //                         "الدولة ${CartCubit.get(context).fatorrahModel!.order!.country!.nameAr!}"),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black54,
                      //                         fontSize: w * 0.03),
                      //                   ),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 height: h * 0.04,
                      //                 width: w * 0.3,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   border:
                      //                       Border.all(color: Colors.grey),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translateString(
                      //                         "city  ${CartCubit.get(context).fatorrahModel!.order!.city!.nameEn!}",
                      //                         "المدينة   ${CartCubit.get(context).fatorrahModel!.order!.city!.nameAr!}"),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black54,
                      //                         fontSize: w * 0.03),
                      //                   ),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 height: h * 0.04,
                      //                 width: w * 0.3,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   border:
                      //                       Border.all(color: Colors.grey),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translateString(
                      //                         "Area   ${CartCubit.get(context).fatorrahModel!.order!.region!}",
                      //                         " المنطقة   ${CartCubit.get(context).fatorrahModel!.order!.region!}"),
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             (prefs.getString('lang')! ==
                      //                                     'en')
                      //                                 ? 'Nunito'
                      //                                 : 'Almarai',
                      //                         fontWeight: FontWeight.w400,
                      //                         color: Colors.black54,
                      //                         fontSize: w * 0.03),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: h * 0.02,
                      //           ),
                      //           Center(
                      //             child: Text(
                      //               CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .theAvenue! +
                      //                   " - " +
                      //                   CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .thePlot! +
                      //                   " - " +
                      //                   CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .theStreet! +
                      //                   " - " +
                      //                   translateString("building number : ",
                      //                       "رقم المبني : ") +
                      //                   CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .buildingNumber! +
                      //                   " - " +
                      //                   translateString(
                      //                       "floor  : ", "الطابق   : ") +
                      //                   CartCubit.get(context)
                      //                       .fatorrahModel!
                      //                       .order!
                      //                       .floor!,
                      //               style: TextStyle(
                      //                   fontFamily:
                      //                       (prefs.getString('lang')! == 'en')
                      //                           ? 'Nunito'
                      //                           : 'Almarai',
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Colors.black54,
                      //                   fontSize: w * 0.03),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      const Text(
                        'شكرا لتسوقك من تطبيق ريان',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        'رقـم الفــاتــورة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        CartCubit.get(context).fatorrahModel!.order!.id.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        height: h * 0.763,
                        width: w,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0,right: 10,left: 10),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: h * 0.01,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'إجمالي الطلب :',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                              // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice: num.parse(CartCubit.get(context).fatorrahModel!.order!.totalPrice.toString())),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                           //   fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'الكمية',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.totalQuantity.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                        //    fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'تاريخ  الطلب',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          date.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                           //   fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'الاسم',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                             // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.name.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            //  fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: w * 0.3,
                                  //       color: Colors.black,
                                  //       child: const Padding(
                                  //         padding: EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           'العنوان',
                                  //           style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 18,
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       color: Colors.white,
                                  //       width: w * 0.6,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           "${CartCubit.get(context).fatorrahModel!.order!.country!.nameAr} ${CartCubit.get(context).fatorrahModel!.order!.city!.nameAr} ${CartCubit.get(context).fatorrahModel!.order!.region} ${CartCubit.get(context).fatorrahModel!.order!.theStreet}",
                                  //           maxLines: 1,
                                  //           style: const TextStyle(
                                  //               color: Colors.black87,
                                  //               fontSize: 16),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: h * 0.01,
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'رقم الهاتف',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                             // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.phone.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            //  fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          ' طريقة الدفع',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            //  fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          context.read<AppCubit>().paidBy,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                        //      fontSize: 16,fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '  اسم المنتج',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                             // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BlocBuilder<HomeCubit, AppCubitStates>(
                                          builder: (context, state) {
                                            final title = HomeCubit.get(context).singleProductModel?.data?.titleAr ?? "f";
                                            return Text(
                                              title,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: w * 0.3,
                                  //       color: Colors.black,
                                  //       child: const Padding(
                                  //         padding: EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           'بريد الكتروني',
                                  //           style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 18,
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       color: Colors.white,
                                  //       width: w * 0.6,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           CartCubit.get(context).fatorrahModel!.order!.email ?? '',
                                  //           style: const TextStyle(
                                  //               color: Colors.black87,
                                  //               fontSize: 16),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: h * 0.01,
                                  // ),
                                  SizedBox(
                                    height: h * 0.04,
                                  ),
                                  Text(
                                    translateString(
                                        'Your Products', 'منتجـــاتـــك'),
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 22,
                                     //   fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  SizedBox(
                                    height: h * 0.22,
                                    width: w,
                                    child: GridView.builder(
                                        itemBuilder: (context, i) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                width: w * 0.3,
                                                child: Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: mainColor)),
                                                    child: Image.network(
                                                      EndPoints.IMAGEURL2 +
                                                          CartCubit.get(context).fatorrahModel!.order!.orderItems![i].product!.img!,
                                                      width: w * 0.2,
                                                      height: h * 0.1,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(                                                          CartCubit.get(context).fatorrahModel!.order!.orderItems![i].quantity!,
                                              )
                                            ],
                                          );
                                        },
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: h * 0.001,
                                            mainAxisSpacing: w * 0.02,
                                            crossAxisCount: 4,
                                            childAspectRatio: 0.8),
                                        itemCount: CartCubit.get(context).fatorrahModel!.order!.orderItems!.length),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      screenshotController.capture().then((image) async {
                                        //Capture Done
                                        await [Permission.storage].request();
                                        final time = DateTime.now().toIso8601String().replaceAll('.', '_').replaceAll(':', '_');
                                        final name = 'screenshot_$time';
                                        final result = ImageGallerySaver.saveImage(image!,name: name);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(translateString('saved in gallery', 'تم الحفظ فى الصور')),
                                            backgroundColor: Colors.green,
                                            duration: const Duration(seconds: 5),
                                          ),
                                        );
                                      }).catchError((onError) {
                                        print(onError);
                                      });
                                    },
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0, vertical: 10),
                                          child: Text(
                                            translateString(
                                                'Download invoice', 'حمل الفاتورة'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.22,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
                fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
