import 'dart:convert';

class VisitesModel {
    final dynamic id;
    final dynamic date;
    final dynamic customerId;
    final dynamic employeeId;
    final dynamic address;
    final dynamic note;
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
    final dynamic employeeName;

    VisitesModel({
        required this.id,
        required this.date,
        required this.customerId,
        required this.employeeId,
        required this.address,
        required this.note,
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
        required this.employeeName,
    });

    factory VisitesModel.fromJson(String str) => VisitesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory VisitesModel.fromMap(Map<String, dynamic> json) => VisitesModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        customerId: json["customer_id"],
        employeeId: json["employee_id"],
        address: json["address"],
        note: json["note"],
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
        employeeName: json["Employee_Name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "date": date,
        "customer_id": customerId,
        "employee_id": employeeId,
        "address": address,
        "note": note,
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
        "Employee_Name": employeeName,
    };
}
