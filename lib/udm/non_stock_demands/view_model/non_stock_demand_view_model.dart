import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/awaiting_my_action_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/consignee_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/dashboard.dart';
import 'package:flutter_app/udm/non_stock_demands/models/forward_finalized_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/indentor.dart';
import 'package:flutter_app/udm/non_stock_demands/models/status_data.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_scroll_visibility_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/repo/non_stock_demand_repo.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum StatusDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeDataState {Idle, Busy, Finished, FinishedWithError}
enum FwdFinalizedDataState {Idle, Busy, NoData, Finished, FinishedWithError}
enum DashboardDataState {Idle, Busy, NoData, Finished, FinishedWithError}
enum IndentorState {Idle, Busy, NoData, Finished, FinishedWithError}
enum AwaitingDataState {Idle, Busy, NoData, Finished, FinishedWithError}


class NonStockDemandViewModel with ChangeNotifier{

  StatusDataState _statusDataState = StatusDataState.Idle;
  DashboardDataState _dashboardDataState = DashboardDataState.Idle;
  FwdFinalizedDataState _fwdFinalizedDataState = FwdFinalizedDataState.Idle;
  IndentorState _indentorState = IndentorState.Idle;
  AwaitingDataState _awaitingDataState = AwaitingDataState.Idle;
  ConsigneeDataState _consigneeDataState = ConsigneeDataState.Idle;

  List<DashBoardData> _dashboarditems = [];
  List<DashBoardData> _duplicatedashboarditems = [];

  List<FwdfndData> _fwdfinalizeditems = [];
  List<FwdfndData> _duplicatefwdfinalizeditems = [];

  List<AwaitingActionData> _awaitingactionitems = [];
  List<AwaitingActionData> _duplicateawaitingactionitems = [];

  List<ConsData> _consigneeitems = [];
  List<Status> _statusitems = [];

  List<IndentorData> _indentoritems = [];

  // --- Status Data ---
  List<Status> get statusitems => _statusitems;
  void setStatusData(List<Status> items){
    _statusitems = items;
  }
  StatusDataState get statusstate => _statusDataState;
  void setStatusState(StatusDataState currentState) {
    _statusDataState = currentState;
    notifyListeners();
  }


  // --- Consignee Data ---
  List<ConsData> get consigneeitems => _consigneeitems;

  void setConsigneeData(List<ConsData> items){
    _consigneeitems = items;
  }

  ConsigneeDataState get cosigneestate => _consigneeDataState;
  void setConsigneeState(ConsigneeDataState currentState) {
    _consigneeDataState = currentState;
    notifyListeners();
  }

  // --- Indentor Data ---
  List<IndentorData> get indentoritems => _indentoritems;

  void setIndentorData(List<IndentorData> items){
    _indentoritems = items;
  }

  IndentorState get indentorState => _indentorState;
  void setIndentorState(IndentorState currentState) {
    _indentorState = currentState;
    notifyListeners();
  }


  // --- DashBoard Data ---
  List<DashBoardData> get dashboarditems => _dashboarditems;
  void setDashboardData(List<DashBoardData> items){
     _dashboarditems = items;
  }

  DashboardDataState get dashboardstate => _dashboardDataState;
  void setDashboardState(DashboardDataState currentState) {
    _dashboardDataState = currentState;
    notifyListeners();
  }

  // --- Forward/Finalized Data ---
  List<FwdfndData> get fwdfinalizeditems => _fwdfinalizeditems;
  void setForwardfinalizedData(List<FwdfndData> items){
    _fwdfinalizeditems = items;
  }

  FwdFinalizedDataState get fwdfinalizedState => _fwdFinalizedDataState;
  void setFwdfinalizedState(FwdFinalizedDataState currentState) {
    _fwdFinalizedDataState = currentState;
    notifyListeners();
  }

  // --- Awaiting My Action Data ---
  List<AwaitingActionData> get awaitingactionitems => _awaitingactionitems;
  void setAwaitingData(List<AwaitingActionData> items){
    _awaitingactionitems = items;
  }

