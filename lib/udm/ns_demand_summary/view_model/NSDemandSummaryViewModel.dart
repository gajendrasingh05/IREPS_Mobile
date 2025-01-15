import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/IndentorData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/NSDemandSummaryData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/NSDemandlinkData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/NSDemandtotallinkData.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/railwaylistdata.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/change_nsdscroll_visibility_provider.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/search_nsdscreen_provider.dart';
import 'package:flutter_app/udm/ns_demand_summary/repo/NSDemandSummaryRepo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RailwayDataState {Idle, Busy, Finished, FinishedWithError}
enum UnittypeDataState {Idle, Busy, Finished, FinishedWithError}
enum UnitnameDataState {Idle, Busy, Finished, FinishedWithError}
enum DepartmentDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeDataState {Idle, Busy, Finished, FinishedWithError}
enum IndentorDataState {Idle, Busy, Finished, FinishedWithError}

enum NSDemandDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum NSDemandDatalinkState {Idle, Busy, Finished, NoData, FinishedWithError}
enum NSDemandDatatotallinkState {Idle, Busy, Finished, NoData, FinishedWithError}

class NSDemandSummaryViewModel with ChangeNotifier {

  RailwayDataState _rlwDataState = RailwayDataState.Idle;
  UnittypeDataState _unittypeDataState = UnittypeDataState.Idle;
  UnitnameDataState _unitnameDataState = UnitnameDataState.Idle;
  DepartmentDataState _departmentDataState = DepartmentDataState.Idle;
  ConsigneeDataState _consigneeDataState = ConsigneeDataState.Idle;
  IndentorDataState _indentorDataState = IndentorDataState.Idle;

  NSDemandDataState _nsDemandDataState = NSDemandDataState.Idle;
  NSDemandDatalinkState _nsDemandDatalinkState = NSDemandDatalinkState.Idle;
  NSDemandDatatotallinkState _nsDemandDatatotallinkState = NSDemandDatatotallinkState.Idle;

  List<dynamic> _consigneeitems = [];
  List<dynamic> _unittypeitems = [];
  List<dynamic> _unitnameitems = [];
  List<dynamic> _departmentitems = [];
  List<IndentorNameData> _indentoritems = [];

  List<NSDmdSummaryData> _nsDemandlistData = [];
  List<NSDmdSummaryData> _duplicatensdmditems = [];

  List<NSlinkData> _nsDemandlinkData = [];
  List<NSlinkData> _duplicatensDemandlinkData = [];

  List<TotallinkData> _nsDemandtotallinkData = [];
  List<TotallinkData> _duplicatensDemandtotallinkData = [];

  List<RlwData> railwaylistData = [];

  int total = 0;
  int draft = 0;
  int ufc = 0;
  int ufv = 0;
  int underprc = 0;
  int appfwdpur = 0;
  int rbypurunit = 0;
  int drpped = 0;

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

  String indentor = "All";
  String indentorName = "All";
  String indentorcode = "-1";

  // --- Railway Data ---
  List<RlwData> get rlylistData => railwaylistData;

