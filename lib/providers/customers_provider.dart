import 'package:auto_mall/models/products_model.dart';
import 'package:flutter/cupertino.dart';
import '../api_services/api_service.dart';

class CustomersProvider extends ChangeNotifier {
  static bool isCustomersLoading = false;
  List<ProductsModel> customersList = [];
  
  getCustomers() async {
    customersList = await ApiService.fetchCustomersApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCustomersLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCustomersLoading = true;
    notifyListeners();
  }
}