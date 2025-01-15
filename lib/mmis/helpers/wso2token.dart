import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';

import 'package:dio/dio.dart';
import 'package:flutter_app/mmis/helpers/shared_data.dart';
import 'package:flutter_app/mmis/routes/routes.dart';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if(Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}

Future fetchToken(BuildContext context) async {
  debugPrint("fetch token calling");
  prefs = await SharedPreferences.getInstance();
  String? tmpdeviceID = await _getId();
  String deviceId = tmpdeviceID.toString().toLowerCase();
  debugPrint("device ID"+deviceId);
  var tokenHeader='Basic OGFWZ19ISUJiaDBuRGFQYmxuN3FUU2t2QVo4YTpsWjY4azByUDhuOTVycU5feUMyZFpVVGtGWlVh';
  IRUDMConstants.showProgressIndicator(context);
  Map<String, dynamic> body = {
    "grant_type": 'client_credentials',
    "scope": 'device_${deviceId}'
  } ;
  var url = 'https://gw.crisapis.indianrail.gov.in/token';
  debugPrint("url = " + url);
  final ioc = HttpClient();
  ioc.badCertificateCallback = (X509Certificate cert, String host, int port) {
    final isValidHost = ["203.176.112.102"].contains(host);
    return isValidHost;
  };
  final http = IOClient(ioc);
  try {
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-type': Headers.formUrlEncodedContentType,
        'Authorization': tokenHeader,
      },
      body: body,
    );
    print(jsonEncode(body));
    print(response);
    if(response.statusCode == 200) {
      IRUDMConstants.removeProgressIndicator(context);
      var jsonResult = json.decode(response.body);
      prefs.setString('token', 'Bearer ' + jsonResult['access_token']);
      int expTime = jsonResult['expires_in'];
      var today = DateTime.now();
      var check_exp = today.add(Duration(seconds: expTime));
      Future.delayed(Duration(seconds: 0), () async {
        Get.offAndToNamed(Routes.loginScreen);
      });
      prefs.setString('exp_time', check_exp.toString());
      prefs.setString('deviceId', deviceId.toString());
      print(jsonResult['access_token']);
      print(check_exp.toIso8601String());
    } else {
      IRUDMConstants.removeProgressIndicator(context);
      fetchToken(context);
      return IRUDMConstants().showSnack("No data found", context);
    }
  }catch(e){
    debugPrint(e.toString());
  }
}
