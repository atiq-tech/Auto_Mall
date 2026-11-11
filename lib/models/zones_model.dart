import 'dart:convert';

class ZonesModel {
    final int zoneId;
    final String zoneName;

    ZonesModel({
        required this.zoneId,
        required this.zoneName,
    });

    factory ZonesModel.fromJson(String str) => ZonesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ZonesModel.fromMap(Map<String, dynamic> json) => ZonesModel(
        zoneId: json["zone_id"],
        zoneName: json["zone_name"],
    );

    Map<String, dynamic> toMap() => {
        "zone_id": zoneId,
        "zone_name": zoneName,
    };
}
