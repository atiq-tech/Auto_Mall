import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/bank_accounts_model.dart';
import 'package:flutter/material.dart';

class BankAccountsProvider extends ChangeNotifier {
  static bool isBankAccountsLoading = false;

  List<BankAccountsModel> bankAccounts = [];
  getBankAccounts() async {
    bankAccounts = await ApiService.fetchBankAccountsApi();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isBankAccountsLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isBankAccountsLoading = true;
    notifyListeners();
  }
}