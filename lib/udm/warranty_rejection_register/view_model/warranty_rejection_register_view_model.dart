import 'package:flutter/material.dart';
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
import 'package:flutter_app/udm/warranty_rejection_register/repo/warranty_rejection_register_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RailwayDataState { Idle, Busy, Finished, FinishedWithError }

enum DepartmentDataState { Idle, Busy, Finished, FinishedWithError }

enum ConsigneeDataState { Idle, Busy, Finished, FinishedWithError }

enum SubConsigneeDataState { Idle, Busy, Finished, FinishedWithError }

enum WrrDataState { Idle, Busy, Finished, NoData, FinishedWithError }

enum RejectionAdviceState { Idle, Busy, Finished, NoData, FinishedWithError }

enum WithdrawnState { Idle, Busy, Finished, NoData, FinishedWithError }

enum ReinspectionState { Idle, Busy, Finished, NoData, FinishedWithError }

enum ReplacementsState { Idle, Busy, Finished, NoData, FinishedWithError }

enum DepositedState { Idle, Busy, Finished, NoData, FinishedWithError }

enum AmountRecoveredState { Idle, Busy, Finished, NoData, FinishedWithError }

enum ReturnedandRejectedItemState {
  Idle,
  Busy,
  Finished,
  NoData,
  FinishedWithError
}

enum AmountRefundState { Idle, Busy, Finished, NoData, FinishedWithError }

enum RecoveryRefundState { Idle, Busy, Finished, NoData, FinishedWithError }

enum WarrantyOfficerDetailState {
  Idle,
  Busy,
  Finished,
  NoData,
  FinishedWithError
}

enum RejectionAdviceRegisterReportState {
  Idle,
  Busy,
  Finished,
  NoData,
  FinishedWithError
}

enum RejectionAdviceRegisterSummaryState {
  Idle,
  Busy,
  Finished,
  NoData,
  FinishedWithError
}

enum WarrantyRejectionreportState {
  Idle,
  Busy,
  Finished,
  NoData,
  FinishedWithError
}

enum WarrantySummaryReportState {
  Idle,
  Busy,
  Finished,
  NoData,
  FinishedWithError
}

class WarrantyRejectionRegisterViewModel with ChangeNotifier {
  bool expand = true;
  bool _wrrsearchvalue = false;
  bool wrrUishowscroll = false;
  bool wrrUiscrollValue = false;
  bool _showhidemicglow = false;
  bool _wrrtextchangelistener = false;

  List<WrrlistData> _wrrlistData = [];
  List<WrrlistData> _duplicatesWrrlistData = [];

  List<RejAdcRegData> _rejadviceregData = [];
  List<RejAdcRegData> _duplicatesRejadviceregData = [];

  List<RejAdcSummaryData> _rejadvsmmryData = [];

  List<WarrantyrejrepData> _warrantyrejreportData = [];
  List<WarrantyrejrepData> _duplicatesWarrantyrejreportData = [];

  List<WarrantySmryReportData> _warrantysummryreportData = [];
  List<WarrantySmryReportData> _duplicatesWarrantysummryreportData = [];

  String wrroption = "all";
  String txntypeoptions = "warrejreg";

  WrrDataState _wrrDataState = WrrDataState.Idle;

  double originalrcv = 0;
  double blncrcv = 0;
  bool get getwrrSearchValue => _wrrsearchvalue;

  double totatqtywd = 0;
  double totqtyreins = 0;
  double totamtrec = 0;
  double totacqtyreins = 0;
  double totalreprec = 0;
  double totalamtref = 0;
  double totalqtyreturn = 0;
  double totrecref = 0;

  String railway = "Select Railway";
  String? rlyCode;
  String department = "Select Department";
  String? deptcode;
  String consignee = "Select Consignee";
  String? consigneecode;
  String subconsignee = "Select Sub Consignee";
  String? subconsigneecode;

  RailwayDataState _rlwDataState = RailwayDataState.Idle;
  DepartmentDataState _departmentDataState = DepartmentDataState.Idle;
  ConsigneeDataState _consigneeDataState = ConsigneeDataState.Idle;
  SubConsigneeDataState _subconsigneeDataState = SubConsigneeDataState.Idle;

  List<WRRRlwData> railwaylistData = [];
  List<dynamic> _departmentitems = [];
  List<dynamic> _consigneeitems = [];
  List<dynamic> _subconsigneeitems = [];

  _all() {
    var all = [
      {
        'intcode': '-1',
        'value': 'All',
      }
    ];
    return all;
  }

