import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/warranty_crn_summary/models/railwaylistdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrCrnSummaryRepo {

  WrCrnSummaryRepo._privateConstructor();
  static final WrCrnSummaryRepo _instance = WrCrnSummaryRepo._privateConstructor();
  static WrCrnSummaryRepo get instance => _instance;

  List<WrCrnSummaryRlwData> dropdowndata_UDMRlyList = [];

  //List<CrnSmryData> crnsummaryData = [];
  //List<CrnsumrylinkData> crnsummarylinkData = [];


  //List<NSlinkData> _nsDemandlinkData = [];

  var myList_UDMUnitType = [];
  var myList_UDMunitName = [];
  var myList_UDMDept = [];
  List<dynamic> myList_UDMConsignee = [];
  List<dynamic> myList_UDMSubConsignee = [];

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  Future<List<WrCrnSummaryRlwData>> fetchrailwaylistData(BuildContext context) async{
    //IRUDMConstants.showProgressIndicator(context);
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','', prefs.getString('token'));
      if(result_UDMRlyList.statusCode == 200) {
        dropdowndata_UDMRlyList.clear();
        var listdata = json.decode(result_UDMRlyList.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            dropdowndata_UDMRlyList = listJson.map<WrCrnSummaryRlwData>((val) => WrCrnSummaryRlwData.fromJson(val)).toList();
            dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return dropdowndata_UDMRlyList;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return dropdowndata_UDMRlyList;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        //IRUDMConstants.removeProgressIndicator(context);
      }
      else{
        dropdowndata_UDMRlyList.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
    finally {
      //IRUDMConstants.removeProgressIndicator(context);
    }
    return dropdowndata_UDMRlyList;
  }

  Future<dynamic> def_fetchUnit(String? value, String? unit_data, String? depart, String? unitName, String? depot, String? userSubDep, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myList_UDMUnitType.clear();
    //IRUDMConstants.showProgressIndicator(context);
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      print("unit type list.... $UDMUnitType_body");
      if(UDMUnitType_body['status'] != 'OK') {
        //IRUDMConstants.removeProgressIndicator(context);
        myList_UDMUnitType.add(getAll());
        return myList_UDMUnitType;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
        var unitData = UDMUnitType_body['data'];
        myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        return myList_UDMUnitType;
      }
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchunitName(String? rai, String? unit, String? unitName_name, String? depot, String? depart, String? userSubDep, BuildContext context) async {
    myList_UDMunitName.clear();
    //IRUDMConstants.showProgressIndicator(context);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai!+"~"+unit!, prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      print("unit name list.... $UDMunitName_body");
      if(UDMunitName_body['status'] != 'OK') {
        //IRUDMConstants.removeProgressIndicator(context);
        myList_UDMunitName.add(getAll());
        return myList_UDMunitName;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
        var divisionData = UDMunitName_body['data'];
        myList_UDMunitName.add(getAll());
        myList_UDMunitName.addAll(divisionData);
        return myList_UDMunitName;
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_depart_result(BuildContext context) async {
    try {
      myList_UDMDept.clear();
      //IRUDMConstants.showProgressIndicator(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      if(UDMDept_body['status'] != 'OK'){
        //IRUDMConstants.removeProgressIndicator(context);
      }
      else{
        //IRUDMConstants.removeProgressIndicator(context);
        var deptData = UDMDept_body['data'];
        myList_UDMDept.addAll(deptData);
        //myList_UDMDept.sort((a, b) => a['value']!.compareTo(b['value']!));
        return myList_UDMDept;
      }

    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> fetchConsignee(String? rai, String? depart, String? unit_typ, String? Unit_Name, String? depot_id, String? userSubDep, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myList_UDMConsignee.clear();
      //IRUDMConstants.showProgressIndicator(context);
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
      var UDMUserConsignee_body = json.decode(result_UDMUserDepot.body);
      print("Hello Consignee..... $UDMUserConsignee_body");
      if(UDMUserConsignee_body['status'] != 'OK') {
        //IRUDMConstants.removeProgressIndicator(context);
        print("consignee error here");
        myList_UDMConsignee.add(getAll());
        return myList_UDMConsignee;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
        if(UDMUserConsignee_body['message'] != "Success!"){
          myList_UDMConsignee.add(getAll());
          return myList_UDMConsignee;
        }
        else{
          var depoData = UDMUserConsignee_body['data'];
          myList_UDMConsignee.add(getAll());
          depoData.forEach((item) {
            if(item['intcode'].toString() == prefs.getString('consigneecode')){
              myList_UDMConsignee.addAll(depoData);
            }
            else{
              if(myList_UDMConsignee.isEmpty || myList_UDMConsignee.length == 1){
                myList_UDMConsignee.addAll(depoData);
              }
            }
          });
          return myList_UDMConsignee;
        }
      }

    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String? userSDepo, BuildContext context) async {
    print("railway now $rai");
    print("depot id now $depot_id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //IRUDMConstants.showProgressIndicator(context);
    myList_UDMSubConsignee.clear();
    try {
      if(depot_id == 'NA') {
        print("Fetch sub depot if condition");
        myList_UDMSubConsignee.add(getAll());
        return myList_UDMSubConsignee;
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        print("Hello Sub Consignee..... $UDMUserSubDepot_body");
        if(UDMUserSubDepot_body['status'] != 'OK') {
          //IRUDMConstants.removeProgressIndicator(context);
          myList_UDMSubConsignee.add(getAll());
          return myList_UDMSubConsignee;
        } else {
          //IRUDMConstants.removeProgressIndicator(context);
          var subDepotData = UDMUserSubDepot_body['data'];
          if(subDepotData == null){
            myList_UDMSubConsignee.add(getAll());
            return myList_UDMSubConsignee;
          }
          else{
            myList_UDMSubConsignee.add(getAll());
            myList_UDMSubConsignee.addAll(subDepotData);
            return myList_UDMSubConsignee;
          }
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }


}