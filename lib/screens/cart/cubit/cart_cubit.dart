// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/DBhelper/cubit.dart';
import 'dart:convert';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/screens/cart/cart_product/body.dart';
import 'package:rayan_store/screens/cart/model/delivery.dart';
import 'package:rayan_store/screens/checkout/checkout.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../componnent/appwidget.dart';
import '../../../generated/local_keys.dart';
import '../../fatorah/model/fatorah_model.dart';
import '../../orders/cubit/order_cubit.dart';
part 'cart_state.dart';
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static CartCubit get(context) => BlocProvider.of(context);

  int totalQuantity = 0;
  void checkProductQty(
      {required String productId,
      required String productQty,
      required String sizeId,
      required String colorId,
      required BuildContext context}) async {
    totalQuantity = 0;
    emit(CheckProductAddcartLoadingState());
    try {
      Map<String, dynamic> body = {
        'product_id': productId,
        'size_id': sizeId,
        'color_id': colorId,
        'quantity': productQty
      };
      print(body);
      var response = await http.post(Uri.parse(EndPoints.ADD_CART), body: body);
      var data = jsonDecode(response.body);
      print(response.body);

      if (data['status'] == 1) {
        totalQuantity = data['data'];
        if (int.parse(productQty) < data['data']) {
          DataBaseCubit.get(context).counter[int.parse(productId)] =
              int.parse(productQty) + 1;
          DataBaseCubit.get(context).updateDatabase(
              productId: int.parse(productId),
              productQty:
                  DataBaseCubit.get(context).counter[int.parse(productId)]!);
          emit(CheckProductAddcartSuccessState());
        } else {
          Fluttertoast.showToast(
              msg: "${LocalKeys.AMOUNT.tr()} : ${data['data']}",
              textColor: Colors.white,
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
      }
    } catch (error) {
      emit(CheckProductAddcartErroState(error.toString()));
      print("erooooooooooor quantity : " + error.toString());
    }
  }

///////////////////////////////////////////////////////////////////////////////////
  DeliveryModel? deliveryModel;
  Future<DeliveryModel?> getDelivery({required BuildContext context}) async {
    emit(DeliveryLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cityId = prefs.getString('city_id').toString();
    try {
      Map<String, dynamic> body = {
        'city': cityId,
        'totalQty': "${DataBaseCubit.get(context).quantity}"
      };
      var response = await http.post(Uri.parse(EndPoints.DELIVERY), body: body);
      var data = jsonDecode(response.body);
      print(data);
      if (data['success'] == 1) {
        deliveryModel = DeliveryModel.fromJson(data);
        emit(DeliverySuccessState());
        return deliveryModel;
      }
    } catch (error) {
      emit(DeliveryErroState(error.toString()));
      print("delivery errrrrrrrrrrrrrrrrrrrrrrrrrrrrrro : " + error.toString());
    }
  }

  FatorrahModel? fatorrahModel;
  void saveOrder(
      {
        required String name,
      required String phone,
      required String email,
      required String address,
      required String note,
      required String region,
      required String floor,
      required String buildingNum,
      required String apartmentNum,
      required String theplot,
      required String theavenue,
      required String streetnam,
        required String deliveredBy,
      required BuildContext context,
      required int cartLength,
      required RoundedLoadingButtonController controller}) async {
    AppWidget.createProgressDialog(context, 'انتظر');
    emit(SaveOrderLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    final String lang = prefs.get('language').toString();
    final String lattitude = prefs.getString('late') ?? '';
    final String longtitude = prefs.getString('lang') ?? '';
    final String countryId = prefs.getString('country_id') ?? '';
    final String cityId = prefs.getString('city_id') ?? '';
    final String cobon = prefs.getString('cobon') ?? '';
    final String type = prefs.getString('type') ?? '';

print(countryId);
print(cityId);
    String productId = '';
    DataBaseCubit.get(context).cart.forEach((element) {
      productId += '${element['productId'].toString()}' ',';
    });
    print(token);
    Map<String, dynamic> productsOptions = {};
    DataBaseCubit.get(context).cart.forEach((element) {
      productsOptions.addAll({
        "${element['productId']}": [
          {'height': element['colorOption']},
          {'size': element['sizeOption']},
          {'quantity': element['productQty']}
        ]
      });
    });
    var options = json.encode(productsOptions);
    print(options);
    print("nahola"+productId);
    print("nono"+type);
    try {

      Map<dynamic, dynamic>body;
      type=="addrss"?
     body = {
        'name': name,
        'delivered_by': "phone",
        'phone': phone,
        'country_id': countryId,
        'city_id': cityId,

      }:
      body = {
        'note': note,
        'name': name,
        'email': email,
        'phone': phone,
        'country_id': countryId,
        'city_id': cityId,
        'address1': "",
        'region': region,
        'the_plot': theplot,
        'the_street': streetnam,
        'the_avenue': theavenue,
        'building_number': buildingNum,
        'floor': floor,
        'apartment_number': apartmentNum,
        'products_id': productId,
        'optionValue_products': options,
        'lat_and_long': lattitude + ',' + longtitude,
        'coupon_code': cobon,
        'postal_code': "0",
      };
      print(json.encode(body));
      var response = await http.post(Uri.parse(EndPoints.SAVE_ORDER),
          body: body, headers: {'Content-Language': lang, 'auth-token': token});

      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 1) {
        fatorrahModel = FatorrahModel.fromJson(data);
        controller.success();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
        prefs.setInt('order_id', data['order']['id']);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool islogin = preferences.getBool('login') ?? false;
        if(islogin){
         await OrderCubit.get(context).getAllorders();
        }
        Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => ConfirmCart(
              cartLength: cartLength,city: region,address: streetnam,
              orderId: data['order']['id'].toString(),
              subTotal: RayanCartBody.finalPrice.toString(),
              discount: RayanCartBody.discount.toString(),
              totalPrice: data['order']['total_price'].toString(), name: name, email: email, phone: phone,
            ),
          ),
        );
        prefs.remove('cobon');
        emit(SaveOrderSuccessState());
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: data['message'].toString(),
            textColor: Colors.white,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        controller.error();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
      }
    } catch (error) {
      controller.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      controller.stop();
      emit(SaveOrderErroState(error.toString()));
      print("error while saving order --------------- " + error.toString());
    }
  }
}