  //--- Warranty Rejection Register Advice ----//
  List<RejectionAdviceData> _rejectionAdviceData = [];
  RejectionAdviceState _rejectionAdviceState = RejectionAdviceState.Idle;

  //--- Warranty Withdrawn ----//
  List<WithdrawData> _withdrawnData = [];
  WithdrawnState _withdrawnState = WithdrawnState.Idle;

  //--- Warranty Reinspection ----//
  List<ReinsData> _reinspData = [];
  ReinspectionState _reinspState = ReinspectionState.Idle;

  //--- Warranty Replacements ----//
  List<RepData> _repData = [];
  ReplacementsState _repState = ReplacementsState.Idle;

  //--- Warranty Deposited ---- not complete//
  List<dynamic> _depositedData = [];
  DepositedState _depositedState = DepositedState.Idle;

  //--- Warranty amount Recovered ----//
  List<AmtRecData> _amtrcvData = [];
  AmountRecoveredState _amountRecoveredState = AmountRecoveredState.Idle;

  //--- Warranty Return of Rejected Item ----//
  List<RetrejData> _retrejData = [];
  ReturnedandRejectedItemState _retrejState = ReturnedandRejectedItemState.Idle;

  //--- Warranty Amount Refund against Warranty ---- //
  List<AmtRefData> _amtrefjData = [];
  AmountRefundState _amtrefState = AmountRefundState.Idle;

  //--- Warranty Amount recovery refund ----//
  List<RecRefData> _recrefData = [];
  RecoveryRefundState _recrefState = RecoveryRefundState.Idle;

  //--- Warranty Officer Details ----//
  List<OfiicerData> _officerData = [];
  WarrantyOfficerDetailState _wrofcrState = WarrantyOfficerDetailState.Idle;

  // --- Rejection Advice Register Report ----//
  RejectionAdviceRegisterReportState _rejectionAdviceRegisterReportState =
      RejectionAdviceRegisterReportState.Idle;

  // --- Rejection Advice Register Summary ----//
  RejectionAdviceRegisterSummaryState _rejectionAdviceRegisterSummaryState =
      RejectionAdviceRegisterSummaryState.Idle;

  // --- Warranty Rejection Report ---//
  WarrantyRejectionreportState _warrantyRejectionreportState =
      WarrantyRejectionreportState.Idle;

  //--- Warranty Summary Report --- //
  WarrantySummaryReportState _warrantySummaryReportState =
      WarrantySummaryReportState.Idle;

  // --- Railway Data ---
  List<WRRRlwData> get rlylistData => railwaylistData;
  void setrailwaylistData(List<WRRRlwData> rlylist) {
    railwaylistData = rlylist;
  }

  RailwayDataState get rlydatastatus => _rlwDataState;
  void setRlwStatusState(RailwayDataState currentState) {
    _rlwDataState = currentState;
    notifyListeners();
  }

  // --- Department Name Data ---
  List<dynamic> get departmentlistData => _departmentitems;
  void setdepartmentlistData(List<dynamic> departmentlist) {
    _departmentitems = departmentlist;
  }

  DepartmentDataState get departmentdatastatus => _departmentDataState;
  void setDepartmentStatusState(DepartmentDataState currentState) {
    _departmentDataState = currentState;
    notifyListeners();
  }

  // --- Consignee Data ---
  List<dynamic> get consigneelistData => _consigneeitems;

  void setConsigneelistData(List<dynamic> conlist) {
    _consigneeitems = conlist;
  }

  ConsigneeDataState get condatastatus => _consigneeDataState;

  void setConStatusState(ConsigneeDataState currentState) {
    _consigneeDataState = currentState;
    notifyListeners();
  }

  // --- Sub Consignee Data ---
  List<dynamic> get subconsigneeData => _subconsigneeitems;

  void setsubConsigneeData(List<dynamic> subconsigneelist) {
    _subconsigneeitems = subconsigneelist;
  }

  SubConsigneeDataState get subconsigneedatastatus => _subconsigneeDataState;

  void setSubConsigneeStatusState(SubConsigneeDataState currentState) {
    _subconsigneeDataState = currentState;
    notifyListeners();
  }

  void updateScreen(bool useraction) {
    _wrrsearchvalue = useraction;
    notifyListeners();
  }

  void setexpandtotal(bool expandvalue) {
    expand = expandvalue;
    notifyListeners();
  }

  bool get expandvalue => expand;

  bool get getWrrUiShowScroll => wrrUishowscroll;
  void setWrrShowScroll(bool value) {
    wrrUishowscroll = value;
    notifyListeners();
  }

