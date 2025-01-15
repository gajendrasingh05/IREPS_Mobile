import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/stockingProposalData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/stockingProposallinkData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/stockproposalsummary_railwaylistdata.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/unifyingRailwayData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/unitInitiatingProposalData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/repo/stocking_proposal_summary_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StksmryrailwayDataState {Idle, Busy, Finished, FinishedWithError}
enum UnitinitproposalDataState {Idle, Busy, Finished, FinishedWithError}
enum UnifyingrlyDataState {Idle, Busy, Finished, FinishedWithError}
enum StksmrdepartmentDataState {Idle, Busy, Finished, FinishedWithError}
enum StoresdepotDataState {Idle, Busy, Finished, FinishedWithError}

enum StksmryDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum StksmryDatalinkState {Idle, Busy, Finished, NoData, FinishedWithError}

class StockingProposalSummaryProvider with ChangeNotifier{

  StksmryrailwayDataState _rlwDataState = StksmryrailwayDataState.Idle;
  UnitinitproposalDataState _unitinitproposalDataState = UnitinitproposalDataState.Idle;
  UnifyingrlyDataState _unifyingrlyDataState = UnifyingrlyDataState.Idle;
  StksmrdepartmentDataState _departmentDataState = StksmrdepartmentDataState.Idle;
  StoresdepotDataState _storesdepotDataState = StoresdepotDataState.Idle;

  StksmryDataState _stksmryDataState = StksmryDataState.Idle;
  StksmryDatalinkState _stksmryDatalinkState = StksmryDatalinkState.Idle;

  List<UnifyingrlyData> _unifyingrlyitems = [];
  List<UnitinitPrpData> _unitinitproposalitems = [];
  List<dynamic> _storesdepotitems = [];
  List<dynamic> _departmentitems = [];
  List<StockProposalSummryRlwData> railwaylistData = [];

  List<StkPrpData> _stkSummarylistData = [];
  List<StkPrpData> _duplicatestkSummarylistData = [];
  List<StkprplinkData> _stkSummarylinklistData = [];
  List<StkprplinkData> _duplicatestkSummarylinklistData = [];

  // Data Variables to assign initial value
  String department = "Select Department";
  String? deptcode;
  String railway = "Select Railway";
  String? rlyCode;
  String unitinitproposal = "Select Unit Initiating Proposal";
  String? unitinitproposalcode;
  String unifyingrly = "Select Unifying Railway";
  String? unifyingrlycode;
  String storesdepot = "Select Stores Depot";
  String? storesdepotcode;

  bool _stksummarysearchvalue = false;
  bool _stklinksearchvalue = false;

  int totalprposalinit = 0;
  int prpindrfdatege = 0;
  int prpother = 0;
  int prpstrdepot = 0;
  int prppcm = 0;
  int prpunifrly = 0;
  int prprejected = 0;
  int prpreturned = 0;
  int stcprpdrop = 0;
  int stkprpapp = 0;

  bool expand = false;

  bool get getstksumrySearchValue => _stksummarysearchvalue;

  bool get getstksmrylinksearchValue => _stklinksearchvalue;

  void setexpandtotal(bool expandvalue){
    expand = expandvalue;
    notifyListeners();
  }

  bool get expandvalue => expand;

  void updateScreen(bool useraction){
    _stksummarysearchvalue = useraction;
    notifyListeners();
  }

  void updatelinkScreen(bool useraction){
    _stklinksearchvalue = useraction;
    notifyListeners();
  }

  bool stkPrpUishowscroll = false;
  bool stkPrpUiscrollValue = false;

  bool stkPrplinkUishowscroll = false;
  bool stkPrplinkUiscrollValue = false;

  bool _showhidelinkmicglow = false;
  bool _showhidemicglow = false;
  bool _stkprpsummarylinktextchangelistener = false;
  bool _stkprpsummarytextchangelistener = false;

  //--- Stocking Proposal Summary UI
  bool get getStkPrpUiScrollValue => stkPrpUiscrollValue;
  void setStkPrpSummryScrollValue(bool value){
    stkPrpUiscrollValue = value;
    notifyListeners();
  }

  bool get getStkPrpSummryUiShowScroll => stkPrpUishowscroll;
  void setStkPrpSummryShowScroll(bool value){
    stkPrpUishowscroll = value;
    notifyListeners();
  }

