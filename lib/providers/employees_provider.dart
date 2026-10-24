import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/employees_model.dart';
import 'package:flutter/material.dart';

class EmployeesProvider extends ChangeNotifier {
  static bool isEmployeesLoading = false;

  List<EmployeesModel> employeesList = [];
  getEmployees() async {
    employeesList = await ApiService.fetchEmployeesApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isEmployeesLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isEmployeesLoading = true;
    notifyListeners();
  }
}