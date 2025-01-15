import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/rejection_warranty/models/rejectionwarrantyapproveddropped.dart';
import 'package:flutter_app/udm/rejection_warranty/models/rejectionwarrantyforwarded.dart';
import 'package:flutter_app/udm/rejection_warranty/models/status_data.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RejectionWarrantyRepo {

  RejectionWarrantyRepo(BuildContext context);

  List<Status> statusitems = [];
  List<dynamic> rwitems = [];

  //----- Rejection Warranty Forwarded Claims ------
  List<WarrantyforwardedData> _rwfcitems = [];

  //----- Rejection Warranty Approved/Dropped Claims ------
  List<ApprovedDroppedData> _rwadcitems = [];

  List statuslist = [
    // {
    //   "statusvalue" : "-1",
    //   "statusname" : "All"
    // },
    {
      "statusvalue": "0",
      "statusname": "Claim Yet to be Lodged on Vendor"
    },
    {
      "statusvalue": "1",
      "statusname": "Claim on Vendor Initiated"
    },
    {
      "statusvalue": "2",
      "statusname": "Claim Lodged on Vendor"
    },
    {
      "statusvalue": '3',
      "statusname": "Returned to Maintenance Application"
    },
    {
      "statusvalue": "4",
      "statusname": "Complaint Data Filled in UDM Deleted"
    },
    {
      "statusvalue": "7",
      "statusname": "Advice Note to Store Depot Initiated"
    },
    {
      "statusvalue": "8",
      "statusname": "Advice Note Returned by Stores Depot"
    },
    {
      "statusvalue": "9",
      "statusname": "Advice Note Sent to Stores Depot"
    }
  ];

  Future<List<Status>> fetchStatusData() async {
    statusitems = statuslist.map<Status>((val) => Status.fromJson(val)).toList();
    //statusitems.sort((a, b) => a.statusvalue!.compareTo(b.statusvalue!));
    return statusitems;
  }

  Future<List<Status>> fetchRWData() async {
    statusitems = statuslist.map<Status>((val) => Status.fromJson(val)).toList();
    //statusitems.sort((a, b) => a.statusvalue!.compareTo(b.statusvalue!));
    return statusitems;
  }

  Future<List<WarrantyforwardedData>> fetchmyforwardedClaimsData(String inputtype, String fromdate, String todate, String query, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.trialwebrejectionwarrantyUrl, inputtype,"5404~07-07-2022~03-01-2023~ ~ALL", prefs.getString('token'));
      print("wr input ${prefs.getString('userpostid')}~$fromdate~$todate~$query~ALL");
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webrejectionwarrantyUrl, inputtype,"${prefs.getString('userpostid')}~$fromdate~$todate~$query~ALL", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        _rwfcitems.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _rwfcitems = listJson.map<WarrantyforwardedData>((val) => WarrantyforwardedData.fromJson(val)).toList();
            return _rwfcitems;
          } else {
            return _rwfcitems;
          }
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
        }
      }
      else{
        _rwfcitems.clear();
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

    return _rwfcitems;
  }

  Future<List<ApprovedDroppedData>> fetchmyapproveddroppedClaimsData(String inputtype, String fromdate, String todate, String query, BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.trialwebrejectionwarrantyUrl, inputtype,"5404~07-07-2022~03-01-2023~ ~ALL", prefs.getString('token'));
      var conresult_hislist = await Network().postDataWithPro(IRUDMConstants.webrejectionwarrantyUrl,inputtype,"${prefs.getString('userpostid')}~$fromdate~$todate~$query~ALL", prefs.getString('token'));
      if(conresult_hislist.statusCode == 200) {
        _rwadcitems.clear();
        var listdata = json.decode(conresult_hislist.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            _rwadcitems = listJson.map<ApprovedDroppedData>((val) => ApprovedDroppedData.fromJson(val)).toList();
            return _rwadcitems;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return _rwadcitems;
          }
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
        }
      }
      else{
        _rwadcitems.clear();
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

    return _rwadcitems;
  }

  // Searching Data

  Future<List<WarrantyforwardedData>> fetchSearchRWFCData(List<WarrantyforwardedData> data, String query) async{
    if(query.isNotEmpty){
      _rwfcitems = data.where((element) => element.fwddetails.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.firtranskey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sourcewarranty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.refno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.refdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.recoveredamount.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounitrate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depodetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transunitdes.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.warrepqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.warrepdtls.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.recoverystatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitfactor.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.billpayoff.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.allocation.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.origrecovery.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.balrecovery.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.curstockinglocation.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transkey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyrejected.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transrate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerkey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfoliono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmtrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmtrdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitdes.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyreceived.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyaccepted.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vendorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.podate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.balrejqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.balrejvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challanno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challandate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejectionrej.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.acceptedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejtranskey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.totalreinspqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.returnedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.suppliedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.reinspflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejadviceno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejadvicedate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approverpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approverdesig.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvedon.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.initiatorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.initiatorpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.initiatordesig.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.authseq.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.statuswarranty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return _rwfcitems;
    }
    else{
      return data;
    }
  }

  Future<List<ApprovedDroppedData>> fetchSearchRWADCData(List<ApprovedDroppedData> data, String query) async{
    if(query.isNotEmpty){
      _rwadcitems = data.where((element) => element.firtranskey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sourcewarranty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.refno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.refdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.recoveredamount.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounitrate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depodetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transunitdes.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.warrepqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.warrepdtls.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.recoverystatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitfactor.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.billpayoff.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.allocation.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.origrecovery.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.balrecovery.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.curstockinglocation.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transkey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyrejected.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transrate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerkey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfoliono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmtrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmtrdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitdes.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyreceived.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyaccepted.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vendorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.podate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.balrejqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.balrejvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challanno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challandate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejectionrej.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.acceptedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejtranskey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.totalreinspqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.returnedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.suppliedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.reinspflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejadviceno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejadvicedate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approverpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approverdesig.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvedon.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.initiatorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.initiatorpost.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.initiatordesig.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.authseq.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.statuswarranty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return _rwadcitems;
    }
    else{
      return data;
    }
  }
}