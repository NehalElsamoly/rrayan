// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/local_keys.dart';
import '../helpers/dio_helper.dart';
import '../screens/notifications/noti_model.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(AppInitialstates());
  static AppCubit get(context) => BlocProvider.of(context);
String  paidBy= LocalKeys.VISA.tr();
  int? colorselected;
  String? colorTitleselected;
  void colorSelection({int? selected, String? title}) {
    colorselected = selected;
    colorTitleselected = title;
    emit(SelectionColorState());
  }

  int? sizeselected;
  String? sizeTitleselected;
  void sizeSelection({int? selected, String? title}) {
    sizeselected = selected;
    sizeTitleselected = title;
    emit(SelectionSizeState());
  }

  int? addressselected;
  void addressSelection({int? selected}) {
    addressselected = selected;
    emit(SelectionAddressState());
  }

  dynamic count;

  void notifyCount(){
    emit(CountLoading());
    DioHelper.postData(url: 'notifications/count', data: {}).then((value) {
      final result = value.data;
      print(result);
      if (result['status'] == 1){
        count = result['data'];
        emit(CountSuccess());
      }
    }).catchError((e){
      print(e.toString());
      emit(CountError(e.toString()));
    });
  }

  void notifyShow(){
    DioHelper.postData(url: 'notifications/show', data: {}).then((value) {
      final result = value.data;
      print(result);
      if (result['status'] == 1){
        notifyCount();
      }
    }).catchError((e){
      print(e.toString());
    });
  }

  NotificationsModel? notificationsModel;

  void getNotify(){
    emit(NotifyLoading());
    DioHelper.postData(url: 'notifications', data: {}).then((value) {
      final result = value.data;
      print(result);
      if (result['status'] == 1) {
        notificationsModel = NotificationsModel.fromJson(result);
        emit(NotifySuccess());
      } else {
        print(2);
        emit(NotifyError(result['message']));
      }
    }).catchError((e){
      print(e.toString());
      emit(NotifyError(e.toString()));
    });
  }

  bool? tabbyStatusValue;
  
  Future<void> tabbyStatus() async {
    emit(TabbyStatusLoading());
    try {
      var response = await http.get(Uri.parse('http://rayan-storee.com/api/V1/get-tabby-status'));
      var data = jsonDecode(response.body);
      print(data);
      if (data['data'] == 1) {
        tabbyStatusValue = true;
        emit(TabbyStatusSuccess());
      } else if (data['data'] == 0) {
        tabbyStatusValue = false;
        emit(TabbyStatusError('error'));
      }
    } catch (error) {
      emit(TabbyStatusError(error.toString()));
      print(error.toString());
    }
  }
}
