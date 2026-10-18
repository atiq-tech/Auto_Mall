import 'dart:convert';
import 'package:auto_mall/models/products_model.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService{
  //==================Product List =======================
  static fetchProductsApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(products,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = jsonDecode(response.data);
      return List.from(item).map((e) => ProductsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================Product List =======================
  static fetchCustomersApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(customers,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = jsonDecode(response.data);
      return List.from(item).map((e) => ProductsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  }