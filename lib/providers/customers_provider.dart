import 'package:auto_mall/models/customers_model.dart';
import 'package:flutter/cupertino.dart';
import '../api_services/api_service.dart';

class CustomersProvider extends ChangeNotifier {
  static bool isCustomersLoading = false;
  List<CustomersModel> customersList = [];
  
  
Future<void> getCustomers(String? customerType) async {
  isCustomersLoading = true;
  notifyListeners();

  try {
    final result = await ApiService.fetchCustomersApi(customerType);

    customersList = [
      CustomersModel(
        customerSlNo: "0",
        customerCode: "",
        customerName: "Cash Customer",
        customerType: "G",
        customerPhone: "",
        customerAddress: "",
        displayName: "Cash Customer",
      ),
      CustomersModel(
        customerSlNo: "0",
        customerCode: "",
        customerName: "New Customer",
        customerType: "N",
        customerPhone: "",
        customerAddress: "",
        displayName: "New Customer",
      ),
      ...result,
    ];
  } catch (e) {
    print("Provider Error: $e");
    customersList = [];
  } finally {
    isCustomersLoading = false;
    notifyListeners();
  }
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