import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/udm/end_user/models/checkverification.dart';
import 'package:flutter_app/udm/end_user/models/enduser_list_data.dart';
import 'package:flutter_app/udm/end_user/models/ledgerfolioitemData.dart';
import 'package:flutter_app/udm/end_user/models/ledgerfolionumData.dart';
import 'package:flutter_app/udm/end_user/models/ledgernumData.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/voucher_list_data.dart';

class ToEndUserRepo{

  ToEndUserRepo._privateConstructor();
  static final ToEndUserRepo _instance = ToEndUserRepo._privateConstructor();
  static ToEndUserRepo get instance => _instance;

  List<LedgerNumData> ledgerNumList = [];
  List<LedgerfolioNumData> ledgerfolioNumList = [];
  List<LedgerfolioItemData> ledgerfolioItemList = [];

  List<EndUserlist> enduserlist = [];
  List<VerificationData> verificationList = [];
  List<Voucherlist> voucherlist = [];

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  Future<List<LedgerNumData>> fetchLedgerNumberData(String? rai, String? depot_id, String? userSDepo, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      ledgerNumList.clear();
      var result_UDMLedgerNum = await Network().postDataWithAPIMList('UDMAppList', 'LedgerNo', rai! + "~" + depot_id! + "~" + userSDepo!,prefs.getString('token'));
      var UDMLedgerNum_body = json.decode(result_UDMLedgerNum.body);
      if(UDMLedgerNum_body['status'] != 'OK') {
        //crnsummaryData.add(getAll());
        return ledgerNumList;
      } else {
        var ledgernumData = UDMLedgerNum_body['data'];
        if(ledgernumData != null) {
          ledgerNumList = ledgernumData.map<LedgerNumData>((val) => LedgerNumData.fromJson(val)).toList();
          //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
          return ledgerNumList;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return ledgerNumList;
          //setState(ItemListState.FinishedWithError);
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }

    return ledgerNumList;
  }

  Future<List<LedgerfolioNumData>> fetchLedgerfolioNumberData(String? rai, String? depot_id, String? userSDepo, String? ledgerNo, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      ledgerfolioNumList.clear();
      var result_LedgerfolioNumber = await Network().postDataWithAPIMList('UDMAppList', 'LedgerFolioNo', rai! + "~" + depot_id! + "~" + userSDepo! + "~" + ledgerNo!, prefs.getString('token'));
      var UDMresult_LedgerfolioNumber_body = json.decode(result_LedgerfolioNumber.body);
      if(UDMresult_LedgerfolioNumber_body['status'] != 'OK') {
        return ledgerfolioNumList;
      } else {
        var ledgerfolionumData = UDMresult_LedgerfolioNumber_body['data'];
        if(ledgerfolionumData != null) {
          ledgerfolioNumList = ledgerfolionumData.map<LedgerfolioNumData>((val) => LedgerfolioNumData.fromJson(val)).toList();
          //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
          return ledgerfolioNumList;
        }
        else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return ledgerfolioNumList;
          //setState(ItemListState.FinishedWithError);
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }

    return ledgerfolioNumList;
  }

  Future<List<LedgerfolioItemData>> fetchLedgerfolioItemData(String? rai, String? depot_id, String? userSDepo, String? ledgerNo, String? folioNo, BuildContext context) async {
    //IRUDMConstants.showProgressIndicator(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      ledgerfolioItemList.clear();
      if (userSDepo == 'NA') {
        ledgerfolioItemList.add(LedgerfolioItemData(intcode: "-1", value: "All"));
      } else {
        var result_UDMLedgerfolioItem = await Network().postDataWithAPIMList('UDMAppList', 'LedgerFolioItem', rai!+"~"+depot_id!+"~"+userSDepo!+"~"+ledgerNo!+"~"+folioNo!,prefs.getString('token'));
        var UDMresult_UDMLedgerfolioItem_body = json.decode(result_UDMLedgerfolioItem.body);
        if(UDMresult_UDMLedgerfolioItem_body['status'] != 'OK') {
          return ledgerfolioItemList;
        } else {
          var ledgerfolioItemData = UDMresult_UDMLedgerfolioItem_body['data'];
          if(ledgerfolioItemData != null) {
            ledgerfolioItemList = ledgerfolioItemData.map<LedgerfolioItemData>((val) => LedgerfolioItemData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return ledgerfolioItemList;
          }
          else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return ledgerfolioItemList;
            //setState(ItemListState.FinishedWithError);
          }
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }

    return ledgerfolioItemList;
  }

  // --------- End User Voucher List Data -----------

  Future<List<EndUserlist>> fetchEndUserlistData(BuildContext context, String input_type, String input) async {
    // Create data for EndUserData
    SharedPreferences prefs = await SharedPreferences.getInstance();
    enduserlist.clear();
    try {
      var result_UDMEndurlst = await Network().postDataWithPro(IRUDMConstants.trialwebissueEndUserUrl, input_type, input, prefs.getString('token'));
      //var result_UDMCons = await Network().postDataWithPro(IRUDMConstants.trialwebnonstockdemandUrl, input_type, "03~06~20~201111~33364", token);
      //var result_UDMCons = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl, input_type, input, token);
      if(result_UDMEndurlst.statusCode == 200) {
        enduserlist.clear();
        var listdata = json.decode(result_UDMEndurlst.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            enduserlist = listJson.map<EndUserlist>((val) => EndUserlist.fromJson(val)).toList();
            //indentorData.insert(0, IndentorNameData(postid: "-1", username: "All", ccode: "-1", desig: "-1"));
            return enduserlist;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return enduserlist;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else {
        enduserlist.clear();
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

    return enduserlist;
  }

  Future<List<Voucherlist>> fetchEndUserVoucherlistData(BuildContext context, String input_type, String input) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var result_UDMvorlst = await Network().postDataWithPro(IRUDMConstants.trialwebissueEndUserUrl, input_type, input, prefs.getString('token'));
      if(result_UDMvorlst.statusCode == 200) {
        voucherlist.clear();
        var listdata = json.decode(result_UDMvorlst.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            voucherlist = listJson.map<Voucherlist>((val) => Voucherlist.fromJson(val)).toList();
            return voucherlist;
          } else {
            return voucherlist;
          }
        }
      }
      else {
        voucherlist.clear();
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

    return voucherlist;
  }

  // -------------  Check  issue Verification ------------

  Future<List<VerificationData>> fetchVerificationData(BuildContext context, String input_type, String input) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var resultUdmverlst = await Network().postDataWithPro(IRUDMConstants.trialwebissueEndUserUrl, input_type, input, prefs.getString('token'));
      if(resultUdmverlst.statusCode == 200) {
        verificationList.clear();
        var listdata = json.decode(resultUdmverlst.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            verificationList = listJson.map<VerificationData>((val) => VerificationData.fromJson(val)).toList();
            return verificationList;
          } else {
            return verificationList;
          }
        }
      }
      else {
        verificationList.clear();
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

    return verificationList;
  }
}