import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/areas_model.dart';
import 'package:flutter/material.dart';

class AreasProvider extends ChangeNotifier {
  static bool isAreasLoading = false;

  List<AreasModel> areasList = [];
  getAreas() async {
    areasList = await ApiService.fetchAreasApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isAreasLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isAreasLoading = true;
    notifyListeners();
  }
}