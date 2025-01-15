import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/mmis/helpers/shared_data.dart';

class Network{
  static String _urlApim = IRUDMConstants.apimDropDownList;
  var token;
  var pinCount;

  static postDataWithPro(apiUrl, input_type, input, header) async{
    debugPrint("apiurl $apiUrl");
    debugPrint("Input $input");
    debugPrint("input_ $input_type");
    var fullUrl = apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode({'input_type': input_type,'input': input}),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : '*/*',
          'Authorization': header
        }
    );
  }

  static dashboardDataWithPro(apiUrl, input_type, header) async{
    debugPrint("dbapiurl $apiUrl");
    debugPrint("dbinput_ $input_type");
    var fullUrl = apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode({'input_type': input_type}),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : '*/*',
          'Authorization': header
        }
    );
  }

  static postDataWithAPIMList(apiUrl,input_type,input,header) async{
    var fullUrl = _urlApim;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode({'input_type': input_type,'input': input}),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : '*/*',
          'Authorization': header
          //  'Authorization' : 'Bearer $token'
        }
    );
  }

  static postDataWithAPIM(apiUrl,input_type,input,header) async{
    var fullUrl = IRUDMConstants.apimUrl+apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode({'input_type': input_type,'input': input}),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : '*/*',
          'Authorization': header
          //  'Authorization' : 'Bearer $token'
        }
    );
  }

}