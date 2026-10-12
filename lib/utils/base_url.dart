
//String baseUrl = "https://soft.dailypasar.com/";//sub
String baseUrl = "https://dailypasar.com/";///main
//String baseUrl = "http://192.168.0.249:8080/";///main

String customers = "${baseUrl}api/v1/customer";
String products = "${baseUrl}api/v1/product";
String categories = "${baseUrl}api/v1/category";
String visits = "${baseUrl}api/v1/visits";
String visitRecords = "${baseUrl}api/v1/visits/records";
String routes = "${baseUrl}api/v1/routes";
String attendance = "${baseUrl}api/v1/attendance";
String sales = "${baseUrl}api/v1/sales";
String salesRecords = "${baseUrl}api/v1/sales/records";
String orders = "${baseUrl}api/v1/orders";
String ordersRecords = "${baseUrl}api/v1/orders/records";

List screenItems = [
  {"name": "Order Entry", "image": "images/order.png"},
  {"name": "Order Record", "image": "images/orecord.png"},
  {"name": "Order Invoice", "image": "images/oInv.png"},
  {"name": "Sales Entry", "image": "images/sales.png"},
  {"name": "Sales Record", "image": "images/srecord.png"},
  {"name": "Sales Invoice", "image": "images/sinv.png"}, 
  {"name": "Product List", "image": "images/plist.png"},
  {"name": "Category List", "image": "images/category.png"},
  {"name": "Customer Entry", "image": "images/centry.png"},
  {"name": "Customer List", "image": "images/clist.png"},
  {"name": "Visit Entry", "image": "images/ve.png"},
  {"name": "Visit History", "image": "images/visit.png"},
  // {"name": "Attendance Entry", "image": "images/attend.png"},
  // {"name": "Outlet Location", "image": "images/outlet.png"},
];

class AddToOrderModel {
  String? productId;
  String? productName;
  String? productImage;
  String? salesRate;
  String? boxQuantity;
  String? quantity;
  String? total;

  AddToOrderModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.salesRate,
    required this.boxQuantity,
    required this.quantity,
    required this.total,
  });
}