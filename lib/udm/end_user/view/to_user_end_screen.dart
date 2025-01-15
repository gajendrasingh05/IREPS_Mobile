import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/end_user/view/end_user_list_screen.dart';
import 'package:flutter_app/udm/end_user/view_models/to_end_user_view_model.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';


class ToEndUserScreen extends StatefulWidget {
  static const routeName = "/toend-user-screen";

  @override
  State<ToEndUserScreen> createState() => _ToEndUserScreenState();
}

class _ToEndUserScreenState extends State<ToEndUserScreen> {

  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ToEndUSerViewModel>(context, listen: false).getledgerNumData(context);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    ToEndUSerViewModel vieModel = Provider.of<ToEndUSerViewModel>(context, listen: false);
    vieModel.setLedgerNumState(LedgerNumberDataState.Idle);
    vieModel.setLedgerfolioNumState(LedgerfolioNumberDataState.Idle);
    vieModel.setLedgerfolioItemState(LedgerfolioitemDataState.Idle);
    vieModel.ledgernumvalue = "Ledger No.";
    vieModel.ledgerfolionumvalue = "Folio No.";
    vieModel.clearData();
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text(language.text('endusertitle'), style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(language.text('ledgerno'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<ToEndUSerViewModel>(builder: (context, value, child) {
                if(value.getledgernumState == LedgerNumberDataState.Busy) {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${language.text('selectledgernum')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ))
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      //selectedItem: value.getLedgerNumData[0].value,
                      popupProps: PopupPropsMultiSelection.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                        menuProps: MenuProps(
                            shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.grey), // You can customize the border color
                            )
                        ),
                      ),
                      // popupShape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                      //   borderRadius: BorderRadius.circular(5.0),
                      //   side: BorderSide(color: Colors.grey), // You can customize the border color
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            hintText: language.text('sln'),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10.0))
                      ),
                      items: (filter, loadProps) => value.getLedgerNumData.map((e) {
                        return "${e.intcode!.trim()}-${e.value.toString().trim()}";
                      }).toList(),
                      onChanged: (changedata) {
                        value.getLedgerNumData.forEach((element) {
                          if(changedata.toString().split("-")[1].trim() == element.value.toString().trim()){
                            value.ledgernumintcode = element.intcode.toString().trim();
                            value.ledgernumvalue = element.value.toString().trim();
                            Provider.of<ToEndUSerViewModel>(context, listen: false).setLedgerfolioItemState(LedgerfolioitemDataState.Idle);
                            Provider.of<ToEndUSerViewModel>(context, listen: false).ledgerfolionumvalue = "Folio No.";
                            Provider.of<ToEndUSerViewModel>(context, listen: false).getledgerfolioNumData(element.intcode.toString().trim(), context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('ledgerfolionum'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<ToEndUSerViewModel>(builder: (context, value, child) {
                if(value.getledgerfolionumState == LedgerfolioNumberDataState.Idle) {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${language.text('selectledgerfolionum')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          IconButton(onPressed: (){
                            if(value.ledgernumvalue!.trim() == "Ledger No."){
                              IRUDMConstants().showSnack(language.text('sln'), context);
                            }
                          },icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey.shade500))
                        ],
                      ),
                    ),
                  );
                }
                else if(value.getledgerfolionumState == LedgerfolioNumberDataState.Busy) {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${language.text('selectledgerfolionum')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ))
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      //selectedItem: value.getLedgerfolioNumData[0].value,
                      popupProps: PopupPropsMultiSelection.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                        menuProps: MenuProps(
                            shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.grey), // You can customize the border color
                            )
                        ),
                      ),
                      // popupShape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5.0),
                      //   side: BorderSide(color: Colors.grey), // You can customize the border color
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            hintText: language.text('slfn'),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10.0))
                      ),
                      items: (filter, loadProps) => value.getLedgerfolioNumData.map((e) {
                        return "${e.intcode!.trim()}-${e.value.toString().trim()}";
                      }).toList(),
                      onChanged: (changedata) {
                        value.getLedgerfolioNumData.forEach((element) {
                          if(changedata.toString().split("-")[1].trim() == element.value.toString().trim() || changedata.toString().split("-").last.trim() == element.value.toString().split("-").last.trim()){
                            value.ledgerfolionumvalue = element.value.toString().trim();
                            value.ledgerfolionumintcode = element.intcode.toString();
                            Provider.of<ToEndUSerViewModel>(context, listen: false).getledgerfolioItemData(value.ledgernumintcode!, element.intcode.toString().trim(), context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('ledgerfolioitem'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<ToEndUSerViewModel>(builder: (context, value, child) {
                if(value.getledgerfolioitemDataState == LedgerfolioitemDataState.Idle) {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${language.text('selectledgerfolioitem')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          IconButton(onPressed: (){
                            if(value.ledgerfolionumvalue!.trim() == "Folio No."){
                              IRUDMConstants().showSnack(language.text('slfn'), context);
                            }
                          },icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey.shade500))
                        ],
                      ),
                    ),
                  );
                }
                if(value.getledgerfolioitemDataState == LedgerfolioitemDataState.Busy) {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${language.text('selectledgerfolioitem')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ))
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      //selectedItem: value.getLedgerfolioNumData[0].value,
                      popupProps: PopupPropsMultiSelection.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                        menuProps: MenuProps(
                            shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.grey), // You can customize the border color
                            )
                        ),
                      ),
                      // popupShape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                      //   borderRadius: BorderRadius.circular(5.0),
                      //   side: BorderSide(color: Colors.grey), // You can customize the border color
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            hintText: language.text('slfi'),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10.0))
                      ),
                      items: (filter, loadProps) => value.getLedgerfolioItemData.map((e) {
                        return "${e.intcode!.trim()}-${e.value.toString().trim()}";
                      }).toList(),
                      onChanged: (changedata) {
                        value.getLedgerfolioItemData.forEach((element) {
                          if(changedata.toString().split("-")[1].trim() == element.value.toString().trim() || changedata.toString().split("-").last.trim() == element.value.toString().split("-").last.trim()){
                            value.ledgerfolioitemvalue = element.value.toString().trim();
                            value.ledgerfolioitemintcode = element.intcode.toString().trim();
                            //Provider.of<ToEndUSerViewModel>(context, listen: false).getledgerfolioItemData(value.ledgernumintcode!, element.intcode.toString().trim(), context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('endusersearch'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: language.text('lficid'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00008B), width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusColor: Colors.red[300],
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value){},
              ),
              SizedBox(height: 20),
              Consumer<ToEndUSerViewModel>(builder: (context, value, child){
                return Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton (
                            height: 45,
                            minWidth: size.width * 0.45,
                            child: Text(language.text('searchbtn')),
                            shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                            onPressed: () {
                              if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline){
                                UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
                              }
                              else{
                                if(searchController.text.trim().isNotEmpty) {
                                  // PageRouteBuilder(
                                  //   pageBuilder: (context, animation, secondaryAnimation) => EndUserScreen(value.ledgernumintcode, value.ledgerfolionumintcode, value.ledgerfolioitemintcode, searchController.text.trim()))),
                                  //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  //     return fromRight(animation, secondaryAnimation, child);
                                  //   },
                                  // );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EndUserScreen(value.ledgernumintcode, value.ledgerfolionumintcode, value.ledgerfolioitemintcode, searchController.text.trim())));
                                }
                                else{
                                  if(value.ledgerfolioitemintcode == null){
                                    IRUDMConstants().showSnack(language.text('asir'), context);
                                  }
                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EndUserScreen(value.ledgernumintcode, value.ledgerfolionumintcode, value.ledgerfolioitemintcode, searchController.text.trim())));
                                  }
                                }
                              }
                            }, color: Colors.blue, textColor: Colors.white),
                        MaterialButton (
                            height: 45,
                            minWidth: size.width * 0.45,
                            child: Text(language.text('exit')),
                            shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                            onPressed: () {
                              Navigator.pop(context);
                            }, color: Colors.red, textColor: Colors.white),
                      ],
                    )
                );
              }),
            ],
          ),
        ),
      ),
    ), onWillPop: _onWillPop);
  }
}
