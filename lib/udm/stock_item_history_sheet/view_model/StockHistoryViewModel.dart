import 'package:flutter/material.dart';
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
import 'package:flutter_app/udm/stock_item_history_sheet/repo/StockHistoryRepository.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum StockHistoryViewModelDataState {Idle, Busy, Finished, FinishedWithError}
enum StockSelHistoryViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData, ClearData}
enum StockHistorylistViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for item detail
enum StockHistoryItemlistViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for consumption detail
enum StockSelHistoryConsumptionViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for available detail
enum StockSelHistoryAvailableViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for uncovered detail
enum StockSelHistoryUncoveredViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for intent detail
enum StockSelHistoryIntentViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}


// enum for railway board intent coverage detail
enum StockSelHistoryRlyBoardIntentViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for covered due detail
enum StockSelHistoryCoveredDueViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for accountal detail
enum StockSelAccountalViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for material rejected detail
enum StockSelMaterialrejViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for order placed detail
enum StockSelHistoryOrderdPlacedViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}

// enum for overstock surplus detail
enum StockSelHistoryOverStockViewModelDataState {Idle, Busy, Finished, FinishedWithError, NoData}


class StockHistoryViewModel with ChangeNotifier{

  StockHistoryViewModelDataState _state = StockHistoryViewModelDataState.Idle;

  StockHistorylistViewModelDataState _hisstate = StockHistorylistViewModelDataState.Idle;

  StockSelHistoryViewModelDataState _selhisstate = StockSelHistoryViewModelDataState.Idle;

  // Item Detail Progress
  StockHistoryItemlistViewModelDataState _selItemhisstate = StockHistoryItemlistViewModelDataState.Idle;

  // Consumption Detail Progress
  StockSelHistoryConsumptionViewModelDataState _selConsumptionhisstate = StockSelHistoryConsumptionViewModelDataState.Idle;

  // Available Detail Progress
  StockSelHistoryAvailableViewModelDataState _selAvailablehisstate = StockSelHistoryAvailableViewModelDataState.Idle;

  // Uncovered Detail Progress
  StockSelHistoryUncoveredViewModelDataState _selUnCoveredhisstate = StockSelHistoryUncoveredViewModelDataState.Idle;

  // Intent Detail Progress
  StockSelHistoryIntentViewModelDataState _selintenthisstate = StockSelHistoryIntentViewModelDataState.Idle;

  // Railway Board Intent Coverage Detail progress
  StockSelHistoryRlyBoardIntentViewModelDataState _selRlyBoardIntenthisstate = StockSelHistoryRlyBoardIntentViewModelDataState.Idle;

  // Covered Due Detail progress
  StockSelHistoryCoveredDueViewModelDataState _selCoveredDuehisstate = StockSelHistoryCoveredDueViewModelDataState.Idle;

  // Accountal Detail progress
  StockSelAccountalViewModelDataState _selAccountalhisstate = StockSelAccountalViewModelDataState.Idle;

  // Material Rejected Detail progress
  StockSelMaterialrejViewModelDataState _selmatrejhisstate = StockSelMaterialrejViewModelDataState.Idle;

  // Ordered placed last 5 Years Progress
  StockSelHistoryOrderdPlacedViewModelDataState _selOrderplacedhisstate = StockSelHistoryOrderdPlacedViewModelDataState.Idle;

  // Overstock surplus Progress
  StockSelHistoryOverStockViewModelDataState _seloverstockhisstate = StockSelHistoryOverStockViewModelDataState.Idle;

  Error? _error;

  List<RlwData> railwaylistData = [];
  List<HisListData> hislistData = [];

  List<ItemDetailData> itemdetailData = [];

  List<ConsumptionDetailData> consumptiondetailData = [];
  List<AvailableStockData> availablestockData = [];
  List<UncoverDueData> uncoveredData = [];
  List<IntentData> intentData = [];
  List<RlyIntentCoverageData> rlyintentData = [];
  List<CoveredDueData> coveredDueData = [];
  List<UnderAccountalData> underaccountalData = [];
  List<MaterialRejectedData> materialRejData = [];
  List<OrderPlacedData> orderplaceData = [];
  List<OverStockData> overstockData = [];

  List _items = [];
  List<HisListData> _duplicateitems = [];

