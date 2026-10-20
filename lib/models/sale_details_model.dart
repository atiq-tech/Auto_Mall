import 'dart:convert';

class SaleDetailsModel {
    final dynamic saleDetailsSlNo;
    final dynamic saleMasterIdNo;
    final dynamic productIdNo;
    final dynamic saleDetailsTotalQuantity;
    final dynamic purchaseRate;
    final dynamic saleDetailsRate;
    final dynamic saleDetailsDiscount;
    final dynamic discountAmount;
    final dynamic saleDetailsTax;
    final dynamic saleDetailsTotalAmount;
    final dynamic warranty;
    final dynamic isService;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic productCode;
    final dynamic productName;
    final dynamic productCategoryId;
    final dynamic productCategoryName;
    final dynamic saleMasterInvoiceNo;
    final dynamic saleMasterSaleDate;
    final dynamic customerCode;
    final dynamic customerName;
    final dynamic customerMobile;
    final dynamic customerAddress;
    final dynamic customerType;

    SaleDetailsModel({
        required this.saleDetailsSlNo,
        required this.saleMasterIdNo,
        required this.productIdNo,
        required this.saleDetailsTotalQuantity,
        required this.purchaseRate,
        required this.saleDetailsRate,
        required this.saleDetailsDiscount,
        required this.discountAmount,
        required this.saleDetailsTax,
        required this.saleDetailsTotalAmount,
        required this.warranty,
        required this.isService,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.productCode,
        required this.productName,
        required this.productCategoryId,
        required this.productCategoryName,
        required this.saleMasterInvoiceNo,
        required this.saleMasterSaleDate,
        required this.customerCode,
        required this.customerName,
        required this.customerMobile,
        required this.customerAddress,
        required this.customerType,
    });

    factory SaleDetailsModel.fromJson(String str) => SaleDetailsModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SaleDetailsModel.fromMap(Map<String, dynamic> json) => SaleDetailsModel(
        saleDetailsSlNo: json["SaleDetails_SlNo"],
        saleMasterIdNo: json["SaleMaster_IDNo"],
        productIdNo: json["Product_IDNo"],
        saleDetailsTotalQuantity: json["SaleDetails_TotalQuantity"],
        purchaseRate: json["Purchase_Rate"],
        saleDetailsRate: json["SaleDetails_Rate"],
        saleDetailsDiscount: json["SaleDetails_Discount"],
        discountAmount: json["Discount_amount"],
        saleDetailsTax: json["SaleDetails_Tax"],
        saleDetailsTotalAmount: json["SaleDetails_TotalAmount"],
        warranty: json["warranty"],
        isService: json["is_service"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        productCode: json["Product_Code"],
        productName: json["Product_Name"],
        productCategoryId: json["ProductCategory_ID"],
        productCategoryName: json["ProductCategory_Name"],
        saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
        saleMasterSaleDate: json["SaleMaster_SaleDate"],
        customerCode: json["Customer_Code"],
        customerName: json["Customer_Name"],
        customerMobile: json["Customer_Mobile"],
        customerAddress: json["Customer_Address"],
        customerType: json["Customer_Type"],
    );

    Map<String, dynamic> toMap() => {
        "SaleDetails_SlNo": saleDetailsSlNo,
        "SaleMaster_IDNo": saleMasterIdNo,
        "Product_IDNo": productIdNo,
        "SaleDetails_TotalQuantity": saleDetailsTotalQuantity,
        "Purchase_Rate": purchaseRate,
        "SaleDetails_Rate": saleDetailsRate,
        "SaleDetails_Discount": saleDetailsDiscount,
        "Discount_amount": discountAmount,
        "SaleDetails_Tax": saleDetailsTax,
        "SaleDetails_TotalAmount": saleDetailsTotalAmount,
        "warranty": warranty,
        "is_service": isService,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Product_Code": productCode,
        "Product_Name": productName,
        "ProductCategory_ID": productCategoryId,
        "ProductCategory_Name": productCategoryName,
        "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
        "SaleMaster_SaleDate": saleMasterSaleDate,
        "Customer_Code": customerCode,
        "Customer_Name": customerName,
        "Customer_Mobile": customerMobile,
        "Customer_Address": customerAddress,
        "Customer_Type": customerType,
    };
}
