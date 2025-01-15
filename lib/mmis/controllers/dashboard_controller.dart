import 'dart:convert';

import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';
import 'package:flutter_app/mmis/extention/debuglog.dart';
import 'package:flutter_app/mmis/helpers/di_services.dart' as di_service;
import 'package:flutter_app/mmis/helpers/api.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:flutter_app/mmis/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DashboardState {Idle, Busy, Finished, Error, FinishedwithError}
class DashBoardController extends GetxController{

  //-----User Data------
  RxString? username = ''.obs;
  RxString? mobile = ''.obs;
  RxString? email = ''.obs;
  RxString? sToken = ''.obs;
  RxString? cToken = ''.obs;
  RxString? mapId = ''.obs;

  //final myObject = Get.find<DebugLog>();

  @override
  void onInit(){
    //change([], status: RxStatus.empty());
    super.onInit();
    debugPrint("onInit Called");
    getUserloginData();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchData();
  }

  var dsbState = DashboardState.Idle.obs;

  List<dynamic> dsbData = [].obs;
  List<dynamic> dmdsData = [].obs;
  List<dynamic> dmddData = [].obs;
  List<dynamic> stackchartData = [].obs;
  List<dynamic> stackchartdetData = [].obs;
  List<dynamic> stackchartdlsData = [].obs;

  void fetchData() async {
    try {
      // Start loading state
      dsbState.value = DashboardState.Busy;

      // Get SharedPreferences instance once
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Execute all futures concurrently using Future.wait
      List<dynamic> results = await Future.wait([
        getDsbResp(),
        getDemandSummary(),
        getDemandDetails("MGMT"),
        getStackChart(),
        getStackChartDet(),
        getStackChartDls()
      ]);

      // Handle results from each future
      dynamic dsbRespResult = results[0]; // Result from getDsbResp()
      dynamic demandSummaryResult = results[1]; // Result from getDemandSummary()
      dynamic demandDetailsResult = results[2]; // Result from getDemandDetails()
      dynamic stackChartResult = results[3]; // Result from getStackChart()
      dynamic stackChartDetailsResult = results[4]; // Result from getStackChartDet()
      dynamic stackChartDlsResult = results[5]; // Result from getStackChartDls()

      debugPrint("Dmd Data $dsbRespResult");
      debugPrint("Dmd Sm Data $demandSummaryResult");
      debugPrint("Dmd Detail Data $demandDetailsResult");

      // You can process or use the results as needed
      // Example:
      if(dsbRespResult != null) {
        dsbData = dsbRespResult;
      }
      if (demandSummaryResult != null) {
        dmdsData = demandSummaryResult;
      }

      // Set finished state
      dsbState.value = DashboardState.Finished;
    } catch (e) {
      // Handle errors
      dsbState.value = DashboardState.Error;
      debugPrint("Error: ${e.toString()}");
    }
  }

