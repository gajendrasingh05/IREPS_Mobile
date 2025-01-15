import 'package:flutter/material.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/model/gem_bill_details.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import '../model/Buyer_details.dart';
import '../model/consignee_Details.dart';
import '../model/covering_po_details.dart';
import '../model/deduction_details.dart';
import '../model/gem_accountal_details.dart';
import '../model/gem_order_details.dart';
import '../repo/gem_repository.dart';


enum BuyerDetailsDataState {Idle, Busy, Finished, FinishedWithError, NoData, ClearData}

enum ConsigneeDeatilsDataState {Idle, Busy, Finished, FinishedWithError, NoData, ClearData}

enum CoveringPoDeatilsDataState {Idle, Busy, Finished, FinishedWithError, NoData}

enum DeductionDetailsDataState {Idle, Busy, Finished, FinishedWithError, NoData}

enum GemAccountailsDetailsDataState {Idle, Busy, Finished, FinishedWithError, NoData}

enum GemOderderDeatilsDataState {Idle, Busy, Finished, FinishedWithError, NoData}

enum GemBillDeatilsDataState {Idle, Busy, Finished, FinishedWithError, NoData}


class GemOrderViewModel with ChangeNotifier{

  BuyerDetailsDataState _buyerstate = BuyerDetailsDataState.Idle;

  ConsigneeDeatilsDataState _consigneestate = ConsigneeDeatilsDataState.Idle;

  CoveringPoDeatilsDataState _coveringstate = CoveringPoDeatilsDataState.Idle;

  DeductionDetailsDataState _deductionstate = DeductionDetailsDataState.Idle;

  GemAccountailsDetailsDataState _gemAccountalstate = GemAccountailsDetailsDataState.Idle;

  GemOderderDeatilsDataState _gemOrderstate = GemOderderDeatilsDataState.Idle;

  GemBillDeatilsDataState _gemBillstate = GemBillDeatilsDataState.Idle;

  Error? _error;

  List<BuyerDetailsData> buyerDetailsData = [];
  List<ConsigneeDetailsData> consigneeDetailsData = [];
  List<CoveringPODetailsData> coveringPODetailsData = [];
  List<DeductionDetailsData> deductionDetailsData = [];
  List<GemAccountalDetailsData> gemAccountalDetailsData = [];
  List<GemOrderDetailsData> gemOrderDetailsData = [];
  List<GemBillDetailsData> gemBillDeatilsData = [];

  List _items = [];
  List<BuyerDetailsData> _duplicateitems = [];

  String co6number = 'value.gemBillDeatilsData[index].co6number.toString()';
  String pokey = 'value.gemOrderDeatilsData[index].pokey.tostring()';

  /*List<BuyerDetailsData> get stockhistorydatalist {
    return buyerDetailsData;
  }

  void setBuyerDetailsData(List<BuyerDetailsData> his){
    buyerDetailsData = his;
  }*/


  BuyerDetailsDataState get buyerstate {
    return _buyerstate;
  }

  void setBuyerState(BuyerDetailsDataState currentState) {
    _buyerstate = currentState;
    notifyListeners();
  }

  ConsigneeDeatilsDataState get consigneestate {
    return _consigneestate;
  }

  void setConsigneeDataState(ConsigneeDeatilsDataState currentState){
    _consigneestate = currentState;
    notifyListeners();
  }

  CoveringPoDeatilsDataState get coveringstate {
    return _coveringstate;
  }

  void setCoveringState(CoveringPoDeatilsDataState currentState){
    _coveringstate = currentState;
    notifyListeners();
  }

  DeductionDetailsDataState get deductionstate {
    return _deductionstate;
  }

  void setDeductionState(DeductionDetailsDataState currentState){
    _deductionstate = currentState;
    notifyListeners();
  }

  GemAccountailsDetailsDataState get gemAccountalstate {
    return _gemAccountalstate;
  }

  void setGemAccountailState(GemAccountailsDetailsDataState currentState){
    _gemAccountalstate = currentState;
    notifyListeners();
  }

  GemOderderDeatilsDataState get gemOrderstate {
    return _gemOrderstate;
  }

  void setGemOerderState(GemOderderDeatilsDataState currentState){
    _gemOrderstate = currentState;
    notifyListeners();
  }

