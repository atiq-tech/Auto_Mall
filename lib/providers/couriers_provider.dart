import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/couriers_model.dart';
import 'package:flutter/material.dart';

class CouriersProvider extends ChangeNotifier {
  static bool isCouriersLoading = false;

  List<CouriersModel> couriersList = [];
  getCouriers() async {
    couriersList = await ApiService.fetchCouriersApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCouriersLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCouriersLoading = true;
    notifyListeners();
  }
}