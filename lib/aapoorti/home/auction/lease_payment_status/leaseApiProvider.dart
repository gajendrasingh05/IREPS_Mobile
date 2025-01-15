import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiException.dart';
import 'package:http/http.dart' as http;
import '../../../common/AapoortiConstants.dart';
import 'ChallanStatus.dart';

enum ApiStatus { none, running, finished }

class ChallanStatusProvider extends ChangeNotifier {
  ChallanStatus challanStatus = ChallanStatus();
  static ApiStatus? apiStatus;

  String? error;

  void setState(ApiStatus status) {
    apiStatus = status;
  }

  Future<void> getStatus(String input) async {
    debugPrint("myinput $input");
    setState(ApiStatus.running);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://ireps.gov.in/EPSApi/Aapoorti/LeaseGetdata'));
    request.body = json.encode({
      "input_type": "ChallanPaymentDTLS",
      //"input": "12445~VP~2~03/06/2022"
      "input": input
    });
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response =
      await request.send().timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        if (jsonResponse.containsKey("data")) {
          if (jsonResponse["data"].length > 0) {
            challanStatus = ChallanStatus.fromJson(jsonResponse["data"][0]);

            setState(ApiStatus.finished);
          } else {
            setState(ApiStatus.none);
          }
        } else {
          setState(ApiStatus.none);
        }
      } else {
        error = response.reasonPhrase;
        setState(ApiStatus.finished);
        throw AapoortiException("Service Not Available");
      }
    } catch (exception) {
      setState(ApiStatus.finished);
      error = "Exception";
      throw exception;
    }

    notifyListeners();
  }
}


// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/common/AapoortiException.dart';
// import 'package:http/http.dart' as http;
// import '../../../common/AapoortiConstants.dart';
// import 'ChallanStatus.dart';
//
// enum ApiStatus { none, running, finished }
//
// class ChallanStatusProvider extends ChangeNotifier {
//   ChallanStatus challanStatus = ChallanStatus();
//   static ApiStatus apiStatus;
//
//   String error;
//
//   void setState(ApiStatus status) {
//     apiStatus = status;
//   }
//
//   // Value list
//   List<String> subTypeItems = ["F1", "F2", "R1"];
//   int dropDownValue = 0;
//   List<String> types = ["SLR", "VP"];
//   String _type = "SLR";
//
//   String get getType => _type;
//   void updateType(int value){
//      _type = types[value];
//      notifyListeners();
//   }
//
//   //Train type Selecrion
//   String _traintype = 'SLR';
//   String get gettraintype => _traintype;
//   void updatetraintype(String traintype){
//     _traintype = traintype;
//     notifyListeners();
//   }
//
//   //Train Selection
//   String _selectedTrain = 'Single';
//   String get getrdtraintype => _selectedTrain;
//   void updateTrain(String rdtraintype){
//     _selectedTrain = rdtraintype;
//     notifyListeners();
//   }
//
//   Future<void> getStatus(String input) async {
//     setState(ApiStatus.running);
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse('https://trial.ireps.gov.in/EPSApi/Aapoorti/LeaseGetdata'));
//     request.body = json.encode({
//       "input_type": "ChallanPaymentDTLS",
//       //"input": "12445~VP~2~03/06/2022"
//       "input": input
//     });
//     request.headers.addAll(headers);
//     try {
//       http.StreamedResponse response = await request.send().timeout(Duration(seconds: 5));
//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(await response.stream.bytesToString());
//         if (jsonResponse.containsKey("data")) {
//           if (jsonResponse["data"].length > 0) {
//             challanStatus = ChallanStatus.fromJson(jsonResponse["data"][0]);
//             setState(ApiStatus.finished);
//           }
//           else {
//             setState(ApiStatus.none);
//           }
//         } else {
//           setState(ApiStatus.none);
//         }
//       } else {
//         error = response.reasonPhrase;
//         setState(ApiStatus.finished);
//         throw AapoortiException("Service Not Available");
//       }
//     } catch (exception) {
//       setState(ApiStatus.finished);
//       error = "Exception";
//       throw exception;
//     }
//     notifyListeners();
//   }
// }
