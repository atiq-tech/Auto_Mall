import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/sales_model.dart';
import 'package:flutter/material.dart';

class PendingOrderProvider extends ChangeNotifier {
  static bool isPendingOrderLoading = false;
  List<SalesModel> pendingOrderList = [];

  getPendingOrder(String? userId,areaId,customerId, employeeId,dateFrom,dateTo,status,isCourier) async {
    pendingOrderList = await ApiService.fetchPendingOrderApi(userId,areaId,customerId,employeeId,dateFrom,dateTo,status,isCourier);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isPendingOrderLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isPendingOrderLoading = true;
    notifyListeners();
  }
}