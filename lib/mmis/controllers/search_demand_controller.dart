import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/models/department.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:get/get.dart';
import 'package:flutter_app/mmis/models/search_demand_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DepartmentState {Idle, Busy, Finished, Error, FinishedwithError}
enum SearchDmdDataState {Idle, Busy, Finished, NoData, Error, FinishedwithError}
class SearchDemandController extends GetxController {

  var departState = DepartmentState.Idle.obs;
  var dmdDataState = SearchDmdDataState.Idle.obs;

  RxBool searchData = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //fetchDepartment();
  }

  List<DepartData> departOptions = [];
  List<SearchDmdData> dmdData = [];
  List<SearchDmdData> duplicatedmdData = [];

  Future<void> fetchDepartment(BuildContext context) async{
    departState.value = DepartmentState.Busy;
    fetchToken(context);
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CRIS_MMIS_SELECT_DEPT",
        "input": "",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        departOptions.clear();
        var listdata = json.decode(response.body);
        if(json.decode(response.body)['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            departOptions = listJson.map<DepartData>((val) => DepartData.fromJson(val)).toList();
            departState.value = DepartmentState.Finished;
          }
          else{
            departState.value = DepartmentState.FinishedwithError;
            departOptions = [];
          }
        }
      }
      else{
        departOptions.clear();
        departState.value = DepartmentState.Error;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {}
    on SocketException {}
    on FormatException {
    } catch (err) {}
  }


  Future<void> fetchSearchDmdData(String? demandType, String? fromDate, String? toDate, String? deptCode, String? statusCode, String? demandnum, BuildContext context) async{
    debugPrint("Parameter $demandType~$fromDate~$toDate~$deptCode~$statusCode~$demandnum~05~98");
    fetchToken(context);
    dmdDataState.value = SearchDmdDataState.Busy;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CRIS_MMIS_SEARCH_DEMAND",
        "input": "$demandType~$fromDate~$toDate~$deptCode~$statusCode~$demandnum~05~98",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response sdd ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        dmdData.clear();
        duplicatedmdData.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            dmdData = listJson.map<SearchDmdData>((val) => SearchDmdData.fromJson(val)).toList();
            duplicatedmdData = listJson.map<SearchDmdData>((val) => SearchDmdData.fromJson(val)).toList();
            dmdDataState.value = SearchDmdDataState.Finished;
          }
          else{
            dmdDataState.value = SearchDmdDataState.NoData;
            dmdData = [];
          }
        }
      }
      else{
        dmdData.clear();
        dmdDataState.value = SearchDmdDataState.Error;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      dmdDataState.value = SearchDmdDataState.FinishedwithError;
    }
  }

  Future<void> changetoolbarUi(bool searchres) async{
    searchData.value = searchres;
  }

  // --- Searching on Search Demand Data
  void searchingDmdData(String query, BuildContext context){
    dmdDataState.value = SearchDmdDataState.Busy;
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<SearchDmdData>> data = fetchSearchdmdData(duplicatedmdData, query);
        data.then((value) {
          dmdData = value.toSet().toList();
          dmdDataState.value = SearchDmdDataState.Finished;
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      dmdData = duplicatedmdData;
      dmdDataState.value = SearchDmdDataState.Finished;
    }
    else{
      dmdData = duplicatedmdData;
      dmdDataState.value = SearchDmdDataState.Finished;
    }
  }

  // --- Search Demand Searching Data ----
  Future<List<SearchDmdData>> fetchSearchdmdData(List<SearchDmdData> data, String query) async{
    if(query.isNotEmpty){
      dmdData = data.where((element) => element.key1.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key2.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key3.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key4.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key5.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key6.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key7.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key8.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key9.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return dmdData;
    }
    else{
      return data;
    }
  }

}


