import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crn_summary/model/crnSummarylinkData.dart';
import 'package:flutter_app/udm/crn_summary/model/crnsummarydata.dart';
import 'package:flutter_app/udm/crn_summary/model/railwaylistdata.dart';
import 'package:flutter_app/udm/crn_summary/repo/crn_summary_repo.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum RailwayDataState {Idle, Busy, Finished, FinishedWithError}
enum UnittypeDataState {Idle, Busy, Finished, FinishedWithError}
enum UnitnameDataState {Idle, Busy, Finished, FinishedWithError}
enum DepartmentDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeDataState {Idle, Busy, Finished, FinishedWithError}
enum SubConsigneeDataState {Idle, Busy, Finished, FinishedWithError}

enum CrnSummaryDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum CrnSummarylinkDataState {Idle, Busy, Finished, NoData, FinishedWithError}

class CrnSummaryViewModel with ChangeNotifier{

  RailwayDataState _rlwDataState = RailwayDataState.Idle;
  UnittypeDataState _unittypeDataState = UnittypeDataState.Idle;
  UnitnameDataState _unitnameDataState = UnitnameDataState.Idle;
  DepartmentDataState _departmentDataState = DepartmentDataState.Idle;
  ConsigneeDataState _consigneeDataState = ConsigneeDataState.Idle;
  SubConsigneeDataState _subconsigneeDataState = SubConsigneeDataState.Idle;

  CrnSummaryDataState _crnSummaryDataState = CrnSummaryDataState.Idle;
  CrnSummarylinkDataState _crnSummarylinkDataState = CrnSummarylinkDataState.Idle;

  List<CrnSummaryRlwData> railwaylistData = [];
  List<dynamic> _unittypeitems = [];
  List<dynamic> _unitnameitems = [];
  List<dynamic> _departmentitems = [];
  List<dynamic> _consigneeitems = [];
  List<dynamic> _subconsigneeitems = [];

  List<CrnSmryData> _crnsummaryitems = [];
  List<CrnSmryData> _duplicatecrnsummaryData = [];

  List<CrnsumrylinkData> _crnsummarylinkitems = [];
  List<CrnsumrylinkData> _duplicatecrnsummarylinkitems = [];


  int openblnctotal = 0;
  int newconsrcvdtotal = 0;
  int signedcrnissuetotal = 0;
  int crnpendingtotal = 0;
  int seventotal = 0;
  int seventofiftytotal = 0;
  int fiftytothirtytotal = 0;
  int morethirtytotal = 0;

  bool expand = false;

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

  void setexpandtotal(bool expandvalue) {
    expand = expandvalue;
    notifyListeners();
  }

  bool get expandvalue => expand;

  bool crnSummarylinkUishowscroll = false;
  bool crnSummaryUiscrollValue = false;

  bool crnSummaryUishowscroll = false;
  bool crnSummarylinkUiscrollValue = false;

  //--- CRN Summary UI
  bool get getCrnSummaryUiScrollValue => crnSummaryUiscrollValue;
  void setCrnSummaryScrollValue(bool value){
    crnSummaryUiscrollValue = value;
    notifyListeners();
  }

  bool get getCrnSummarylinkUiScrollValue => crnSummarylinkUiscrollValue;
  void setCrnSummarylinkScrollValue(bool value){
    crnSummarylinkUiscrollValue = value;
    notifyListeners();
  }

  bool get getCrnSummaryUiShowScroll => crnSummaryUishowscroll;
  void setCrnSummaryShowScroll(bool value){
    crnSummaryUishowscroll = value;
    notifyListeners();
  }

  bool get getCrnSummarylinkUiShowScroll => crnSummarylinkUishowscroll;
  void setCrnSummarylinkShowScroll(bool value){
    crnSummarylinkUishowscroll = value;
    notifyListeners();
  }

  bool _crnSummarysearchvalue = false;
  bool _crnSummarylinksearchvalue = false;
  bool _crnSummarytextchangelistener = false;
  bool _crnSummarylinktextchangelistener = false;
  bool _showhidemicglow = false;
  bool _showhidelinkmicglow = false;

  bool get getcrnSummarySearchValue => _crnSummarysearchvalue;
  bool get getcrnSummarylinkSearchValue => _crnSummarylinksearchvalue;

