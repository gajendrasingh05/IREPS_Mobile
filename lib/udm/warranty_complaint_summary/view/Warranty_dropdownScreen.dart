import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_DeatilsScreen.dart';
import 'package:provider/provider.dart';
import '../../helpers/shared_data.dart';
import '../../providers/languageProvider.dart';
import '../provider/search.dart';
import '../view_model/WarrantyCompaint_ViewModel.dart';

class WarrantyComplaintDropdown extends StatefulWidget {
  static const routeName = "/WarrantyComplaintDropdown-screen";

  @override
  State<WarrantyComplaintDropdown> createState() => _WarrantyComplaintDropdownState();
}

class _WarrantyComplaintDropdownState extends State<WarrantyComplaintDropdown> {

  String complaintsource = "All";
  String complaintsourcecode = "-1";

  String? rlyname = "All";
  String? rlycode = "-1";

  String? rlyname1 = "All";
  String? rlycode1 = "-1";

  String? consignee = "All";
  String? consigneecode = "-1";

  String? consignee1 = "All";
  String? consigneecode1 = "-1";

  String fromdate = "";
  String todate = "";

  ScrollController listScrollController = ScrollController();

  final _demandnoController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DateTime frdate = DateTime.now().subtract(const Duration(days: 182));
      DateTime tdate = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      fromdate = formatter.format(frdate);
      todate = formatter.format(tdate);
      Provider.of<WarrantyComplaintViewModel>(context, listen: false).getComplaintSourceData(context);
      Provider.of<WarrantyComplaintViewModel>(context, listen: false).getRailwaylistData(context);
      Provider.of<WarrantyComplaintViewModel>(context, listen: false).getConsigneeComplaint("","",context);

    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar:  AppBar(
        backgroundColor: Colors.red[300],
        leading: IconButton(
          splashRadius: 30,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(language.text('warrantycomsum'), style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        name: 'FromDate',
                        initialDate: DateTime.now().subtract(const Duration(days: 182)),
                        initialValue: DateTime.now().subtract(const Duration(days: 182)),
                        inputType: InputType.date,
                        format: DateFormat('dd-MM-yyyy'),
                        onChanged: (datevalue){
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');
                          fromdate = formatter.format(datevalue!);
                        },
                        decoration: InputDecoration(
                          labelText: language.text('cfrom'),
                          contentPadding: EdgeInsetsDirectional.all(10),
                          suffixIcon: Icon(Icons.calendar_month),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        name: 'ToDate',
                        initialDate: DateTime.now(),
                        initialValue: DateTime.now(),
                        inputType: InputType.date,
                        format: DateFormat('dd-MM-yyyy'),
                        onChanged: (datevalue){
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');
                          todate = formatter.format(datevalue!);
                        },
                        decoration: InputDecoration(
                          labelText: language.text('cto'),
                          contentPadding: EdgeInsetsDirectional.all(10),
                          suffixIcon: Icon(Icons.calendar_month),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(language.text('nsdrailway'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 8),
                Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
                  if(value.rlydatastatus == RailListDataState.Busy) {
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
                              Provider.of<WarrantyComplaintViewModel>(context, listen: false).getConsigneeComplaint(value.rlyCode!, "", context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 15),
                Text(language.text('ccodegencom'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 8),
                Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
                  if(value.condatastatus == ConsigneeComplaintDataState.Busy) {
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
                            }
                            if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                              consignee = changedata.toString();
                              value.consigneecode = element['intcode'].toString();
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
                SizedBox(height: 15),
                Text(language.text('rlc'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 8),
                Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
                  if(value.rlydatastatus == RailListDataState.Busy) {
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
                        selectedItem: rlyname,
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
                        // selectedItem: value.railway,
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
                              rlycode1 = element.intcode.toString();
                              value.rlyCode1 = element.intcode.toString();
                              Provider.of<WarrantyComplaintViewModel>(context, listen: false).getConsigneeLodgeclaim(value.rlyCode1!, "", context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 15),
                Text(language.text('concodelc'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 8),
                Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
                  if(value.conlodgedatastatus == ConsigneeLodgeDataState.Busy) {
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
                        //showSelectedItems: true,
                        selectedItem: consignee1,
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
                        items: (filter, loadProps) => value.consigneelodgelistData.map((item) {
                          if(item['value'].toString().trim() == "All"){
                            return item['value'].toString().trim();
                          }
                          else{
                            return item['intcode'].toString()+"-"+item['value'].toString().trim();
                          }
                        }).toList(),
                        onChanged: (changedata) {
                          value.consigneelodgelistData.forEach((element) {
                            if(changedata.toString() == "All"){
                              consignee = "All";
                              value.consigneecode = "-1";
                              consigneecode1 = element['intcode'].toString();
                            }
                            if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                              consignee = changedata.toString();
                              value.consigneelodgecode = element['intcode'].toString();
                              consigneecode1 = element['intcode'].toString();
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
                SizedBox(height: 15),
                Text(language.text('csource'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 8),
                Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
                  if(value.complaintSourcestate == ComplaintSourceDataState.Busy) {
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
                            Text("${language.text('selectsts')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                        selectedItem: complaintsource,
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
                        items: (filter, loadProps) => value.complaintSourceitemstate.map((e) {
                          return e.complaintsourcename.toString().trim();
                        }).toList(),
                        onChanged: (changedata) {
                          value.complaintSourceitemstate.forEach((element) {
                            if(changedata.toString() == element.complaintsourcename.toString()){
                              complaintsource = element.complaintsourcename.toString().trim();
                              complaintsourcecode = element.complaintsourcename.toString();
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 20),
                Consumer<WarrantyComplaintViewModel>(builder: (context, value, child){
                  return Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 50,
                          width: 160,
                          child: OutlinedButton(
                            style: IRUDMConstants.bStyle(),
                            onPressed: (){
                              // print("1. ${value.rlyCode!}");
                              // print("2. ${value.consigneecode!}");
                              // print("3. ${rlycode1!}");
                              // print("4. ${consigneecode1!}");
                              // print("5. ${complaintsourcecode}");
                              // print("6. ${fromdate}");
                              // print("7. ${todate}");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyDeatilsScreen(
                                  value.rlyCode!,value.consigneecode!, rlycode1!, consigneecode1!,complaintsourcecode, fromdate, todate)));
                            },
                            child: Text(language.text('submit'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[300],
                                )),
                          ),
                        ),
                        Container(
                          width: 160,
                          height: 50,
                          child: OutlinedButton(
                            style: IRUDMConstants.bStyle(),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context, PageRouteBuilder(
                                pageBuilder: (_, __, ___) => WarrantyComplaintDropdown(),
                                transitionDuration: const Duration(seconds: 0),
                              ),
                              );
                            },
                            child: Text(
                                language.text('reset'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[300],
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ]),
        ),
      ),
    );
  }
}
