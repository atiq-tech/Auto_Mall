import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/sale_records_model.dart';
import 'package:flutter/material.dart';

class PendingOrderRecordProvider extends ChangeNotifier {
  static bool isPendingOrderRecordLoading = false;
  List<SaleRecordsModel> pendingOrderRecordList = [];

  getPendingOrderRecord(String? userId,areaId,customerId, employeeId,dateFrom,dateTo,status,isCourier) async {
    pendingOrderRecordList = await ApiService.fetchPendingOrderRecordApi(userId,areaId,customerId,employeeId,dateFrom,dateTo,status,isCourier);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isPendingOrderRecordLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isPendingOrderRecordLoading = true;
    notifyListeners();
  }
}