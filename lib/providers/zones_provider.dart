import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/zones_model.dart';
import 'package:flutter/material.dart';

class ZonesProvider extends ChangeNotifier {

  bool isZonesLoading = false;

  List<ZonesModel> zonesList = [];

  // পুরোনো API request ignore করার জন্য
  int _requestId = 0;

  Future<void> getZones(String? cityId) async {

    final currentRequestId = ++_requestId;

    // আগের Zone data clear
    zonesList = [];

    isZonesLoading = true;
    notifyListeners();

    try {

      if (cityId == null || cityId.isEmpty || cityId == 'null') {
        return;
      }

      final response = await ApiService.fetchZonesApi(cityId);

      // এর মধ্যে অন্য City select হলে পুরোনো response ignore হবে
      if (currentRequestId != _requestId) return;

      zonesList = response;

    } catch (e) {

      if (currentRequestId == _requestId) {
        zonesList = [];
        debugPrint("Zone API Error: $e");
      }

    } finally {

      if (currentRequestId == _requestId) {
        isZonesLoading = false;
        notifyListeners();
      }
    }
  }

  void clearZones() {
    _requestId++;
    zonesList = [];
    isZonesLoading = false;
    notifyListeners();
  }
}
// class ZonesProvider extends ChangeNotifier {
//   static bool isZonesLoading = false;

//   List<ZonesModel> zonesList = [];
//   getZones(String? cityId) async {
//     zonesList = await ApiService.fetchZonesApi(cityId);
//     off();
//     notifyListeners();
//   }
//   off(){
//     Future.delayed(const Duration(seconds: 1),() {
//       print('offff');
//       isZonesLoading = false;
//       notifyListeners();
//     },);
//   }
//   on(){
//     print('onnn');
//     isZonesLoading = true;
//     notifyListeners();
//   }
// }