  bool get getcrnSummarylinksearchValue => _crnSummarylinksearchvalue;

  bool get getchangetextlistener => _crnSummarytextchangelistener;
  bool get getchangelinktextlistener => _crnSummarylinktextchangelistener;

  bool get getshowhidemicglow => _showhidemicglow;
  bool get getshowhidelinkmicglow => _showhidelinkmicglow;

  void updateScreen(bool useraction){
    _crnSummarysearchvalue = useraction;
    notifyListeners();
  }

  void updatelinkScreen(bool useraction){
    _crnSummarylinksearchvalue = useraction;
    notifyListeners();
  }

  void updatetextchangeScreen(bool useraction){
    _crnSummarytextchangelistener = useraction;
    notifyListeners();
  }

  void updatelinktextchangeScreen(bool useraction){
    _crnSummarylinktextchangelistener = useraction;
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
    }
    ];
    return all;
  }

  // --- Railway Data ---
  List<CrnSummaryRlwData> get rlylistData => railwaylistData;
  void setrailwaylistData(List<CrnSummaryRlwData> rlylist) {
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

  // ---------CRN Summary Data -------
  List<CrnSmryData> get crnsummaryData => _crnsummaryitems;
  void setcrnSummaryData(List<CrnSmryData> crnsummarylist) {
    _crnsummaryitems = crnsummarylist;
  }
  CrnSummaryDataState get crnSummaryDataState => _crnSummaryDataState;
  void setcrnsummaryDataState(CrnSummaryDataState currentState) {
    _crnSummaryDataState = currentState;
    notifyListeners();
  }

  List<CrnsumrylinkData> get crnsummarylinkData => _crnsummarylinkitems;
  void setcrnSummarylinkData(List<CrnsumrylinkData> crnsummarylist) {
    _crnsummarylinkitems = crnsummarylist;
  }
  CrnSummarylinkDataState get crnSummaryDatalinkState => _crnSummarylinkDataState;
  void setcrnsummarylinkDataState(CrnSummarylinkDataState currentState) {
    _crnSummarylinkDataState = currentState;
    notifyListeners();
  }


  Future<void> getRailwaylistData(BuildContext context) async {
    setRlwStatusState(RailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<CrnSummaryRlwData>> data = CrnSummaryRepo.instance
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
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchUnit(
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
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchUnit(
            rly,
            prefs.getString('orgunittype'),
            prefs.getString('orgsubunit'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        _unitnameitems.clear();
        _consigneeitems.clear();
        setunitnamelistData(_all());
        setConsigneelistData(_all());
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
            // value.forEach((item) {
            //   if(item['intcode'].toString() == prefs.getString('orgunittype')){
            //     unittype = item['value'].toString();
            //     unittypecode = item['intcode'].toString();
            //   }
            //   else{
            //      unittype = "All";
            //      unittypecode = "-1";
            //   }
            // });
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
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchunitName(
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
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchunitName(
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
      Future<dynamic> data = CrnSummaryRepo.instance.def_depart_result(context);
      data.then((value) {
        print("All department...... $value");
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
        Future<dynamic> data = CrnSummaryRepo.instance.fetchConsignee(
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
        Future<dynamic> data = CrnSummaryRepo.instance.fetchConsignee(
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
    print("user depot value $userDepot");
    print("Sub consignee value ${prefs.getString('subconsigneecode')}");
    _subconsigneeitems.clear();
    if(userDepot == "" && prefs.getString('subconsigneecode') == "NA") {
      print("this is calling now1");
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      Future.delayed(Duration(milliseconds: 1000),() => setSubConsigneeStatusState(SubConsigneeDataState.Finished));
    }
    else if(userDepot == "" && prefs.getString('subconsigneecode') != "NA") {
      print("this is calling now2");
      try {
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchSubDepot(
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
      print("this is calling now3");
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      setSubConsigneeStatusState(SubConsigneeDataState.Finished);
    }
    else if(userDepot != "-1" && prefs.getString('subconsigneecode') != "NA") {
      print("this is calling now4");
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchSubDepot(
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
      print("this is calling now5");
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchSubDepot(
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
      print("this is calling now6");
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = CrnSummaryRepo.instance.def_fetchSubDepot(
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


  // ------- CRN Summary Data -------
  Future<void> getCrnSummaryData(String? fromdate, String? todate, String? rly, String? unittype, String? unitname, String? dept, String? consignee, String? subconsignee, BuildContext context) async{
    setcrnsummaryDataState(CrnSummaryDataState.Busy);
    setCrnSummaryShowScroll(false);
    openblnctotal = 0;
    newconsrcvdtotal = 0;
    signedcrnissuetotal = 0;
    crnpendingtotal = 0;
    seventotal = 0;
    seventofiftytotal = 0;
    fiftytothirtytotal = 0;
    morethirtytotal = 0;
    try{
      Future<List<CrnSmryData>> data = CrnSummaryRepo.instance.crnSummaryData(
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
          setcrnsummaryDataState(CrnSummaryDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setcrnSummaryData(value.toSet().toList());
          _duplicatecrnsummaryData = value;
          value.forEach((element) {
            openblnctotal = openblnctotal + int.parse(element.openbal!);
            newconsrcvdtotal = newconsrcvdtotal + int.parse(element.billreceived!);
            signedcrnissuetotal = signedcrnissuetotal + int.parse(element.billpassed!);
            crnpendingtotal = crnpendingtotal + int.parse(element.totalpending!);
            seventotal = seventotal + int.parse(element.pendsevendays!);
            seventofiftytotal = seventofiftytotal + int.parse(element.pendfifteendays!);
            fiftytothirtytotal = fiftytothirtytotal + int.parse(element.pendthirtydays!);
            morethirtytotal = morethirtytotal + int.parse(element.pendmorethirty!);
          });
          setcrnsummaryDataState(CrnSummaryDataState.Finished);
          setCrnSummaryShowScroll(true);
        }
        else {
          setcrnsummaryDataState(CrnSummaryDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      setcrnsummaryDataState(CrnSummaryDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }

  }

  Future<void> getCrnSummarylinkData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, String? actionname, BuildContext context) async{
    setcrnsummarylinkDataState(CrnSummarylinkDataState.Busy);
    setCrnSummarylinkShowScroll(false);
    try{
      if(actionname == "openBlnc"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummaryopenBlncData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.NoData);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
            setCrnSummarylinkShowScroll(true);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "conrecvd"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummaryconrcvdData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "crnissue"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummarycrnissueData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "closingblnc"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummarycloseblncData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "lessseven"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummarylessthnsevenData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "seventofifteen"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummaryseventofifteenData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "fifteentothirty"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummaryfifteentothirtyData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
      else if(actionname == "morethirty"){
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.crnSummarymorethirtyData(rly,consignee,subconsignee,fromdate,todate, context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setcrnSummarylinkData(value);
            _duplicatecrnsummarylinkitems = value;
            setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
          }
          else {
            setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
          }
        });
      }
    }
    on Exception catch (err) {
      setcrnsummarylinkDataState(CrnSummarylinkDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }


  // --- Searching on CRN Summary Data
  void searchingCRNSummaryData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      //NSDemandSummaryRepo nsDemandSummaryRepo = NSDemandSummaryRepo(context);
      try{
        Future<List<CrnSmryData>> data = CrnSummaryRepo.instance.fetchSearchCrnsummaryData(_duplicatecrnsummaryData, query);
        data.then((value) {
          setcrnSummaryData(value.toSet().toList());
          setcrnsummaryDataState(CrnSummaryDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setcrnSummaryData(_duplicatecrnsummaryData);
      setcrnsummaryDataState(CrnSummaryDataState.Finished);
    }
    else{
      setcrnSummaryData(_duplicatecrnsummaryData);
      setcrnsummaryDataState(CrnSummaryDataState.Finished);
    }
  }

  // ---- Searching on CRN Summary Link Data
  void searchingCRNSummarylinkData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      try{
        Future<List<CrnsumrylinkData>> data = CrnSummaryRepo.instance.fetchSearchCrnsummarylinkData(_duplicatecrnsummarylinkitems, query);
        data.then((value) {
          setcrnSummarylinkData(value.toSet().toList());
          setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setcrnSummarylinkData(_duplicatecrnsummarylinkitems);
      setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
    }
    else{
      setcrnSummarylinkData(_duplicatecrnsummarylinkitems);
      setcrnsummarylinkDataState(CrnSummarylinkDataState.Finished);
    }
  }
}