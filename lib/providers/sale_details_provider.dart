import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/sale_details_model.dart';
import 'package:flutter/material.dart';

class SaleDetailsProvider extends ChangeNotifier {
  static bool isSaleDetailsLoading = false;
  List<SaleDetailsModel> saleDetailsList = [];

  getSaleDetails(String? categoryId,productId,dateFrom,dateTo,status) async {
    saleDetailsList = await ApiService.fetchSaleDetailsApi(categoryId,productId,dateFrom,dateTo,status);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isSaleDetailsLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isSaleDetailsLoading = true;
    notifyListeners();
  }
}