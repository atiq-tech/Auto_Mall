import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/sale_records_model.dart';
import 'package:flutter/material.dart';

class SaleRecordsProvider extends ChangeNotifier {
  static bool isSaleRecordsLoading = false;
  List<SaleRecordsModel> saleRecordsList = [];

  getSaleRecords(String? userId,areaId,customerId, employeeId,dateFrom,dateTo,status) async {
    saleRecordsList = await ApiService.fetchSaleRecordsApi(userId,areaId,customerId,employeeId,dateFrom,dateTo,status);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isSaleRecordsLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isSaleRecordsLoading = true;
    notifyListeners();
  }
}