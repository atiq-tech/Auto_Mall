import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/pathao_areas_model.dart';
import 'package:flutter/material.dart';

class PathaoAreasProvider extends ChangeNotifier {

  bool isPathaoAreasLoading = false;

  List<PathaoAreasModel> pathaoAreasList = [];

  // পুরোনো API request ignore করার জন্য
  int _requestId = 0;

  Future<void> getPathaoAreas(String? zoneId) async {

    final currentRequestId = ++_requestId;

    // আগের Pathao Areas data clear
    pathaoAreasList = [];

    isPathaoAreasLoading = true;
    notifyListeners();

    try {

      if (zoneId == null || zoneId.isEmpty || zoneId == 'null') {
        return;
      }

      final response = await ApiService.fetchPathaoAreasApi(zoneId);

      // এর মধ্যে অন্য Zone select হলে পুরোনো response ignore হবে
      if (currentRequestId != _requestId) return;

      pathaoAreasList = response;

    } catch (e) {

      if (currentRequestId == _requestId) {
        pathaoAreasList = [];
        debugPrint("Pathao Areas API Error: $e");
      }

    } finally {

      if (currentRequestId == _requestId) {
        isPathaoAreasLoading = false;
        notifyListeners();
      }
    }
  }

  void clearPathaoAreas() {
    _requestId++;
    pathaoAreasList = [];
    isPathaoAreasLoading = false;
    notifyListeners();
  }
}