import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/cities_model.dart';
import 'package:flutter/material.dart';

class CitiesProvider extends ChangeNotifier {
  static bool isCitiesLoading = false;

  List<CitiesModel> citiesList = [];
  getCities() async {
    citiesList = await ApiService.fetchCitiesApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCitiesLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCitiesLoading = true;
    notifyListeners();
  }
}