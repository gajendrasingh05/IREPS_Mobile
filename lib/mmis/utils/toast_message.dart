import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ToastMessage {
  static success(String message) {
    return Get.snackbar('Success', message,
        duration: Duration(milliseconds: 1500),
        borderRadius: 10.0,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(right: 16, left: 16),
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  static error(String message) {
    return Get.snackbar('Alert',
        message,duration: Duration(milliseconds: 1500),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  static networkError(String message) {
    return Get.snackbar('Network Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }

  static toastMessage(String message){
    return Fluttertoast.showToast(msg: message, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
  }

  static showSnackBar(String title, String message, Color backGColor){
     return Get.snackbar(
         title,
         message,
         snackPosition: SnackPosition.BOTTOM,
         duration: Duration(seconds: 2),
         backgroundColor: backGColor,
         colorText: Colors.white,
         margin: EdgeInsets.all(16),
         borderRadius: 8
     );
  }

  static backPress(String message) {
    return Fluttertoast.showToast(msg: message, backgroundColor: Colors.black, textColor: Colors.white, gravity: ToastGravity.BOTTOM, fontSize: 14);
  }

  static Future<bool> checkconnection() async {
    var connectivityresult;
    try {
      connectivityresult = await InternetAddress.lookup('google.com');
      if (connectivityresult != null) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
