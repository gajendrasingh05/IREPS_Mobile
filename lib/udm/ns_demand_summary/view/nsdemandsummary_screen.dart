import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/localization/english.dart';
import 'package:flutter_app/udm/ns_demand_summary/models/railwaylistdata.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/nsdemanddatasummary_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view_model/NSDemandSummaryViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NSDemandSummaryScreen extends StatefulWidget {
  static const routeName = "/ns-demand-screen";

  @override
  State<NSDemandSummaryScreen> createState() => _NSDemandSummaryScreenState();
}

class _NSDemandSummaryScreenState extends State<NSDemandSummaryScreen> {

  String? rlyname = "All";
  String? rlycode = "-1";

  String? unittype = "All";
  String? unittypecode = "-1";

  String? unitname = "All";
  String? unitnamecode = "-1";

  String? departmentname = "All";
  String? departmentcode = "-1";

  String? consignee = "All";
  String? consigneecode = "-1";

  String? indentor = "All";
  String? indentorName = "All";
  String? indentorcode = "-1";

  String fromdate = "";
  String todate = "";

  String? dropDownValue;
  String? railway;

  ScrollController listScrollController = ScrollController();

  final _demandnoController = TextEditingController();
  final _itemdecController = TextEditingController();

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
    IRUDMConstants.showProgressIndicator(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime frdate = DateTime.now().subtract(const Duration(days: 366));
    DateTime tdate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    fromdate = formatter.format(frdate);
    todate = formatter.format(tdate);
    await Provider.of<NSDemandSummaryViewModel>(context, listen: false).getRailwaylistData(context);
    await Provider.of<NSDemandSummaryViewModel>(context, listen: false).getUnitTypeData("", context);
    await Provider.of<NSDemandSummaryViewModel>(context, listen: false).getUnitNameData("","", context);
    await Provider.of<NSDemandSummaryViewModel>(context, listen: false).getDepartment(context);
    await Provider.of<NSDemandSummaryViewModel>(context, listen: false).getConsignee("","","","", context);
    Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(prefs.getString('userzone'),prefs.getString('orgsubunit'),prefs.getString('adminunit'),
        prefs.getString('orgunittype'),prefs.getString('consigneecode'), context).then((value) => value == true ? IRUDMConstants.removeProgressIndicator(context) : IRUDMConstants.showProgressIndicator(context));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(language.text('nsdemandtitle'), style: TextStyle(color: Colors.white)),
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
                Text(language.text('nsdatefrom'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'FromDate',
                  initialDate: DateTime.now().subtract(const Duration(days: 366)),
                  initialValue: DateTime.now().subtract(const Duration(days: 366)),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue){
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    fromdate = formatter.format(datevalue!);
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
                Text(language.text('nsdateto'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'ToDate',
                  initialDate: DateTime.now(),
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue){
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    todate = formatter.format(datevalue!);
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
                Text(language.text('nsdrailway'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child) {
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
                        items: (filter, loadProps) => value.railwaylistData.map((e) {
                          return e.value.toString().trim();
                        }).toList(),
                        onChanged: (changedata) {
                          value.railwaylistData.forEach((element) {
                            if(changedata.toString() == element.value.toString()){
                              value.railway = element.value.toString().trim();
                              value.rlyCode = element.intcode.toString();
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getUnitTypeData(value.rlyCode, context);
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(value.rlyCode,value.deptcode,value.unitnamecode,value.unittypecode,value.consigneecode, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('nsdunittype'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child) {
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
                              print("onChange unit type code ${value.unittypecode}");
                              await Provider.of<NSDemandSummaryViewModel>(context, listen: false).getUnitNameData(value.rlyCode, value.unittypecode, context);
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getConsignee(value.rlyCode, value.deptcode, value.unittypecode, value.unitnamecode, context);
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(value.rlyCode,value.deptcode,value.unitnamecode,value.unittypecode,value.consigneecode, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('nsdunitname'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child) {
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
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(value.rlyCode,value.deptcode,value.unitnamecode,value.unittypecode,value.consigneecode, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('nsddepartment'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child) {
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
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        items: (filter, loadProps) => value.departmentlistData.map((e) {
                          return e['value'].toString().trim();
                        }).toList(),
                        onChanged: (changedata) {
                          value.departmentlistData.forEach((element) {
                            if(changedata.toString() == element['value'].toString()){
                              departmentname = element['value'].toString().trim();
                              value.deptcode = element['intcode'].toString();
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getConsignee(value.rlyCode, value.deptcode, value.unittypecode, value.unitnamecode, context);
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(value.rlyCode,value.deptcode,value.unitnamecode,value.unittypecode,value.consigneecode, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('nsdconsignee'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child) {
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
                        items: (filter, loadProps) => value.consigneelistData.map((item) {
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
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(value.rlyCode,value.deptcode,value.unitnamecode,value.unittypecode,value.consigneecode, context);
                            }
                            if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                                consignee = changedata.toString();
                                value.consigneecode = element['intcode'].toString();
                                Provider.of<NSDemandSummaryViewModel>(context, listen: false).getIndentor(value.rlyCode,value.deptcode,value.unitnamecode,value.unittypecode,value.consigneecode, context);
                            }
                            // if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                            //   print("if change value $changedata");
                            //   consignee = changedata.toString();
                            //   value.consigneecode = element['intcode'].toString();
                            //   return;
                            // }
                            // else{
                            //   print("else change value $changedata");
                            //   consignee = "All";
                            //   value.consigneecode = "-1";
                            // }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('nsdindentor'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child) {
                  if(value.indentordatastatus == IndentorDataState.Busy) {
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
                            Text("${language.text('selectindentor')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: DropdownSearch<String>(
                        //mode: Mode.DIALOG,
                        //showSearchBox: true,
                        selectedItem: value.indentor,
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
                        items: (filter, loadProps) => value.indentorlistData.map((item) {
                          if(item.username.toString().trim() == "All"){
                            return item.username.toString().trim();
                          }
                          else{
                            return item.desig.toString()+"-"+item.username.toString().trim();
                          }
                        }).toList(),
                        onChanged: (changedata) {
                          value.indentorlistData.forEach((element) {
                            if(changedata.toString() == "All"){
                              value.indentor = "All";
                              value.indentorName = "All";
                              value.indentorcode = "-1";
                            }
                            if(changedata.toString() == element.desig.toString()+"-"+element.username.toString()){
                              value.indentor = element.desig.toString()+"-"+element.username.toString();
                              value.indentorName = element.username.toString().trim();
                              value.indentorcode = element.postid.toString();
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 20),
                Consumer<NSDemandSummaryViewModel>(builder: (context, value, child){
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
                               child: Text(language.text('nsdsubmit')),
                               shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                               onPressed: () {
                                 print("$fromdate+$todate+${value.rlyCode}+${value.unittypecode}+${value.unitnamecode}+${value.deptcode}+${value.consigneecode}${value.indentorcode}+${value.indentorName}");
                                 if(value.indentorName == "All"){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandDataSummaryScreen(fromdate, todate, value.rlyCode, value.unittypecode, value.unitnamecode, value.deptcode, value.consigneecode, value.indentorcode, "-1")));
                                 }
                                 else{
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandDataSummaryScreen(fromdate, todate, value.rlyCode, value.unittypecode, value.unitnamecode, value.deptcode, value.consigneecode, value.indentorcode, value.indentorName)));
                                 }
                               }, color: Colors.blue, textColor: Colors.white),
                           MaterialButton (
                               height: 45,
                               minWidth: size.width * 0.45,
                               child: Text(language.text('reset')),
                               shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                               onPressed: () {
                                 getInitData();
                                 //Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandDataSummaryScreen(fromdate, todate, rlycode, unittypecode, unitnamecode, departmentcode, consigneecode, indentorcode)));
                               }, color: Colors.red, textColor: Colors.white),
                         ],
                       )
                   );
                }),
              ]
          ),
        ),
      ),
    );
  }
}
