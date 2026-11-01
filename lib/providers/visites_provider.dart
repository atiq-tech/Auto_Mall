import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/visites_model.dart';
import 'package:flutter/material.dart';

class VisitesProvider extends ChangeNotifier {
  static bool isVisitesLoading = false;

  List<VisitesModel> visitesList = [];
  getVisites(String? customerId,employeeId,dateFrom,dateTo) async {
    visitesList = await ApiService.fetchVisitesApi(customerId,employeeId,dateFrom,dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isVisitesLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isVisitesLoading = true;
    notifyListeners();
  }
}