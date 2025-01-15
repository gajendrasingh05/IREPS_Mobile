import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class NetworkProvider with ChangeNotifier{

  ConnectivityStatus _status = ConnectivityStatus.Offline;

  NetworkProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi) {
        _updateStatus(ConnectivityStatus.WiFi);
      } else if (result == ConnectivityResult.mobile) {
        _updateStatus(ConnectivityStatus.Cellular);
      } else {
        _updateStatus(ConnectivityStatus.Offline);
      }
    });
  }

  ConnectivityStatus get status => _status;

  void _updateStatus(ConnectivityStatus status) {
    _status = status;
    notifyListeners();
  }
}