  GemBillDeatilsDataState get gemBillstate {
    return _gemBillstate;
  }

  void setGemBillState(GemBillDeatilsDataState currentState){
    _gemBillstate = currentState;
    notifyListeners();
  }


  void setbuyerdetailslistlistData(List<BuyerDetailsData> buyerdetailslist){
    buyerDetailsData = buyerdetailslist;
  }

  void setconsigneeDetailslistData(List<ConsigneeDetailsData> consigneeDetailslist){
    consigneeDetailsData = consigneeDetailslist;
  }

  void setcoveringPODetailslist(List<CoveringPODetailsData> coveringPODetailslist){
    coveringPODetailsData = coveringPODetailslist;
  }

  void setdeductionDetailslist(List<DeductionDetailsData> deductionDetailslist){
    deductionDetailsData = deductionDetailslist;
  }

  void setgemAccountalDetailslist(List<GemAccountalDetailsData> gemAccountalDetailslist){
    gemAccountalDetailsData = gemAccountalDetailslist;
  }

  void setgemOrderDetailslist(List<GemOrderDetailsData> gemOrderDetailslist){
    gemOrderDetailsData = gemOrderDetailslist;
  }

  void setgemBillDetailslist(List<GemBillDetailsData> gemBillDetailslist){
    gemBillDeatilsData = gemBillDetailslist;
  }


