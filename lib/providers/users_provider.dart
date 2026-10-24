import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/users_model.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  static bool isUsersLoading = false;

  List<UsersModel> usersList = [];
  getUsers() async {
    usersList = await ApiService.fetchUsersApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isUsersLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isUsersLoading = true;
    notifyListeners();
  }
}