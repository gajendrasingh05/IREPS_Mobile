import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crc_summary/model/crcsummarydata.dart';
import 'package:flutter_app/udm/crc_summary/model/crcsummarylinkdata.dart';
import 'package:flutter_app/udm/crc_summary/repo/crc_summary_repo.dart';
import 'package:flutter_app/udm/crc_summary/model/railwaylistdata.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RailwayDataState {Idle, Busy, Finished, FinishedWithError}
enum UnittypeDataState {Idle, Busy, Finished, FinishedWithError}
enum UnitnameDataState {Idle, Busy, Finished, FinishedWithError}
enum DepartmentDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeDataState {Idle, Busy, Finished, FinishedWithError}
enum SubConsigneeDataState {Idle, Busy, Finished, FinishedWithError}

enum CrcSummaryDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum CrcSummarylinkDataState {Idle, Busy, Finished, NoData, FinishedWithError}

class CrcSummaryViewModel with ChangeNotifier{

  RailwayDataState _rlwDataState = RailwayDataState.Idle;
  UnittypeDataState _unittypeDataState = UnittypeDataState.Idle;
  UnitnameDataState _unitnameDataState = UnitnameDataState.Idle;
  DepartmentDataState _departmentDataState = DepartmentDataState.Idle;
  ConsigneeDataState _consigneeDataState = ConsigneeDataState.Idle;
  SubConsigneeDataState _subconsigneeDataState = SubConsigneeDataState.Idle;

  CrcSummaryDataState _crcSummaryDataState = CrcSummaryDataState.Idle;
  CrcSummarylinkDataState _crcSummarylinkDataState = CrcSummarylinkDataState.Idle;

  List<CrcSummaryRlwData> railwaylistData = [];
  List<dynamic> _unittypeitems = [];
  List<dynamic> _unitnameitems = [];
  List<dynamic> _departmentitems = [];
  List<dynamic> _consigneeitems = [];
  List<dynamic> _subconsigneeitems = [];

  List<CrcSmryData> _crcsummaryitems = [];
  List<CrcSmryData> _duplicatecrcsummaryData = [];

  List<CrcsumrylinkData> _crcsummarylinkitems = [];
  List<CrcsumrylinkData> _duplicatecrcsummarylinkitems = [];

  int openblnctotal = 0;
  int newconsrcvdtotal = 0;
  int signedcrcissuetotal = 0;
  int crcpendingtotal = 0;
  int seventotal = 0;
  int seventofiftytotal = 0;
  int fiftytothirtytotal = 0;
  int morethirtytotal = 0;

  bool topexpand = false;
  bool linktopexpand = false;
  bool expand = false;

  double totalvalue = 0.0;

  // Data Variables to assign initial value
  String department = "Select Department";
  String? deptcode;
  String railway = "Select Railway";
  String? rlyCode;
  String unittype = "Select Unit Type";
  String? unittypecode;
  String unitname = "Select Unit Name";
  String? unitnamecode;
  String consignee = "Select Consignee";
  String? consigneecode;
  String subconsignee = "Select Sub Consignee";
  String? subconsigneecode;

  bool get topexpandvalue => topexpand;
  void settopexpand(bool topexpandvalue) {
    topexpand = topexpandvalue;
    notifyListeners();
  }

  bool get linktopexpandvalue => linktopexpand;
  void setlinktopexpand(bool topexpandvalue) {
    linktopexpand = topexpandvalue;
    notifyListeners();
  }

  bool get expandvalue => expand;
  void setexpandtotal(bool expandvalue) {
    expand = expandvalue;
    notifyListeners();
  }

  bool crcSummarylinkUishowscroll = false;
  bool crcSummaryUiscrollValue = false;

  bool crcSummaryUishowscroll = false;
  bool crcSummarylinkUiscrollValue = false;

  //--- CRC Summary UI
  bool get getCrcSummaryUiScrollValue => crcSummaryUiscrollValue;
  void setCrcSummaryScrollValue(bool value){
    crcSummaryUiscrollValue = value;
    notifyListeners();
  }

  bool get getCrcSummarylinkUiScrollValue => crcSummarylinkUiscrollValue;
  void setCrcSummarylinkScrollValue(bool value){
    crcSummarylinkUiscrollValue = value;
    notifyListeners();
  }

