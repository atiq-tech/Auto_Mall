import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/categories_model.dart';
import 'package:flutter/material.dart';

class CategoriesProvider extends ChangeNotifier {
  static bool isCategoriesLoading = false;

  List<CategoriesModel> categoriesList = [];
  getCategories() async {
    categoriesList = await ApiService.fetchCategoriesApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCategoriesLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCategoriesLoading = true;
    notifyListeners();
  }
}