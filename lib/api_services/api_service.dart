import 'dart:convert';
import 'package:auto_mall/models/customers_model.dart';
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
            "Authorization": "${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      return List.from(item).map((e) => ProductsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================Product List =======================
  // static fetchCustomersApi(String? customerType) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await Dio().post(customers,
  //        data: {
  //          "customerType": "$customerType",
  //        },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "${sharedPreferences.getString("token")}",
  //         }));
  //     var item = response.data;
  //     return List.from(item).map((e) => CustomersModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  
static Future<List<CustomersModel>> fetchCustomersApi(
    String? customerType) async {
  final prefs = await SharedPreferences.getInstance();

  try {
    final response = await Dio().post(
      customers,
      data: {
        "customerType": customerType ?? "",
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Cookie": "ci_session=${prefs.getString("sessionId") ?? ""}",
          "Authorization": prefs.getString("token") ?? "",
        },
      ),
    );

    dynamic data = response.data;

    // Response String hole JSON decode korbe
    if (data is String) {
      data = jsonDecode(data);
    }

    // Apnar API response directly List
    if (data is List) {
      return data
          .map(
            (item) => CustomersModel.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    }

    throw FormatException(
      "Expected List, received ${data.runtimeType}",
    );
  } catch (e) {
    print("Customers API Error: $e");
    return <CustomersModel>[];
  }
}

  }