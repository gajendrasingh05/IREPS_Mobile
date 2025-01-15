import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter/material.dart';

class Network{
  final String _urlApim = IRUDMConstants.apimDropDownList;
  var token;

  var pinCount;
  _getToken() async {}

  postDataWithPro(apiUrl, input_type, input, header) async{
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

  postDataWithAPIMList(apiUrl,input_type,input,header) async{
    var fullUrl = _urlApim;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode({'input_type': input_type,'input': input}),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : '*/*',
          'Authorization' : header
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
        }
    );
  }

}