  String railway = "--Select Railway--";
  String? rlyCode;

  //Total Consumption Data

  double totyr1920 = 0;
  double totyr2021 = 0;
  double totyr2122 = 0;
  double totyr2223 = 0;
  double accncpvalue = 0;
  double stockvalue = 0;
  double monthvalue = 0;

  List<HisListData> get stockhistorydatalist {
    return hislistData;
  }

  void setHisData(List<HisListData> his){
    hislistData = his;
  }


  List<RlwData> get rlylistData{
    return railwaylistData;
  }

  void setrailwaylistData(List<RlwData> rlylist){
    railwaylistData = rlylist;
  }

  StockHistoryViewModelDataState get state {
    return _state;
  }

  void setState(StockHistoryViewModelDataState currentState) {
    _state = currentState;
    notifyListeners();
  }

  StockHistorylistViewModelDataState get hisstate {
    return _hisstate;
  }

  void setHisState(StockHistorylistViewModelDataState currentState){
    _hisstate = currentState;
    notifyListeners();
  }

  // Global Progress
  StockSelHistoryViewModelDataState get selhisstate {
    return _selhisstate;
  }

  void setSelHisState(StockSelHistoryViewModelDataState currentState){
    _selhisstate = currentState;
    notifyListeners();
  }


  // Set Item Detail State
  StockHistoryItemlistViewModelDataState get selItemhisstate {
    return _selItemhisstate;
  }

  void setSelItemHisState(StockHistoryItemlistViewModelDataState currentState){
    _selItemhisstate = currentState;
    notifyListeners();
  }

  // Set Consumption Detail State
  StockSelHistoryConsumptionViewModelDataState get selConsumptionhisstate {
    return _selConsumptionhisstate;
  }

  void setSelConsumptionHisState(StockSelHistoryConsumptionViewModelDataState currentState){
    _selConsumptionhisstate = currentState;
    notifyListeners();
  }

  // Set Available Detail State
  StockSelHistoryAvailableViewModelDataState get selAvailablehisstate {
    return _selAvailablehisstate;
  }

  void setSelAvailableHisState(StockSelHistoryAvailableViewModelDataState currentState){
    _selAvailablehisstate = currentState;
    notifyListeners();
  }

  // Set UnCovered Detail State
  StockSelHistoryUncoveredViewModelDataState get selUncoveredhisstate {
    return _selUnCoveredhisstate;
  }

  void setSelUncoveredHisState(StockSelHistoryUncoveredViewModelDataState currentState){
    _selUnCoveredhisstate = currentState;
    notifyListeners();
  }

  // Set Intent Detail State
  StockSelHistoryIntentViewModelDataState get selIntenthisstate {
    return _selintenthisstate;
  }

  void setSelIntentHisState(StockSelHistoryIntentViewModelDataState currentState){
    _selintenthisstate = currentState;
    notifyListeners();
  }

  // Set Rly Board Intent Detail State
  StockSelHistoryRlyBoardIntentViewModelDataState get selRlyBoardIntenthisstate {
    return _selRlyBoardIntenthisstate;
  }

  void setSelRlyBoardIntentHisState(StockSelHistoryRlyBoardIntentViewModelDataState currentState){
    _selRlyBoardIntenthisstate = currentState;
    notifyListeners();
  }

  // Set Covered Due Detail State
  StockSelHistoryCoveredDueViewModelDataState get selCoveredDuehisstate {
    return _selCoveredDuehisstate;
  }

  void setSelCoveredDueHisState(StockSelHistoryCoveredDueViewModelDataState currentState){
    _selCoveredDuehisstate = currentState;
    notifyListeners();
  }

  // Set Accountal State
  StockSelAccountalViewModelDataState get selAccountalhisstate {
    return _selAccountalhisstate;
  }

  void setSelAccountalHisState(StockSelAccountalViewModelDataState currentState){
    _selAccountalhisstate = currentState;
    notifyListeners();
  }

  // Set Material Rejected State
  StockSelMaterialrejViewModelDataState get selMatrejhisstate {
    return _selmatrejhisstate;
  }

  void setSelMatRejHisState(StockSelMaterialrejViewModelDataState currentState){
    _selmatrejhisstate = currentState;
    notifyListeners();
  }

