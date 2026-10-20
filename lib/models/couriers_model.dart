import 'dart:convert';

class CouriersModel {
    final dynamic id;
    final dynamic name;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;

    CouriersModel({
        required this.id,
        required this.name,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
    });

    factory CouriersModel.fromJson(String str) => CouriersModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CouriersModel.fromMap(Map<String, dynamic> json) => CouriersModel(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
    };
}