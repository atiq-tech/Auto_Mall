import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/stores_model.dart';
import 'package:flutter/material.dart';

class StoresProvider extends ChangeNotifier {
  static bool isStoresLoading = false;

  List<StoresModel> storesList = [];
  getStores() async {
    storesList = await ApiService.fetchStoresApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isStoresLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isStoresLoading = true;
    notifyListeners();
  }
}