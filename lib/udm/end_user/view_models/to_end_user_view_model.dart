import 'package:flutter_app/udm/end_user/models/checkverification.dart';
import 'package:flutter_app/udm/end_user/models/enduser_list_data.dart';
import 'package:flutter_app/udm/end_user/models/ledgerfolioitemData.dart';
import 'package:flutter_app/udm/end_user/models/ledgerfolionumData.dart';
import 'package:flutter_app/udm/end_user/models/ledgernumData.dart';
import 'package:flutter_app/udm/end_user/models/voucher_list_data.dart';
import 'package:flutter_app/udm/end_user/repo/toenduser_repo.dart';
import 'package:flutter_app/udm/end_user/view/issuetouser_screen.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LedgerNumberDataState {Idle, Busy, Finished, FinishedWithError}
enum LedgerfolioNumberDataState {Idle, Busy, Finished, FinishedWithError}
enum LedgerfolioitemDataState {Idle, Busy, Finished, FinishedWithError}

enum EndUserDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum VoucherDataState {Idle, Busy, Finished, NoData, FinishedWithError}

enum VerificationDataState {Idle, Busy, Finished, NoData, FinishedWithError}

class ToEndUSerViewModel with ChangeNotifier{

  LedgerNumberDataState _ledgerNumberDataState = LedgerNumberDataState.Idle;
  LedgerfolioNumberDataState _ledgerfolioNumberDataState = LedgerfolioNumberDataState.Idle;
  LedgerfolioitemDataState _ledgerfolioitemDataState = LedgerfolioitemDataState.Idle;

  // ------ End User Data ---------
  EndUserDataState _endUserDataState = EndUserDataState.Idle;
  List<EndUserlist> _enduserData = [];

  // ------- user Voucher Data ---------
  VoucherDataState _endUservoucherDataState = VoucherDataState.Idle;
  List<Voucherlist> _enduservoucherData = [];

  //---------- verification Data ------
  VerificationDataState _verificationDataState = VerificationDataState.Idle;
  List<VerificationData> _enduserverifiData = [];

  List<LedgerNumData> _ledgernumitems = [];
  String? ledgernumintcode;
  String? ledgernumvalue = "Ledger No.";
  List<LedgerfolioNumData> _ledgerfolionumitems = [];
  String? ledgerfolionumintcode;
  String? ledgerfolionumvalue = "Folio No.";
  List<LedgerfolioItemData> _ledgerfolioitems = [];
  String? ledgerfolioitemintcode;
  String? ledgerfolioitemvalue = "Ledger Folio PL No.";

  bool _endusersearchvalue = false;
  bool _endusertextchangelistener = false;
  bool _showhidemicglow = false;

  Widget usercheckwidget = SizedBox();



  //Issue Type Selection
  String _selectedIssueType = 'Returnable';
  String get getissuetype => _selectedIssueType;
  void updateIssueType(String issuetype){
    _selectedIssueType = issuetype;
    notifyListeners();
  }

  //Asset Type Selection
  String _selectedAssettype = 'Others';
  String get getassettype => _selectedAssettype;
  void updateAssetType(String assettype){
    _selectedAssettype = assettype;
    notifyListeners();
  }

  //Issue Qty calculation
  int _issueQty = 0;
  int get getIssueQty => _issueQty;
  void calculateIssueQty(String qty){
     _issueQty = _issueQty+int.parse(qty);
     notifyListeners();
  }

  bool get getendusersearchValue => _endusersearchvalue;
  void updateendusersearchScreen(bool useraction){
    _endusersearchvalue = useraction;
    notifyListeners();
  }

  bool get getchangetextlistener => _endusertextchangelistener;

  bool get getshowhidemicglow => _showhidemicglow;

  bool enduserUishowscroll = false;
  bool enduserUiscrollValue = false;

  void updatetextchangeScreen(bool useraction){
    _endusertextchangelistener = useraction;
    notifyListeners();
  }

  void showhidemicglow(bool useraction){
    _showhidemicglow = useraction;
    notifyListeners();
  }


