import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/warranty_crn_summary/view/warranty_crn_summary_data_screen.dart';
import 'package:flutter_app/udm/warranty_crn_summary/view_models/warrantycrnsummary_viewmodel.dart';
import 'package:provider/provider.dart';
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


class WarrantyCRNSummaryScreen extends StatefulWidget {
  static const routeName = "/warrantycrn-summary-screen";


  @override
  State<WarrantyCRNSummaryScreen> createState() => _WarrantyCRNSummaryScreenState();
}

class _WarrantyCRNSummaryScreenState extends State<WarrantyCRNSummaryScreen> {

  String wcfromdate = "";
  String wctodate = "";
  String rfromdate = "";
  String rtodate = "";

  String? departmentname = "All";
  String? departmentcode = "-1";

  String? consignee = "All";
  String? consigneecode = "-1";

  String? subconsignne = "All";
  String? subconsignnecode = "-1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getInitData();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getInitData();
    });
  }

  Future<void> getInitData() async{
    //IRUDMConstants.showProgressIndicator(context);
    DateTime frdate = DateTime.now().subtract(const Duration(days: 92));
    DateTime tdate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    wcfromdate = formatter.format(frdate);
    wctodate = formatter.format(tdate);
    rfromdate = formatter.format(frdate);
    rtodate = formatter.format(tdate);
    await Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getRailwaylistData(context);
    await Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getUnitTypeData("", context);
    await Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getUnitNameData("","", context);
    await Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getDepartment(context);
    await Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getConsignee("","","","", context);
    await Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getSubConsignee("","","","", "", context);
  }

  Future<bool> _onWillPop() async {
    WarrantyCrnSummaryViewModel vieModel = Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false);
    // vieModel.setLedgerNumState(LedgerNumberDataState.Idle);
    // vieModel.setLedgerfolioNumState(LedgerfolioNumberDataState.Idle);
    // vieModel.setLedgerfolioItemState(LedgerfolioitemDataState.Idle);
    // vieModel.ledgernumvalue = "Ledger No.";
    // vieModel.ledgerfolionumvalue = "Folio No.";
    // vieModel.clearData();
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
          title: Text(language.text('erstitle'), style: TextStyle(color: Colors.white)),
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
              Text(language.text('wcfd'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'FromDate',
                initialDate: DateTime.now().subtract(const Duration(days: 92)),
                initialValue: DateTime.now().subtract(const Duration(days: 92)),
                inputType: InputType.date,
                format: DateFormat('dd-MM-yyyy'),
                onChanged: (datevalue){
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  wcfromdate = formatter.format(datevalue!);
                  //value.checkdateDiff(fromdate, todate, formatter, context);
                  //_checkdateDiff(formatter.format(value!), todate, formatter);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsetsDirectional.all(10),
                  suffixIcon: Icon(Icons.calendar_month),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                  //border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(language.text('wct'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'ToDate',
                initialDate: DateTime.now(),
                initialValue: DateTime.now(),
                inputType: InputType.date,
                format: DateFormat('dd-MM-yyyy'),
                onChanged: (datevalue){
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  wctodate = formatter.format(datevalue!);
                  //value.checkdateDiff(fromdate, todate, formatter, context);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsetsDirectional.all(10),
                  suffixIcon: Icon(Icons.calendar_month),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                  //border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(language.text('wcsrcptdatefrom'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'FromDate',
                initialDate: DateTime.now().subtract(const Duration(days: 92)),
                initialValue: DateTime.now().subtract(const Duration(days: 92)),
                inputType: InputType.date,
                format: DateFormat('dd-MM-yyyy'),
                onChanged: (datevalue){
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  rfromdate = formatter.format(datevalue!);
                  //value.checkdateDiff(fromdate, todate, formatter, context);
                  //_checkdateDiff(formatter.format(value!), todate, formatter);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsetsDirectional.all(10),
                  suffixIcon: Icon(Icons.calendar_month),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                  //border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(language.text('wrcrcptdateto'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'ToDate',
                initialDate: DateTime.now(),
                initialValue: DateTime.now(),
                inputType: InputType.date,
                format: DateFormat('dd-MM-yyyy'),
                onChanged: (datevalue){
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  rtodate = formatter.format(datevalue!);
                  //value.checkdateDiff(fromdate, todate, formatter, context);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsetsDirectional.all(10),
                  suffixIcon: Icon(Icons.calendar_month),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                  //border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(language.text('wrcrly'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.rlydatastatus == RailwayDataState.Busy) {
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
                          Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                } else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      selectedItem: value.railway,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10))
                      ),
                      items:(filter, loadProps) => value.railwaylistData.map((e) {
                        return e.value.toString().trim();
                      }).toList(),
                      onChanged: (changedata) {
                        value.railwaylistData.forEach((element) {
                          if(changedata.toString() == element.value.toString()){
                            value.railway = element.value.toString().trim();
                            value.rlyCode = element.intcode.toString();
                            //Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getUnitTypeData(value.rlyCode, context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('wrcunittype'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.unittypedatastatus == UnittypeDataState.Busy) {
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
                          Text("${language.text('selectunittype')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          Container(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.0))
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 45,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      selectedItem: value.unittype,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10))
                      ),
                      items: (filter, loadProps) => value.unittypelistData.map((item) {
                        return item['value'].toString().trim();
                      }).toList(),
                      onChanged: (changedata) {
                        value.unittypelistData.forEach((element) async{
                          if(changedata.toString() == element['value'].toString()){
                            value.unittype = element['value'].toString().trim();
                            value.unittypecode = element['intcode'].toString();
                            //await Provider.of<CrnSummaryViewModel>(context, listen: false).getUnitNameData(value.rlyCode, value.unittypecode, context);
                            //Provider.of<CrnSummaryViewModel>(context, listen: false).getConsignee(value.rlyCode, value.deptcode, value.unittypecode, value.unitnamecode, context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('wrcunitname'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.unitnamedatastatus == UnitnameDataState.Busy) {
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
                          Text("${language.text('selectunitname')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                } else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      selectedItem: value.unitname,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                         decoration: InputDecoration(
                             enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(12),
                                 borderSide: BorderSide.none),
                             contentPadding: EdgeInsets.only(left: 10))
                      ),
                      // items: value.railwaylistData.map((item) {
                      //   return DropdownMenuItem(child: Text(item.value.toString().trim()), value: item.intcode.toString());
                      // }).toList(),
                      items: (filter, loadProps) => value.unitnamelistData.map((e) {
                        return e['value'].toString().trim();
                      }).toList(),
                      onChanged: (changedata) {
                        value.unitnamelistData.forEach((element) {
                          if(changedata.toString() == element['value'].toString()){
                            value.unitname = element['value'].toString().trim();
                            value.unitnamecode = element['intcode'].toString();
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('wrcslctdepart'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.departmentdatastatus == DepartmentDataState.Busy) {
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
                          Text("${language.text('selectdept')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                } else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showSelectedItems: true,
                      selectedItem: value.department,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10)),
                      ),
                      items:(filter, loadProps) => value.departmentlistData.map((e) {
                        return e['value'].toString().trim();
                      }).toList(),
                      onChanged: (changedata) {
                        value.departmentlistData.forEach((element) {
                          if(changedata.toString() == element['value'].toString()){
                            departmentname = element['value'].toString().trim();
                            value.deptcode = element['intcode'].toString();
                            Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getConsignee(value.rlyCode, value.deptcode, value.unittypecode, value.unitnamecode, context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('wrcslctuserdepo'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.condatastatus == ConsigneeDataState.Busy) {
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
                          Text("${language.text('selectcon')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                } else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      selectedItem: value.consignee.length > 35 ? value.consignee.substring(0, 32) : value.consignee,
                      //showSelectedItems: true,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10))
                      ),
                      items: (filter, loadProps) =>  value.consigneelistData.map((item) {
                        if(item['value'].toString().trim() == "All"){
                          return item['value'].toString().trim();
                        }
                        else{
                          return item['intcode'].toString()+"-"+item['value'].toString().trim();
                        }
                      }).toList(),
                      onChanged: (changedata) {
                        value.consigneelistData.forEach((element) {
                          if(changedata.toString() == "All"){
                            consignee = "All";
                            value.consigneecode = "-1";
                            //Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getSubConsignee(value.rlyCode, value.deptcode, value.unittypecode, value.unitnamecode, value.consigneecode, context);
                          }
                          if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                            consignee = changedata.toString();
                            value.consigneecode = element['intcode'].toString();
                            //Provider.of<WarrantyCrnSummaryViewModel>(context, listen: false).getSubConsignee(value.rlyCode, value.deptcode, value.unittypecode, value.unitnamecode, value.consigneecode, context);
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('wrcsubcons'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.subconsigneedatastatus == SubConsigneeDataState.Busy) {
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
                          Text("${language.text('selectsubcons')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.0))
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 45,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      selectedItem: value.subconsignee,
                      //showSelectedItems: true,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10))
                      ),
                      items:(filter, loadProps) => value.subconsigneeData.map((item) {
                        if(item['value'].toString().trim() == "All"){
                          return item['value'].toString().trim();
                        }
                        else{
                          return item['intcode'].toString()+"-"+item['value'].toString().trim();
                        }
                      }).toList(),
                      onChanged: (changedata) {
                        value.subconsigneeData.forEach((element) {
                          if(changedata.toString() == "All"){
                            subconsignne = "All";
                            value.subconsigneecode = "-1";
                          }
                          if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                            subconsignne = changedata.toString();
                            value.subconsigneecode = element['intcode'].toString();
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              Text(language.text('wrcvendor'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child) {
                if(value.subconsigneedatastatus == SubConsigneeDataState.Busy) {
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
                          Text("${language.text('selectsubcons')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                          Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.0))
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 45,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      selectedItem: value.subconsignee,
                      //showSelectedItems: true,
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
                      //   side: BorderSide(color: Colors.grey),
                      // ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10))
                      ),
                      items: (filter, loadProps) => value.subconsigneeData.map((item) {
                        if(item['value'].toString().trim() == "All"){
                          return item['value'].toString().trim();
                        }
                        else{
                          return item['intcode'].toString()+"-"+item['value'].toString().trim();
                        }
                      }).toList(),
                      onChanged: (changedata) {
                        value.subconsigneeData.forEach((element) {
                          if(changedata.toString() == "All"){
                            subconsignne = "All";
                            value.subconsigneecode = "-1";
                          }
                          if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                            subconsignne = changedata.toString();
                            value.subconsigneecode = element['intcode'].toString();
                          }
                        });
                      },
                    ),
                  );
                }
              }),
              SizedBox(height: 20),
              Consumer<WarrantyCrnSummaryViewModel>(builder: (context, value, child){
                return Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            height: 45,
                            minWidth: size.width * 0.45,
                            child: Text(language.text('nsdsubmit')),
                            shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyCrnSummaryDataScreen(wcfromdate, wctodate, value.railway, value.rlyCode, value.unittype, value.unittypecode, value.unitname, value.unitnamecode, value.department, value.deptcode, value.consignee, value.consigneecode, value.subconsignee, value.subconsigneecode)));
                            }, color: Colors.blue, textColor: Colors.white),
                        MaterialButton (
                            height: 45,
                            minWidth: size.width * 0.45,
                            child: Text(language.text('reset')),
                            shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                            onPressed: (){
                              getInitData();
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => CrnSummaryDataScreen(fromdate, todate, rlycode, unittypecode, unitnamecode, departmentcode, consigneecode, subconsignnecode)));
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