  // Set Order placed Detail State
  StockSelHistoryOrderdPlacedViewModelDataState get selOrderPlacedhisstate {
    return _selOrderplacedhisstate;
  }

  void setSelOrderPlacedHisState(StockSelHistoryOrderdPlacedViewModelDataState currentState){
    _selOrderplacedhisstate = currentState;
    notifyListeners();
  }

  // Set Over Stock Detail State
  StockSelHistoryOverStockViewModelDataState get selOverStockhisstate {
    return _seloverstockhisstate;
  }

  void setSelOverStockHisState(StockSelHistoryOverStockViewModelDataState currentState){
    _seloverstockhisstate = currentState;
    notifyListeners();
  }


  void setitemdetaillistData(List<ItemDetailData> itemlist){
    itemdetailData = itemlist;

  }

  void setconsumptiondetaillistData(List<ConsumptionDetailData> consumptionlist){
    consumptiondetailData = consumptionlist;
    totyr1920 = 0;
    totyr2021 = 0;
    totyr2122 = 0;
    totyr2223 = 0;
    stockvalue = 0;
    accncpvalue = 0;
    monthvalue = 0;
    consumptiondetailData.forEach((element) {
        totyr1920 = totyr1920 + double.parse(element.issueYr3!);
        totyr2021 = totyr2021 + double.parse(element.issueYr2!);
        totyr2122 = totyr2122 + double.parse(element.issueYr1!);
        totyr2223 = totyr2223 + double.parse(element.issueYr0!);
        stockvalue = stockvalue + double.parse(element.stock!);
        if(element.month1 != null){
          monthvalue = monthvalue + double.parse(element.month1!);
        }
        if(element.cat.toString() == "10"){
          accncpvalue = accncpvalue + double.parse(element.aac!);
        }
    });
    monthvalue = stockvalue/accncpvalue*12;
  }

  void setavailableStocklistData(List<AvailableStockData> availableStock){
    availablestockData = availableStock;
  }

  void setuncoveredStocklistData(List<UncoverDueData> uncoveredStock){
    uncoveredData = uncoveredStock;
  }

  void setintentStocklistData(List<IntentData> intentStock){
    intentData = intentStock;
  }

  void setRlyCoverageIntentData(List<RlyIntentCoverageData> rlyIntentData){
    rlyintentData = rlyIntentData;
  }

  void setCoveredDueData(List<CoveredDueData> coveredDuedata){
    coveredDueData = coveredDuedata;
  }

  void setUnderAccountalData(List<UnderAccountalData> underaccdata){
    underaccountalData = underaccdata;
  }

  void setMatRejData(List<MaterialRejectedData> matrejdata){
    materialRejData = matrejdata;
  }

  void setOrderPlaceData(List<OrderPlacedData> orderplacedata){
    orderplaceData = orderplacedata;
  }

  void setOverStockData(List<OverStockData> overstockdata){
    overstockData = overstockdata;
  }


