import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NetworkController extends GetxController {
  var connectionStatus = 0.obs; // 0: None, 1: Wifi, 2: Mobile

  // Initialize Connectivity
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();  // Initialize the current connectivity state
    // Subscribe to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Method to check initial connectivity state
  Future<void> initConnectivity() async {
    List<ConnectivityResult> result = [];
    try {
      // Check the current connectivity status (WiFi, Mobile, None)
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.toString()}');
    }
    _updateConnectionStatus(result);  // Update the status after checking
  }

  // Update the connection status based on the ConnectivityResult
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile)) {
      connectionStatus.value = 2;
    }
    else if(result.contains(ConnectivityResult.wifi)) {
      connectionStatus.value = 1;
    }
    else if(result.contains(ConnectivityResult.none)){
      connectionStatus.value = 0;
    }
    // switch (result) {
    //   case ConnectivityResult.wifi:
    //     connectionStatus.value = 1;  // Wi-Fi connected
    //     break;
    //   case ConnectivityResult.mobile:
    //     connectionStatus.value = 2;  // Mobile data connected
    //     break;
    //   case ConnectivityResult.none:
    //     connectionStatus.value = 0;  // No internet connection
    //     break;
    //   default:
    //   // Handle any other case (not typically expected)
    //     connectionStatus.value = 0;
    //     debugPrint('Failed to get network connection status.');
    //     break;
    // }
  }

  // Make sure to cancel the connectivity subscription when the controller is closed
  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  // Optional: You can add additional lifecycle methods like `onReady` if needed
  @override
  void onReady() {
    super.onReady();
    // You could put additional initialization logic here if needed
  }
}
