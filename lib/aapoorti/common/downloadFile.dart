import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> downloadFile(String url) async {
  HttpClient httpClient = HttpClient();
  File file;
  String filePath = '';
  String myUrl = '';
  String? dir = (await getExternalStorageDirectory())?.path;
  String fileName = url.split('/').last;
  try {
    myUrl = url;
    var request = await httpClient.getUrl(Uri.parse(myUrl));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    } else
      filePath = 'Error code: ' + response.statusCode.toString();
  } catch (ex) {
    filePath = 'Can not fetch url';
  }
  print(filePath);
  return filePath;
}
