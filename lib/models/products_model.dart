import 'dart:convert';

class ProductsModel {
    final dynamic productSlNo;
    final dynamic productCode;
    final dynamic code;
    final dynamic productName;
    final dynamic productCategoryId;
    final dynamic color;
    final dynamic brand;
    final dynamic size;
    final dynamic vat;
    final dynamic productReOrederLevel;
    final dynamic productPurchaseRate;
    final dynamic productSellingPrice;
    final dynamic productMinimumSellingPrice;
    final dynamic productWholesaleRate;
    final dynamic oneCartunEqual;
    final dynamic isService;
    final dynamic unitId;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic productCategoryName;
    final dynamic brandName;
    final dynamic unitName;

    ProductsModel({
        required this.productSlNo,
        required this.productCode,
        required this.code,
        required this.productName,
        required this.productCategoryId,
        required this.color,
        required this.brand,
        required this.size,
        required this.vat,
        required this.productReOrederLevel,
        required this.productPurchaseRate,
        required this.productSellingPrice,
        required this.productMinimumSellingPrice,
        required this.productWholesaleRate,
        required this.oneCartunEqual,
        required this.isService,
        required this.unitId,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.productCategoryName,
        required this.brandName,
        required this.unitName,
    });

    factory ProductsModel.fromJson(String str) => ProductsModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductsModel.fromMap(Map<String, dynamic> json) => ProductsModel(
        productSlNo: json["Product_SlNo"],
        productCode: json["Product_Code"],
        code: json["code"],
        productName: json["Product_Name"],
        productCategoryId: json["ProductCategory_ID"],
        color: json["color"],
        brand: json["brand"],
        size: json["size"],
        vat: json["vat"],
        productReOrederLevel: json["Product_ReOrederLevel"],
        productPurchaseRate: json["Product_Purchase_Rate"],
        productSellingPrice: json["Product_SellingPrice"],
        productMinimumSellingPrice: json["Product_MinimumSellingPrice"],
        productWholesaleRate: json["Product_WholesaleRate"],
        oneCartunEqual: json["one_cartun_equal"],
        isService: json["is_service"],
        unitId: json["Unit_ID"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        productCategoryName: json["ProductCategory_Name"],
        brandName: json["brand_name"],
        unitName: json["Unit_Name"],
    );

    Map<String, dynamic> toMap() => {
        "Product_SlNo": productSlNo,
        "Product_Code": productCode,
        "code": code,
        "Product_Name": productName,
        "ProductCategory_ID": productCategoryId,
        "color": color,
        "brand": brand,
        "size": size,
        "vat": vat,
        "Product_ReOrederLevel": productReOrederLevel,
        "Product_Purchase_Rate": productPurchaseRate,
        "Product_SellingPrice": productSellingPrice,
        "Product_MinimumSellingPrice": productMinimumSellingPrice,
        "Product_WholesaleRate": productWholesaleRate,
        "one_cartun_equal": oneCartunEqual,
        "is_service": isService,
        "Unit_ID": unitId,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "ProductCategory_Name": productCategoryName,
        "brand_name": brandName,
        "Unit_Name": unitName,
    };
}