  void getBuyerDetailsData(String orderID, BuildContext context) async{
    buyerDetailsData.clear();
    _duplicateitems.clear();
    setbuyerdetailslistlistData(buyerDetailsData);
    setBuyerState(BuyerDetailsDataState.Busy);
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<BuyerDetailsData>> data = gemOrderRepository.fetchBuyerDetailsDatalist(orderID, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setbuyerdetailslistlistData(value);
          setBuyerState(BuyerDetailsDataState.FinishedWithError);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          print("Buyer details length ${value.length}");
          _duplicateitems.addAll(value);
          setbuyerdetailslistlistData(value);
          setBuyerState(BuyerDetailsDataState.Finished);
        }
        else{
          setBuyerState(BuyerDetailsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setBuyerState(BuyerDetailsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }


  Future<void> getConsigneeDetailsData(String orderID, BuildContext context) async{
    //setSelHisState(StockSelHistoryViewModelDataState.Idle);
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<ConsigneeDetailsData>> data = gemOrderRepository.fetchConsigneeDetailsDatalist(orderID, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setConsigneeDataState(ConsigneeDeatilsDataState.NoData);
          setconsigneeDetailslistData(value);

        }
        else if(value.isNotEmpty || value.length != 0){
          print("Consignee details length ${value.length}");
          setConsigneeDataState(ConsigneeDeatilsDataState.Finished);
          setconsigneeDetailslistData(value);
          return;
        }
        else{
          setConsigneeDataState(ConsigneeDeatilsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setConsigneeDataState(ConsigneeDeatilsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }


  Future<void> getCoveringPODetailsData(String pokey, BuildContext context) async{
    //setSelHisState(StockSelHistoryViewModelDataState.Idle);
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<CoveringPODetailsData>> data = gemOrderRepository.fetchCoveringPODetailsDatalist(pokey, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setCoveringState(CoveringPoDeatilsDataState.NoData);
          setcoveringPODetailslist(value);
        }
        else if(value.isNotEmpty || value.length != 0){
          print("Covering PO Details length ${value.length}");
          setCoveringState(CoveringPoDeatilsDataState.Finished);
          setcoveringPODetailslist(value);
          return;
        }
        else{
          setCoveringState(CoveringPoDeatilsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setCoveringState(CoveringPoDeatilsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDeductionDetailsData(String co6number, BuildContext context) async{
    //setSelHisState(StockSelHistoryViewModelDataState.Idle);
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<DeductionDetailsData>> data = gemOrderRepository.fetchDeductionDetailsDatalist(co6number, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setDeductionState(DeductionDetailsDataState.NoData);
          setdeductionDetailslist(value);

        }
        else if(value.isNotEmpty || value.length != 0){
          print("Deduction details length ${value.length}");
          setDeductionState(DeductionDetailsDataState.Finished);
          setdeductionDetailslist(value);
          return;
        }
        else{
          setDeductionState(DeductionDetailsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setDeductionState(DeductionDetailsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getGemAccountalDetailsData(String orderID, BuildContext context) async{
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<GemAccountalDetailsData>> data = gemOrderRepository.fetchGemAccountalDetailsDatalist(orderID, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setGemAccountailState(GemAccountailsDetailsDataState.NoData);
          setgemAccountalDetailslist(value);

        }
        else if(value.isNotEmpty || value.length != 0){
          print("Gem Accountal Deatils length ${value.length}");
          setGemAccountailState(GemAccountailsDetailsDataState.Finished);
          setgemAccountalDetailslist(value);
          return;
        }
        else{
          setGemAccountailState(GemAccountailsDetailsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setGemAccountailState(GemAccountailsDetailsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getGemOrderDetailsData(String orderID, BuildContext context) async{
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<GemOrderDetailsData>> data = gemOrderRepository.fetchGemOrderDetailsDataDatalist(orderID, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setGemOerderState(GemOderderDeatilsDataState.NoData);
          setgemOrderDetailslist(value);
        }
        else if(value.isNotEmpty || value.length != 0){
          print("Gem order Detail length ${value.length}");
          pokey = value[0].pokey.toString();
          setGemOerderState(GemOderderDeatilsDataState.Finished);
          setgemOrderDetailslist(value);
          return;
        }
        else{
          setGemOerderState(GemOderderDeatilsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setGemOerderState(GemOderderDeatilsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getGemBillDetailsData(String orderID, BuildContext context) async{
    GemOrderRepository gemOrderRepository = GemOrderRepository(context);
    try{
      Future<List<GemBillDetailsData>> data = gemOrderRepository.fetchGemBillDetailsDataDatalist(orderID, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setGemBillState(GemBillDeatilsDataState.NoData);
          setgemBillDetailslist(value);

        }
        else if(value.isNotEmpty || value.length != 0){
          print("Gem Bill Detail length ${value.length}");
          print("hfhfhhhfhf112 "+value[0].co6number.toString());
          co6number = value[0].co6number.toString();
          setGemBillState(GemBillDeatilsDataState.Finished);
          setgemBillDetailslist(value);
          return;
        }
        else{
          setGemBillState(GemBillDeatilsDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setGemBillState(GemBillDeatilsDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  // other operation process

  void clearAllData(BuildContext context) async{
    setBuyerState(BuyerDetailsDataState.Busy);
    Future.delayed(const Duration(seconds: 1), () {
      buyerDetailsData.clear();
      _duplicateitems.clear();
      setbuyerdetailslistlistData(buyerDetailsData);
      setBuyerState(BuyerDetailsDataState.NoData);
      FocusManager.instance.primaryFocus?.unfocus();
      UdmUtilities.showInSnackBar(context, "Data cleared successfully.");
    });
  }

  void clearSelAllData(BuildContext context) async{
    Future.delayed(const Duration(milliseconds: 200), () {
      setBuyerState(BuyerDetailsDataState.ClearData);
      FocusManager.instance.primaryFocus?.unfocus();
      UdmUtilities.showInSnackBar(context, "Data cleared successfully.");
    });
  }

  void loadData(BuildContext context) async{
    Future.delayed(const Duration(milliseconds: 200), () {
      setBuyerState(BuyerDetailsDataState.Finished);
      FocusManager.instance.primaryFocus?.unfocus();
      UdmUtilities.showInSnackBar(context, "Data loaded successfully.");
    });
  }

  Future<void> clearOnBack(BuildContext context) async{
    Future.delayed(const Duration(milliseconds: 200), () {
      setBuyerState(BuyerDetailsDataState.Idle);
      buyerDetailsData.clear();
      _duplicateitems.clear();
    });
  }

  void searchingData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      GemOrderRepository gemOrderRepository = GemOrderRepository(context);
      try{
        Future<List<BuyerDetailsData>> data = gemOrderRepository.fetchSearchBuyerDetailsData(_duplicateitems, query);
        data.then((value) {
          setbuyerdetailslistlistData(value);
          setBuyerState(BuyerDetailsDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setbuyerdetailslistlistData(_duplicateitems);
      setBuyerState(BuyerDetailsDataState.Finished);
    }
    else{
      setbuyerdetailslistlistData(_duplicateitems);
      setBuyerState(BuyerDetailsDataState.Finished);
    }
  }
}