  bool get getStkPrpSummrylinkUiScrollValue => stkPrplinkUiscrollValue;
  void setStkPrpSummrylinkScrollValue(bool value){
    stkPrplinkUiscrollValue = value;
    notifyListeners();
  }

  bool get getStkPrpSummrylinkUiShowScroll => stkPrplinkUishowscroll;
  void setStkPrpSummrylinkShowScroll(bool value){
    stkPrplinkUishowscroll = value;
    notifyListeners();
  }

  bool get getshowhidemicglow => _showhidemicglow;
  void showhidemicglow(bool useraction){
    _showhidemicglow = useraction;
    notifyListeners();
  }

  bool get getshowhidelinkmicglow => _showhidelinkmicglow;
  void showhidelinkmicglow(bool useraction){
    _showhidelinkmicglow = useraction;
    notifyListeners();
  }

  bool get getchangetextlistener => _stkprpsummarytextchangelistener;
  void updatetextchangeScreen(bool useraction){
    _stkprpsummarytextchangelistener = useraction;
    notifyListeners();
  }

  bool get getchangelinktextlistener => _stkprpsummarylinktextchangelistener;
  void updatelinktextchangeScreen(bool useraction){
    _stkprpsummarylinktextchangelistener = useraction;
    notifyListeners();
  }


  // --- Railway Data ---
  List<StockProposalSummryRlwData> get rlylistData => railwaylistData;
  void setrailwaylistData(List<StockProposalSummryRlwData> rlylist){
    railwaylistData = rlylist;
  }
  StksmryrailwayDataState get rlydatastatus => _rlwDataState;
  void setRlwStatusState(StksmryrailwayDataState currentState) {
    _rlwDataState = currentState;
    notifyListeners();
  }

  // --- Department Name Data ---
  List<dynamic> get departmentlistData => _departmentitems;
  void setdepartmentlistData(List<dynamic> departmentlist){
    _departmentitems = departmentlist;
  }
  StksmrdepartmentDataState get departmentdatastatus => _departmentDataState;
  void setDepartmentStatusState(StksmrdepartmentDataState currentState) {
    _departmentDataState = currentState;
    notifyListeners();
  }

  // --- Unit Initiating Proposal Data ---
  List<UnitinitPrpData> get unitinitproposalData => _unitinitproposalitems;
  void setunitinitproposalData(List<UnitinitPrpData> data){
    _unitinitproposalitems = data;
  }
  UnitinitproposalDataState get unitinitproposalState => _unitinitproposalDataState;
  void setUnitInitProposalState(UnitinitproposalDataState state){
    _unitinitproposalDataState = state;
    notifyListeners();
  }

  // --- Unifying Railway Data ---
  List<UnifyingrlyData> get unifyingrlylistData => _unifyingrlyitems;
  void setUnifyingrlylistData(List<UnifyingrlyData> conlist){
    _unifyingrlyitems = conlist;
  }
  UnifyingrlyDataState get unifyingdatastatus => _unifyingrlyDataState;
  void setUnifyingStatusState(UnifyingrlyDataState currentState) {
    _unifyingrlyDataState = currentState;
    notifyListeners();
  }

  // --- Stores Depot Data ----
  List<dynamic> get storeDepotData => _storesdepotitems;
  void setStoresDepotData(List<dynamic> data){
    _storesdepotitems = data;
  }
  StoresdepotDataState get storeDepotState => _storesdepotDataState;
  void setStoresDepotState(StoresdepotDataState state){
    _storesdepotDataState = state;
    notifyListeners();
  }

  //--- Stock Proposal Summary Data -----
  List<StkPrpData> get stkSummaryData => _stkSummarylistData;
  void setStkSummarylistData(List<StkPrpData> data){
     _stkSummarylistData = data;
  }

  StksmryDataState get stksmryDatastate => _stksmryDataState;
  void setStkSumryDataState(StksmryDataState state){
    _stksmryDataState = state;
    notifyListeners();
  }

  // --- Stock Proposal Summary Link Data -----
  List<StkprplinkData> get stksummarylinkData => _stkSummarylinklistData;
  void setStkSummarylinklistData(List<StkprplinkData> data){
    _stkSummarylinklistData = data;
  }
  StksmryDatalinkState get stksmryDatalinkstate => _stksmryDatalinkState;
  void setStkSumryDatalinkState(StksmryDatalinkState state){
    _stksmryDatalinkState = state;
    notifyListeners();
  }