  void getRailwaylistData(BuildContext context) async{
    setState(StockHistoryViewModelDataState.Busy);
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Future<List<RlwData>> data = stockHistoryRepository.fetchrailwaylistData(context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(StockHistoryViewModelDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setrailwaylistData(value);
          value.forEach((item) {
            if(item.intcode.toString() == prefs.getString('userzone')) {
              railway = item.value.toString();
              rlyCode = item.intcode.toString();
            }
          });
          setState(StockHistoryViewModelDataState.Finished);
        }
        else{
          setState(StockHistoryViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getStockhistorylistData(String railcode, String plvalue, BuildContext context) async{
    hislistData.clear();
    _duplicateitems.clear();
    setHisData(hislistData);
    setHisState(StockHistorylistViewModelDataState.Busy);
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<HisListData>> data = stockHistoryRepository.fetchhistorylist(railcode, plvalue, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setHisData(value);
          setHisState(StockHistorylistViewModelDataState.FinishedWithError);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _duplicateitems.addAll(value);
          setHisData(value);
          setHisState(StockHistorylistViewModelDataState.Finished);
        }
        else{
          setHisState(StockHistorylistViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setHisState(StockHistorylistViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  // Selection Method process

  Future<void> getStockSelectItemData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    //setSelHisState(StockSelHistoryViewModelDataState.Idle);
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<ItemDetailData>> data = stockHistoryRepository.fetchselItemhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setSelItemHisState(StockHistoryItemlistViewModelDataState.NoData);
          setitemdetaillistData(value);

        }
        else if(value.isNotEmpty || value.length != 0){
          print("Item Detail length ${value.length}");
          setSelItemHisState(StockHistoryItemlistViewModelDataState.Finished);
          setitemdetaillistData(value);
          return;
        }
        else{
          setSelItemHisState(StockHistoryItemlistViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelItemHisState(StockHistoryItemlistViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectConsumptionData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<ConsumptionDetailData>> data = stockHistoryRepository.fetchselConsumptionhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Consumption length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setconsumptiondetaillistData(value);
          setSelConsumptionHisState(StockSelHistoryConsumptionViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setconsumptiondetaillistData(value);
          setSelConsumptionHisState(StockSelHistoryConsumptionViewModelDataState.Finished);
        }
        else{
          setSelConsumptionHisState(StockSelHistoryConsumptionViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelConsumptionHisState(StockSelHistoryConsumptionViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectAvailableStockData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<AvailableStockData>> data = stockHistoryRepository.fetchselAvailableStockhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Available length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setavailableStocklistData(value);
          setSelAvailableHisState(StockSelHistoryAvailableViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setavailableStocklistData(value);
          setSelAvailableHisState(StockSelHistoryAvailableViewModelDataState.Finished);
        }
        else{
          setSelAvailableHisState(StockSelHistoryAvailableViewModelDataState.Finished);
        }
      });
    }
    on Exception catch(err){
      setSelAvailableHisState(StockSelHistoryAvailableViewModelDataState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectUnCoveredStockData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<UncoverDueData>> data = stockHistoryRepository.fetchselUncoveredStockhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Uncovered length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setuncoveredStocklistData(value);
          setSelUncoveredHisState(StockSelHistoryUncoveredViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setuncoveredStocklistData(value);
          setSelUncoveredHisState(StockSelHistoryUncoveredViewModelDataState.Finished);
        }
        else{
          setSelUncoveredHisState(StockSelHistoryUncoveredViewModelDataState.Finished);
        }
      });
    }
    on Exception catch(err){
      setSelUncoveredHisState(StockSelHistoryUncoveredViewModelDataState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectIntentStockData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<IntentData>> data = stockHistoryRepository.fetchselIntentStockhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Intent length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setintentStocklistData(value);
          setSelIntentHisState(StockSelHistoryIntentViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setintentStocklistData(value);
          setSelIntentHisState(StockSelHistoryIntentViewModelDataState.Finished);
        }
        else{
          setSelIntentHisState(StockSelHistoryIntentViewModelDataState.Finished);
        }
      });
    }
    on Exception catch(err){
      setSelIntentHisState(StockSelHistoryIntentViewModelDataState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectRlyCoverageIntentData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<RlyIntentCoverageData>> data = stockHistoryRepository.fetchselRlyIntentCoveragehistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Rly Coverage ${value.length}");
        if(value.isEmpty || value.length == 0){
          setRlyCoverageIntentData(value);
          setSelRlyBoardIntentHisState(StockSelHistoryRlyBoardIntentViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setRlyCoverageIntentData(value);
          setSelRlyBoardIntentHisState(StockSelHistoryRlyBoardIntentViewModelDataState.Finished);
        }
        else{
          setSelRlyBoardIntentHisState(StockSelHistoryRlyBoardIntentViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelRlyBoardIntentHisState(StockSelHistoryRlyBoardIntentViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectCoveredDueData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<CoveredDueData>> data = stockHistoryRepository.fetchselCoveredDuehistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Covered due length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setCoveredDueData(value);
          setSelCoveredDueHisState(StockSelHistoryCoveredDueViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setCoveredDueData(value);
          setSelCoveredDueHisState(StockSelHistoryCoveredDueViewModelDataState.Finished);
        }
        else{
          setSelCoveredDueHisState(StockSelHistoryCoveredDueViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelCoveredDueHisState(StockSelHistoryCoveredDueViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectUnderAccData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<UnderAccountalData>> data = stockHistoryRepository.fetchselUnderAcchistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("under Acc ${value.length}");
        if(value.isEmpty || value.length == 0){
          setUnderAccountalData(value);
          setSelAccountalHisState(StockSelAccountalViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setUnderAccountalData(value);
          setSelAccountalHisState(StockSelAccountalViewModelDataState.Finished);
        }
        else{
          setSelAccountalHisState(StockSelAccountalViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelAccountalHisState(StockSelAccountalViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectMaterialRejData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<MaterialRejectedData>> data = stockHistoryRepository.fetchselMatRejhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Material Rejected length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setMatRejData(value);
          setSelMatRejHisState(StockSelMaterialrejViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setMatRejData(value);
          setSelMatRejHisState(StockSelMaterialrejViewModelDataState.Finished);
        }
        else{
          setSelMatRejHisState(StockSelMaterialrejViewModelDataState.Finished);
        }
      });
    }
    on Exception catch(err){
      setSelMatRejHisState(StockSelMaterialrejViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectOrderPlacedData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    setSelHisState(StockSelHistoryViewModelDataState.Finished);
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<OrderPlacedData>> data = stockHistoryRepository.fetchselOrderPlacehistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("Order Place length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setOrderPlaceData(value);
          setSelOrderPlacedHisState(StockSelHistoryOrderdPlacedViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setOrderPlaceData(value);
          setSelOrderPlacedHisState(StockSelHistoryOrderdPlacedViewModelDataState.Finished);
        }
        else{
          setSelOrderPlacedHisState(StockSelHistoryOrderdPlacedViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelOrderPlacedHisState(StockSelHistoryOrderdPlacedViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getStockSelectOverStockData(String railcode, String plvalue, String inputtype, BuildContext context) async{
    setSelHisState(StockSelHistoryViewModelDataState.Finished);
    StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
    try{
      Future<List<OverStockData>> data = stockHistoryRepository.fetchselOverStockhistorylist(railcode, plvalue, inputtype, context);
      data.then((value){
        print("over stock length ${value.length}");
        if(value.isEmpty || value.length == 0){
          setOverStockData(value);
          setSelOverStockHisState(StockSelHistoryOverStockViewModelDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setOverStockData(value);
          setSelOverStockHisState(StockSelHistoryOverStockViewModelDataState.Finished);
        }
        else{
          setSelOverStockHisState(StockSelHistoryOverStockViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setSelOverStockHisState(StockSelHistoryOverStockViewModelDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }


  // other operation process

  void clearAllData(BuildContext context) async{
    setHisState(StockHistorylistViewModelDataState.Busy);
    Future.delayed(const Duration(seconds: 1), () {
      hislistData.clear();
      _duplicateitems.clear();
      setHisData(hislistData);
      setHisState(StockHistorylistViewModelDataState.NoData);
      FocusManager.instance.primaryFocus?.unfocus();
      UdmUtilities.showInSnackBar(context, "Data cleared successfully.");
    });
  }

  void clearSelAllData(BuildContext context) async{
    Future.delayed(const Duration(milliseconds: 200), () {
      setSelHisState(StockSelHistoryViewModelDataState.ClearData);
      FocusManager.instance.primaryFocus?.unfocus();
      UdmUtilities.showInSnackBar(context, "Data cleared successfully.");
    });
  }

  void loadData(BuildContext context) async{
    Future.delayed(const Duration(milliseconds: 200), () {
      setSelHisState(StockSelHistoryViewModelDataState.Finished);
      FocusManager.instance.primaryFocus?.unfocus();
      UdmUtilities.showInSnackBar(context, "Data loaded successfully.");
    });
  }

  Future<void> clearOnBack(BuildContext context) async{
    Future.delayed(const Duration(milliseconds: 200), () {
      setHisState(StockHistorylistViewModelDataState.Idle);
      hislistData.clear();
      _duplicateitems.clear();
    });
  }

  void searchingHisData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      StockHistoryRepository stockHistoryRepository = StockHistoryRepository(context);
      try{
        Future<List<HisListData>> data = stockHistoryRepository.fetchSearchHisData(_duplicateitems, query);
        data.then((value) {
          setHisData(value);
          setHisState(StockHistorylistViewModelDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setHisData(_duplicateitems);
      setHisState(StockHistorylistViewModelDataState.Finished);
    }
    else{
      setHisData(_duplicateitems);
      setHisState(StockHistorylistViewModelDataState.Finished);
    }
  }

  void getmyrlylistData() async{}

  void getAllrlylistData() async{}
}