  Future<dynamic> getDsbResp() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //----------- trial URl --------------------
      //var resp = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.userDashboardEndPoint, 'MM_GRAPH_1', prefs.getString('orgzone'),  prefs.getString('token'));
      //----------- prod URl --------------------
      var resp = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.userDashboardEndPoint, 'MM_GRAPH_1', prefs.getString('orgzone'),  prefs.getString('token'));
      if(resp.statusCode == 200){
        var listdata = json.decode(resp.body);
        debugPrint("nydb data ${listdata.toString()}");
        //myObject.log("nydb data ${listdata.toString()}");
        if(listdata['status'] == "OK"){
          dsbData = listdata['data'];
          return dsbData;
        }
        else{
          //ToastMessage.error('Data not found!!');
          return dsbData;
        }
      }
      else{
        return dsbData;
      }

    }
    catch(e){
      debugPrint("error data ${e.toString()}");
    }

  }

  Future<dynamic> getDemandSummary() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //----------- trial URl --------------------
      //var resp = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.userDashboardEndPoint, 'demand_summary', prefs.getString('orgzone'),  prefs.getString('token'));
      //----------- prod URl --------------------
      var resp = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.userDashboardEndPoint, 'demand_summary', prefs.getString('orgzone'),  prefs.getString('token'));
      if(resp.statusCode == 200){
        var listdata = json.decode(resp.body);
        debugPrint("Demand Summary ${listdata.toString()}");
        //myObject.log("Demand Summary ${listdata.toString()}");
        if(listdata['status'] == "OK"){
          dmdsData = listdata['data'];
          return dmdsData;
        }
        else{
          //ToastMessage.error('Data not found!!');
          return dmdsData;
        }
      }
      else{
        return dmdsData;
      }

    }
    catch(e){
      debugPrint("error data ${e.toString()}");
    }
  }

  Future<dynamic> getDemandDetails(String type) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //-------------- trial Url -----------------------
      //var resp = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.userDashboardEndPoint, 'dmd_details', "${prefs.getString('orgzone')}~$type",  prefs.getString('token'));
      //-------------- prod Url -----------------------
      var resp = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.userDashboardEndPoint, 'dmd_details', "${prefs.getString('orgzone')}~$type",  prefs.getString('token'));
      if(resp.statusCode == 200){
        var listdata = json.decode(resp.body);
        debugPrint("demand Details ${listdata.toString()}");
        //myObject.log("demand Details ${listdata.toString()}");
        if(listdata['status'] == "OK"){
          dmddData = listdata['data'];
          return dmddData;
        }
        else{
          //ToastMessage.error('Data not found!!');
          return dmddData;
        }
      }
      else{
        return dmddData;
      }
    }
    catch(e){
      debugPrint("error data ${e.toString()}");
    }
  }

  Future<dynamic> getStackChart() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //-------------- trial Url ---------------------------
      //var resp = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.userDashboardEndPoint, 'Stack_chart', "${prefs.getString('orgzone')}",  prefs.getString('token'));
      //-------------- prod Url ---------------------------
      var resp = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.userDashboardEndPoint, 'Stack_chart', "${prefs.getString('orgzone')}",  prefs.getString('token'));
      if(resp.statusCode == 200){
        var listdata = json.decode(resp.body);
        debugPrint("Stack Chart Data ${listdata.toString()}");
        //myObject.log("Stack Chart Data ${listdata.toString()}");
        if(listdata['status'] == "OK"){
          stackchartData = listdata['data'];
          return stackchartData;
        }
        else{
          //ToastMessage.error('Data not found!!');
          return stackchartData;
        }
      }
      else{
        return stackchartData;
      }
    }
    catch(e){
      debugPrint("error data ${e.toString()}");
    }
  }

  Future<dynamic> getStackChartDet() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //-------------- trial Url ---------------------------
      //var resp = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.userDashboardEndPoint, 'Stack_chart_details', "${prefs.getString('orgzone')}",  prefs.getString('token'));
      //-------------- prod Url ---------------------------
      var resp = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.userDashboardEndPoint, 'Stack_chart_details', "${prefs.getString('orgzone')}",  prefs.getString('token'));
      if(resp.statusCode == 200){
        var listdata = json.decode(resp.body);
        debugPrint("Stack Chart Details Data ${listdata.toString()}");
        //myObject.log("Stack Chart Data ${listdata.toString()}");
        if(listdata['status'] == "OK"){
          stackchartdetData = listdata['data'];
          return stackchartdetData;
        }
        else{
          //ToastMessage.error('Data not found!!');
          return stackchartdetData;
        }
      }
      else{
        return stackchartdetData;
      }
    }
    catch(e){
      debugPrint("error data ${e.toString()}");
    }
  }

  Future<dynamic> getStackChartDls() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // ---------- trail Url -----------------------
      //var resp = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.userDashboardEndPoint, 'Stack_chart_dtls', "${prefs.getString('orgzone')}",  prefs.getString('token'));
      // ---------- prod Url -----------------------
      var resp = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.userDashboardEndPoint, 'Stack_chart_dtls', "${prefs.getString('orgzone')}",  prefs.getString('token'));
      if(resp.statusCode == 200){
        var listdata = json.decode(resp.body);
        debugPrint("Stack Chart Details Data2 ${listdata.toString()}");
        //myObject.log("Stack Chart Data ${listdata.toString()}");
        if(listdata['status'] == "OK"){
          stackchartdlsData = listdata['data'];
          return stackchartdlsData;
        }
        else{
          //ToastMessage.error('Data not found!!');
          return stackchartdlsData;
        }
      }
      else{
        return stackchartdlsData;
      }
    }
    catch(e){
      debugPrint("error data ${e.toString()}");
    }
  }

  void getUserloginData() async {
    final box = await Hive.openBox<UserLoginrespDb>('user');
    for (var i = 0; i < box.length; i++) {
      var userLoginrespDb = box.getAt(i);
      username!.value = userLoginrespDb!.userName;
      mobile!.value = userLoginrespDb.mobile!;
      email!.value = userLoginrespDb.emailId;
      cToken!.value = userLoginrespDb.cToken;
      sToken!.value = userLoginrespDb.sToken;
      mapId!.value = userLoginrespDb.mapId;
    }
  }


}