// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/screens/product_detail/model/productcolor_model.dart';
import 'package:rayan_store/screens/product_detail/model/singleproduct_model.dart';
import 'package:rayan_store/screens/tabone_screen/model/home_model.dart';

import '../../cart/model/setting.dart';

class HomeCubit extends Cubit<AppCubitStates> {
  HomeCubit() : super(AppInitialstates());

  static HomeCubit get(context) => BlocProvider.of(context);

  HomeitemsModel? homeitemsModel;

  Future<HomeitemsModel?> getHomeitems() async {
    emit(HomeitemsLoaedingState());
    try {
      var response = await http.get(Uri.parse(EndPoints.HOME_ITEMS));
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 1) {
        homeitemsModel = HomeitemsModel.fromJson(data);
      }
      emit(HomeitemsSuccessState());
      return homeitemsModel;
    } catch (error) {
      print("error while get home data =================================" +
          error.toString());
      emit(HomeitemsErrorState(error.toString()));
    }
  }
//
  String findMainCatById(String id, String lang) {
    var catItem = homeitemsModel?.data?.categories?.firstWhere((item) => item.id.toString() == "27");
    return (lang == 'en') ? catItem?.nameEn.toString()??"" : catItem?.nameAr??"";
  }

  List<CategoriesSub>? findSubCategoryById(String id) {
    var catItem =  homeitemsModel?.data?.categories?.firstWhere((item) => item.id.toString() == "27");
    return catItem?.categoriesSub;
  }
///////////////////////////////////////////////////////////////////////////////////
  SingleProductModel? singleProductModel;

  Future<SingleProductModel?> getProductdata(
      {required String productId}) async {
    emit(SingleProductLoaedingState());
    print(productId);
    try {
      var response = await http
          .get(Uri.parse(EndPoints.BASE_URL + "get-product/$productId"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        singleProductModel = SingleProductModel.fromJson(data);
      }
      emit(SingleProductSuccessState());
      return singleProductModel;
    } catch (error) {
      print("error while get home data =================================" +
          error.toString());
      emit(SingleProductErrorState(error.toString()));
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  SingleProductColorModel? singleProductColorModel;
  Future<SingleProductColorModel?> getProductColor(
      {required String productId,
      required String sizeId,
      required BuildContext context}) async {
    emit(SingleProductColorLoaedingState());
    try {
      var response = await http
          .get(Uri.parse(EndPoints.PRODUCT_COLOR + "$productId/$sizeId"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        singleProductColorModel = SingleProductColorModel.fromJson(data);
      }
      emit(SingleProductColorSuccessState());
      return singleProductColorModel;
    } catch (error) {
      print("error while get product color =================================" +
          error.toString());
      emit(SingleProductColorErrorState(error.toString()));
    }
  }//
  ///////////////////////////////////////////////////////////////////

  SettingModel? settingModel;
  Future<SettingModel?> getSetting() async {
    emit(SettingDataLoadingState());
    try {
      var response = await http.get(Uri.parse(EndPoints.SETTING));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        settingModel = SettingModel.fromJson(data);
        emit(SettingDataSuccessState());
        return settingModel;
      }
    } catch (e) {
      emit(SettingDataErrorState(e.toString()));
      print("error while get setting : " + e.toString());
    }
  }
  //////////////

  ////
//
}
//
