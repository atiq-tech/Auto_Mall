class SalesCartModel {
  String? productId;
  String? categoryId;
  String? categoryName;
  String? name;
  String? productCode;
  String? salesRate;
  String? vat;
  String? quantity;
  String? total;
  String? purchaseRate;
  String? isService;
  String? discount;
  String? warranty;

  SalesCartModel({
    required this.productId,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.productCode,
    required this.salesRate,
    required this.vat,
    required this.quantity,
    required this.total,
    required this.purchaseRate,
    required this.isService,
    required this.discount,
    required this.warranty,
  });
}

// Exchange
class ExchangeModel {
  String? exchangeProductId;
  String? exchangeProductCode;
  String? exchangeProductName;
  String? exchangeProductCategory;
  String? exchangeSalesRate;
  String? exchangeQty;
  String? exchangeTotalAmount;

  ExchangeModel({
    required this.exchangeProductId,
    required this.exchangeProductCode,
    required this.exchangeProductName,
    required this.exchangeProductCategory,
    required this.exchangeSalesRate,
    required this.exchangeQty,
    required this.exchangeTotalAmount,
  });
}

