import 'package:auto_mall/models/products_model.dart';
import 'package:flutter/cupertino.dart';
import '../api_services/api_service.dart';

class ProductsProvider extends ChangeNotifier {

  static bool isProductsLoading = false;

  List<ProductsModel> productsList = [];
  getProducts() async {
    productsList = await ApiService.fetchProductsApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isProductsLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isProductsLoading = true;
    notifyListeners();
  }
}