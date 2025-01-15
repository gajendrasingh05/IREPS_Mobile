import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/Pop_up_functionality.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/level_count.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/rlyList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cmplaintSource.dart';
import '../model/consignee_codegenComplaint.dart';
import '../repository/warranty_compalint_repo.dart';

enum LevelCountDataState {Idle, Busy, Finished, FinishedWithError, NoData, ClearData}
enum PopupFuncDataState {Idle, Busy, Finished, FinishedWithError, NoData, ClearData}
enum ComplaintSourceDataState {Idle, Busy, Finished, FinishedWithError}
enum RailListDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeComplaintDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeLodgeDataState {Idle, Busy, Finished, FinishedWithError}


class WarrantyComplaintViewModel with ChangeNotifier{

  LevelCountDataState _levelCountstate = LevelCountDataState.Idle;
  PopupFuncDataState _popupFuncstate = PopupFuncDataState.Idle;
  ComplaintSourceDataState _ComplaintDataState = ComplaintSourceDataState.Idle;
  RailListDataState _rlwListDataState = RailListDataState.Idle;
  ConsigneeComplaintDataState _consigneeComplaintDataState = ConsigneeComplaintDataState.Idle;
  ConsigneeLodgeDataState _consigneelodgeDataState = ConsigneeLodgeDataState.Idle;

  Error? _error;

  List<LevelCountData> levelCountData = [];
  List<PopupFuncData> popupFuncData = [];
  List<ComplaintSource> complaintSource = [];
  List<RlwListData> railwaylistData = [];
  List<dynamic> _consigneeCompaintitems = [];
  List<dynamic> _consigneelodgeitems = [];

  List _items = [];
  List<LevelCountData> _duplicateitems = [];
  List<PopupFuncData> _duplicateitemspopup = [];

  String railway = "Select Railway";
  String? rlyCode;
  String consignee = "Select Consignee Code";
  String? consigneecode;
  String consigneelodge = "Select Consignee Code";
  String? consigneelodgecode;
  String? rlyCode1;


  // --- Railway Data ---
  List<RlwListData> get rlylistData => railwaylistData;
  void setrailwaylistData(List<RlwListData> rlylist){
    railwaylistData = rlylist;
  }
  RailListDataState get rlydatastatus => _rlwListDataState;
  void setRlwStatusState(RailListDataState currentState) {
    _rlwListDataState = currentState;
    notifyListeners();
  }

  // complaint source
  List<ComplaintSource> get complaintSourceitemstate => complaintSource;
  void setComplaintSourceDetailslist(List<ComplaintSource> complaintSourceDataDetailslist){
    complaintSource = complaintSourceDataDetailslist;
  }
  ComplaintSourceDataState get complaintSourcestate => _ComplaintDataState;
  void setComplaintSourceState(ComplaintSourceDataState currentState) {
    _ComplaintDataState = currentState;
    notifyListeners();
  }

  //Consignee Complaint
  List<dynamic> get consigneelistData => _consigneeCompaintitems;
  void setConsigneelistData(List<dynamic> consigneeComplaintlist){
    _consigneeCompaintitems = consigneeComplaintlist;
  }
  ConsigneeComplaintDataState get condatastatus => _consigneeComplaintDataState;
  void setConStatusState(ConsigneeComplaintDataState currentState) {
    _consigneeComplaintDataState = currentState;
    notifyListeners();
  }

  //Consignee Lodge claim
  List<dynamic> get consigneelodgelistData => _consigneelodgeitems;
  void setConsigneelodgelistData(List<dynamic> consigneeLodgelist){
    _consigneelodgeitems = consigneeLodgelist;
  }
  ConsigneeLodgeDataState get conlodgedatastatus => _consigneelodgeDataState;
  void setConlodgeStatusState(ConsigneeLodgeDataState currentState) {
    _consigneelodgeDataState = currentState;
    notifyListeners();
  }

  //levelCount
  List<LevelCountData> get levelCountlistData => levelCountData;
  LevelCountDataState get levelCountstate {
    return _levelCountstate;
  }
  void setLevelCountState(LevelCountDataState currentState) {
    _levelCountstate = currentState;
    notifyListeners();
  }
  void setlevelCountDataDetailslist(List<LevelCountData> levelCountDataDetailslist){
    levelCountData = levelCountDataDetailslist;
  }

//popup Function data
  List<PopupFuncData> get popfunclistData => popupFuncData;
  PopupFuncDataState get popupFuncstate {
    return _popupFuncstate;
  }
  void setPopupFuncDataState(PopupFuncDataState currentState) {
    _popupFuncstate = currentState;
    notifyListeners();
  }
  void setpopupFuncDataDetailslist(List<PopupFuncData> popupFuncDataDetailslist){
    popupFuncData = popupFuncDataDetailslist;
  }


