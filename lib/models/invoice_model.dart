import 'dart:convert';

class InvoiceModel {
    final List<SaleDetail>? saleDetails;
    final List<ExchangeDetail>? exchangeDetails;
    final List<Sale>? sales;

    InvoiceModel({
        required this.saleDetails,
        required this.exchangeDetails,
        required this.sales,
    });

    factory InvoiceModel.fromJson(String str) => InvoiceModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InvoiceModel.fromMap(Map<String, dynamic> json) => InvoiceModel(
        saleDetails: json["saleDetails"] == null || json["saleDetails"] == [] ? [] : List<SaleDetail>.from(json["saleDetails"].map((x) => SaleDetail.fromMap(x))),
        exchangeDetails: json["exchangeDetails"] == null || json["exchangeDetails"] == [] ? [] : List<ExchangeDetail>.from(json["exchangeDetails"].map((x) => ExchangeDetail.fromMap(x))),
        sales: json["sales"] == null || json["sales"] == [] ? [] : List<Sale>.from(json["sales"].map((x) => Sale.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "saleDetails": List<dynamic>.from(saleDetails!.map((x) => x.toJson())),
        "exchangeDetails": List<dynamic>.from(exchangeDetails!.map((x) => x.toJson())),
        "sales": List<dynamic>.from(sales!.map((x) => x.toJson())),
    };
}

class ExchangeDetail {
    final dynamic id;
    final dynamic saleId;
    final dynamic productId;
    final dynamic quantity;
    final dynamic price;
    final dynamic total;
    final dynamic status;
    final dynamic addedBy;
    final dynamic addedDate;
    final dynamic updateBy;
    final dynamic updateDate;
    final dynamic branchId;
    final dynamic productCode;
    final dynamic productName;
    final dynamic productCategoryName;
    final dynamic unitName;

    ExchangeDetail({
        required this.id,
        required this.saleId,
        required this.productId,
        required this.quantity,
        required this.price,
        required this.total,
        required this.status,
        required this.addedBy,
        required this.addedDate,
        required this.updateBy,
        required this.updateDate,
        required this.branchId,
        required this.productCode,
        required this.productName,
        required this.productCategoryName,
        required this.unitName,
    });

    factory ExchangeDetail.fromJson(String str) => ExchangeDetail.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ExchangeDetail.fromMap(Map<String, dynamic> json) => ExchangeDetail(
        id: json["id"],
        saleId: json["sale_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        price: json["price"],
        total: json["total"],
        status: json["status"],
        addedBy: json["added_by"],
        addedDate: json["added_date"],
        updateBy: json["update_by"],
        updateDate: json["update_date"],
        branchId: json["branch_id"],
        productCode: json["Product_Code"],
        productName: json["Product_Name"],
        productCategoryName: json["ProductCategory_Name"],
        unitName: json["Unit_Name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "sale_id": saleId,
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "total": total,
        "status": status,
        "added_by": addedBy,
        "added_date": addedDate,
        "update_by": updateBy,
        "update_date": updateDate,
        "branch_id": branchId,
        "Product_Code": productCode,
        "Product_Name": productName,
        "ProductCategory_Name": productCategoryName,
        "Unit_Name": unitName,
    };
}

class SaleDetail {
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
    final dynamic productCategoryName;
    final dynamic unitName;

    SaleDetail({
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
        required this.productCategoryName,
        required this.unitName,
    });

    factory SaleDetail.fromJson(String str) => SaleDetail.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SaleDetail.fromMap(Map<String, dynamic> json) => SaleDetail(
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
        productCategoryName: json["ProductCategory_Name"],
        unitName: json["Unit_Name"],
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
        "ProductCategory_Name": productCategoryName,
        "Unit_Name": unitName,
    };
}

class Sale {
    final dynamic invoiceText;
    final dynamic saleMasterSlNo;
    final dynamic isOrder;
    final dynamic isCourier;
    final dynamic saleMasterInvoiceNo;
    final dynamic salseCustomerIdNo;
    final dynamic salesModelCustomerType;
    final dynamic salesModelCustomerName;
    final dynamic salesModelCustomerMobile;
    final dynamic salesModelCustomerAddress;
    final dynamic salesModelEmployeeId;
    final dynamic saleMasterSaleDate;
    final dynamic saleMasterDescription;
    final dynamic saleMasterSaleType;
    final dynamic paymentType;
    final dynamic saleMasterTotalSaleAmount;
    final dynamic saleMasterTotalDiscountAmount;
    final dynamic saleMasterTaxAmount;
    final dynamic saleMasterFreight;
    final dynamic saleMasterSubTotalAmount;
    final dynamic exchangeTotal;
    final dynamic saleMasterPaidAmount;
    final dynamic saleMasterDueAmount;
    final dynamic saleMasterPreviousDue;
    final dynamic accountId;
    final dynamic cashPaid;
    final dynamic bankPaid;
    final dynamic courierId;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic customerCode;
    final dynamic customerName;
    final dynamic customerMobile;
    final dynamic customerAddress;
    final dynamic customerType;
    final dynamic customerPayment;
    final dynamic employeeName;
    final dynamic employeeId;
    final dynamic branchName;
    final dynamic accountName;
    final dynamic accountNumber;
    final dynamic bankName;
    final dynamic addedBy;

    Sale({
        required this.invoiceText,
        required this.saleMasterSlNo,
        required this.isOrder,
        required this.isCourier,
        required this.saleMasterInvoiceNo,
        required this.salseCustomerIdNo,
        required this.salesModelCustomerType,
        required this.salesModelCustomerName,
        required this.salesModelCustomerMobile,
        required this.salesModelCustomerAddress,
        required this.salesModelEmployeeId,
        required this.saleMasterSaleDate,
        required this.saleMasterDescription,
        required this.saleMasterSaleType,
        required this.paymentType,
        required this.saleMasterTotalSaleAmount,
        required this.saleMasterTotalDiscountAmount,
        required this.saleMasterTaxAmount,
        required this.saleMasterFreight,
        required this.saleMasterSubTotalAmount,
        required this.exchangeTotal,
        required this.saleMasterPaidAmount,
        required this.saleMasterDueAmount,
        required this.saleMasterPreviousDue,
        required this.accountId,
        required this.cashPaid,
        required this.bankPaid,
        required this.courierId,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.customerCode,
        required this.customerName,
        required this.customerMobile,
        required this.customerAddress,
        required this.customerType,
        required this.customerPayment,
        required this.employeeName,
        required this.employeeId,
        required this.branchName,
        required this.accountName,
        required this.accountNumber,
        required this.bankName,
        required this.addedBy,
    });

    factory Sale.fromJson(String str) => Sale.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Sale.fromMap(Map<String, dynamic> json) => Sale(
        invoiceText: json["invoice_text"],
        saleMasterSlNo: json["SaleMaster_SlNo"],
        isOrder: json["is_order"],
        isCourier: json["is_courier"],
        saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
        salseCustomerIdNo: json["SalseCustomer_IDNo"],
        salesModelCustomerType: json["customerType"],
        salesModelCustomerName: json["customerName"],
        salesModelCustomerMobile: json["customerMobile"],
        salesModelCustomerAddress: json["customerAddress"],
        salesModelEmployeeId: json["employee_id"],
        saleMasterSaleDate: json["SaleMaster_SaleDate"],
        saleMasterDescription: json["SaleMaster_Description"],
        saleMasterSaleType: json["SaleMaster_SaleType"],
        paymentType: json["payment_type"],
        saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"],
        saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"],
        saleMasterTaxAmount: json["SaleMaster_TaxAmount"],
        saleMasterFreight: json["SaleMaster_Freight"],
        saleMasterSubTotalAmount: json["SaleMaster_SubTotalAmount"],
        exchangeTotal: json["exchange_total"],
        saleMasterPaidAmount: json["SaleMaster_PaidAmount"],
        saleMasterDueAmount: json["SaleMaster_DueAmount"],
        saleMasterPreviousDue: json["SaleMaster_Previous_Due"],
        accountId: json["accountId"],
        cashPaid: json["cashPaid"],
        bankPaid: json["bankPaid"],
        courierId: json["courier_id"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        customerCode: json["Customer_Code"],
        customerName: json["Customer_Name"],
        customerMobile: json["Customer_Mobile"],
        customerAddress: json["Customer_Address"],
        customerType: json["Customer_Type"],
        customerPayment: json["customer_payment"],
        employeeName: json["Employee_Name"],
        employeeId: json["Employee_ID"],
        branchName: json["Branch_name"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        bankName: json["bank_name"],
        addedBy: json["added_by"],
    );

    Map<String, dynamic> toMap() => {
        "invoice_text": invoiceText,
        "SaleMaster_SlNo": saleMasterSlNo,
        "is_order": isOrder,
        "is_courier": isCourier,
        "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
        "SalseCustomer_IDNo": salseCustomerIdNo,
        "customerType": salesModelCustomerType,
        "customerName": salesModelCustomerName,
        "customerMobile": salesModelCustomerMobile,
        "customerAddress": salesModelCustomerAddress,
        "employee_id": salesModelEmployeeId,
        "SaleMaster_SaleDate": saleMasterSaleDate,
        "SaleMaster_Description": saleMasterDescription,
        "SaleMaster_SaleType": saleMasterSaleType,
        "payment_type": paymentType,
        "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
        "SaleMaster_TotalDiscountAmount": saleMasterTotalDiscountAmount,
        "SaleMaster_TaxAmount": saleMasterTaxAmount,
        "SaleMaster_Freight": saleMasterFreight,
        "SaleMaster_SubTotalAmount": saleMasterSubTotalAmount,
        "exchange_total": exchangeTotal,
        "SaleMaster_PaidAmount": saleMasterPaidAmount,
        "SaleMaster_DueAmount": saleMasterDueAmount,
        "SaleMaster_Previous_Due": saleMasterPreviousDue,
        "accountId": accountId,
        "cashPaid": cashPaid,
        "bankPaid": bankPaid,
        "courier_id": courierId,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Customer_Code": customerCode,
        "Customer_Name": customerName,
        "Customer_Mobile": customerMobile,
        "Customer_Address": customerAddress,
        "Customer_Type": customerType,
        "customer_payment": customerPayment,
        "Employee_Name": employeeName,
        "Employee_ID": employeeId,
        "Branch_name": branchName,
        "account_name": accountName,
        "account_number": accountNumber,
        "bank_name": bankName,
        "added_by": addedBy,
    };
}
