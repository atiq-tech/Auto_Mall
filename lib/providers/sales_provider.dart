import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/sales_model.dart';
import 'package:flutter/material.dart';

class SalesProvider extends ChangeNotifier {
  static bool isSalesLoading = false;
  List<SalesModel> salesList = [];

  getSales(String? userId,areaId,customerId, employeeId,dateFrom,dateTo,status) async {
    salesList = await ApiService.fetchSalesApi(userId,areaId,customerId,employeeId,dateFrom,dateTo,status);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isSalesLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isSalesLoading = true;
    notifyListeners();
  }
}