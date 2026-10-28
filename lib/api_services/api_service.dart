import 'dart:convert';
import 'package:auto_mall/models/areas_model.dart';
import 'package:auto_mall/models/bank_accounts_model.dart';
import 'package:auto_mall/models/categories_model.dart';
import 'package:auto_mall/models/couriers_model.dart';
import 'package:auto_mall/models/customer_due_model.dart';
import 'package:auto_mall/models/customers_model.dart';
import 'package:auto_mall/models/employees_model.dart';
import 'package:auto_mall/models/invoice_model.dart';
import 'package:auto_mall/models/products_model.dart';
import 'package:auto_mall/models/sale_details_model.dart';
import 'package:auto_mall/models/sale_records_model.dart';
import 'package:auto_mall/models/sales_model.dart';
import 'package:auto_mall/models/users_model.dart';
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
 static Future<List<CustomersModel>> fetchCustomersApi(String? customerType) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await Dio().post(customers,
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
      return data.map((item) => CustomersModel.fromMap(Map<String, dynamic>.from(item as Map))).toList();
    }

    throw FormatException("Expected List, received ${data.runtimeType}");
  } catch (e) {
    print("Customers API Error: $e");
    return <CustomersModel>[];
  }
}

 //==================Customer Due List =======================
  static fetchCustomerDueApi(String? customerId,String? areaId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(customerDue,
        data: {
          "customerId": customerId ?? "",
          "areaId": areaId ?? ""
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => CustomerDueModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  //==================areas List =======================
  static fetchAreasApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(areas,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => AreasModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

   //==================sales List =======================
  static fetchSalesApi(String? userId,areaId,customerId,employeeId,dateFrom,dateTo,status) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(sales,
        data: {
          "userId": userId,
          "areaId": areaId,
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item["sales"]).map((e) => SalesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

   //==================saleRecords List =======================
  static fetchSaleRecordsApi(String? userId,areaId,customerId,employeeId,dateFrom,dateTo,status) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(saleRecords,
        data: {
          "userId": userId,
          "areaId": areaId,
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => SaleRecordsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
   //==================SaleDetails List =======================
  static fetchSaleDetailsApi(String? categoryId,productId,dateFrom,dateTo,status) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(saleDetails,
        data: {
          "categoryId": categoryId,
          "productId": productId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => SaleDetailsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  //==================employees List =======================
  static fetchEmployeesApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().get(employees,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => EmployeesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================users List =======================
  static fetchUsersApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().get(users,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => UsersModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  //==================categories List =======================
  static fetchCategoriesApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().get(categories,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => CategoriesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  
   //==================sales List =======================
  static fetchPendingOrderApi(String? userId,areaId,customerId,employeeId,dateFrom,dateTo,status,isCourier) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(sales,
        data: {
          "userId": userId,
          "areaId": areaId,
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status,
          "isCourier": isCourier
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item["sales"]).map((e) => SalesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
     //==================saleRecords List =======================
  static fetchPendingOrderRecordApi(String? userId,areaId,customerId,employeeId,dateFrom,dateTo,status,isCourier) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(saleRecords,
        data: {
          "userId": userId,
          "areaId": areaId,
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status,
          "isCourier": isCourier
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => SaleRecordsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  //==================bank-accounts List =======================
  static fetchBankAccountsApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(bankAccounts,
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "${sharedPreferences.getString("token")}",
      }));
      var item = response.data;
      return List.from(item).map((e) => BankAccountsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///==================Invoice=======================
  static fetchInvoice(String? salesId) async {
    InvoiceModel? invoiceModel;
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var body = {
        "salesId": "$salesId",
      };
      Response response = await Dio().post(sales,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "${sharedPreferences.getString("token")}",
          }));
      return InvoiceModel.fromMap(response.data);
      //return SalesInvoiceModel.fromMap(jsonDecode(response.data));
    } catch (e) {
      print("Something is wrong getSaleslist=======:$e");
    }
    return invoiceModel;
  }

 //==================areas List =======================
  static fetchCouriersApi() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(couriers,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      return List.from(item).map((e) => CouriersModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

}