  bool get getWrrScrollValue => wrrUiscrollValue;
  void setWrrScrollValue(bool value) {
    wrrUiscrollValue = value;
    notifyListeners();
  }

  bool get getshowhidemicglow => _showhidemicglow;
  void showhidemicglow(bool useraction) {
    _showhidemicglow = useraction;
    notifyListeners();
  }

  bool get getchangetextlistener => _wrrtextchangelistener;
  void updatetextchangeScreen(bool useraction) {
    _wrrtextchangelistener = useraction;
    notifyListeners();
  }

  WrrDataState get wrrDatastate => _wrrDataState;
  void setWrrDataState(WrrDataState state) {
    _wrrDataState = state;
    notifyListeners();
  }

  List<WrrlistData> get wrrlistData => _wrrlistData;
  void setWrrlistData(List<WrrlistData> data) {
    _wrrlistData = data;
  }

  WarrantyRejectionreportState get warrantyrejectionreportstate =>
      _warrantyRejectionreportState;
  void setWarrantyRejectionReportState(WarrantyRejectionreportState state) {
    _warrantyRejectionreportState = state;
    notifyListeners();
  }

  List<WarrantyrejrepData> get warrantyrejectionreportData =>
      _warrantyrejreportData;
  void setWarrantyRejectionReportData(List<WarrantyrejrepData> data) {
    _warrantyrejreportData = data;
  }

  WarrantySummaryReportState get warrantysummaryreportstate =>
      _warrantySummaryReportState;
  void setWarrantySummaryReportState(WarrantySummaryReportState state) {
    _warrantySummaryReportState = state;
    notifyListeners();
  }

  List<WarrantySmryReportData> get warrantysummaryreportdata =>
      _warrantysummryreportData;
  void setWarrantySummaryReport(List<WarrantySmryReportData> data) {
    _warrantysummryreportData = data;
  }

  RejectionAdviceRegisterReportState get rejectionadviceregisterreportstate =>
      _rejectionAdviceRegisterReportState;
  void setRejectionAdviceRegisterReportState(
      RejectionAdviceRegisterReportState state) {
    _rejectionAdviceRegisterReportState = state;
    notifyListeners();
  }

  List<RejAdcRegData> get rejectionadvicereportData => _rejadviceregData;
  void setRejectionAdviceregistertData(List<RejAdcRegData> data) {
    _rejadviceregData = data;
  }

  RejectionAdviceRegisterSummaryState get rejectionadviceregistersumrystate =>
      _rejectionAdviceRegisterSummaryState;
  void setRejectionAdviceRegisterSummaryState(
      RejectionAdviceRegisterSummaryState state) {
    _rejectionAdviceRegisterSummaryState = state;
    notifyListeners();
  }

  List<RejAdcSummaryData> get rejadvsmmryData => _rejadvsmmryData;
  void setRejectionAdvicesummaryData(List<RejAdcSummaryData> data) {
    _rejadvsmmryData = data;
  }

  RejectionAdviceState get rejectionAdviceState => _rejectionAdviceState;
  void setRejectionAdviceDataState(RejectionAdviceState state) {
    _rejectionAdviceState = state;
    notifyListeners();
  }

  List<RejectionAdviceData> get rejectionadvicelistData => _rejectionAdviceData;
  void setRejectionAdvicelistData(List<RejectionAdviceData> data) {
    _rejectionAdviceData = data;
  }

  WarrantyOfficerDetailState get wodState => _wrofcrState;
  void setOfficerState(WarrantyOfficerDetailState state) {
    _wrofcrState = state;
    notifyListeners();
  }

  List<OfiicerData> get officerData => _officerData;
  void setOfficerData(List<OfiicerData> data) {
    _officerData = data;
  }

  WithdrawnState get withdrawState => _withdrawnState;
  void setWithdrawnState(WithdrawnState state) {
    _withdrawnState = state;
    notifyListeners();
  }

  List<WithdrawData> get withdrawData => _withdrawnData;
  void setWithdrawData(List<WithdrawData> data) {
    _withdrawnData = data;
  }

  ReinspectionState get reinspectionState => _reinspState;
  void setReinspectionState(ReinspectionState state) {
    _reinspState = state;
    notifyListeners();
  }

  List<ReinsData> get reinsData => _reinspData;
  void setReinsData(List<ReinsData> data) {
    _reinspData = data;
  }

  ReplacementsState get replacementsState => _repState;
  void setReplacementsState(ReplacementsState state) {
    _repState = state;
    notifyListeners();
  }

