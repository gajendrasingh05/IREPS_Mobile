import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/model/gem_bill_details.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Buyer_details.dart';
import '../model/consignee_Details.dart';
import '../model/covering_po_details.dart';
import '../model/deduction_details.dart';
import '../model/gem_accountal_details.dart';
import '../model/gem_order_details.dart';

enum GemOrderState {Idle, Busy, Finished, FinishedWithError}

class GemOrderRepository {

  List<BuyerDetailsData> buyerDetailsDatalistData = [];
  List<ConsigneeDetailsData> consigneeDetailsDatalistData = [];
  List<CoveringPODetailsData> coveringPODetailsDatalistData = [];
  List<DeductionDetailsData> DeductionDetailsDatalistData = [];
  List<GemAccountalDetailsData> GemAccountalDetailsDatalistData = [];
  List<GemOrderDetailsData> GemOrderDetailsDatalistData = [];
  List<GemBillDetailsData> GemBillDetailsDatalistData = [];

  GemOrderRepository(BuildContext context);

//BuyerDetails
  Future<List<BuyerDetailsData>> fetchBuyerDetailsDatalist(String orderID, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_BuyerDetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Buyer_Details',"$orderID", prefs.getString('token'));
      if(result_BuyerDetailsData.statusCode == 200) {
        buyerDetailsDatalistData.clear();
        var listdata = json.decode(result_BuyerDetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            buyerDetailsDatalistData = listJson.map<BuyerDetailsData>((val) => BuyerDetailsData.fromJson(val)).toList();
            //buyerDetailsDatalistData.sort((a, b) => a.plNo!.compareTo(b.plNo!));
            return buyerDetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return buyerDetailsDatalistData;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        buyerDetailsDatalistData.clear();
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
    return buyerDetailsDatalistData;
  }

  //ConsigneeDetailsData
  Future<List<ConsigneeDetailsData>> fetchConsigneeDetailsDatalist(String orderID, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_ConsigneeDetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','ConsigneeDetailsData',"$orderID", prefs.getString('token'));
      if(result_ConsigneeDetailsData.statusCode == 200) {
        consigneeDetailsDatalistData.clear();
        var listdata = json.decode(result_ConsigneeDetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            consigneeDetailsDatalistData = listJson.map<ConsigneeDetailsData>((val) => ConsigneeDetailsData.fromJson(val)).toList();
            return consigneeDetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return consigneeDetailsDatalistData;
          }
        } else {
        }
      }
      else{
        consigneeDetailsDatalistData.clear();
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
    return consigneeDetailsDatalistData;
  }

  //CoveringPODetailsData
  Future<List<CoveringPODetailsData>> fetchCoveringPODetailsDatalist(String pokey, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_CoveringPODetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','covering_po_details',"$pokey", prefs.getString('token'));
      if(result_CoveringPODetailsData.statusCode == 200) {
        coveringPODetailsDatalistData.clear();
        var listdata = json.decode(result_CoveringPODetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            coveringPODetailsDatalistData = listJson.map<CoveringPODetailsData>((val) => CoveringPODetailsData.fromJson(val)).toList();
            return coveringPODetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return coveringPODetailsDatalistData;
          }
        } else {
        }
      }
      else{
        coveringPODetailsDatalistData.clear();
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

    return coveringPODetailsDatalistData;
  }

  //DeductionDetailsData
  Future<List<DeductionDetailsData>> fetchDeductionDetailsDatalist(String co6number, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_DeductionDetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Deduction_details',"$co6number", prefs.getString('token'));
      if(result_DeductionDetailsData.statusCode == 200) {
        DeductionDetailsDatalistData.clear();
        var listdata = json.decode(result_DeductionDetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          print("Deduction details CO6Number ${listdata}");
          if(listJson != null) {
            DeductionDetailsDatalistData = listJson.map<DeductionDetailsData>((val) => DeductionDetailsData.fromJson(val)).toList();
            return DeductionDetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return DeductionDetailsDatalistData;
          }
        } else {
        }
      }
      else{
        DeductionDetailsDatalistData.clear();
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
    return DeductionDetailsDatalistData;
  }

  //GemAccountalDetailsData
  Future<List<GemAccountalDetailsData>> fetchGemAccountalDetailsDatalist(String orderID, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_GemAccountalDetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Gem_Accountal_Details',"$orderID", prefs.getString('token'));
      if(result_GemAccountalDetailsData.statusCode == 200) {
        GemAccountalDetailsDatalistData.clear();
        var listdata = json.decode(result_GemAccountalDetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            GemAccountalDetailsDatalistData = listJson.map<GemAccountalDetailsData>((val) => GemAccountalDetailsData.fromJson(val)).toList();
            return GemAccountalDetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return GemAccountalDetailsDatalistData;
          }
        } else {
        }
      }
      else{
        GemAccountalDetailsDatalistData.clear();
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
    return GemAccountalDetailsDatalistData;
  }

  //GemOrderDetailsData
  Future<List<GemOrderDetailsData>> fetchGemOrderDetailsDataDatalist(String orderID, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_GemOrderDetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Gem_Order',"$orderID", prefs.getString('token'));
      if(result_GemOrderDetailsData.statusCode == 200) {
        GemOrderDetailsDatalistData.clear();
        var listdata = json.decode(result_GemOrderDetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            GemOrderDetailsDatalistData = listJson.map<GemOrderDetailsData>((val) => GemOrderDetailsData.fromJson(val)).toList();
            return GemOrderDetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return GemOrderDetailsDatalistData;
          }
        } else {
        }
      }
      else{
        GemOrderDetailsDatalistData.clear();
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

    return GemOrderDetailsDatalistData;
  }

  //gemBill
  Future<List<GemBillDetailsData>> fetchGemBillDetailsDataDatalist(String orderID, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_GemBillDetailsData = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Gem_Bill_Details',"$orderID", prefs.getString('token'));
      if(result_GemBillDetailsData.statusCode == 200) {
        GemBillDetailsDatalistData.clear();
        var listdata = json.decode(result_GemBillDetailsData.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            GemBillDetailsDatalistData = listJson.map<GemBillDetailsData>((val) => GemBillDetailsData.fromJson(val)).toList();
            return GemBillDetailsDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return GemBillDetailsDatalistData;
          }
        } else {
        }
      }
      else{
        GemBillDetailsDatalistData.clear();
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

    return GemBillDetailsDatalistData;
  }


  // Searching Data

  Future<List<BuyerDetailsData>> fetchSearchBuyerDetailsData(List<BuyerDetailsData> data, String query) async{
    if(query.isNotEmpty){
      buyerDetailsDatalistData.clear();
      data.forEach((element) {
        if(element.organisation.toString().trim().contains(query)){
          buyerDetailsDatalistData.add(element);
        }
        else if(element.buyername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())){
          buyerDetailsDatalistData.add(element);
        }
        else if(element.buyeraddress.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())){
          buyerDetailsDatalistData.add(element);
        }
        else if(element.buyermobile.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())){
          buyerDetailsDatalistData.add(element);
        }
      });
      return buyerDetailsDatalistData;
    }
    else{
      return buyerDetailsDatalistData;
    }
  }
}