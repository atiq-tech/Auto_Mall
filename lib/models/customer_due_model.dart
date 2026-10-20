import 'dart:convert';

class CustomerDueModel {
    final dynamic customerSlNo;
    final dynamic customerCode;
    final dynamic customerName;
    final dynamic previousDue;
    final dynamic ownerName;
    final dynamic customerMobile;
    final dynamic customerAddress;
    final dynamic materialBill;
    final dynamic materialPaid;
    final dynamic bill;
    final dynamic billPaid;
    final dynamic returnAmount;
    final dynamic received;
    final dynamic paid;
    final dynamic dueAmount;

    CustomerDueModel({
      required this.customerSlNo,
      required this.customerCode,
      required this.customerName,
      required this.previousDue,
      required this.ownerName,
      required this.customerMobile,
      required this.customerAddress,
      required this.materialBill,
      required this.materialPaid,
      required this.bill,
      required this.billPaid,
      required this.returnAmount,
      required this.received,
      required this.paid,
      required this.dueAmount,
    });

    factory CustomerDueModel.fromJson(String str) => CustomerDueModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerDueModel.fromMap(Map<String, dynamic> json) => CustomerDueModel(
        customerSlNo: json["Customer_SlNo"],
        customerCode: json["Customer_Code"],
        customerName: json["Customer_Name"],
        previousDue: json["previous_due"],
        ownerName: json["owner_name"],
        customerMobile: json["Customer_Mobile"],
        customerAddress: json["Customer_Address"],
        materialBill: json["materialBill"],
        materialPaid: json["materialPaid"],
        bill: json["bill"],
        billPaid: json["billPaid"],
        returnAmount: json["return_amount"],
        received: json["received"],
        paid: json["paid"],
        dueAmount: json["dueAmount"],
    );

    Map<String, dynamic> toMap() => {
        "Customer_SlNo": customerSlNo,
        "Customer_Code": customerCode,
        "Customer_Name": customerName,
        "previous_due": previousDue,
        "owner_name": ownerName,
        "Customer_Mobile": customerMobile,
        "Customer_Address": customerAddress,
        "materialBill": materialBill,
        "materialPaid": materialPaid,
        "bill": bill,
        "billPaid": billPaid,
        "return_amount": returnAmount,
        "received": received,
        "paid": paid,
        "dueAmount": dueAmount,
    };
}