  List<RepData> get repData => _repData;
  void setRepData(List<RepData> data) {
    _repData = data;
  }

  DepositedState get depositedState => _depositedState;
  void setDepositedState(DepositedState state) {
    _depositedState = state;
    notifyListeners();
  }

  List<dynamic> get depositData => _depositedData;
  void setDepositedData(List<dynamic> data) {
    _depositedData = data;
  }

  AmountRecoveredState get amountRecoveredState => _amountRecoveredState;
  void setAmountRecoveredState(AmountRecoveredState state) {
    _amountRecoveredState = state;
    notifyListeners();
  }

  List<AmtRecData> get amtrecvData => _amtrcvData;
  void setAmtRecData(List<AmtRecData> data) {
    _amtrcvData = data;
  }

  ReturnedandRejectedItemState get returnedandRejectedItemState => _retrejState;
  void setReturnedandRejectedItemState(ReturnedandRejectedItemState state) {
    _retrejState = state;
    notifyListeners();
  }

  List<RetrejData> get retrejData => _retrejData;
  void setRetrejData(List<RetrejData> data) {
    _retrejData = data;
  }

  AmountRefundState get amountRefundState => _amtrefState;
  void setAmountRefundState(AmountRefundState state) {
    _amtrefState = state;
    notifyListeners();
  }

  List<AmtRefData> get amountRefundData => _amtrefjData;
  void setAmountRefundData(List<AmtRefData> data) {
    _amtrefjData = data;
  }

  RecoveryRefundState get recoveryRefundState => _recrefState;
  void setRecoveryRefundState(RecoveryRefundState state) {
    _recrefState = state;
    notifyListeners();
  }

  List<RecRefData> get recRefData => _recrefData;
  void setRecRefData(List<RecRefData> data) {
    _recrefData = data;
  }

  String get getWrrOption => wrroption;
  setOptionsValue(String value) {
    wrroption = value;
    notifyListeners();
  }

  String get getTxntypeOption => txntypeoptions;
  setTxnOptionsValue(String value) {
    txntypeoptions = value;
    notifyListeners();
  }

