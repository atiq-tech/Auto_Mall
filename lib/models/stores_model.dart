import 'dart:convert';

class StoresModel {
    final int storeId;
    final String storeName;
    final String storeAddress;
    final int isActive;
    final int cityId;
    final int zoneId;
    final int hubId;
    final bool isDefaultStore;
    final bool isDefaultReturnStore;

    StoresModel({
        required this.storeId,
        required this.storeName,
        required this.storeAddress,
        required this.isActive,
        required this.cityId,
        required this.zoneId,
        required this.hubId,
        required this.isDefaultStore,
        required this.isDefaultReturnStore,
    });

    factory StoresModel.fromJson(String str) => StoresModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StoresModel.fromMap(Map<String, dynamic> json) => StoresModel(
        storeId: json["store_id"],
        storeName: json["store_name"],
        storeAddress: json["store_address"],
        isActive: json["is_active"],
        cityId: json["city_id"],
        zoneId: json["zone_id"],
        hubId: json["hub_id"],
        isDefaultStore: json["is_default_store"],
        isDefaultReturnStore: json["is_default_return_store"],
    );

    Map<String, dynamic> toMap() => {
        "store_id": storeId,
        "store_name": storeName,
        "store_address": storeAddress,
        "is_active": isActive,
        "city_id": cityId,
        "zone_id": zoneId,
        "hub_id": hubId,
        "is_default_store": isDefaultStore,
        "is_default_return_store": isDefaultReturnStore,
    };
}
