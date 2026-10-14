class SalesCartModel {
  String? productId;
  String? categoryId;
  String? categoryName;
  String? name;
  String? woodName;
  String? modelName;
  String? productCode;
  String? salesRate;
  String? vat;
  String? quantity;
  String? total;
  String? purchaseRate;
  String? isService;

  SalesCartModel({
    required this.productId,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.woodName,
    required this.modelName,
    required this.productCode,
    required this.salesRate,
    required this.vat,
    required this.quantity,
    required this.total,
    required this.purchaseRate,
    required this.isService,
  });
}
// Material Purchase
class MaterialPurchaseModelClass {
  String? Mate_productId;
  String? categoryName;
  String? name;
  //String? salesRate;
  String? vat;
  String? quantity;
  String? total;
  String? purchaseRate;

  MaterialPurchaseModelClass({
    required this.Mate_productId,
    required this.categoryName,
    required this.name,
    //required this.salesRate,
    required this.vat,
    required this.quantity,
    required this.total,
    required this.purchaseRate,
  });
}