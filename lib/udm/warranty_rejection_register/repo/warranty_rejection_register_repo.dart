import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/amountRecoveredData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/amountRefundData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/railwaylistdata.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/recoveryRefundListData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/reinspData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/rejectionAdviceDetailsData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/rejectionAdviceRegisterData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/rejectionAdviceSummaryData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/replacementData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/returnedOfRejectedItemListData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/warrantyOfficerData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/warrantyRejectionRegisterData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/warrantyrejectionreportData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/warrantysummaryreportData.dart';
import 'package:flutter_app/udm/warranty_rejection_register/models/withdrawnData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarrantyRejectionRegisterRepo{

  WarrantyRejectionRegisterRepo._privateConstructor();
  static final WarrantyRejectionRegisterRepo _instance = WarrantyRejectionRegisterRepo._privateConstructor();
  static WarrantyRejectionRegisterRepo get instance => _instance;

  List<WrrlistData> wrrlistData = [];

  List<WarrantyrejrepData> warrantyrejreportData = [];
  List<WarrantySmryReportData>  warrantysummryreportData = [];

  List<RejAdcRegData> rejadviceregData = [];
  List<RejAdcSummaryData> rejadvsmmryData = [];

  List<WRRRlwData> dropdowndata_UDMRlyList = [];
  var myList_UDMDept = [];
  List<dynamic> myList_UDMConsignee = [];
  List<dynamic> myList_UDMSubConsignee = [];

  List<RejectionAdviceData> rejectionAdviceData = [];
  List<OfiicerData> officerData = [];
  List<WithdrawData> withdrawData = [];
  List<ReinsData> reinspData = [];
  List<RepData> repData = [];
  List<dynamic> depositedData = [];
  List<AmtRecData> amtrcvData = [];
  List<RetrejData> retrejData = [];
  List<AmtRefData> amtrefjData = [];
  List<RecRefData> recrefData = [];

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  Future<List<WRRRlwData>> fetchrailwaylistData(BuildContext context) async{
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
            dropdowndata_UDMRlyList = listJson.map<WRRRlwData>((val) => WRRRlwData.fromJson(val)).toList();
            dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            dropdowndata_UDMRlyList.insert(0, WRRRlwData(intcode: "-1", value: "All"));
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
        //myList_UDMDept.insert(0, getAll());
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

  Future<dynamic> fetchConsignee(String? rai, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myList_UDMConsignee.clear();
      //IRUDMConstants.showProgressIndicator(context);
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','Consignee',rai,prefs.getString('token'));
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
        print("else condition ${rai! + "~" + depot_id!}");
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

  // Future<List<WrrlistData>> fetchWrrlistData(String rly, String concode, String subconscode, String fromdate, String todate, String iquery, String vendorsearch, String searchtype, BuildContext context) async{
  //   try{
  //     wrrlistData.clear();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     print('$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
  //     //print('${prefs.getString('userzone')!}~${prefs.getString('consigneecode')!}~${prefs.getString('subconsigneecode')!}~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
  //     var result_stkproposalDataUDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'Warranty_Register','$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
  //     //var result_stkproposalDataUDM=await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'Warranty_Register','${prefs.getString('userzone')!}~${prefs.getString('consigneecode')!}~${prefs.getString('subconsigneecode')!}~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
  //     if(result_stkproposalDataUDM.statusCode == 200){
  //       var listdata = json.decode(result_stkproposalDataUDM.body);
  //       if(listdata['status'] == "OK"){
  //         var listJson = listdata['data'];
  //         if(listJson != null) {
  //           wrrlistData = listJson.map<WrrlistData>((val) => WrrlistData.fromJson(val)).toList();
  //           //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
  //           return wrrlistData;
  //         } else {
  //           IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
  //           return wrrlistData;
  //         }
  //       }
  //     }
  //   }
  //   on SocketException {
  //     IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
  //   } on Exception {
  //     IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
  //   } catch (err) {
  //     IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
  //   }
  //   return wrrlistData;
  // }

  Future<List<WarrantyrejrepData>> fetchWarrantyRejectionReport(String rly, String concode, String subconscode, String fromdate, String todate, String iquery, String vendorsearch, String searchtype, BuildContext context) async{
    try{
      warrantyrejreportData.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //print('${prefs.getString('userzone')!}~${prefs.getString('consigneecode')!}~${prefs.getString('subconsigneecode')!}~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //var result_stkproposalDataUDM = await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'warranty_rejection_report',"03~33364~00~07-06-2022~07-07-2023~ ~ ~A", prefs.getString('token'));
      var result_stkproposalDataUDM=await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'warranty_rejection_report','$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
      if(result_stkproposalDataUDM.statusCode == 200){
        var listdata = json.decode(result_stkproposalDataUDM.body);
        print("rejectionreport list data22 $listdata");
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            warrantyrejreportData = listJson.map<WarrantyrejrepData>((val) => WarrantyrejrepData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return warrantyrejreportData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return warrantyrejreportData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return warrantyrejreportData;
  }

  Future<List<WarrantySmryReportData>> fetchWarrantySummaryReport(String rly, String concode, String subconscode, String fromdate, String todate, String iquery, String vendorsearch, String searchtype, BuildContext context) async{
    try{
      warrantysummryreportData.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //print('${prefs.getString('userzone')!}~${prefs.getString('consigneecode')!}~${prefs.getString('subconsigneecode')!}~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //var result_stkproposalDataUDM = await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'warranty_rejection_report','$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
      var result_stkproposalDataUDM=await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'warranty_summary_report','$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
      if(result_stkproposalDataUDM.statusCode == 200){
        var listdata = json.decode(result_stkproposalDataUDM.body);
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            warrantysummryreportData = listJson.map<WarrantySmryReportData>((val) => WarrantySmryReportData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return warrantysummryreportData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return warrantysummryreportData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return warrantysummryreportData;
  }

  Future<List<RejAdcRegData>> fetchRejectionAdviceregister(String rly, String concode, String subconscode, String deptcode, String fromdate, String todate, String iquery, String vendorsearch, String searchtype, BuildContext context) async{
    try{
      rejadviceregData.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('rejection advice :- $rly~$concode~$subconscode~$deptcode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //print('${prefs.getString('userzone')!}~${prefs.getString('consigneecode')!}~${prefs.getString('subconsigneecode')!}~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //var result_stkproposalDataUDM = await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'rejection_advice_register',"03~33364~00~06~07-06-2022~07-07-2023~ ~ ~A", prefs.getString('token'));
      var result_stkproposalDataUDM=await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'rejection_advice_register','$rly~$concode~$subconscode~$deptcode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
      if(result_stkproposalDataUDM.statusCode == 200) {
        var listdata = json.decode(result_stkproposalDataUDM.body);
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            rejadviceregData = listJson.map<RejAdcRegData>((val) => RejAdcRegData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return rejadviceregData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return rejadviceregData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return rejadviceregData;
  }


  //-----Detail Data----//

  Future<List<RejectionAdviceData>> fetchRejectionAdviceData(String trkey, BuildContext context) async{
    rejectionAdviceData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM = await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'RejectionAdviceDetail',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("rejectionAdvice list data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            rejectionAdviceData = listJson.map<RejectionAdviceData>((val) => RejectionAdviceData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return rejectionAdviceData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return rejectionAdviceData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return rejectionAdviceData;
  }

  Future<List<RejAdcSummaryData>> fetchRejectionAdvicesummary(String rly, String concode, String subconscode, String deptcode, String fromdate, String todate, String iquery, String vendorsearch, String searchtype, BuildContext context) async{
    try{
      rejadvsmmryData .clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //print('${prefs.getString('userzone')!}~${prefs.getString('consigneecode')!}~${prefs.getString('subconsigneecode')!}~$fromdate~$todate~$iquery~$vendorsearch~$searchtype');
      //var result_stkproposalDataUDM = await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'warranty_rejection_report','$rly~$concode~$subconscode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
      var result_stkproposalDataUDM=await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'rejection_advice_summary','$rly~$concode~$subconscode~$deptcode~$fromdate~$todate~$iquery~$vendorsearch~$searchtype', prefs.getString('token'));
      if(result_stkproposalDataUDM.statusCode == 200){
        var listdata = json.decode(result_stkproposalDataUDM.body);
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            rejadvsmmryData = listJson.map<RejAdcSummaryData>((val) => RejAdcSummaryData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return rejadvsmmryData ;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return rejadvsmmryData ;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return rejadvsmmryData;
  }

  Future<List<OfiicerData>> fetchOfficerDetailsData(String trkey, BuildContext context) async{
    officerData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'WarrantyOfficerDetails',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("officer data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            officerData = listJson.map<OfiicerData>((val) => OfiicerData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return officerData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return officerData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return officerData;
  }

  //--- List Data of Details Data ---

  Future<List<WithdrawData>> fetchWithdrawData(String trkey, BuildContext context) async{
    withdrawData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'WithDrawn',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("withdraw data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            withdrawData = listJson.map<WithdrawData>((val) => WithdrawData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return withdrawData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return withdrawData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return withdrawData;
  }

  Future<List<ReinsData>> fetchReinsData(String trkey, BuildContext context) async{
    reinspData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'Reinsp',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Reinsp data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            reinspData = listJson.map<ReinsData>((val) => ReinsData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return reinspData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return reinspData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return reinspData;
  }

  Future<List<RepData>> fetchReplacementsData(String trkey, BuildContext context) async{
    repData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'Replacement',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Replacements data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            repData = listJson.map<RepData>((val) => RepData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return repData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return repData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return repData;
  }

  Future<List<dynamic>> fetchDepositedData(String trkey, BuildContext context) async{
    depositedData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'AmountDepositedByVendor',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Deposited data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            depositedData = listJson;
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return depositedData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return depositedData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return depositedData;
  }

  Future<List<AmtRecData>> fetchAmtRecoveredData(String trkey, BuildContext context) async{
    amtrcvData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'AmountRecovered',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Amount recovered data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            amtrcvData = listJson.map<AmtRecData>((val) => AmtRecData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return amtrcvData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return amtrcvData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return amtrcvData;
  }

  Future<List<RetrejData>> fetchReturnRejData(String trkey, BuildContext context) async{
    retrejData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'ReturnedOfRejectedItemList',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Returned Rejected data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            retrejData = listJson.map<RetrejData>((val) => RetrejData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return retrejData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return retrejData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return retrejData;
  }

  Future<List<AmtRefData>> fetchAmtRefData(String trkey, BuildContext context) async{
    amtrefjData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'AmountRefundedList',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Amount Refund data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            amtrefjData = listJson.map<AmtRefData>((val) => AmtRefData.fromJson(val)).toList();;
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return amtrefjData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return amtrefjData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return amtrefjData;
  }

  Future<List<RecRefData>> fetchAmtRecRefData(String trkey, BuildContext context) async{
    recrefData.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      //var result_UDM=await Network().postDataWithPro('http://localhost:9080/EPSApi/UDM/warrantyrejectionregister/GetData','RejectionAdviceDetail','15891', prefs.getString('token'));
      var result_UDM = await Network().postDataWithPro(IRUDMConstants.webWarrantyRejectionRegister,'RecoveryRefundList',trkey, prefs.getString('token'));
      //var result_UDM=await Network().postDataWithPro(IRUDMConstants.webtrialWarrantyRejectionRegister,'RejectionAdviceDetail','$trkey', prefs.getString('token'));
      if(result_UDM.statusCode == 200){
        var listdata = json.decode(result_UDM.body);
        print("trkey value $trkey");
        print("Amount Recovery Refund data ${json.decode(result_UDM.body)}");
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            recrefData = listJson.map<RecRefData>((val) => RecRefData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return recrefData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return recrefData;
          }
        }
      }
    }
    on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on Exception {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return recrefData;
  }


  Future<List<WarrantyrejrepData>> fetchSearchWrrlistData(List<WarrantyrejrepData> data, String query) async{
    if(query.isNotEmpty){
      warrantyrejreportData = data.where((element) => element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unifiedplno.toString().trim().contains(query.toString().trim())
          || element.receiptVrBalQty.toString().trim().contains(query.toString().trim())
          || element.transunitdes.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherno.toString().trim().contains(query.toString().trim())
          || element.ledgerno.toString().trim().contains(query.toString().trim())
          || element.vendorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase())
      ).toList();
      return warrantyrejreportData;
    }
    else{
      return data;
    }
  }

  Future<List<RejAdcRegData>> fetchSearchRejectionAdvicelistData(List<RejAdcRegData> data, String query) async{
    if(query.isNotEmpty){
      rejadviceregData = data.where((element) => element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unifiedplno.toString().trim().contains(query.toString().trim())
          || element.dmtrno.toString().trim().contains(query.toString().trim())
          || element.challanno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherno.toString().trim().contains(query.toString().trim())
          || element.ledgerno.toString().trim().contains(query.toString().trim())
          || element.vendorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.recoverystatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase())
          || element.rejectionrej.toString().toLowerCase().trim().contains(query.toString().trim().toLowerCase())
      ).toList();
      return rejadviceregData;
    }
    else{
      return data;
    }
  }
}