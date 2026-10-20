import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/customer_due_model.dart';
import 'package:flutter/material.dart';

class CustomerDueProvider extends ChangeNotifier {
  static bool isCustomerDueLoading = false;
  List<CustomerDueModel> customerDueList = [];

  getCustomerDue(String? customerId,String? areaId) async {
    customerDueList = await ApiService.fetchCustomerDueApi(customerId,areaId);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCustomerDueLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCustomerDueLoading = true;
    notifyListeners();
  }
}