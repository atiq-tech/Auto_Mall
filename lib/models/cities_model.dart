import 'dart:convert';

class CitiesModel {
    final int cityId;
    final String cityName;

    CitiesModel({
        required this.cityId,
        required this.cityName,
    });

    factory CitiesModel.fromJson(String str) => CitiesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CitiesModel.fromMap(Map<String, dynamic> json) => CitiesModel(
        cityId: json["city_id"],
        cityName: json["city_name"],
    );

    Map<String, dynamic> toMap() => {
        "city_id": cityId,
        "city_name": cityName,
    };
}