  Widget get getUpdateWidget => usercheckwidget;
  void updateWidget(String value){
    if(value.isEmpty) {
      usercheckwidget = SizedBox();
      notifyListeners();
    }
    else{
      final number = int.tryParse(value);
      number != null && number > 95 ? usercheckwidget = Container(height: 40, width: 40, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: Icon(Icons.clear, color: Colors.white)) : Container(height: 40, width: 40, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),child: Icon(Icons.check, color: Colors.white));
      notifyListeners();
    }
  }



  //--- End User Screen UI ----
  bool get getendUserUiScrollValue => enduserUiscrollValue;
  void setEndUserScrollValue(bool value){
    enduserUiscrollValue = value;
    notifyListeners();
  }

  bool get getendUserUiShowScroll => enduserUishowscroll;
  void setendUserShowScroll(bool value){
    enduserUishowscroll = value;
    notifyListeners();
  }

  LedgerNumberDataState get getledgernumState => _ledgerNumberDataState;
  void setLedgerNumState(LedgerNumberDataState state){
    _ledgerNumberDataState = state;
    notifyListeners();
  }
  List<LedgerNumData> get getLedgerNumData => _ledgernumitems;
  void setLedgerNumData(List<LedgerNumData> value){
    _ledgernumitems = value;
    notifyListeners();
  }

  LedgerfolioNumberDataState get getledgerfolionumState => _ledgerfolioNumberDataState;
  void setLedgerfolioNumState(LedgerfolioNumberDataState state){
    _ledgerfolioNumberDataState = state;
    notifyListeners();
  }
  List<LedgerfolioNumData> get getLedgerfolioNumData => _ledgerfolionumitems;
  void setLedgerfolioNumData(List<LedgerfolioNumData> value){
    _ledgerfolionumitems = value;
    notifyListeners();
  }

  LedgerfolioitemDataState get getledgerfolioitemDataState => _ledgerfolioitemDataState;
  void setLedgerfolioItemState(LedgerfolioitemDataState state){
    _ledgerfolioitemDataState = state;
    notifyListeners();
  }
  List<LedgerfolioItemData> get getLedgerfolioItemData => _ledgerfolioitems;
  void setLedgerfolioItemData(List<LedgerfolioItemData> value){
    _ledgerfolioitems = value;
    notifyListeners();
  }

  //------ End User Data ------
  EndUserDataState get getEndUserDataState => _endUserDataState;
  void setEndUserDataState(EndUserDataState state){
    _endUserDataState = state;
    notifyListeners();
  }
  List<EndUserlist> get getEndUserData => _enduserData;
  void setEndUserData(List<EndUserlist> value){
    _enduserData = value;
    notifyListeners();
  }

  //------ End User Voucher Data ------
  VoucherDataState get getVoucherDataState => _endUservoucherDataState;
  void setVoucherDataState(VoucherDataState state){
    _endUservoucherDataState = state;
    notifyListeners();
  }
  List<Voucherlist> get getVoucherData => _enduservoucherData;
  void setVoucherData(List<Voucherlist> value){
    _enduservoucherData = value;
    notifyListeners();
  }

  //------------- Issue Verification --------------

  VerificationDataState get getVerificationDataState => _verificationDataState;
  void setVerificationDataState(VerificationDataState state){
    _verificationDataState = state;
    notifyListeners();
  }
  List<VerificationData> get getVerifiData => _enduserverifiData;
  void setVerifiData(List<VerificationData> value){
    _enduserverifiData = value;
    //notifyListeners();
  }

  Future<void> getledgerNumData(BuildContext context) async {
    setLedgerNumState(LedgerNumberDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<LedgerNumData>> data = ToEndUserRepo.instance.fetchLedgerNumberData(prefs.getString('userzone'), prefs.getString('consigneecode'), prefs.getString('subconsigneecode'),context);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setLedgerNumState(LedgerNumberDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setLedgerNumData(value);
          value.forEach((item) {
            // if (item.intcode.toString() == prefs.getString('userzone')) {
            //   railway = item.value.toString();
            //   rlyCode = item.intcode.toString();
            // }
          });
          setLedgerNumState(LedgerNumberDataState.Finished);
        }
        else {
          setLedgerNumState(LedgerNumberDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getledgerfolioNumData(String? ledgerNum, BuildContext context) async {
    setLedgerfolioNumState(LedgerfolioNumberDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<LedgerfolioNumData>> data = ToEndUserRepo.instance.fetchLedgerfolioNumberData(prefs.getString('userzone'), prefs.getString('consigneecode'), prefs.getString('subconsigneecode'), ledgerNum!, context);
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setLedgerfolioNumState(LedgerfolioNumberDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0) {
          setLedgerfolioNumData(value);
          value.forEach((item) {
              //railway = item.value.toString();
              //rlyCode = item.intcode.toString();
          });
          setLedgerfolioNumState(LedgerfolioNumberDataState.Finished);
        }
        else {
          setLedgerfolioNumState(LedgerfolioNumberDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getledgerfolioItemData(String? ledgerNum, String? folioNum, BuildContext context) async {
    setLedgerfolioItemState(LedgerfolioitemDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Future<List<LedgerfolioItemData>> data = ToEndUserRepo.instance.fetchLedgerfolioItemData(prefs.getString('userzone'), prefs.getString('consigneecode'), prefs.getString('subconsigneecode'), ledgerNum!, folioNum!, context);
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setLedgerfolioItemState(LedgerfolioitemDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0) {
          setLedgerfolioItemData(value);
          value.forEach((item) {
            //railway = item.value.toString();
            //rlyCode = item.intcode.toString();
          });
          setLedgerfolioItemState(LedgerfolioitemDataState.Finished);
        }
        else {
          setLedgerfolioItemState(LedgerfolioitemDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  // --------------- End User Screen Data --------------------

  Future<void> getenduserlistData(BuildContext context, String ledgerNum, String folioNum, String folioitem) async{
    setEndUserDataState(EndUserDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("rail ${prefs.getString('userzone')}");
    print("cons ${prefs.getString('consigneecode')}");
    print("subcons ${prefs.getString('subconsigneecode')}");
    try{
      Future<List<EndUserlist>> data = ToEndUserRepo.instance.fetchEndUserlistData(context, "Item_List", "99~36640~00~002~0001~75900191~");
      //Future<List<EndUserlist>> data = ToEndUserRepo.instance.fetchEndUserlistData(context, "Item_List", "${prefs.getString('userzone')}~${prefs.getString('consigneecode')}~${prefs.getString('subconsigneecode')}~$ledgerNum~$folioNum~$folioitem~");
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setEndUserDataState(EndUserDataState.NoData);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0) {
          setEndUserData(value);
          setEndUserDataState(EndUserDataState.Finished);
        }
        else {
          setEndUserDataState(EndUserDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getenduservoucherlistData(BuildContext context) async{
    setVoucherDataState(VoucherDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("rail ${prefs.getString('userzone')}");
    print("cons ${prefs.getString('consigneecode')}");
    print("subcons ${prefs.getString('subconsigneecode')}");
    try{
      Future<List<Voucherlist>> data = ToEndUserRepo.instance.fetchEndUserVoucherlistData(context, "Voucher_List", "99~36640~75900191~2097");
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setEndUserDataState(EndUserDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setVoucherData(value);
          setVoucherDataState(VoucherDataState.Finished);
        }
        else {
          setVoucherDataState(VoucherDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  //--------------- Issue Verification ----------------
  Future<void> checkVerification(BuildContext context, String ledgerKey, EndUserlist list) async{
    setVerificationDataState(VerificationDataState.Busy);
    try {
      Future<List<VerificationData>> data = ToEndUserRepo.instance.fetchVerificationData(context,"on_selection_check_pending_verification", ledgerKey);
      data.then((value) {
        if (value.isEmpty || value.length == 0) {
          setVerificationDataState(VerificationDataState.NoData);
          //IRUDMConstants().showSnack('Data not found.', context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => IssueToEndUserScreen(
              "${list.ledgerNo.toString()}:${list.ledgerName.toString()}",
              "${list.ledgerFolioNo.toString()}:${list.ledgerFolioName.toString()}",
              "${list.itemCode.toString()}",
              "${list.itemDesc.toString()}",
              "${list.stkQty.toString()}",
              "${list.unitDes.toString()}",
              "${list.rate.toString()}",
              "${list.stkVal.toString()}"
          )));
        }
        else if (value.isNotEmpty || value.length != 0) {
          setVerifiData(value);
          setVerificationDataState(VerificationDataState.Finished);
          showInformation(value, context);
        }
        else {
          setVerificationDataState(VerificationDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      setVerificationDataState(VerificationDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);

    }
  }

  void showInformation(List<VerificationData> data, BuildContext context){
    LanguageProvider language = Provider.of<LanguageProvider>(context, listen: false);
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Card(
          elevation: 2.0,
          color: Colors.white,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0, top: 15.0),
            child: Column(
              children: [
                Text("${data[0].pendingAt}.", style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(child: Text(language.text('endok'), style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.normal)), onPressed: (){Navigator.pop(context);}, style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    side: BorderSide(color: Colors.white, width: 2),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.normal),
                  )),
                )
              ],
            ),
          ),
        ),
      );
    });
  }


  void clearData() {
    _ledgernumitems = [];
    ledgernumintcode = null;
    ledgernumvalue = "Ledger No.";
    _ledgerfolionumitems = [];
    ledgerfolionumintcode = null;
    ledgerfolionumvalue = "Folio No.";
    _ledgerfolioitems = [];
    ledgerfolioitemintcode = null;
    ledgerfolioitemvalue = "Ledger Folio PL No.";

    _endusersearchvalue = false;
    _endusertextchangelistener = false;
    _showhidemicglow = false;

    notifyListeners(); // Notify listeners to update UI
  }
}