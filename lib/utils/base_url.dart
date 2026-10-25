
//String baseUrl = "https://soft.dailypasar.com/";//sub
String baseUrl = "https://demo.automallerp.com/";///main
//String baseUrl = "http://192.168.0.249:8080/";///main

String login = "${baseUrl}signin";
String logout = "${baseUrl}signout";
String addCustomer = "${baseUrl}add-customer";
String customers = "${baseUrl}get-customers";
String customerDue = "${baseUrl}get-customer-due";
String products = "${baseUrl}get-products";
String categories = "${baseUrl}get-categories";
String areas = "${baseUrl}get-areas";
String employees = "${baseUrl}get-employees";
String users = "${baseUrl}get-users";
String sales = "${baseUrl}get-sales";
String saleRecords = "${baseUrl}get-sale-records";
String saleDetails = "${baseUrl}get-sale-details";
String ordersRecords = "${baseUrl}orders/records";
String bankAccounts = "${baseUrl}get-bank-accounts";


List screenItems = [
  {"name": "Order Entry", "image": "images/order.png"},
  {"name": "Pending Order", "image": "images/orecord.png"},
  {"name": "Order Invoice", "image": "images/oinv.png"},
  {"name": "Sales Entry", "image": "images/sales.png"},
  {"name": "Sales Record", "image": "images/srecord.png"},
  {"name": "Sales Invoice", "image": "images/sinv.png"}, 
  {"name": "Product List", "image": "images/plist.png"},
  {"name": "Customer Entry", "image": "images/centry.png"},
  {"name": "Customer List", "image": "images/clist.png"},
  {"name": "Customer Due", "image": "images/cdue.png"},
  {"name": "Visit Entry", "image": "images/visit.png"},
  {"name": "Visit List", "image": "images/vlist.png"},
];