  void setrailwaylistData(List<RlwData> rlylist) {
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

  // --- Indentor Data ---
  List<IndentorNameData> get indentorlistData => _indentoritems;

  void setindentorlistData(List<IndentorNameData> indentorlist) {
    _indentoritems = indentorlist;
  }

  IndentorDataState get indentordatastatus => _indentorDataState;

  void setIndentorStatusState(IndentorDataState currentState) {
    _indentorDataState = currentState;
    notifyListeners();
  }

  // ---------  NS Demand List Data ---------
  List<NSDmdSummaryData> get nslistData => _nsDemandlistData;

  void setnsdemandlistData(List<NSDmdSummaryData> nslist) {
    _nsDemandlistData = nslist;
  }

  NSDemandDataState get nsDataState => _nsDemandDataState;

  void setNSDemandState(NSDemandDataState currentState) {
    _nsDemandDataState = currentState;
    notifyListeners();
  }

  // ---------  NS DemandLink List Data ---------
  List<NSlinkData> get nslinklistData => _nsDemandlinkData;
  void setnsdemandlinklistData(List<NSlinkData> nslist) {
    _nsDemandlinkData = nslist;
  }

  NSDemandDatalinkState get nslinkDataState => _nsDemandDatalinkState;
  void setNSDemandlinkState(NSDemandDatalinkState currentState) {
    _nsDemandDatalinkState = currentState;
    notifyListeners();
  }

  // ---------  NS DemandLink Total List Data ---------
  List<TotallinkData> get nstotallinklistData => _nsDemandtotallinkData;
  void setnsdemandtotallinklistData(List<TotallinkData> nslist) {
    _nsDemandtotallinkData = nslist;
  }

  NSDemandDatatotallinkState get nstotallinkDataState => _nsDemandDatatotallinkState;
  void setNSDemandtotallinkState(NSDemandDatatotallinkState currentState) {
    _nsDemandDatatotallinkState = currentState;
    notifyListeners();
  }

  void setexpandtotal(bool expandvalue) {
    expand = expandvalue;
    notifyListeners();
  }

  bool get expandvalue => expand;

  _all() {
    var all = [{
      'intcode': '-1',
      'value': 'All',
    }
    ];
    return all;
  }

  Future<void> getRailwaylistData(BuildContext context) async {
    setRlwStatusState(RailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<RlwData>> data = NSDemandSummaryRepo.instance
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _unittypeitems.clear();
    if (rly == "") {
      try {
        Future<dynamic> data = NSDemandSummaryRepo.instance.def_fetchUnit(
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
        Future<dynamic> data = NSDemandSummaryRepo.instance.def_fetchUnit(
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

        data.then((value) {
          setConStatusState(ConsigneeDataState.Finished);
          setUnitnameStatusState(UnitnameDataState.Finished);
          setDepartmentStatusState(DepartmentDataState.Finished);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _unitnameitems.clear();
    try {
      if (unittype == "") {
        print("Blank currently");
        Future<dynamic> data = NSDemandSummaryRepo.instance.def_fetchunitName(
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
        Future<dynamic> data = NSDemandSummaryRepo.instance.def_fetchunitName(
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
    setUnittypeStatusState(UnittypeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _departmentitems.clear();
    try {
      Future<dynamic> data = NSDemandSummaryRepo.instance.def_depart_result(
          context);
      data.then((value) {
        print("All department...... $value");
        if (value.isEmpty || value.length == 0) {
          setDepartmentStatusState(DepartmentDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
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
    if (unittype == "" && unitname == "" &&
        prefs.getString('consigneecode') == "NA") {
      consignee = "All";
      consigneecode = "-1";
      setConsigneelistData(_all());
      setConStatusState(ConsigneeDataState.Finished);
    }
    else if (unittype == "" && unitname == "" &&
        prefs.getString('consigneecode') != "NA") {
      try {
        Future<dynamic> data = NSDemandSummaryRepo.instance.fetchConsignee(
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
              if (item['intcode'].toString() == "-1") {
                consignee = item['value'].toString();
                consigneecode = item['intcode'].toString();
              }
              else {
                consignee =
                    item['intcode'].toString() + "-" + item['value'].toString();
                consigneecode = item['intcode'].toString();
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
        Future<dynamic> data = NSDemandSummaryRepo.instance.fetchConsignee(
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

  Future<bool> getIndentor(String? userzone, String? dept, String? unitname, String? unittype, String? consignee, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setIndentorStatusState(IndentorDataState.Busy);
    indentor = "All";
    print("indentor input $userzone~$dept~$unittype~$unitname~$consignee");
    try{
      Future<List<IndentorNameData>> data = NSDemandSummaryRepo.instance.fetchIndentorData('Indentor_List', "$userzone~$dept~$unittype~$unitname~$consignee", prefs.getString('token'), context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setindentorlistData(value);
          setIndentorStatusState(IndentorDataState.FinishedWithError);
          return false;
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setindentorlistData(value);
          //indentor = value[0]['username'].toString();
          setIndentorStatusState(IndentorDataState.Finished);
          return true;
        }
        else{
          setIndentorStatusState(IndentorDataState.FinishedWithError);
          return false;
        }
      });
    }
    on Exception catch(err){
      setIndentorStatusState(IndentorDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return true;
  }

  Future<void> getNSDemandData(String? fromdate, String? todate, String? rly, String? unittype, String? unitname, String? dept, String? consignee, String? indentorname,String? indentorcode, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setNSDemandState(NSDemandDataState.Busy);
    Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDShowScroll(false);
    Provider.of<SearchNSDScreenProvider>(context, listen: false).updateScreen(false);
    total = 0;
    draft = 0;
    ufc = 0;
    ufv = 0;
    underprc = 0;
    appfwdpur = 0;
    rbypurunit = 0;
    drpped = 0;
    try{
      Future<List<NSDmdSummaryData>> data = NSDemandSummaryRepo.instance.fetchNsdmdsummaryData('NS_Demand_Summary',fromdate,todate,rly, unittype, unitname, dept, consignee, indentorcode,indentorname,context);
      //Future<List<NSDmdSummaryData>> data = nsDemandSummaryRepo.fetchNsdmdsummaryData('NS_Demand_Summary',fromdate,todate,prefs.getString('userzone'), unittype, unitname, dept, consignee, indentor,context);
      //Future<List<NSDmdSummaryData>> data = nsDemandSummaryRepo.fetchNsdmdsummaryData('NS_Demand_Summary',"09-11-2022","09-02-2023",prefs.getString('userzone'), "-1", "-1", "-1", "-1", "-1",context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setnsdemandlistData(value);
          setNSDemandState(NSDemandDataState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setnsdemandlistData(value);
          _duplicatensdmditems = value;
          value.forEach((element) {
               total = total + int.parse(element.total!);
               draft = draft + int.parse(element.draft!);
               ufc = ufc + int.parse(element.underfinanceconcurrence!);
               ufv = ufv + int.parse(element.underfinancevetting!);
               underprc = underprc + int.parse(element.underprocess!);
               appfwdpur = appfwdpur + int.parse(element.approved!);
               rbypurunit = rbypurunit + int.parse(element.returned!);
               drpped = drpped + int.parse(element.dropped!);
          });

          Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDShowScroll(true);
          setNSDemandState(NSDemandDataState.Finished);
        }
        else{
          setNSDemandState(NSDemandDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setNSDemandState(NSDemandDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getNSDemandlinkData(indentorPostId,indentorName,total,draft,underFinanceConcurrence,underFinanceVetting,
      underProcess,approvedForwardPurchase,returnedByPurchase,dropped,frmDate,toDate, BuildContext context) async{
    setNSDemandlinkState(NSDemandDatalinkState.Busy);
    Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(false);
    Provider.of<SearchNSDScreenProvider>(context, listen: false).updatelinkScreen(false);
    try{
      Future<List<NSlinkData>> data = NSDemandSummaryRepo.instance.fetchNsdmdlinksummaryData('HyperLinkQuery',indentorPostId,indentorName,total,draft,underFinanceConcurrence,underFinanceVetting,underProcess,approvedForwardPurchase,returnedByPurchase,dropped,frmDate,toDate,context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setnsdemandlinklistData(value);
          setNSDemandlinkState(NSDemandDatalinkState.FinishedWithError);
        }
        else if(value.isNotEmpty || value.length != 0){
          setnsdemandlinklistData(value);
          _duplicatensDemandlinkData = value;
          _duplicatensDemandlinkData.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
          setNSDemandlinkState(NSDemandDatalinkState.Finished);
        }
        else{
          setNSDemandlinkState(NSDemandDatalinkState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setNSDemandlinkState(NSDemandDatalinkState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getNSDemandTotallinkData(String? orgZone,String? unitType,String? unitName,String? department,String? indentorPostId,
      String? consCode,String? indentorNameStr,String? total,String? draft,String? underFinanceConcurrence,String? underFinanceVetting,String? underProcess,
      String? approvedForwardPurchase,String? returnedByPurchase,String? dropped,String? frmDate,String? toDate, BuildContext context) async{
    setNSDemandtotallinkState(NSDemandDatatotallinkState.Busy);
    Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(false);
    Provider.of<SearchNSDScreenProvider>(context, listen: false).updatelinkScreen(false);
    try{
      Future<List<TotallinkData>> data = NSDemandSummaryRepo.instance.fetchNsdmdtotallinksummaryData('Total_HyperLinkQuery',orgZone,unitType,unitName,department,indentorPostId,consCode,indentorNameStr,total,draft,underFinanceConcurrence,underFinanceVetting,underProcess,
          approvedForwardPurchase,returnedByPurchase,dropped,frmDate,toDate,context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setnsdemandtotallinklistData(value);
          setNSDemandtotallinkState(NSDemandDatatotallinkState.FinishedWithError);
        }
        else if(value.isNotEmpty || value.length != 0){
          setnsdemandtotallinklistData(value);
          _duplicatensDemandtotallinkData = value;
          _duplicatensDemandlinkData.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
          setNSDemandtotallinkState(NSDemandDatatotallinkState.Finished);
        }
        else{
          setNSDemandtotallinkState(NSDemandDatatotallinkState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setNSDemandtotallinkState(NSDemandDatatotallinkState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void searchingNSDMD(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      //NSDemandSummaryRepo nsDemandSummaryRepo = NSDemandSummaryRepo(context);
      try{
        Future<List<NSDmdSummaryData>> data = NSDemandSummaryRepo.instance.fetchSearchNsdmdsummaryData(_duplicatensdmditems, query);
        data.then((value) {
          setnsdemandlistData(value);
          setNSDemandState(NSDemandDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setnsdemandlistData(_duplicatensdmditems);
      setNSDemandState(NSDemandDataState.Finished);
    }
    else{
      setnsdemandlistData(_duplicatensdmditems);
      setNSDemandState(NSDemandDataState.Finished);
    }
  }

  void searchingNSDMDlink(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(false);
      try{
        Future<List<NSlinkData>> data = NSDemandSummaryRepo.instance.fetchSearchNsdmdsummarylinkData(_duplicatensDemandlinkData, query);
        data.then((value) {
          setnsdemandlinklistData(value);
          value.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
          setNSDemandlinkState(NSDemandDatalinkState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setnsdemandlinklistData(_duplicatensDemandlinkData);
      _duplicatensDemandlinkData.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
      setNSDemandlinkState(NSDemandDatalinkState.Finished);
    }
    else{
      setnsdemandlinklistData(_duplicatensDemandlinkData);
      _duplicatensDemandlinkData.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
      setNSDemandlinkState(NSDemandDatalinkState.Finished);
    }
  }

  void searchingNSDMDtotallink(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(false);
      try{
        Future<List<TotallinkData>> data = NSDemandSummaryRepo.instance.fetchSearchNsdmdsummarytotallinkData(_duplicatensDemandtotallinkData, query);
        data.then((value) {
          setnsdemandtotallinklistData(value);
          value.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
          setNSDemandtotallinkState(NSDemandDatatotallinkState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      setnsdemandtotallinklistData(_duplicatensDemandtotallinkData);
      _duplicatensDemandtotallinkData.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
      setNSDemandtotallinkState(NSDemandDatatotallinkState.Finished);
    }
    else{
      setnsdemandtotallinklistData(_duplicatensDemandtotallinkData);
      _duplicatensDemandtotallinkData.length > 2 ? Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true) : SizedBox();
      setNSDemandtotallinkState(NSDemandDatatotallinkState.Finished);
    }
  }

}