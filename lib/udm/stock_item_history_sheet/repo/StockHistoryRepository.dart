import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/covered_due_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/historylistdata.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/overstock_surplus.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/railwaylistdata.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/rly_board_indent_coverage_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stock_consumption_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stock_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stock_intent_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stock_item_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stock_uncovDue_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stockdetails_material_rejected.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stockdetails_material_under_accountal.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/model/stocklast_five_years_orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StockHistoryState {Idle, Busy, Finished, FinishedWithError}

class StockHistoryRepository {

  List<RlwData> dropdowndata_UDMRlyList = [];


  List<HisListData> historylistData = [];

  List<ItemDetailData> itemdetailData = [];

  List<ConsumptionDetailData> consumptiondetailData = [];
  List<AvailableStockData> availableStockData = [];
  List<UncoverDueData> uncoveredStockData = [];
  List<IntentData> intentData = [];
  List<RlyIntentCoverageData> rlyintentcoverageData = [];
  List<CoveredDueData> coveredDueData = [];
  List<UnderAccountalData> underaccountalData = [];
  List<MaterialRejectedData> materialRejData = [];
  List<OrderPlacedData> orderplaceData = [];
  List<OverStockData> overstockData = [];


  StockHistoryRepository(BuildContext context);

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

  Future<List<HisListData>> fetchhistorylist(String railway, String plvalue, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_hislist = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/HistorySheet/GetData','Search_PL_desc',"$railway~$plvalue", prefs.getString('token'));
      if(result_hislist.statusCode == 200) {
        historylistData.clear();
        var listdata = json.decode(result_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            historylistData = listJson.map<HisListData>((val) => HisListData.fromJson(val)).toList();
            historylistData.sort((a, b) => a.plNo!.compareTo(b.plNo!));
            return historylistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return historylistData;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        historylistData.clear();
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

    return historylistData;
  }

  //Selection list Data

  Future<List<ItemDetailData>> fetchselItemhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(result_hislist.statusCode == 200) {
        itemdetailData.clear();
        var listdata = json.decode(result_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            itemdetailData = listJson.map<ItemDetailData>((val) => ItemDetailData.fromJson(val)).toList();
            return itemdetailData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return itemdetailData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        itemdetailData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return itemdetailData;
  }

  Future<List<ConsumptionDetailData>> fetchselConsumptionhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    debugPrint("Railway $railway");
    debugPrint("plvalue $plvalue");
    debugPrint("inputtype $inputtype");
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      debugPrint("Consumption data $conresult_hislist");
      if(conresult_hislist.statusCode == 200) {
        consumptiondetailData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            consumptiondetailData = listJson.map<ConsumptionDetailData>((val) => ConsumptionDetailData.fromJson(val)).toList();
            return consumptiondetailData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return consumptiondetailData;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        consumptiondetailData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
    return consumptiondetailData;
  }

  Future<List<AvailableStockData>> fetchselAvailableStockhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        availableStockData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            availableStockData = listJson.map<AvailableStockData>((val) => AvailableStockData.fromJson(val)).toList();
            return availableStockData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return availableStockData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        availableStockData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return availableStockData;
  }

  Future<List<UncoverDueData>> fetchselUncoveredStockhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        uncoveredStockData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            uncoveredStockData = listJson.map<UncoverDueData>((val) => UncoverDueData.fromJson(val)).toList();
            return uncoveredStockData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return uncoveredStockData;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        uncoveredStockData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return uncoveredStockData;
  }

  Future<List<IntentData>> fetchselIntentStockhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        intentData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            intentData = listJson.map<IntentData>((val) => IntentData.fromJson(val)).toList();
            return intentData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return intentData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        intentData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return intentData;
  }

  Future<List<RlyIntentCoverageData>> fetchselRlyIntentCoveragehistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        rlyintentcoverageData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            rlyintentcoverageData = listJson.map<RlyIntentCoverageData>((val) => RlyIntentCoverageData.fromJson(val)).toList();
            return rlyintentcoverageData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return rlyintentcoverageData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        rlyintentcoverageData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return rlyintentcoverageData;
  }

  Future<List<CoveredDueData>> fetchselCoveredDuehistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        coveredDueData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            coveredDueData = listJson.map<CoveredDueData>((val) => CoveredDueData.fromJson(val)).toList();
            return coveredDueData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return coveredDueData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        coveredDueData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return coveredDueData;
  }

  Future<List<UnderAccountalData>> fetchselUnderAcchistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        underaccountalData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            underaccountalData = listJson.map<UnderAccountalData>((val) => UnderAccountalData.fromJson(val)).toList();
            return underaccountalData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return underaccountalData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        underaccountalData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return underaccountalData;
  }

  Future<List<MaterialRejectedData>> fetchselMatRejhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        materialRejData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            materialRejData = listJson.map<MaterialRejectedData>((val) => MaterialRejectedData.fromJson(val)).toList();
            return materialRejData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return materialRejData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        materialRejData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return materialRejData;
  }

  Future<List<OrderPlacedData>> fetchselOrderPlacehistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        orderplaceData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            orderplaceData = listJson.map<OrderPlacedData>((val) => OrderPlacedData.fromJson(val)).toList();
            return orderplaceData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return orderplaceData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        orderplaceData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return orderplaceData;
  }

  Future<List<OverStockData>> fetchselOverStockhistorylist(String railway, String plvalue, String inputtype, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webstockhisUrl,inputtype,"$railway~$plvalue", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        overstockData.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            overstockData = listJson.map<OverStockData>((val) => OverStockData.fromJson(val)).toList();
            return overstockData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return overstockData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        overstockData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return overstockData;
  }

  // Searching Data

  Future<List<HisListData>> fetchSearchHisData(List<HisListData> data, String query) async{
    if(query.isNotEmpty){
      historylistData = data.where((element) => element.plNo.toString().trim().contains(query.toString().trim())
          || element.descr.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return historylistData;
    }
    else{
      return data;
    }
  }
}