  bool get getCrcSummaryUiShowScroll => crcSummaryUishowscroll;
  void setCrcSummaryShowScroll(bool value){
    crcSummaryUishowscroll = value;
    notifyListeners();
  }

  bool get getCrcSummarylinkUiShowScroll => crcSummarylinkUishowscroll;
  void setCrcSummarylinkShowScroll(bool value){
    crcSummarylinkUishowscroll = value;
    notifyListeners();
  }

  bool _crcSummarysearchvalue = false;
  bool _crcSummarylinksearchvalue = false;
  bool _crcSummarytextchangelistener = false;
  bool _crcSummarylinktextchangelistener = false;
  bool _showhidemicglow = false;
  bool _showhidelinkmicglow = false;

  bool get getcrcSummarySearchValue => _crcSummarysearchvalue;
  bool get getcrcSummarylinkSearchValue => _crcSummarylinksearchvalue;

  bool get getcrcSummarylinksearchValue => _crcSummarylinksearchvalue;

  bool get getchangetextlistener => _crcSummarytextchangelistener;
  bool get getchangelinktextlistener => _crcSummarylinktextchangelistener;

  bool get getshowhidemicglow => _showhidemicglow;
  bool get getshowhidelinkmicglow => _showhidelinkmicglow;

  void updateScreen(bool useraction){
    _crcSummarysearchvalue = useraction;
    notifyListeners();
  }

  void updatelinkScreen(bool useraction){
    _crcSummarylinksearchvalue = useraction;
    notifyListeners();
  }

  void updatetextchangeScreen(bool useraction){
    _crcSummarytextchangelistener = useraction;
    notifyListeners();
  }

  void updatelinktextchangeScreen(bool useraction){
    _crcSummarylinktextchangelistener = useraction;
    notifyListeners();
  }

  void showhidelinkmicglow(bool useraction){
    _showhidelinkmicglow = useraction;
    notifyListeners();
  }

  void showhidemicglow(bool useraction){
    _showhidemicglow = useraction;
    notifyListeners();
  }

  _all() {
    var all = [{
      'intcode': '-1',
      'value': 'All',
    }];
    return all;
  }

  // --- Railway Data ---
  List<CrcSummaryRlwData> get rlylistData => railwaylistData;
  void setrailwaylistData(List<CrcSummaryRlwData> rlylist) {
    railwaylistData = rlylist;
  }
  RailwayDataState get rlydatastatus => _rlwDataState;
  void setRlwStatusState(RailwayDataState currentState) {
    _rlwDataState = currentState;
    notifyListeners();
  }

  // --- Unit Type Data ---
  List<dynamic> get unittypelistData => _unittypeitems;
  void setunittypelistData(List<dynamic> unittypelist) {
    _unittypeitems = unittypelist;
  }
  UnittypeDataState get unittypedatastatus => _unittypeDataState;
  void setUnittypeStatusState(UnittypeDataState currentState) {
    _unittypeDataState = currentState;
    notifyListeners();
  }

