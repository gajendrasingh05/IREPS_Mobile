import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crn_digitally_signed/model/CrnAwaitingData.dart';
import 'package:flutter_app/udm/crn_digitally_signed/model/CrnfinalizedData.dart';
import 'package:flutter_app/udm/crn_digitally_signed/model/crn_myfinalised_data.dart';
import 'package:flutter_app/udm/crn_digitally_signed/model/crn_myforwarded_data.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';



enum CrnState {Idle, Busy, Finished, FinishedWithError}

class CrnRepository {

  List<MyfinalisedCrnData> _myfinaliseditems = [];
  List<MyforwardedCrnData> _myforwardeditems = [];
  List<CrnawaitData> _items = [];
  List<CrnfinalzData> _itemsfinalized = [];


  CrnRepository(BuildContext context);

  Future<List<MyfinalisedCrnData>> fetchcrnmyfinalisedData(input_type, zone, conscode, subconscode, fromdate, todate, BuildContext context) async{
     try{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData',input_type, zone+"~"+conscode+"~"+subconscode+"~"+fromdate+"~"+todate, prefs.getString('token'));
       if(response.statusCode == 200) {
         _myfinaliseditems.clear();
         var listdata = json.decode(response.body);
         if(listdata['status'] == "OK") {
           var listJson = listdata['data'];
           if(listJson != null) {
             _myfinaliseditems = listJson.map<MyfinalisedCrnData>((val) => MyfinalisedCrnData.fromJson(val)).toList();
             return _myfinaliseditems;
           } else {
             IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
             return _myfinaliseditems;
             //setState(ItemListState.FinishedWithError);
           }
         } else {
           //IRUDMConstants().showSnack('Data not found.', context);
         }
       }
       else{
         _myfinaliseditems.clear();
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

     return _myfinaliseditems;
  }

  Future<List<MyforwardedCrnData>> fetchcrnmyforwardedData(input_type, zone, postid, conscode, fromdate, todate, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData',input_type, zone+"~"+postid+"~"+conscode+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        _myforwardeditems.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _myforwardeditems = listJson.map<MyforwardedCrnData>((val) => MyforwardedCrnData.fromJson(val)).toList();
            return _myforwardeditems;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return _myforwardeditems;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        _myforwardeditems.clear();
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

    return _myforwardeditems;
  }

  Future<List<CrnawaitData>> fetchcrnawaitData(input_type, zone, postid, fromdate, todate, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData',input_type, zone+"~"+postid+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        _items.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _items = listJson.map<CrnawaitData>((val) => CrnawaitData.fromJson(val)).toList();
            return _items;
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

  Future<List<CrnfinalzData>> fetchcrnfinalizedData(input_type, zone, postid, fromdate, todate, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData',input_type, zone+"~"+postid+"~"+fromdate+"~"+todate, prefs.getString('token'));
      if(response.statusCode == 200) {
        _itemsfinalized.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _itemsfinalized = listJson.map<CrnfinalzData>((val) => CrnfinalzData.fromJson(val)).toList();
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

  Future<List<MyforwardedCrnData>> fetchsearchmyforwardedcrn(List<MyforwardedCrnData> data, String query) async{
    if(query.isNotEmpty){
      _myforwardeditems = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.postname.toString().trim().toLowerCase().contains(query.toLowerCase().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.podate.toString().trim().contains(query.toString().trim())
          || element.ponumber.toString().trim().contains(query.toString().trim())
          || element.qtyreceived.toString().trim().contains(query.toString().trim())
      ).toList();
      return _myforwardeditems;
    }
    return data;
    // if(query.isNotEmpty){
    //   _myforwardeditems.clear();
    //   data.forEach((element) {
    //     if(element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.trvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.vrnumber.toString().trim().contains(query.toString().trim()) || element.vrnumber.toString().trim().startsWith(query.toString().trim())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.postname.toString().trim().toLowerCase().contains(query.toLowerCase().trim().toLowerCase()) || element.postname.toString().trim().toLowerCase().startsWith(query.toLowerCase().trim().toLowerCase())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.firmaccountname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.podate.toString().trim().contains(query.toString().trim()) || element.podate.toString().trim().startsWith(query.toString().trim())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.ponumber.toString().trim().contains(query.toString().trim()) || element.ponumber.toString().trim().startsWith(query.toString().trim())){
    //       _myforwardeditems.add(element);
    //     }
    //     else if(element.qtyreceived.toString().trim().contains(query.toString().trim()) || element.qtyreceived.toString().trim().startsWith(query.toString().trim())){
    //       _myforwardeditems.add(element);
    //     }
    //   });
    //   return _myforwardeditems;
    // }
    // else{
    //   return _myforwardeditems;
    // }
  }

  Future<List<CrnawaitData>> fetchsearchawaitingcrn(List<CrnawaitData> data, String query) async{
    //_items.clear();
    if(query.isNotEmpty){
      _items = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sendername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ponumber.toString().trim().contains(query.toString().trim())
          || element.qtyreceived.toString().trim().contains(query.toString().trim())
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
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.firmaccountname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //     else if(element.sendername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.sendername.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _items.add(element);
    //     }
    //     else if(element.ponumber.toString().trim().contains(query.toString().trim()) || element.ponumber.toString().trim().startsWith(query.toString().trim())){
    //       _items.add(element);
    //     }
    //     else if(element.qtyreceived.toString().trim().contains(query.toString().trim()) || element.qtyreceived.toString().trim().contains(query.toString().trim())){
    //       _items.add(element);
    //     }
    //   });
    //   return _items;
    // }
    // else{
    //   return _items;
    // }
  }

  Future<List<MyfinalisedCrnData>> fetchsearchmyfinalisedcrn(List<MyfinalisedCrnData> data, String query) async{
    if(query.isNotEmpty){
      _myfinaliseditems = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.podate.toString().trim().contains(query.toString().trim())
          || element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.crnstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.approvername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();

      return _myfinaliseditems;
    }
    else{
       return data;
    }
    if(query.isNotEmpty){
      _myfinaliseditems.clear();
      data.forEach((element) {
        if(element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.trvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
          _myfinaliseditems.add(element);
        }
        else if(element.vrnumber.toString().trim().contains(query.toString().trim()) || element.vrnumber.toString().trim().startsWith(query.toString().trim())){
          _myfinaliseditems.add(element);
        }
        else if(element.consname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.consname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
          _myfinaliseditems.add(element);
        }
        else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
          _myfinaliseditems.add(element);
        }
        else if(element.podate.toString().trim().contains(query.toString().trim()) || element.podate.toString().trim().startsWith(query.toString().trim())){
          _myfinaliseditems.add(element);
        }
        else if(element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.firmaccountname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
          _myfinaliseditems.add(element);
        }
        else if(element.crnstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.crnstatus.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
          _myfinaliseditems.add(element);
        }
        else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
          _myfinaliseditems.add(element);
        }
        else if(element.approvername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.approvername.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
           _myfinaliseditems.add(element);
        }
      });
      return _myfinaliseditems;
    }
    else{
      return _myfinaliseditems;
    }
  }

  Future<List<CrnfinalzData>> fetchsearchfinalisedcrn(List<CrnfinalzData> data, String query) async{
    if(query.isNotEmpty){
      _itemsfinalized = data.where((element) => element.trvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrnumber.toString().trim().contains(query.toString().trim())
          || element.authdate.toString().trim().contains(query.toString().trim())
          || element.plno.toString().trim().contains(query.toString().trim())
          || element.consname.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase())
          || element.crnstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sendername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.podate.toString().trim().contains(query.toString().trim())
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
    //     else if(element.authdate.toString().trim().contains(query.toString().trim()) || element.authdate.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.plno.toString().trim().contains(query.toString().trim()) || element.plno.toString().trim().startsWith(query.toString().trim())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.consname.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase()) || element.consname.toString().toLowerCase().trim().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.crnstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.crnstatus.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.firmaccountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.firmaccountname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.sendername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.sendername.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       _itemsfinalized.add(element);
    //     }
    //     else if(element.podate.toString().trim().contains(query.toString().trim()) || element.podate.toString().trim().startsWith(query.toString().trim())){
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