  Future<void> getRailwaylistData(BuildContext context) async{
    setRlwStatusState(StksmryrailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Future<List<StockProposalSummryRlwData>> data = StockingProposalSummaryRepo.instance.fetchrailwaylistData(context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setRlwStatusState(StksmryrailwayDataState.Idle);
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
          setRlwStatusState(StksmryrailwayDataState.Finished);
        }
        else{
          setRlwStatusState(StksmryrailwayDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDepartment(String? rlyzone, BuildContext context) async{
    setDepartmentStatusState(StksmrdepartmentDataState.Busy);
    setUnitInitProposalState(UnitinitproposalDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _departmentitems.clear();
    _unitinitproposalitems.clear();
    try{
      if(rlyzone == ""){
        Future<dynamic> data = StockingProposalSummaryRepo.instance.def_depart_result(context);
        data.then((value) {
          if(value.isEmpty || value.length == 0){
            setDepartmentStatusState(StksmrdepartmentDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0){
            setdepartmentlistData(value);
            value.forEach((item) {
              if(item['intcode'].toString() == prefs.getString('orgsubunit')){
                department = item['value'].toString();
                deptcode = item['intcode'].toString();
              }
            });
            setDepartmentStatusState(StksmrdepartmentDataState.Finished);
          }
          else{
            setDepartmentStatusState(StksmrdepartmentDataState.FinishedWithError);
          }
        });
      }
      else{
        Future<dynamic> data = StockingProposalSummaryRepo.instance.def_depart_result(context);
        data.then((value) {
          if(value.isEmpty || value.length == 0){
            setDepartmentStatusState(StksmrdepartmentDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0){
            setdepartmentlistData(value);
            department = "All";
            deptcode = "-1";
            setDepartmentStatusState(StksmrdepartmentDataState.Finished);
          }
          else{
            setDepartmentStatusState(StksmrdepartmentDataState.FinishedWithError);
          }
        });
      }

    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getUnitInitiatingproposalData(String orgzone, String dept, BuildContext context) async{
    setUnitInitProposalState(UnitinitproposalDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _unitinitproposalitems.clear();
    try{
       if(orgzone == ""){
         Future<List<UnitinitPrpData>> data = StockingProposalSummaryRepo.instance.fetchunitinitprpData(prefs.getString('userzone'),  prefs.getString('orgsubunit'), context);
         data.then((value){
           if(value.isEmpty || value.length == 0){
             setUnitInitProposalState(UnitinitproposalDataState.Idle);
             IRUDMConstants().showSnack('Data not found.', context);
           }
           else if(value.isNotEmpty || value.length != 0){
             setunitinitproposalData(value);
             value.forEach((item) {
               if(item.intCode.toString() == prefs.getString('deptid')){
                 unitinitproposal = item.intCode.toString()+"-"+item.value.toString();
                 unitinitproposalcode = item.intCode.toString();
               }
             });
             setUnitInitProposalState(UnitinitproposalDataState.Finished);
           }
           else{
             setUnitInitProposalState(UnitinitproposalDataState.FinishedWithError);
           }
         });
       }
       else{
         Future<List<UnitinitPrpData>> data = StockingProposalSummaryRepo.instance.fetchunitinitprpData(orgzone, dept, context);
         data.then((value){
           if(value.isEmpty || value.length == 0){
             setUnitInitProposalState(UnitinitproposalDataState.Idle);
             IRUDMConstants().showSnack('Data not found.', context);
           }
           else if(value.isNotEmpty || value.length != 0){
             setunitinitproposalData(value);
             unitinitproposal = "All";
             unitinitproposalcode = "-1";
             value.forEach((item) {
               if(item.intCode.toString() == prefs.getString('userzone')){
                 unitinitproposal = item.value.toString();
                 unitinitproposalcode = item.intCode.toString();
               }
             });
             setUnitInitProposalState(UnitinitproposalDataState.Finished);
           }
           else{
             setUnitInitProposalState(UnitinitproposalDataState.FinishedWithError);
           }
         });
       }
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getUnifyingrlyData(BuildContext context) async{
     setUnifyingStatusState(UnifyingrlyDataState.Busy);
     SharedPreferences prefs = await SharedPreferences.getInstance();
     _unifyingrlyitems.clear();
     try{
       Future<List<UnifyingrlyData>> data = StockingProposalSummaryRepo.instance.fetchunifyingRlyData(context);
       data.then((value){
         if(value.isEmpty || value.length == 0){
           setUnifyingStatusState(UnifyingrlyDataState.Idle);
           IRUDMConstants().showSnack('Data not found.', context);
         }
         else if(value.isNotEmpty || value.length != 0){
           setUnifyingrlylistData(value);
           value.forEach((item) {
             if(item.intCode.toString() == prefs.getString('userzone')){
               unifyingrly = item.value.toString();
               unifyingrlycode = item.intCode.toString();
             }
             else{
               unifyingrly = "All";
               unifyingrlycode = "-1";
             }
           });
           setUnifyingStatusState(UnifyingrlyDataState.Finished);
         }
         else{
           setUnifyingStatusState(UnifyingrlyDataState.FinishedWithError);
         }
       });

     }
     on Exception catch(err){
       IRUDMConstants().showSnack(err.toString(), context);
     }
  }

  Future<void> getStoresDepotData(String orgzone, BuildContext context) async{
    setStoresDepotState(StoresdepotDataState.Busy);
    _storesdepotitems.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      if(orgzone == ""){
        Future<dynamic> data = StockingProposalSummaryRepo.instance.fetchStoreDepotData(prefs.getString('userzone'),  context);
        data.then((value){
          if(value.isEmpty || value.length == 0) {
            setStoresDepotState(StoresdepotDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0){
            storesdepot = "All";
            storesdepotcode = "-1";
            setStoresDepotData(value);
            setStoresDepotState(StoresdepotDataState.Finished);
          }
          else{
            setStoresDepotState(StoresdepotDataState.FinishedWithError);
          }
        });
      }
      else{
        Future<dynamic> data = StockingProposalSummaryRepo.instance.fetchStoreDepotData(orgzone, context);
        data.then((value){
        if(value.isEmpty || value.length == 0) {
          setStoresDepotState(StoresdepotDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          storesdepot = "All";
          storesdepotcode = "-1";
          setStoresDepotData(value);
          setStoresDepotState(StoresdepotDataState.Finished);
        }
        else{
          setStoresDepotState(StoresdepotDataState.FinishedWithError);
        }
      });
      }
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStkSummaryData(String? rly, String?  storesdepot, String unitinitproposal, String? department, String? unifyingrly,String? fromdate, String? todate, BuildContext context) async{
    setStkSumryDataState(StksmryDataState.Busy);
    _unifyingrlyitems.clear();
    totalprposalinit = 0;
    prpindrfdatege = 0;
    prpother = 0;
    prpstrdepot = 0;
    prppcm = 0;
    prpunifrly = 0;
    prprejected = 0;
    prpreturned = 0;
    stcprpdrop = 0;
    stkprpapp = 0;
    try{
      Future<List<StkPrpData>> data = StockingProposalSummaryRepo.instance.fetchStkproposallistData(rly!, storesdepot!, unitinitproposal, department!, unifyingrly!, fromdate!, todate!, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setStkSumryDataState(StksmryDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setStkSummarylistData(value);
          _duplicatestkSummarylistData = value;
          value.forEach((element) {
            totalprposalinit = totalprposalinit + int.parse(element.totalCount!);
            prpindrfdatege = prpindrfdatege + int.parse(element.proposalInDraftStage!);
            prpother = prpother + int.parse(element.proposalWithDeptts!);
            prpstrdepot = prpstrdepot + int.parse(element.proposalWithStoreDepo!);
            prppcm = prppcm + int.parse(element.proposalWithPcmm!);
            prpunifrly = prpunifrly + int.parse(element.proposalWithUnifying!);
            prprejected = prprejected + int.parse(element.proposalRejectedUnifying!);
            prpreturned = prpreturned + int.parse(element.proposalReturnedToInitiator!);
            stcprpdrop = stcprpdrop + int.parse(element.stokingProposalDroped!);
            stkprpapp = stkprpapp + int.parse(element.stokingProposalApproved!);
          });
          if(value.length > 2){setStkPrpSummryShowScroll(true);} else {setStkPrpSummryShowScroll(false);}
          setStkSumryDataState(StksmryDataState.Finished);
        }
        else{
          setStkSumryDataState(StksmryDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStkSummarylinkData(String? rly, String? department, String unitinitproposal, String? unifyingrly, String? storesdepot,String? fromdate, String? todate, String status, BuildContext context) async{
    setStkSumryDatalinkState(StksmryDatalinkState.Busy);
    _stkSummarylinklistData.clear();
    try{
      if(unifyingrly == null || unifyingrly == "null"){
        Future<List<StkprplinkData>> data = StockingProposalSummaryRepo.instance.fetchStkproposallinklistData(rly!, department!, "null", unitinitproposal, storesdepot!, fromdate!, todate!, status, context);
        data.then((value){
          if(value.isEmpty || value.length == 0){
            setStkSumryDatalinkState(StksmryDatalinkState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0){
            setStkSummarylinklistData(value);
            _duplicatestkSummarylinklistData = value;
            if(value.length > 2){setStkPrpSummrylinkShowScroll(true);} else {setStkPrpSummrylinkShowScroll(false);}
            setStkSumryDatalinkState(StksmryDatalinkState.Finished);
          }
          else{
            setStkSumryDatalinkState(StksmryDatalinkState.FinishedWithError);
          }
        });
      }
      else{
        Future<List<StkprplinkData>> data = StockingProposalSummaryRepo.instance.fetchStkproposallinklistData(rly!, department!, unifyingrly, unitinitproposal, storesdepot!, fromdate!, todate!, status, context);
        data.then((value){
          if(value.isEmpty || value.length == 0){
            setStkSumryDatalinkState(StksmryDatalinkState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0){
            setStkSummarylinklistData(value);
            _duplicatestkSummarylinklistData = value;
            if(value.length > 2){setStkPrpSummrylinkShowScroll(true);} else {setStkPrpSummrylinkShowScroll(false);}
            setStkSumryDatalinkState(StksmryDatalinkState.Finished);
          }
          else{
            setStkSumryDatalinkState(StksmryDatalinkState.FinishedWithError);
          }
        });
      }
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getSearchStkSummaryData(String? query, BuildContext context) {
    if(query!.isNotEmpty && query.length > 0) {
      try{
        Future<List<StkPrpData>> data = StockingProposalSummaryRepo.instance.fetchSearchStkproposallistData(_duplicatestkSummarylistData, query);
        data.then((value) {
          setStkSummarylistData(value.toSet().toList());
          if(value.length > 2){setStkPrpSummryShowScroll(true);} else {setStkPrpSummryShowScroll(false);}
          setStkSumryDataState(StksmryDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setStkSummarylistData(_duplicatestkSummarylistData);
      if(_duplicatestkSummarylistData.length > 2){setStkPrpSummryShowScroll(true);} else {setStkPrpSummryShowScroll(false);}
      setStkSumryDataState(StksmryDataState.Finished);
    }
    else{
      setStkSummarylistData(_duplicatestkSummarylistData);
      if(_duplicatestkSummarylistData.length > 2){setStkPrpSummryShowScroll(true);} else {setStkPrpSummryShowScroll(false);}
      setStkSumryDataState(StksmryDataState.Finished);
    }
  }

  void getSearchStkSummarylinkData(String? query, BuildContext context) {
    if(query!.isNotEmpty && query.length > 0) {
      try{
        Future<List<StkprplinkData>> data = StockingProposalSummaryRepo.instance.fetchSearchStkproposallinklistData(_duplicatestkSummarylinklistData, query);
        data.then((value) {
          setStkSummarylinklistData(value.toSet().toList());
          if(value.length > 2){setStkPrpSummrylinkShowScroll(true);} else {setStkPrpSummrylinkShowScroll(false);}
          setStkSumryDatalinkState(StksmryDatalinkState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setStkSummarylinklistData(_duplicatestkSummarylinklistData);
      if(_duplicatestkSummarylinklistData.length > 2){setStkPrpSummrylinkShowScroll(true);} else {setStkPrpSummrylinkShowScroll(false);}
      setStkSumryDatalinkState(StksmryDatalinkState.Finished);
    }
    else{
      setStkSummarylinklistData(_duplicatestkSummarylinklistData);
      if(_duplicatestkSummarylinklistData.length > 2){setStkPrpSummrylinkShowScroll(true);} else {setStkPrpSummrylinkShowScroll(false);}
      setStkSumryDatalinkState(StksmryDatalinkState.Finished);
    }
  }
}