  // --- Unit Name Data ---
  List<dynamic> get unitnamelistData => _unitnameitems;
  void setunitnamelistData(List<dynamic> unitnamelist) {
    _unitnameitems = unitnamelist;
  }
  UnitnameDataState get unitnamedatastatus => _unitnameDataState;
  void setUnitnameStatusState(UnitnameDataState currentState) {
    _unitnameDataState = currentState;
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

  // ---------CRC Summary Data -------
  List<CrcSmryData> get crcsummaryData => _crcsummaryitems;
  void setcrcSummaryData(List<CrcSmryData> crcsummarylist) {
    _crcsummaryitems = crcsummarylist;
  }
  CrcSummaryDataState get crcSummaryDataState => _crcSummaryDataState;
  void setcrcsummaryDataState(CrcSummaryDataState currentState) {
    _crcSummaryDataState = currentState;
    notifyListeners();
  }

  List<CrcsumrylinkData> get crcsummarylinkData => _crcsummarylinkitems;
  void setcrcSummarylinkData(List<CrcsumrylinkData> crcsummarylist) {
    _crcsummarylinkitems = crcsummarylist;
  }
  CrcSummarylinkDataState get crcSummaryDatalinkState => _crcSummarylinkDataState;
  void setcrcsummarylinkDataState(CrcSummarylinkDataState currentState) {
    _crcSummarylinkDataState = currentState;
    notifyListeners();
  }


  Future<void> getRailwaylistData(BuildContext context) async {
    setRlwStatusState(RailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<CrcSummaryRlwData>> data = CrcSummaryRepo.instance
          .fetchrailwaylistData(context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setRlwStatusState(RailwayDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setrailwaylistData(value);
          value.forEach((item) {
            if (item.intcode.toString() == prefs.getString('userzone')) {
              railway = item.value.toString();
              rlyCode = item.intcode.toString();
            }
          });
          setRlwStatusState(RailwayDataState.Finished);
        }
        else {
          setRlwStatusState(RailwayDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getUnitTypeData(String? rly, BuildContext context) async {
    setUnittypeStatusState(UnittypeDataState.Busy);
    setUnitnameStatusState(UnitnameDataState.Busy);
    setDepartmentStatusState(DepartmentDataState.Busy);
    setConStatusState(ConsigneeDataState.Busy);
    setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _unittypeitems.clear();
    if(rly == "") {
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchUnit(
            prefs.getString('userzone'),
            prefs.getString('orgunittype'),
            prefs.getString('orgsubunit'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setUnittypeStatusState(UnittypeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunittypelistData(value);
            value.forEach((item) {
              if (item['intcode'].toString() ==
                  prefs.getString('orgunittype')) {
                unittype = item['value'].toString();
                unittypecode = item['intcode'].toString();
              }
            });
            setUnittypeStatusState(UnittypeDataState.Finished);
          }
          else {
            setUnittypeStatusState(UnittypeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setUnittypeStatusState(UnittypeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchUnit(
            rly,
            prefs.getString('orgunittype'),
            prefs.getString('orgsubunit'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        _unitnameitems.clear();
        _consigneeitems.clear();
        _subconsigneeitems.clear();
        setunitnamelistData(_all());
        setConsigneelistData(_all());
        setsubConsigneeData(_all());
        unittype = "All";
        unittypecode = "-1";
        unitname = "All";
        unitnamecode = "-1";
        department = "All";
        deptcode = "-1";
        consignee = "All";
        consigneecode = "-1";
        subconsignee = "All";
        subconsigneecode = "-1";
        data.then((value) {
          setConStatusState(ConsigneeDataState.Finished);
          setUnitnameStatusState(UnitnameDataState.Finished);
          setDepartmentStatusState(DepartmentDataState.Finished);
          setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          if (value.isEmpty || value.length == 0) {
            setUnittypeStatusState(UnittypeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunittypelistData(value);
            setUnittypeStatusState(UnittypeDataState.Finished);
          }
          else {
            setUnittypeStatusState(UnittypeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setUnittypeStatusState(UnittypeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> getUnitNameData(String? rly, String? unittype, BuildContext context) async {
    setUnitnameStatusState(UnitnameDataState.Busy);
    setDepartmentStatusState(DepartmentDataState.Busy);
    setConStatusState(ConsigneeDataState.Busy);
    setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _unitnameitems.clear();
    try {
      if(unittype == "") {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchunitName(
            prefs.getString('userzone'),
            prefs.getString('orgunittype'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('orgsubunit'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setUnitnameStatusState(UnitnameDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunitnamelistData(value);
            value.forEach((item) {
              if (item['intcode'].toString() == prefs.getString('adminunit')) {
                unitname = item['value'].toString();
                unitnamecode = item['intcode'].toString();
              }
            });
            setUnitnameStatusState(UnitnameDataState.Finished);
          }
          else {
            setUnitnameStatusState(UnitnameDataState.FinishedWithError);
          }
        });
      }
      else {
        _consigneeitems.clear();
        setConsigneelistData(_all());
        unitname = "All";
        unitnamecode = "-1";
        consignee = "All";
        consigneecode = "-1";
        department = "All";
        deptcode = "-1";
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchunitName(
            rly,
            unittype,
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('orgsubunit'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setUnitnameStatusState(UnitnameDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunitnamelistData(value);
            setDepartmentStatusState(DepartmentDataState.Finished);
            setConStatusState(ConsigneeDataState.Finished);
            setUnitnameStatusState(UnitnameDataState.Finished);
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setUnitnameStatusState(UnitnameDataState.FinishedWithError);
          }
        });
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDepartment(BuildContext context) async {
    setDepartmentStatusState(DepartmentDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _departmentitems.clear();
    try {
      Future<dynamic> data = CrcSummaryRepo.instance.def_depart_result(context);
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setDepartmentStatusState(DepartmentDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value == null){
          setDepartmentStatusState(DepartmentDataState.Finished);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setdepartmentlistData(value);
          value.forEach((item) {
            if (item['intcode'].toString() == prefs.getString('orgsubunit')) {
              department = item['value'].toString();
              deptcode = item['intcode'].toString();
            }
          });
          setDepartmentStatusState(DepartmentDataState.Finished);
        }
        else {
          setDepartmentStatusState(DepartmentDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getConsignee(String? rly, String? orgsubunit, String? unittype, String? unitname, BuildContext context) async {
    setConStatusState(ConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _consigneeitems.clear();
    if(unittype == "" && unitname == "" && prefs.getString('consigneecode') == "NA") {
      consignee = "All";
      consigneecode = "-1";
      setConsigneelistData(_all());
      Future.delayed(Duration(milliseconds: 1000),() => setConStatusState(ConsigneeDataState.Finished));
    }
    else if(unittype == "" && unitname == "" && prefs.getString('consigneecode') != "NA") {
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.fetchConsignee(
            prefs.getString('userzone'),
            prefs.getString('orgsubunit'),
            prefs.getString('orgunittype'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            value.forEach((item) {
              if(item['intcode'].toString() == "-1") {
                consignee = item['value'].toString();
                consigneecode = item['intcode'].toString();
                return;
              }
              else {
                if(item['intcode'].toString() ==  prefs.getString('consigneecode')){
                  consignee = item['intcode'].toString() + "-" + item['value'].toString();
                  consigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setConStatusState(ConsigneeDataState.Finished);
          }
          else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      consignee = "All";
      consigneecode = "-1";
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.fetchConsignee(
            rly,
            orgsubunit,
            unittype,
            unitname,
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            //consignee = "All";
            //consigneecode = "-1";
            // value.forEach((item) {
            //   if(item['intcode'].toString() == "-1"){
            //     consignee = item['value'].toString();
            //     consigneecode = item['intcode'].toString();
            //   }
            //   else{
            //     consignee = item['intcode'].toString()+"-"+item['value'].toString();
            //     consigneecode = item['intcode'].toString();
            //   }
            // });
            setConStatusState(ConsigneeDataState.Finished);
          }
          else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> getSubConsignee(String? rly, String? orgsubunit, String? unittype, String? unitname, String? userDepot, BuildContext context) async {
    setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _subconsigneeitems.clear();
    if(userDepot == "" && prefs.getString('subconsigneecode') == "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      Future.delayed(Duration(milliseconds: 1000),() => setSubConsigneeStatusState(SubConsigneeDataState.Finished));
    }
    else if(userDepot == "" && prefs.getString('subconsigneecode') != "NA") {
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchSubDepot(
            prefs.getString('userzone'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            value.forEach((item) {
              if (item['intcode'].toString() == "-1") {
                subconsignee = item['value'].toString();
                subconsigneecode = item['intcode'].toString();
                return;
              }
              else {
                if(item['intcode'].toString() == prefs.getString('subconsigneecode')){
                  subconsignee = item['intcode'].toString() + "-" + item['value'].toString();
                  subconsigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if(userDepot == "-1" && prefs.getString('subconsigneecode') != "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      setSubConsigneeStatusState(SubConsigneeDataState.Finished);
    }
    else if(userDepot != "-1" && prefs.getString('subconsigneecode') != "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchSubDepot(
            rly,
            userDepot,
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if(userDepot != "-1" && prefs.getString('subconsigneecode') == "NA") {
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchSubDepot(
            rly,
            userDepot,
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = CrcSummaryRepo.instance.def_fetchSubDepot(
            rly,
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  // ------- CRC Summary Data -------
  Future<void> getCrcSummaryData(String? fromdate, String? todate, String? rly, String? unittype, String? unitname, String? dept, String? consignee, String? subconsignee, BuildContext context) async{
    setcrcsummaryDataState(CrcSummaryDataState.Busy);
    setCrcSummaryShowScroll(false);
    openblnctotal = 0;
    newconsrcvdtotal = 0;
    signedcrcissuetotal = 0;
    crcpendingtotal = 0;
    seventotal = 0;
    seventofiftytotal = 0;
    fiftytothirtytotal = 0;
    morethirtytotal = 0;
    try{
      Future<List<CrcSmryData>> data = CrcSummaryRepo.instance.crcSummaryData(
          rly,
          unittype,
          unitname,
          dept,
          consignee,
          subconsignee,
          fromdate,
          todate,
          context);
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setcrcsummaryDataState(CrcSummaryDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setcrcSummaryData(value.toSet().toList());
          settopexpand(true);
          _duplicatecrcsummaryData = value;
          value.forEach((element) {
            openblnctotal = openblnctotal + int.parse(element.openbal!);
            newconsrcvdtotal = newconsrcvdtotal + int.parse(element.billreceived!);
            signedcrcissuetotal = signedcrcissuetotal + int.parse(element.billpassed!);
            crcpendingtotal = crcpendingtotal + int.parse(element.totalpending!);
            seventotal = seventotal + int.parse(element.pendsevendays!);
            seventofiftytotal = seventofiftytotal + int.parse(element.pendfifteendays!);
            fiftytothirtytotal = fiftytothirtytotal + int.parse(element.pendthirtydays!);
            morethirtytotal = morethirtytotal + int.parse(element.pendmorethirty!);
          });
          setcrcsummaryDataState(CrcSummaryDataState.Finished);
          setCrcSummaryShowScroll(true);
        }
        else {
          setcrcsummaryDataState(CrcSummaryDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      setcrcsummaryDataState(CrcSummaryDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }

  }

  Future<void> getCrcSummarylinkData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, String? actionname, BuildContext context) async{
    setcrcsummarylinkDataState(CrcSummarylinkDataState.Busy);
    setCrcSummarylinkShowScroll(false);
    totalvalue = 0.0;
    try{
      if(actionname == "openBlnc"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummaryopenBlncData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
               if(element.povalue != null){
                 totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
               }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "conrecvd"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummaryconrcvdData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "crcissue"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummarycrcissueData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "closingblnc"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummarycloseblncData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "lessseven"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummarylessthnsevenData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "seventofifteen"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummaryseventofifteenData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "fifteentothirty"){
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummaryfifteentothirtyData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "morethirty") {
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.crcSummarymorethirtyData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrcSummarylinkData(value);
            _duplicatecrcsummarylinkitems = value;
            value.forEach((element) {
              if(element.povalue != null){
                totalvalue = totalvalue + double.parse(element.povalue.toString().trim());
              }
            });
            setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
            setlinktopexpand(true);
            setCrcSummarylinkShowScroll(true);
          }
          else {
            setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
          }
        });
      }
    }
    on Exception catch (err) {
      setcrcsummarylinkDataState(CrcSummarylinkDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }


  // --- Searching on CRC Summary Data
  void searchingCRCSummaryData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<CrcSmryData>> data = CrcSummaryRepo.instance.fetchSearchCrcsummaryData(_duplicatecrcsummaryData, query);
        data.then((value) {
          setcrcSummaryData(value.toSet().toList());
          setcrcsummaryDataState(CrcSummaryDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setcrcSummaryData(_duplicatecrcsummaryData);
      setcrcsummaryDataState(CrcSummaryDataState.Finished);
    }
    else{
      setcrcSummaryData(_duplicatecrcsummaryData);
      setcrcsummaryDataState(CrcSummaryDataState.Finished);
    }
  }

  // ---- Searching on CRC Summary Link Data
  void searchingCRCSummarylinkData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      try{
        Future<List<CrcsumrylinkData>> data = CrcSummaryRepo.instance.fetchSearchCrcsummarylinkData(_duplicatecrcsummarylinkitems, query);
        data.then((value) {
          setcrcSummarylinkData(value.toSet().toList());
          setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setcrcSummarylinkData(_duplicatecrcsummarylinkitems);
      setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
    }
    else{
      setcrcSummarylinkData(_duplicatecrcsummarylinkitems);
      setcrcsummarylinkDataState(CrcSummarylinkDataState.Finished);
    }
  }
}