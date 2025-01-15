import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/IndentorData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/NSDemandSummaryData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/NSDemandlinkData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/NSDemandtotallinkData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/railwaylistdata.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NSDemandSummaryRepo {

  //NSDemandSummaryRepo(BuildContext context);

  NSDemandSummaryRepo._privateConstructor();
  static final NSDemandSummaryRepo _instance = NSDemandSummaryRepo._privateConstructor();
  static NSDemandSummaryRepo get instance => _instance;

  List<RlwData> dropdowndata_UDMRlyList = [];
  List<NSDmdSummaryData> dmdsummaryData = [];

  List<NSlinkData> _nsDemandlinkData = [];
  List<TotallinkData> _nsDemandtotallinkData = [];

  var myList_UDMUnitType = [];
  var myList_UDMunitName = [];
  var myList_UDMDept = [];
  List<dynamic> myList_UDMConsignee = [];
  List<IndentorNameData> indentorData = [];

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  Map<String, String> getintentAll() {
    var all = {
      'postid': '-1',
      'username': "All",
    };
    return all;
  }


  Future<List<RlwData>> fetchrailwaylistData(BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','', prefs.getString('token'));
      if(result_UDMRlyList.statusCode == 200) {
        dropdowndata_UDMRlyList.clear();
        var listdata = json.decode(result_UDMRlyList.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            dropdowndata_UDMRlyList = listJson.map<RlwData>((val) => RlwData.fromJson(val)).toList();
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

    return dropdowndata_UDMRlyList;
  }

  Future<dynamic> def_fetchUnit(String? value, String? unit_data, String? depart, String? unitName, String? depot, String? userSubDep, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myList_UDMUnitType.clear();
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      print("unit type list.... $UDMUnitType_body");
      if(UDMUnitType_body['status'] != 'OK') {
        myList_UDMUnitType.add(getAll());
        return myList_UDMUnitType;
      } else {
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
  }

  Future<dynamic> def_fetchunitName(String? rai, String? unit, String? unitName_name, String? depot, String? depart, String? userSubDep, BuildContext context) async {
    myList_UDMunitName.clear();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai!+"~"+unit!, prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      if(UDMunitName_body['status'] != 'OK') {
        myList_UDMunitName.add(getAll());
        return myList_UDMunitName;

      } else {
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
  }

  Future<dynamic> def_depart_result(BuildContext context) async {
    try {
      myList_UDMDept.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      if(UDMDept_body['status'] != 'OK'){

      }
      else{
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
  }

  Future<dynamic> fetchConsignee(String? rai, String? depart, String? unit_typ, String? Unit_Name, String? depot_id, String? userSubDep, BuildContext context) async {
    try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        myList_UDMConsignee.clear();
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
        var UDMUserConsignee_body = json.decode(result_UDMUserDepot.body);
        print("Hello Consignee..... $UDMUserConsignee_body");
        if(UDMUserConsignee_body['status'] != 'OK') {
          print("consignee error here");
          myList_UDMConsignee.add(getAll());
          return myList_UDMConsignee;
        }
        else {
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
    }


  Future<List<IndentorNameData>> fetchIndentorData(input_type, input, token, BuildContext context) async {
    try {
      var result_UDMCons = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl, input_type, input, token);
      //var result_UDMCons = await Network().postDataWithPro(IRUDMConstants.trialwebnonstockdemandUrl, input_type, "03~06~20~201111~33364", token);
      //var result_UDMCons = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl, input_type, input, token);
      if(result_UDMCons.statusCode == 200) {
        indentorData.clear();
        var listdata = json.decode(result_UDMCons.body);
        print("Indetor Data..... $listdata");
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            indentorData = listJson.map<IndentorNameData>((val) => IndentorNameData.fromJson(val)).toList();
            indentorData.insert(0, IndentorNameData(postid: "-1", username: "All", ccode: "-1", desig: "-1"));
            return indentorData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return indentorData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else {
        indentorData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
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

    return indentorData;
  }

  // ---- NS Demand Summary Data -----

  Future<List<NSDmdSummaryData>> fetchNsdmdsummaryData(String? inputtype, String? fromdate, String? todate, String? rly, String? unittype, String? unitname, String? dept, String? consignee, String? indentorcode,String? indentorname, BuildContext context) async{
    print("input type $inputtype");
    print("fromdate $fromdate");
    print("todate $todate");
    print("railway $rly");
    print("unit type $unittype");
    print("unitname $unitname");
    print("dept $dept");
    print("consignee $consignee");
    print("indentor $indentorcode");
    print("indentorname $indentorname");
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("ns demand data input $rly~$unittype~$unitname~$dept~$indentorcode~$consignee~$indentorname~$fromdate~$todate");
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl, inputtype, "$rly~$unittype~$unitname~$dept~$indentorcode~$consignee~$indentorname~$fromdate~$todate", prefs.getString('token'));
      //var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$rly~$unittype~$unitname~$dept~$indentorcode~$consignee~$indentorname~$fromdate~$todate", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        dmdsummaryData.clear();
        var listdata = json.decode(conresult_hislist.body);
        print("Ns Demand Summary Data $listdata");
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            dmdsummaryData = listJson.map<NSDmdSummaryData>((val) => NSDmdSummaryData.fromJson(val)).toList();
            return dmdsummaryData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return dmdsummaryData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        dmdsummaryData.clear();
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

    return dmdsummaryData;
  }

  Future<List<NSlinkData>> fetchNsdmdlinksummaryData(String? inputtype, indentorPostId,indentorName,total,draft,underFinanceConcurrence,underFinanceVetting,
      underProcess,approvedForwardPurchase,returnedByPurchase,dropped,frmDate,toDate,BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("hyperlink input $indentorPostId~$indentorName~$total~$draft~$underFinanceConcurrence~$underFinanceVetting~$underProcess~$approvedForwardPurchase~$returnedByPurchase~$dropped~$frmDate~$toDate");
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$indentorPostId~$indentorName~$total~$draft~$underFinanceConcurrence~$underFinanceVetting~$underProcess~$approvedForwardPurchase~$returnedByPurchase~$dropped~$frmDate~$toDate", prefs.getString('token'));
      //var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$indentorPostId~$indentorName~$total~$draft~$underFinanceConcurrence~$underFinanceVetting~$underProcess~$approvedForwardPurchase~$returnedByPurchase~$dropped~$frmDate~$toDate", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        _nsDemandlinkData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _nsDemandlinkData = listJson.map<NSlinkData>((val) => NSlinkData.fromJson(val)).toList();
            return _nsDemandlinkData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return _nsDemandlinkData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        _nsDemandlinkData.clear();
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

    return _nsDemandlinkData;
  }

  Future<List<TotallinkData>> fetchNsdmdtotallinksummaryData(String? inputtype, String? orgZone,String? unitType,String? unitName,String? department,
      String? indentorPostId,String? consCode,String? indentorNameStr,String? total,String? draft,String? underFinanceConcurrence,String? underFinanceVetting,
      String? underProcess, String? approvedForwardPurchase,String? returnedByPurchase,String? dropped,String? frmDate,String? toDate, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("total hyperlink input $orgZone~$unitType~$unitName~$department~$indentorPostId~$consCode~$indentorNameStr~$total~$draft~$underFinanceConcurrence~$underFinanceVetting~$underProcess~$approvedForwardPurchase~$returnedByPurchase~$dropped~$frmDate~$toDate");
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$orgZone~$unitType~$unitName~$department~$indentorPostId~$consCode~$indentorNameStr~$total~$draft~$underFinanceConcurrence~$underFinanceVetting~$underProcess~$approvedForwardPurchase~$returnedByPurchase~$dropped~$frmDate~$toDate", prefs.getString('token'));
      //var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$orgZone~$unitType~$unitName~$department~$indentorPostId~$consCode~$indentorNameStr~$total~$draft~$underFinanceConcurrence~$underFinanceVetting~$underProcess~$approvedForwardPurchase~$returnedByPurchase~$dropped~$frmDate~$toDate", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        _nsDemandtotallinkData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _nsDemandtotallinkData = listJson.map<TotallinkData>((val) => TotallinkData.fromJson(val)).toList();
            return _nsDemandtotallinkData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return _nsDemandtotallinkData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        _nsDemandtotallinkData.clear();
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

    return _nsDemandtotallinkData;
  }

  Future<List<NSDmdSummaryData>> fetchSearchNsdmdsummaryData(List<NSDmdSummaryData> data, String query) async{
    if(query.isNotEmpty){
      dmdsummaryData = data.where((element) => element.orgzone.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.orgzonecode.toString().trim().contains(query.toString().trim())
          || element.unitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitnamecode.toString().trim().contains(query.toString().trim())
          || element.unittypename.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unittypecode.toString().trim().contains(query.toString().trim())
          || element.deptname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.deptcode.toString().trim().contains(query.toString().trim())
          || element.ccode.toString().trim().contains(query.toString().trim())
          || element.cname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.total.toString().trim().contains(query.toString().trim())
          || element.draft.toString().trim().contains(query.toString().trim())
          || element.underfinanceconcurrence.toString().trim().contains(query.toString().trim())
          || element.underprocess.toString().trim().contains(query.toString().trim())
          || element.approved.toString().trim().contains(query.toString().trim())
          || element.returned.toString().trim().contains(query.toString().trim())
          || element.dropped.toString().trim().contains(query.toString().trim())
      ).toList();
      return dmdsummaryData;
    }
    else{
      return data;
    }
  }

  Future<List<NSlinkData>> fetchSearchNsdmdsummarylinkData(List<NSlinkData> data, String query) async {
    if(query.isNotEmpty) {
      _nsDemandlinkData = data.where((element) => element.dmdstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.fileno.toString().trim().contains(query.toString().trim())
          || element.approverpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.demandref.toString().trim().contains(query.toString().trim())
          || element.authSeq.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvalstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.previouspost.toString().trim().contains(query.toString().trim())
          || element.initiatedwithpost.toString().trim().contains(query.toString().trim())
          || element.purchageunit.toString().trim().toLowerCase().contains(query.toString().trim().toString())
          || element.currentlywithpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmdkey.toString().trim().contains(query.toString().trim())
          || element.dmdno.toString().trim().contains(query.toString().trim())
          || element.dmddate.toString().trim().contains(query.toString().trim())
          || element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.demandstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return _nsDemandlinkData;
    }
    else{
      return data;
    }
  }

  Future<List<TotallinkData>> fetchSearchNsdmdsummarytotallinkData(List<TotallinkData> data, String query) async {
    if(query.isNotEmpty) {
      _nsDemandtotallinkData = data.where((element) => element.dmdstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.fileno.toString().trim().contains(query.toString().trim())
          || element.approverpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.demandref.toString().trim().contains(query.toString().trim())
          || element.approvalstatus.toString().trim().contains(query.toString().trim())
          || element.itemDescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.previouspost.toString().trim().contains(query.toString().trim())
          || element.purchageunit.toString().trim().toLowerCase().contains(query.toString().trim().toString())
          || element.initiatedwithpost.toString().trim().contains(query.toString().trim())
          || element.currentlywithpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmdkey.toString().trim().contains(query.toString().trim())
          || element.dmdno.toString().trim().contains(query.toString().trim())
          || element.dmddate.toString().trim().contains(query.toString().trim())
          || element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.demandstatus.toString().trim().contains(query.toString().trim())
          || element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return _nsDemandtotallinkData;
    }
    else{
      return data;
    }
  }

}