  AwaitingDataState get awaitingState => _awaitingDataState;
  void setAwaitingState(AwaitingDataState currentState) {
    _awaitingDataState = currentState;
    notifyListeners();
  }


  Future<void> getStatusData(BuildContext context) async{
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    setStatusState(StatusDataState.Busy);
    try{
      Future<List<Status>> data = nonStockDemandRepo.fetchStatusData();
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setStatusData(value);
          setStatusState(StatusDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setStatusData(value);
          setStatusState(StatusDataState.Finished);
        }
        else{
          setStatusState(StatusDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setStatusState(StatusDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getIndentor(String? userzone, String? dept, String? unitname, String? unittype, String? consignee, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    setIndentorState(IndentorState.Busy);
    try{
      Future<List<IndentorData>> data = nonStockDemandRepo.fetchIndentorData('Indentor_List', "$userzone~$dept~$unittype~$unitname~$consignee", prefs.getString('token'));
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setIndentorData(value);
          setIndentorState(IndentorState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setIndentorData(value);
          setIndentorState(IndentorState.Finished);
        }
        else{
          setIndentorState(IndentorState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setIndentorState(IndentorState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getConsigneeData(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    setConsigneeState(ConsigneeDataState.Busy);
    try{
      Future<List<ConsData>> data = nonStockDemandRepo.fetchConsigneeData('UDMAppList', 'Consignee', prefs.getString('userzone'), prefs.getString('token'));
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setConsigneeData(value);
          setConsigneeState(ConsigneeDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setConsigneeData(value);
          setConsigneeState(ConsigneeDataState.Finished);
        }
        else{
          setConsigneeState(ConsigneeDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setConsigneeState(ConsigneeDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDefaultDBData(String input_type, String fromdate, String todate, BuildContext context) async{
    Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setDashboardState(DashboardDataState.Busy);
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    try{
      Future<List<DashBoardData>> data = nonStockDemandRepo.fetchNonStockDemandDefaultDashboardData(input_type, prefs.getString('userid'), prefs.getString('deptid'), fromdate, todate, prefs.getString('token'), context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setDashboardState(DashboardDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          if(value.length > 3){
            Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(true);
            _dashboarditems.clear();
            _duplicatedashboarditems.clear();
            _duplicatedashboarditems.addAll(value);
            setDashboardData(value);
            setDashboardState(DashboardDataState.Finished);
          }
          else{
            _dashboarditems.clear();
            _duplicatedashboarditems.clear();
            _duplicatedashboarditems.addAll(value);
            setDashboardData(value);
            setDashboardState(DashboardDataState.Finished);
          }

        }
        else{
          setDashboardState(DashboardDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDashBoardData(String input_type, String statuscode, String demandno, String indentorcode, String consigneecode, String datefrom, String dateto, String itmdesc, BuildContext context) async{
    Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setDashboardState(DashboardDataState.Busy);
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    try{
      Future<List<DashBoardData>> data = nonStockDemandRepo.fetchNonStockDemandDashboardData(input_type, prefs.getString('userzone'), prefs.getString('deptid'), prefs.getString('adminunit'), statuscode, indentorcode, prefs.getString('userid'), demandno, datefrom, dateto, consigneecode, itmdesc, prefs.getString('token'), context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setDashboardState(DashboardDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          if(value.length > 3){
            Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(true);
            _dashboarditems.clear();
            _duplicatedashboarditems.clear();
            _duplicatedashboarditems.addAll(value);
            setDashboardData(value);
            setDashboardState(DashboardDataState.Finished);
          }
          else{
            _duplicatedashboarditems.clear();
            _duplicatedashboarditems.addAll(value);
            setDashboardData(value);
            setDashboardState(DashboardDataState.Finished);
          }

        }
        else{
          setDashboardState(DashboardDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getfwdfinalizedData(String input_type, String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fwdfinalizeditems.clear();
    setFwdfinalizedState(FwdFinalizedDataState.Busy);
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    try{
      Future<List<FwdfndData>> data = nonStockDemandRepo.fetchfwdfinalizedData(input_type, prefs.getString('userpostid'), fromdate, todate, prefs.getString('token'), context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setFwdfinalizedState(FwdFinalizedDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          if(value.length > 3){
            Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setFwdVisibilityValue(true);
            Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setfwdScrollValue(false);
            _duplicatefwdfinalizeditems = value;
            setForwardfinalizedData(value);
            setFwdfinalizedState(FwdFinalizedDataState.Finished);
          }
          else{
            _duplicatefwdfinalizeditems = value;
            setForwardfinalizedData(value);
            setFwdfinalizedState(FwdFinalizedDataState.Finished);
          }
        }
        else{
          setFwdfinalizedState(FwdFinalizedDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getAwaitingData(String input_type, String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    awaitingactionitems.clear();
    setAwaitingState(AwaitingDataState.Busy);
    NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
    try{
      Future<List<AwaitingActionData>> data = nonStockDemandRepo.fetchAwaitingData(input_type, "01", prefs.getString('userid'), prefs.getString('userpostid'), fromdate, todate, prefs.getString('token'), context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setAwaitingState(AwaitingDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          if(value.length > 3){
            Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitVisibilityValue(true);
            Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(false);
            _duplicateawaitingactionitems.addAll(value);
            setAwaitingData(value);
            setAwaitingState(AwaitingDataState.Finished);
          }
          else{
            _duplicateawaitingactionitems.addAll(value);
            setAwaitingData(value);
            setAwaitingState(AwaitingDataState.Finished);
          }

        }
        else{
          setAwaitingState(AwaitingDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //---Search Operation----

  void searchingDBData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
      try{
        Future<List<DashBoardData>> data = nonStockDemandRepo.fetchSearchDBData(_duplicatedashboarditems, query);
        data.then((value) {
          setDashboardData(value);
          setDashboardState(DashboardDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      //_dashboarditems.clear();
      setDashboardData(_duplicatedashboarditems);
      setDashboardState(DashboardDataState.Finished);
    }
    else{
      setDashboardData(_duplicatedashboarditems);
      setDashboardState(DashboardDataState.Finished);
    }
  }

  void searchingFwdfinalizedData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
      try{
        Future<List<FwdfndData>> data = nonStockDemandRepo.fetchSearchFwdFinalData(_duplicatefwdfinalizeditems, query);
        data.then((value) {
          //_fwdfinalizeditems.clear();
          setForwardfinalizedData(value);
          setFwdfinalizedState(FwdFinalizedDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      //_fwdfinalizeditems.clear();
      setForwardfinalizedData(_duplicatefwdfinalizeditems);
      setFwdfinalizedState(FwdFinalizedDataState.Finished);
    }
    else{
      setForwardfinalizedData(_duplicatefwdfinalizeditems);
      setFwdfinalizedState(FwdFinalizedDataState.Finished);
    }
  }

  void searchingAwaitingActionData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      NonStockDemandRepo nonStockDemandRepo = NonStockDemandRepo(context);
      try{
        Future<List<AwaitingActionData>> data = nonStockDemandRepo.fetchSearchawaitData(_duplicateawaitingactionitems, query);
        data.then((value) {
          //_awaitingactionitems.clear();
          setAwaitingData(value);
          setAwaitingState(AwaitingDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setAwaitingData(_duplicateawaitingactionitems);
      setAwaitingState(AwaitingDataState.Finished);
    }
    else{
      setAwaitingData(_duplicateawaitingactionitems);
      setAwaitingState(AwaitingDataState.Finished);
    }
  }


  checkdateDiff(String fromdate, String todate, DateFormat formatter, BuildContext context){

    //var dt1 = Jiffy(DateFormat('DD-MM-yyyy').parse(fromdate));
    //var dt2 = Jiffy(DateFormat('DD-MM-yyyy').parse(todate));


    //int years = int.parse("${dt2.diff(dt1, Units.YEAR)}");
    //dt1.add(years: years);

    // Parse the dates using DateTime
    DateTime dt1 = DateTime.parse(fromdate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(todate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;

    //int month = int.parse("${dt2.diff(dt1, Unit.month)}");
    if(days >= 210){
      //setMonth(CrcAwaitCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      //setMonth(CrcAwaitCheckMonthState.less);
    }
  }

}