  //level count
  Future<void> getLevelCountData(String rlyCode,String consigneecode,String rlycode1,String consigneecode1,String complaintsourcecode,String fromdate,String todate, BuildContext context) async{
    levelCountData.clear();
    _duplicateitems.clear();
    setlevelCountDataDetailslist(levelCountData);
    setLevelCountState(LevelCountDataState.Busy);
    WarrantyComplaintRepository warrantyComplaintRepository = WarrantyComplaintRepository(context);
    try{
      Future<List<LevelCountData>> data = warrantyComplaintRepository.fetchLevelCountDatalist('Level1_count_query',rlyCode, consigneecode,rlycode1, consigneecode1,complaintsourcecode, fromdate, todate, context);
      print("level count1 -- $data");
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setlevelCountDataDetailslist(value);
          setLevelCountState(LevelCountDataState.FinishedWithError);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          print("Warranty complaint ${value.length}");
          _duplicateitems.addAll(value);
          setlevelCountDataDetailslist(value);
          setLevelCountState(LevelCountDataState.Finished);
        }
        else{
          setLevelCountState(LevelCountDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setLevelCountState(LevelCountDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //search level count
  void searchingDataLevelCount(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      WarrantyComplaintRepository warrantyComplaintRepository = WarrantyComplaintRepository(context);
      try{
        Future<List<LevelCountData>> data = warrantyComplaintRepository.fetchsearchingDataLevelCount(_duplicateitems, query);
        data.then((value) {
          setlevelCountDataDetailslist(value);
          setLevelCountState(LevelCountDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      //_dashboarditems.clear();
      setlevelCountDataDetailslist(_duplicateitems);
      setLevelCountState(LevelCountDataState.Finished);
    }
    else{
      setlevelCountDataDetailslist(_duplicateitems);
      setLevelCountState(LevelCountDataState.Finished);
    }
  }

  //pop up func
  Future<void> getPopupFuncData(String? inputtype,String? rlycode,String? consigneecode,String? rlycode1,String? consigneecode1,String? complaintsourcecode,String? fromdate,String? todate,String? query, BuildContext context) async{
   popupFuncData.clear();
    _duplicateitemspopup.clear();
    WarrantyComplaintRepository warrantyComplaintRepository = WarrantyComplaintRepository(context);
    try{
      Future<List<PopupFuncData>> data = warrantyComplaintRepository.fetchPopupFuncDatalist('Pop_up_functionality', rlycode, consigneecode, rlycode1, consigneecode1, complaintsourcecode, fromdate, todate, query, context);
      print("popfunc -- $data");
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setPopupFuncDataState(PopupFuncDataState.NoData);
          setpopupFuncDataDetailslist(value);
        }
        else if(value.isNotEmpty || value.length != 0){
          print("pop func data ${value.length}");
          _duplicateitemspopup.addAll(value);
          setPopupFuncDataState(PopupFuncDataState.Finished);
          setpopupFuncDataDetailslist(value);
          return;
        }
        else{
          setPopupFuncDataState(PopupFuncDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setPopupFuncDataState(PopupFuncDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //search popup function
  void searchingPopUpFunc(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      WarrantyComplaintRepository warrantyComplaintRepository = WarrantyComplaintRepository(context);
      try{
        Future<List<PopupFuncData>> data = warrantyComplaintRepository.fetchsearchingPopupFunc(_duplicateitemspopup, query);
        data.then((value) {
          setpopupFuncDataDetailslist(value);
          setPopupFuncDataState(PopupFuncDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      //_dashboarditems.clear();
      setpopupFuncDataDetailslist(_duplicateitemspopup);
      setPopupFuncDataState(PopupFuncDataState.Finished);
    }
    else{
      setpopupFuncDataDetailslist(_duplicateitemspopup);
      setPopupFuncDataState(PopupFuncDataState.Finished);
    }
  }

  //complaint source
  Future<void> getComplaintSourceData(BuildContext context) async{
    WarrantyComplaintRepository nonStockDemandRepo = WarrantyComplaintRepository(context);
    setComplaintSourceState(ComplaintSourceDataState.Busy);
    try{
      Future<List<ComplaintSource>> data = nonStockDemandRepo.fetchComplaintSourceData();
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setComplaintSourceDetailslist(value);
          setComplaintSourceState(ComplaintSourceDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setComplaintSourceDetailslist(value);
          setComplaintSourceState(ComplaintSourceDataState.Finished);
        }
        else{
          setComplaintSourceState(ComplaintSourceDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setComplaintSourceState(ComplaintSourceDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //railway
  void getRailwaylistData(BuildContext context) async{
    setRlwStatusState(RailListDataState.Busy);
    //WarrantyComplaintRepository warrantyComplaintRepository = WarrantyComplaintRepository(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Future<List<RlwListData>> data = WarrantyComplaintRepository.instance.fetchraillistData(context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setRlwStatusState(RailListDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setrailwaylistData(value);
          railway = "All";
          rlyCode = "-1";
          value.forEach((item) {
            if(item.intcode.toString() == prefs.getString('userzone')){
               railway = item.value.toString();
               rlyCode = item.intcode.toString();
            }
          });
          setRlwStatusState(RailListDataState.Finished);
        }
        else{
          setRlwStatusState(RailListDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //consignee
  Future<void> getConsigneeComplaint(String? rly,String ccode, BuildContext context) async{
    setConStatusState(ConsigneeComplaintDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _consigneeCompaintitems.clear();
    try{
        if(rly == "" && ccode == ""){
          Future<dynamic> data = WarrantyComplaintRepository.instance.fetchConsigneeComplaint(prefs.getString('userzone'), prefs.getString('consigneecode'), context);
          data.then((value){
            if(value.isEmpty || value.length == 0){
              setConStatusState(ConsigneeComplaintDataState.Idle);
              IRUDMConstants().showSnack('Data not found.', context);
            }
            else if(value.isNotEmpty || value.length != 0){
              setConsigneelistData(value.toSet().toList());
              value.forEach((item) {
                if(item['intcode'].toString() == "-1"){
                  consignee = item['value'].toString();
                  consigneecode = item['intcode'].toString();
                }
                else{
                  if(item['intcode'].toString() == prefs.getString('consigneecode')){
                    consignee = item['intcode'].toString()+"-"+item['value'].toString();
                    consigneecode = item['intcode'].toString();
                  }
                }
              });
              setConStatusState(ConsigneeComplaintDataState.Finished);
            }
            else{
              setConStatusState(ConsigneeComplaintDataState.FinishedWithError);
            }
          });
        }
        else if(rly != "" && ccode == ""){
          Future<dynamic> data = WarrantyComplaintRepository.instance.fetchConsigneeComplaint(rly, prefs.getString('consigneecode'), context);
          data.then((value){
            if(value.isEmpty || value.length == 0){
              setConStatusState(ConsigneeComplaintDataState.Idle);
              IRUDMConstants().showSnack('Data not found.', context);
            }
            else if(value.isNotEmpty || value.length != 0) {
              setConStatusState(ConsigneeComplaintDataState.Finished);
              setConsigneelistData(value.toSet().toList());
              value.forEach((item){
                if(item['intcode'].toString() == "-1"){
                  consignee = item['value'].toString();
                  consigneecode = item['intcode'].toString();
                }
                else{
                  if(item['intcode'].toString() == prefs.getString('consigneecode')){
                    consignee = item['intcode'].toString()+"-"+item['value'].toString();
                    consigneecode = item['intcode'].toString();
                  }
                  else{
                    consignee = "All";
                    consigneecode = "-1";
                  }
                }
              });
            }
            else{
              setConStatusState(ConsigneeComplaintDataState.FinishedWithError);
            }
          });
        }
    }
    on Exception catch(err){
      setConStatusState(ConsigneeComplaintDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getConsigneeLodgeclaim(String? rly,String ccode, BuildContext context) async{
    setConlodgeStatusState(ConsigneeLodgeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _consigneelodgeitems.clear();
    try{
      if(rly == "" && ccode == ""){
        Future<dynamic> data = WarrantyComplaintRepository.instance.fetchConsigneeComplaint(prefs.getString('userzone'), prefs.getString('consigneecode'), context);
        data.then((value){
          if(value.isEmpty || value.length == 0){
            setConlodgeStatusState(ConsigneeLodgeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0){
            setConsigneelodgelistData(value.toSet().toList());
            value.forEach((item) {
              if(item['intcode'].toString() == "-1"){
                consigneelodge = item['value'].toString();
                consigneelodgecode = item['intcode'].toString();
              }
              else{
                if(item['intcode'].toString() == prefs.getString('consigneecode')){
                  consigneelodge = item['intcode'].toString()+"-"+item['value'].toString();
                  consigneelodgecode = item['intcode'].toString();
                }
              }
            });
            setConlodgeStatusState(ConsigneeLodgeDataState.Finished);
          }
          else{
            setConlodgeStatusState(ConsigneeLodgeDataState.FinishedWithError);
          }
        });
      }
      else if(rly != "" && ccode == ""){
        Future<dynamic> data = WarrantyComplaintRepository.instance.fetchConsigneeComplaint(rly, prefs.getString('consigneecode'), context);
        data.then((value){
          if(value.isEmpty || value.length == 0){
            setConlodgeStatusState(ConsigneeLodgeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0) {
            setConlodgeStatusState(ConsigneeLodgeDataState.Finished);
            setConsigneelodgelistData(value.toSet().toList());
            value.forEach((item){
              if(item['intcode'].toString() == "-1"){
                consigneelodge = item['value'].toString();
                consigneelodgecode = item['intcode'].toString();
              }
              else{
                if(item['intcode'].toString() == prefs.getString('consigneecode')){
                  consigneelodge = item['intcode'].toString()+"-"+item['value'].toString();
                  consigneelodgecode = item['intcode'].toString();
                }
                else{
                  consigneelodge = "All";
                  consigneelodgecode = "-1";
                }
              }
            });
          }
          else{
            setConlodgeStatusState(ConsigneeLodgeDataState.FinishedWithError);
          }
        });
      }
    }
    on Exception catch(err){
      setConlodgeStatusState(ConsigneeLodgeDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

}
