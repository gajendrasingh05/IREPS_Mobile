import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/CrcAwaitingData.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/CrcfinalzedData.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/crc_myfinalised_data.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/crc_myforwarded_data.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CrcRepository {

  List<MyforwardedCrcData> crcmyforwardeitems = [];
  List<MyfinalisedCrcData> crcmyfinaliseditems = [];
  List<CrcAwaitData> _items = [];
  List<CrcfinalzData> _itemsfinalized = [];
  String? _error;

  CrcRepository(BuildContext context);

  Future<List<MyforwardedCrcData>> fetchcrcmyforwardedData(input_type, zone, conscode, subconscode, fromdate, todate,  BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData',input_type, zone+"~"+conscode+"~"+subconscode+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        crcmyforwardeitems.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            crcmyforwardeitems = listJson.map<MyforwardedCrcData>((val) => MyforwardedCrcData.fromJson(val)).toList();
            return crcmyforwardeitems;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return crcmyforwardeitems;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        crcmyforwardeitems.clear();
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

    return crcmyforwardeitems;
  }

  Future<List<MyfinalisedCrcData>> fetchcrcmyfinalisedData(input_type, zone, conscode, subconscode, fromdate, todate, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData',input_type, zone+"~"+conscode+"~"+subconscode+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        crcmyfinaliseditems.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            crcmyfinaliseditems = listJson.map<MyfinalisedCrcData>((val) => MyfinalisedCrcData.fromJson(val)).toList();
            return crcmyfinaliseditems;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return crcmyfinaliseditems;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        crcmyforwardeitems.clear();
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

    return crcmyfinaliseditems;
  }

  Future<List<CrcAwaitData>> fetchcrcawaitData(input_type, zone, postid, fromdate, todate, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData', input_type, zone+"~"+postid+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        _items.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _items = listJson.map<CrcAwaitData>((val) => CrcAwaitData.fromJson(val)).toList();
            return _items;
            //storeInDB();
            //countData=_items!.length;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return _items;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        _items.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    } on HttpException {
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

    return _items;
  }

  Future<List<CrcfinalzData>> fetchcrcfinalizedData(input_type, zone, postid, fromdate, todate, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData', input_type, zone+"~"+postid+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        _itemsfinalized.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _itemsfinalized = listJson.map<CrcfinalzData>((val) => CrcfinalzData.fromJson(val)).toList();
            return _itemsfinalized;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return _itemsfinalized;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        _itemsfinalized.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    } on HttpException {
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
    return _itemsfinalized;
  }

  // Search operation

  Future<List<MyforwardedCrcData>> fetchsearchmyforwardedcrc(List<MyforwardedCrcData> data, String query) async{
    if(query.isNotEmpty){
      crcmyforwardeitems = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.postname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.podate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.ponumber.toString().trim().contains(query.toString().trim())
          || element.qtyreceived.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();

      return crcmyforwardeitems;
    }
    else{
      return data;
    }
    // if(query.isNotEmpty){
    //   crcmyforwardeitems.clear();
    //   data.forEach((element) {
    //     if(element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.trvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.vrnumber.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.vrnumber.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.postname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.postname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.podate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.podate.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.pounit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.pounit.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.pounitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.pounitname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.ponumber.toString().trim().contains(query.toString().trim()) || element.ponumber.toString().trim().startsWith(query.toString().trim()) ){
    //       crcmyforwardeitems.add(element);
    //     }
    //     else if(element.qtyreceived.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.qtyreceived.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyforwardeitems.add(element);
    //     }
    //   });
    //   return crcmyforwardeitems;
    // }
    // else{
    //   return crcmyforwardeitems;
    // }
  }

  Future<List<CrcAwaitData>> fetchsearchawaitingcrc(List<CrcAwaitData> data, String query) async{
    if(query.isNotEmpty){
      _items = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.podate.toString().trim().contains(query.toString().trim())
          || element.sendername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.ponumber.toString().trim().contains(query.toString().trim())
          || element.firmaccountname.toString().trim().contains(query.toString().trim())
      ).toList();

      return _items;
    }
    else{
      return data;
    }
    // if(query.isNotEmpty){
    //   _items.clear();
    //   data.forEach((element) {
    //     if(element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.trvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //     else if(element.vrnumber.toString().trim().contains(query.toString().trim()) || element.vrnumber.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.consname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //     else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.podate.toString().trim().contains(query.toString().trim()) || element.podate.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.sendername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.sendername.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //     else if(element.pounitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.pounitname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.ponumber.toString().trim().contains(query.toString().trim()) || element.ponumber.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.firmaccountname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //   });
    //   return _items;
    // }
    // else{
    //   return _items;
    // }
  }

  Future<List<MyfinalisedCrcData>> fetchsearchmyfinalisedcrc(List<MyfinalisedCrcData> data, String query) async{
    if(query.isNotEmpty){
      crcmyfinaliseditems = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.podate.toString().trim().contains(query.toString().trim())
          || element.vrdate.toString().trim().contains(query.trim())
          || element.crnstatus.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.ponumber.toString().trim().contains(query.toString().trim())
          || element.approvaldate.toString().trim().contains(query.toString().trim())
      ).toList();

      return crcmyfinaliseditems;
    }
    else{
       return data;
    }
    // if(query.isNotEmpty){
    //   crcmyfinaliseditems.clear();
    //   data.forEach((element) {
    //     if(element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.trvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.vrnumber.toString().trim().contains(query.toString().trim()) || element.vrnumber.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.consname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.podate.toString().trim().contains(query.toString().trim()) || element.podate.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.vrdate.toString().trim().contains(query.trim()) || element.vrdate.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.crnstatus.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase()) || element.crnstatus.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.ponumber.toString().trim().contains(query.toString().trim()) || element.ponumber.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //     else if(element.approvaldate.toString().trim().contains(query.toString().trim()) || element.approvaldate.toString().trim().startsWith(query.toString().trim())){
    //       crcmyfinaliseditems.add(element);
    //     }
    //   });
    //   return crcmyfinaliseditems;
    // }
    // else{
    //   return crcmyfinaliseditems;
    // }
  }

  Future<List<CrcfinalzData>> fetchsearchfinalisedcrc(List<CrcfinalzData> data, String query) async{
    if(query.isNotEmpty){
      _itemsfinalized = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.podate.toString().trim().contains(query.toString().trim())
          || element.sendername.toString().trim().toLowerCase().contains(query.trim().toLowerCase())
          || element.crnstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.ponumber.toString().trim().contains(query.toString().trim())
          || element.approvaldate.toString().trim().contains(query.toString().trim())
      ).toList();

      return _itemsfinalized;
    }
    else{
       return data;
    }
    // if(query.isNotEmpty){
    //   _itemsfinalized.clear();
    //   data.forEach((element) {
    //     if(element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.trvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.vrnumber.toString().trim().contains(query.toString().trim()) || element.vrnumber.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.consname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.podate.toString().trim().contains(query.toString().trim()) || element.podate.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.sendername.toString().trim().toLowerCase().contains(query.trim().toLowerCase()) || element.sendername.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.crnstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.crnstatus.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.ponumber.toString().trim().contains(query.toString().trim()) || element.ponumber.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.approvaldate.toString().trim().contains(query.toString().trim()) || element.approvaldate.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //   });
    //   return _itemsfinalized;
    // }
    // else{
    //   return _itemsfinalized;
    // }
  }
}