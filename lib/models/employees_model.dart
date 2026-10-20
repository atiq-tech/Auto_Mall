import 'dart:convert';

class EmployeesModel {
    final dynamic employeeSlNo;
    final dynamic designationId;
    final dynamic departmentId;
    final dynamic employeeId;
    final dynamic bioId;
    final dynamic employeeName;
    final dynamic employeeJoinDate;
    final dynamic employeeGender;
    final dynamic employeeBirthDate;
    final dynamic employeeNid;
    final dynamic employeeContactNo;
    final dynamic employeeEmail;
    final dynamic employeeMaritalStatus;
    final dynamic employeeFatherName;
    final dynamic employeeMotherName;
    final dynamic employeePrasentAddress;
    final dynamic employeePermanentAddress;
    final dynamic employeePicOrg;
    final dynamic employeePicThum;
    final dynamic salaryRange;
    final dynamic employeeReference;
    final dynamic commission;
    final dynamic deduction;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic departmentName;
    final dynamic designationName;
    final dynamic displayName;

    EmployeesModel({
        required this.employeeSlNo,
        required this.designationId,
        required this.departmentId,
        required this.employeeId,
        required this.bioId,
        required this.employeeName,
        required this.employeeJoinDate,
        required this.employeeGender,
        required this.employeeBirthDate,
        required this.employeeNid,
        required this.employeeContactNo,
        required this.employeeEmail,
        required this.employeeMaritalStatus,
        required this.employeeFatherName,
        required this.employeeMotherName,
        required this.employeePrasentAddress,
        required this.employeePermanentAddress,
        required this.employeePicOrg,
        required this.employeePicThum,
        required this.salaryRange,
        required this.employeeReference,
        required this.commission,
        required this.deduction,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.departmentName,
        required this.designationName,
        required this.displayName,
    });

    factory EmployeesModel.fromJson(String str) => EmployeesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EmployeesModel.fromMap(Map<String, dynamic> json) => EmployeesModel(
        employeeSlNo: json["Employee_SlNo"],
        designationId: json["Designation_ID"],
        departmentId: json["Department_ID"],
        employeeId: json["Employee_ID"],
        bioId: json["bio_id"],
        employeeName: json["Employee_Name"],
        employeeJoinDate: json["Employee_JoinDate"],
        employeeGender: json["Employee_Gender"],
        employeeBirthDate: json["Employee_BirthDate"],
        employeeNid: json["Employee_NID"],
        employeeContactNo: json["Employee_ContactNo"],
        employeeEmail: json["Employee_Email"],
        employeeMaritalStatus: json["Employee_MaritalStatus"],
        employeeFatherName: json["Employee_FatherName"],
        employeeMotherName: json["Employee_MotherName"],
        employeePrasentAddress: json["Employee_PrasentAddress"],
        employeePermanentAddress: json["Employee_PermanentAddress"],
        employeePicOrg: json["Employee_Pic_org"],
        employeePicThum: json["Employee_Pic_thum"],
        salaryRange: json["salary_range"],
        employeeReference: json["Employee_Reference"],
        commission: json["commission"],
        deduction: json["deduction"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        departmentName: json["Department_Name"],
        designationName: json["Designation_Name"],
        displayName: json["display_name"],
    );

    Map<String, dynamic> toMap() => {
        "Employee_SlNo": employeeSlNo,
        "Designation_ID": designationId,
        "Department_ID": departmentId,
        "Employee_ID": employeeId,
        "bio_id": bioId,
        "Employee_Name": employeeName,
        "Employee_JoinDate": employeeJoinDate,
        "Employee_Gender": employeeGender,
        "Employee_BirthDate": employeeBirthDate,
        "Employee_NID": employeeNid,
        "Employee_ContactNo": employeeContactNo,
        "Employee_Email": employeeEmail,
        "Employee_MaritalStatus": employeeMaritalStatus,
        "Employee_FatherName": employeeFatherName,
        "Employee_MotherName": employeeMotherName,
        "Employee_PrasentAddress": employeePrasentAddress,
        "Employee_PermanentAddress": employeePermanentAddress,
        "Employee_Pic_org": employeePicOrg,
        "Employee_Pic_thum": employeePicThum,
        "salary_range": salaryRange,
        "Employee_Reference": employeeReference,
        "commission": commission,
        "deduction": deduction,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Department_Name": departmentName,
        "Designation_Name": designationName,
        "display_name": displayName,
    };
}
