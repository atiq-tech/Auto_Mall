import 'dart:convert';

class PathaoAreasModel {
    final int areaId;
    final String areaName;
    final bool homeDeliveryAvailable;
    final bool pickupAvailable;

    PathaoAreasModel({
        required this.areaId,
        required this.areaName,
        required this.homeDeliveryAvailable,
        required this.pickupAvailable,
    });

    factory PathaoAreasModel.fromJson(String str) => PathaoAreasModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PathaoAreasModel.fromMap(Map<String, dynamic> json) => PathaoAreasModel(
        areaId: json["area_id"],
        areaName: json["area_name"],
        homeDeliveryAvailable: json["home_delivery_available"],
        pickupAvailable: json["pickup_available"],
    );

    Map<String, dynamic> toMap() => {
        "area_id": areaId,
        "area_name": areaName,
        "home_delivery_available": homeDeliveryAvailable,
        "pickup_available": pickupAvailable,
    };
}