  Future<void> getRailwaylistData(BuildContext context) async {
    setRlwStatusState(RailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<WRRRlwData>> data = WarrantyRejectionRegisterRepo.instance.fetchrailwaylistData(context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setRlwStatusState(RailwayDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        } else if (value.isNotEmpty || value.length != 0) {
          setrailwaylistData(value);
          value.forEach((item) {
            if (item.intcode.toString() == prefs.getString('userzone')) {
              railway = item.value.toString();
              rlyCode = item.intcode.toString();
            }
          });
          setRlwStatusState(RailwayDataState.Finished);
        } else {
          setRlwStatusState(RailwayDataState.FinishedWithError);
        }
      });
    } on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDepartment(BuildContext context) async {
    setDepartmentStatusState(DepartmentDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _departmentitems.clear();
    try {
      Future<dynamic> data =
          WarrantyRejectionRegisterRepo.instance.def_depart_result(context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setDepartmentStatusState(DepartmentDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        } else if (value == null) {
          setDepartmentStatusState(DepartmentDataState.Finished);
        } else if (value.isNotEmpty || value.length != 0) {
          setdepartmentlistData(value);
          value.forEach((item) {
            if (item['intcode'].toString() == prefs.getString('orgsubunit')) {
              department = item['value'].toString();
              deptcode = item['intcode'].toString();
            }
          });
          setDepartmentStatusState(DepartmentDataState.Finished);
        } else {
          setDepartmentStatusState(DepartmentDataState.FinishedWithError);
        }
      });
    } on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getConsignee(String? rly, BuildContext context) async {
    setConStatusState(ConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _consigneeitems.clear();
    if(prefs.getString('consigneecode') == "NA" && rly == "") {
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.fetchConsignee(prefs.getString('userzone'),context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if(value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            value.forEach((item) {
              if(item['intcode'].toString() == "-1") {
                consignee = item['value'].toString();
                consigneecode = item['intcode'].toString();
                return;
              } else {
                if(item['intcode'].toString() == prefs.getString('consigneecode')) {
                  consignee = item['intcode'].toString() + "-" + item['value'].toString();
                  consigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setConStatusState(ConsigneeDataState.Finished);
          } else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if(prefs.getString('consigneecode') != "NA" && rly == "") {
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.fetchConsignee(prefs.getString('userzone'),context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if(value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            value.forEach((item) {
              if(item['intcode'].toString() == "-1") {
                consignee = item['value'].toString();
                consigneecode = item['intcode'].toString();
                return;
              } else {
                if(item['intcode'].toString() == prefs.getString('consigneecode')) {
                  consignee = item['intcode'].toString() + "-" + item['value'].toString();
                  consigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setConStatusState(ConsigneeDataState.Finished);
          } else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      setSubConsigneeStatusState(SubConsigneeDataState.Busy);
      _subconsigneeitems.clear();
      consignee = "All";
      consigneecode = "-1";
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.fetchConsignee(rly,context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if(value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            value.forEach((item) {
              if(item['intcode'].toString() == "-1") {
                consignee = item['value'].toString();
                consigneecode = item['intcode'].toString();
                return;
              } else {
                if(item['intcode'].toString() == prefs.getString('consigneecode')) {
                  consignee = item['intcode'].toString() + "-" + item['value'].toString();
                  consigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setConStatusState(ConsigneeDataState.Finished);
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          } else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> getSubConsignee(String? rly, String? consCode, String? deptCode, BuildContext context) async {
    setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _subconsigneeitems.clear();
    if(consCode == "" && prefs.getString('subconsigneecode') == "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      Future.delayed(Duration(milliseconds: 1000), () => setSubConsigneeStatusState(SubConsigneeDataState.Finished));
    }
    else if(consCode == "" && prefs.getString('subconsigneecode') != "NA") {
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.def_fetchSubDepot(
                prefs.getString('userzone'),
                prefs.getString('consigneecode'),
                prefs.getString('subconsigneecode'),
                context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            value.forEach((item) {
              if (item['intcode'].toString() == "-1") {
                subconsignee = item['value'].toString();
                subconsigneecode = item['intcode'].toString();
                return;
              } else {
                if (item['intcode'].toString() == prefs.getString('subconsigneecode')) {
                  subconsignee = item['intcode'].toString() + "-" + item['value'].toString();
                  subconsigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          } else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if (consCode == "-1" && prefs.getString('subconsigneecode') != "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      setSubConsigneeStatusState(SubConsigneeDataState.Finished);

    }
    else if(consCode != "-1" && prefs.getString('subconsigneecode') != "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.def_fetchSubDepot(rly, consCode, prefs.getString('subconsigneecode'), context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          } else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if(consCode != "-1" && prefs.getString('subconsigneecode') == "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.def_fetchSubDepot(rly, consCode, prefs.getString('subconsigneecode'), context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          } else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = WarrantyRejectionRegisterRepo.instance.def_fetchSubDepot(rly, prefs.getString('consigneecode'),
                prefs.getString('subconsigneecode'), context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          } else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          } else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      } on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> getWarrantyRejectionReport(
      String? rlycode,
      String? concode,
      String? subconcode,
      String? fromdate,
      String? todate,
      String? iquery,
      String? vensearch,
      String? searchtype,
      BuildContext context) async {
    setWarrantyRejectionReportState(WarrantyRejectionreportState.Busy);
    setWrrShowScroll(false);
    try {
      Future<List<WarrantyrejrepData>> data =
          WarrantyRejectionRegisterRepo.instance.fetchWarrantyRejectionReport(
              rlycode!,
              concode!,
              subconcode!,
              fromdate!,
              todate!,
              iquery!,
              vensearch!,
              searchtype!,
              context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setWrrShowScroll(false);
          setWarrantyRejectionReportState(WarrantyRejectionreportState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setWarrantyRejectionReportData(value);
          _duplicatesWarrantyrejreportData = value;
          value.forEach((element) {
            originalrcv =
                double.parse(element.origrecovery.toString()) + originalrcv;
            blncrcv = double.parse(element.balrecovery.toString()) + blncrcv;
          });
          setWarrantyRejectionReportState(WarrantyRejectionreportState.Finished);
          if(_duplicatesWarrantyrejreportData.length > 2) {
            setWrrShowScroll(true);
          } else {
            setWrrShowScroll(false);
          }
        }
      });
    } on Exception catch (err) {
      setWrrShowScroll(false);
      setWarrantyRejectionReportState(WarrantyRejectionreportState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getWarrantySummaryReport(
      String? rlycode,
      String? concode,
      String? subconcode,
      String? fromdate,
      String? todate,
      String? iquery,
      String? vensearch,
      String? searchtype,
      BuildContext context) async {
    setWarrantySummaryReportState(WarrantySummaryReportState.Busy);
    try {
      Future<List<WarrantySmryReportData>> data =
          WarrantyRejectionRegisterRepo.instance.fetchWarrantySummaryReport(
              rlycode!,
              concode!,
              subconcode!,
              fromdate!,
              todate!,
              iquery!,
              vensearch!,
              searchtype!,
              context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setWarrantySummaryReportState(WarrantySummaryReportState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setWarrantySummaryReport(value);
          _duplicatesWarrantysummryreportData = value;
          setWarrantySummaryReportState(WarrantySummaryReportState.Finished);
        }
      });
    } on Exception catch (err) {
      setWarrantySummaryReportState(WarrantySummaryReportState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getRejectionAdviceRegister(
      String? rlycode,
      String? concode,
      String? subconcode,
      String? deptcode,
      String? fromdate,
      String? todate,
      String? iquery,
      String? vensearch,
      String? searchtype,
      BuildContext context) async {
    setRejectionAdviceRegisterReportState(RejectionAdviceRegisterReportState.Busy);
    setWrrShowScroll(false);
    try {
      Future<List<RejAdcRegData>> data = WarrantyRejectionRegisterRepo.instance.fetchRejectionAdviceregister(
              rlycode!,
              concode!,
              subconcode!,
              deptcode!,
              fromdate!,
              todate!,
              iquery!,
              vensearch!,
              searchtype!,
              context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setRejectionAdviceRegisterReportState(
              RejectionAdviceRegisterReportState.NoData);
          setWrrShowScroll(false);
          IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRejectionAdviceregistertData(value);
          _duplicatesRejadviceregData = value;
          setWrrShowScroll(true);
          setRejectionAdviceRegisterReportState(RejectionAdviceRegisterReportState.Finished);
        }
      });
    } on Exception catch (err) {
      setRejectionAdviceRegisterReportState(
          RejectionAdviceRegisterReportState.FinishedWithError);
      setWrrShowScroll(false);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getRejectionAdviceSummary(
      String? rlycode,
      String? concode,
      String? subconcode,
      String? deptcode,
      String? fromdate,
      String? todate,
      String? iquery,
      String? vensearch,
      String? searchtype,
      BuildContext context) async {
    setRejectionAdviceRegisterSummaryState(RejectionAdviceRegisterSummaryState.Busy);
    try {
      Future<List<RejAdcSummaryData>> data =
          WarrantyRejectionRegisterRepo.instance.fetchRejectionAdvicesummary(
              rlycode!,
              concode!,
              subconcode!,
              deptcode!,
              fromdate!,
              todate!,
              iquery!,
              vensearch!,
              searchtype!,
              context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setRejectionAdviceRegisterSummaryState(RejectionAdviceRegisterSummaryState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRejectionAdvicesummaryData(value);
          setRejectionAdviceRegisterSummaryState(RejectionAdviceRegisterSummaryState.Finished);

        }
      });
    } on Exception catch (err) {
      setRejectionAdviceRegisterSummaryState(
          RejectionAdviceRegisterSummaryState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  // Future<void> getWrrlistData(
  //     String? rly,
  //     String? concode,
  //     String? subconcode,
  //     String? fromdate,
  //     String? todate,
  //     String iquery,
  //     String searchven,
  //     String searchtype,
  //     BuildContext context) async {
  //   setWrrDataState(WrrDataState.Busy);
  //   setWrrShowScroll(false);
  //   originalrcv = 0;
  //   blncrcv = 0;
  //   try {
  //     Future<List<WrrlistData>> data = WarrantyRejectionRegisterRepo.instance
  //         .fetchWrrlistData(rly!, concode!, subconcode!, fromdate!, todate!,
  //             iquery, searchven, searchtype, context);
  //     data.then((value) {
  //       if (value.isEmpty || value.length == 0) {
  //         setWrrDataState(WrrDataState.NoData);
  //         IRUDMConstants().showSnack('Data not found.', context);
  //       } else {
  //         setWrrlistData(value);
  //         _duplicatesWrrlistData = value;
  //         value.forEach((element) {
  //           originalrcv =
  //               double.parse(element.origrecovery.toString()) + originalrcv;
  //           blncrcv = double.parse(element.balrecovery.toString()) + blncrcv;
  //         });
  //         if (_duplicatesWrrlistData.length > 2) {
  //           setWrrShowScroll(true);
  //         } else {
  //           setWrrShowScroll(false);
  //         }
  //         setWrrDataState(WrrDataState.Finished);
  //       }
  //     });
  //   } on Exception catch (err) {
  //     setWrrDataState(WrrDataState.Finished);
  //     IRUDMConstants().showSnack(err.toString(), context);
  //   }
  //   // finally{
  //   //   //setWrrlistData(wrrlistData);
  //   //   setWrrDataState(WrrDataState.Finished);
  //   // }
  // }

  //-----Detail Data----//

  Future<void> getRejectionAdvicelistData(String? trkey, BuildContext context) async {
    setRejectionAdviceDataState(RejectionAdviceState.Busy);
    try {
      Future<List<RejectionAdviceData>> data = WarrantyRejectionRegisterRepo
          .instance
          .fetchRejectionAdviceData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setRejectionAdviceDataState(RejectionAdviceState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRejectionAdvicelistData(value);
          setRejectionAdviceDataState(RejectionAdviceState.Finished);
        }
      });
    } on Exception catch (err) {
      setRejectionAdviceDataState(RejectionAdviceState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getWarrantyOfficerData(
      String? trkey, BuildContext context) async {
    setOfficerState(WarrantyOfficerDetailState.Busy);
    try {
      Future<List<OfiicerData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchOfficerDetailsData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setOfficerState(WarrantyOfficerDetailState.Finished);
          IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setOfficerData(value);
          setOfficerState(WarrantyOfficerDetailState.Finished);
        }
      });
    } on Exception catch (err) {
      setOfficerState(WarrantyOfficerDetailState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //--- Detail Data for list ---//

  Future<void> getWithdrawnData(String? trkey, BuildContext context) async {
    setWithdrawnState(WithdrawnState.Busy);
    totatqtywd = 0;
    try {
      Future<List<WithdrawData>> data = WarrantyRejectionRegisterRepo.instance.fetchWithdrawData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setWithdrawnState(WithdrawnState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setWithdrawData(value);
          value.forEach((element) {
            totatqtywd =
                totatqtywd + double.parse(element.qtyAccepted.toString());
          });
          setWithdrawnState(WithdrawnState.Finished);
        }
      });
    } on Exception catch (err) {
      setWithdrawnState(WithdrawnState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getReinspData(String? trkey, BuildContext context) async {
    setReinspectionState(ReinspectionState.Busy);
    totqtyreins = 0;
    totacqtyreins = 0;
    try {
      Future<List<ReinsData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchReinsData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setReinspectionState(ReinspectionState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setReinsData(value);
          value.forEach((element) {
            if(element.qtyAccepted != null && element.qtyReceived != null){
              totacqtyreins = totacqtyreins + double.parse(element.qtyAccepted.toString());
              totqtyreins = totqtyreins + double.parse(element.qtyReceived.toString());
            }
          });
          setReinspectionState(ReinspectionState.Finished);
        }
      });
    } on Exception catch (err) {
      setReinspectionState(ReinspectionState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getReplacementsData(String? trkey, BuildContext context) async {
    setReplacementsState(ReplacementsState.Busy);
    totalreprec = 0;
    try {
      Future<List<RepData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchReplacementsData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setReplacementsState(ReplacementsState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRepData(value);
          value.forEach((element) {
            if(element.qtyreplaced != null){
              totalreprec = totalreprec + double.parse(element.qtyreplaced.toString());
            }
          });
          setReplacementsState(ReplacementsState.Finished);
        }
      });
    } on Exception catch (err) {
      setReplacementsState(ReplacementsState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDepositedData(String? trkey, BuildContext context) async {
    setDepositedState(DepositedState.Busy);
    try {
      Future<List<RepData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchReplacementsData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setDepositedState(DepositedState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRepData(value);
          setDepositedState(DepositedState.Finished);
        }
      });
    } on Exception catch (err) {
      setDepositedState(DepositedState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getAmountRecoverdData(String? trkey, BuildContext context) async {
    setAmountRecoveredState(AmountRecoveredState.Busy);
    totamtrec = 0;
    try {
      Future<List<AmtRecData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchAmtRecoveredData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setAmountRecoveredState(AmountRecoveredState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setAmtRecData(value);
          value.forEach((element) {
            totamtrec =
                totamtrec + double.parse(element.amountrecovered.toString());
          });
          setAmountRecoveredState(AmountRecoveredState.Finished);
        }
      });
    } on Exception catch (err) {
      setAmountRecoveredState(AmountRecoveredState.Finished);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> fetchReturnRejData(String? trkey, BuildContext context) async {
    setReturnedandRejectedItemState(ReturnedandRejectedItemState.Busy);
    totalqtyreturn = 0;
    try {
      Future<List<RetrejData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchReturnRejData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setReturnedandRejectedItemState(ReturnedandRejectedItemState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRetrejData(value);
          value.forEach((element) {
            totalqtyreturn =
                totalqtyreturn + double.parse(element.trQty.toString());
          });
          setReturnedandRejectedItemState(
              ReturnedandRejectedItemState.Finished);
        }
      });
    } on Exception catch (err) {
      setReturnedandRejectedItemState(
          ReturnedandRejectedItemState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> fetchAmountRefundData(String? trkey, BuildContext context) async {
    setAmountRefundState(AmountRefundState.Busy);
    totalamtref = 0;
    try {
      Future<List<AmtRefData>> data = WarrantyRejectionRegisterRepo.instance.fetchAmtRefData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setAmountRefundState(AmountRefundState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setAmountRefundData(value);
          value.forEach((element) {
            totalamtref = totalamtref + double.parse(element.amountRefunded.toString());
          });
          setAmountRefundState(AmountRefundState.Finished);
        }
      });
    } on Exception catch (err) {
      setAmountRefundState(AmountRefundState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> fetchRecoveryRefundData(String? trkey, BuildContext context) async {
    setRecoveryRefundState(RecoveryRefundState.Busy);
    totrecref = 0;
    try {
      Future<List<RecRefData>> data = WarrantyRejectionRegisterRepo.instance
          .fetchAmtRecRefData(trkey!, context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setRecoveryRefundState(RecoveryRefundState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        } else {
          setRecRefData(value);
          value.forEach((element) {
            totrecref =
                totrecref + double.parse(element.refundValue.toString());
          });
          setRecoveryRefundState(RecoveryRefundState.Finished);
        }
      });
    } on Exception catch (err) {
      setRecoveryRefundState(RecoveryRefundState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getSearchWrrData(String? query, BuildContext context) {
    if (query!.isNotEmpty && query.length > 0) {
      try {
        Future<List<WarrantyrejrepData>> data = WarrantyRejectionRegisterRepo
            .instance
            .fetchSearchWrrlistData(_duplicatesWarrantyrejreportData, query);
        data.then((value) {
          setWarrantyRejectionReportData(value.toSet().toList());
          if (value.length > 2) {
            setWrrShowScroll(true);
          } else {
            setWrrShowScroll(false);
          }
          setWarrantyRejectionReportState(
              WarrantyRejectionreportState.Finished);
        });
      } on Exception catch (err) {
        setWarrantyRejectionReportState(WarrantyRejectionreportState.Finished);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    } else if (query.isEmpty ||
        query.length == 0 ||
        query == "" ||
        query == null) {
      setWarrantyRejectionReportData(_duplicatesWarrantyrejreportData);
      if (_duplicatesWarrantyrejreportData.length > 2) {
        setWrrShowScroll(true);
      } else {
        setWrrShowScroll(false);
      }
      setWarrantyRejectionReportState(WarrantyRejectionreportState.Finished);
    } else {
      setWarrantyRejectionReportData(_duplicatesWarrantyrejreportData);
      if (_duplicatesWarrantyrejreportData.length > 2) {
        setWrrShowScroll(true);
      } else {
        setWrrShowScroll(false);
      }
      setWarrantyRejectionReportState(WarrantyRejectionreportState.Finished);
    }
  }

  void getSearchRejectionAdviceData(String? query, BuildContext context) {
    if (query!.isNotEmpty && query.length > 0) {
      try {
        Future<List<RejAdcRegData>> data = WarrantyRejectionRegisterRepo
            .instance
            .fetchSearchRejectionAdvicelistData(
                _duplicatesRejadviceregData, query);
        data.then((value) {
          setRejectionAdviceregistertData(value.toSet().toList());
          if (value.length > 2) {
            setWrrShowScroll(true);
          } else {
            setWrrShowScroll(false);
          }
          setRejectionAdviceRegisterReportState(
              RejectionAdviceRegisterReportState.Finished);
        });
      } on Exception catch (err) {
        setRejectionAdviceRegisterReportState(
            RejectionAdviceRegisterReportState.Finished);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    } else if (query.isEmpty ||
        query.length == 0 ||
        query == "" ||
        query == null) {
      setRejectionAdviceregistertData(_duplicatesRejadviceregData);
      if (_duplicatesRejadviceregData.length > 2) {
        setWrrShowScroll(true);
      } else {
        setWrrShowScroll(false);
      }
      setRejectionAdviceRegisterReportState(
          RejectionAdviceRegisterReportState.Finished);
    } else {
      setRejectionAdviceregistertData(_duplicatesRejadviceregData);
      if (_duplicatesRejadviceregData.length > 2) {
        setWrrShowScroll(true);
      } else {
        setWrrShowScroll(false);
      }
      setRejectionAdviceRegisterReportState(
          RejectionAdviceRegisterReportState.Finished);
    }
  }
}
