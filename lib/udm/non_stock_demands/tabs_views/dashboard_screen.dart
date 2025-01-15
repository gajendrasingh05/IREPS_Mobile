import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/non_stock_demands/tabs_views/dashboard_list_screen.dart';
import 'package:flutter_app/udm/non_stock_demands/view_model/non_stock_demand_view_model.dart';
import 'package:flutter_app/udm/non_stock_demands/views/non_stock_demands_screen.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  String status = "All";
  String statuscode = "-1";

  String indentor = "All";
  String indentorcode = "-1";

  String consignee = "All";
  String consigneecode = "-1";

  String fromdate = "";
  String todate = "";

  ScrollController listScrollController = ScrollController();

  final _demandnoController = TextEditingController();
  final _itemdecController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getInitData();
    });
  }

  Future<void> getInitData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DateTime frdate = DateTime.now().subtract(const Duration(days: 92));
      DateTime tdate = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      fromdate = formatter.format(frdate);
      todate = formatter.format(tdate);
      Provider.of<NonStockDemandViewModel>(context, listen: false).getStatusData(context);
      Provider.of<NonStockDemandViewModel>(context, listen: false).getIndentor(prefs.getString('userzone'),prefs.getString('orgsubunit'),prefs.getString('adminunit'),
          prefs.getString('orgunittype'),prefs.getString('consigneecode'), context);
      Provider.of<NonStockDemandViewModel>(context, listen: false).getConsigneeData(context);
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
  void didUpdateWidget(covariant DashBoardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
       //key: _scaffoldKey,
       body: Container(
         height: size.height,
         width: size.width,
         padding: EdgeInsets.all(10.0),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Text(language.text('status'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
               SizedBox(height: 10),
               Consumer<NonStockDemandViewModel>(builder: (context, value, child) {
                 if(value.statusstate == StatusDataState.Busy) {
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
                       //showFavoriteItems: true,
                       selectedItem: status,
                       popupProps: PopupPropsMultiSelection.menu(
                         showSearchBox: true,
                         title: Text(status),
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
                       //hint: status,
                       // favoriteItems: (val) {
                       //   return [status];
                       // },
                       decoratorProps: DropDownDecoratorProps(
                         decoration: InputDecoration(
                             enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(12),
                                 borderSide: BorderSide.none),
                             contentPadding: EdgeInsets.only(left: 10))
                       ),
                       items: (filter, loadProps) => value.statusitems.map((e) {
                         return e.statusname.toString().trim();
                       }).toList(),
                       onChanged: (changedata) {
                         value.statusitems.forEach((element) {
                           if(changedata.toString() == element.statusname.toString()){
                             status = element.statusname.toString().trim();
                             statuscode = element.statusvalue.toString();
                           }
                         });
                       },
                     ),
                   );
                 }
               }),
               SizedBox(height: 10),
               Text(language.text('demandno'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
               SizedBox(height: 10),
               Container(
                 height: 45,
                 alignment: Alignment.center,
                 child: TextField(
                   controller: _demandnoController,
                   decoration: InputDecoration(
                     border: InputBorder.none,
                     hintText: language.text('demandno'),
                     focusColor: Colors.grey,
                     focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                   ),
                 ),
               ),
               SizedBox(height: 10),
               Text(language.text('indentor'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
               SizedBox(height: 10),
               Consumer<NonStockDemandViewModel>(builder: (context, value, child) {
                 if(value.indentorState == IndentorState.Busy) {
                   return Container(
                     height: 45,
                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), border: Border.all(color: Colors.grey, width: 1)),
                     alignment: Alignment.center,
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("${language.text('selectindentor')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                           Container(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.0))
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
                       //showFavoriteItems: true,
                       selectedItem: indentor,
                       //showSelectedItems: true,
                       popupProps: PopupPropsMultiSelection.menu(
                         showSearchBox: true,
                         //title: Text(status),
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
                       // favoriteItems: (val) {
                       //   return [indentor];
                       // },
                       decoratorProps: DropDownDecoratorProps(
                         decoration: InputDecoration(
                             enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(12),
                                 borderSide: BorderSide.none),
                             contentPadding: EdgeInsets.only(left: 10))
                       ),
                       items: (filter, loadProps) => value.indentoritems.map((e) {
                         return e.username.toString().trim();
                       }).toList(),
                       onChanged: (changedata) {
                         value.indentoritems.forEach((element) {
                           if(changedata.toString() == element.username.toString()){
                             indentor = element.username.toString();
                             indentorcode = element.postid.toString();
                           }
                         });
                       },
                     ),
                   );
                 }
               }),
               SizedBox(height: 10),
               Text(language.text('consignee'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
               SizedBox(height: 10),
               Consumer<NonStockDemandViewModel>(builder: (context, value, child) {
                 if(value.cosigneestate == ConsigneeDataState.Busy) {
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
                           Text("${language.text('selectcons')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                       selectedItem: consignee,
                       popupProps: PopupPropsMultiSelection.menu(
                         showSearchBox: true,
                         //title: Text(status),
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
                       // favoriteItems: (val) {
                       //   return [consignee];
                       // },
                       decoratorProps: DropDownDecoratorProps(
                         decoration: InputDecoration(
                             enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(12),
                                 borderSide: BorderSide.none),
                             contentPadding: EdgeInsets.only(left: 10))
                       ),
                       items: (filter, loadProps) => value.consigneeitems.map((e) {
                         return e.intcode.toString().trim() + '-' + e.value.toString().trim();
                       }).toList(),
                       onChanged: (changedata) {
                            value.consigneeitems.forEach((element) {
                             if(changedata.toString().split('-').first.toString() == element.intcode.toString()){
                              consignee = element.value.toString();
                              consigneecode = element.intcode.toString();
                           }
                         });
                       },
                     ),
                   );
                 }
               }),
               SizedBox(height: 10),
               Text(language.text('dmddtfrom'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
               SizedBox(height: 10),
               FormBuilderDateTimePicker(
                 name: 'FromDate',
                 initialDate: DateTime.now().subtract(const Duration(days: 92)),
                 initialValue: DateTime.now().subtract(const Duration(days: 92)),
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
               Text(language.text('dmddtto'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
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
               Text(language.text('itemdesc'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
               SizedBox(height: 10),
               Container(
                 height: 45,
                 alignment: Alignment.center,
                 child: TextField(
                   decoration: InputDecoration(
                     border: InputBorder.none,
                     hintText: language.text('itemdesc'),
                     focusColor: Colors.grey,
                     focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                   ),
                   controller: _itemdecController,
                 ),
               ),
               SizedBox(height: 20),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 mainAxisSize: MainAxisSize.max,
                 children: [
                   SizedBox(
                     width: size.width/2.3,
                     height: 45,
                     child: MaterialButton(
                         child: Text(language.text('proceed')),
                         shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black12)),
                         onPressed: (){
                           if(_demandnoController.text.length == 0){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardDataScreen(status, statuscode, " ", indentor, indentorcode, consignee, consigneecode, fromdate, todate, _itemdecController.text.trim())));
                           }
                           else{
                             Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardDataScreen(status, statuscode, _demandnoController.text.trim(), indentor, indentorcode, consignee, consigneecode, fromdate, todate, _itemdecController.text.trim())));
                           }

                     }, color: Colors.blue, textColor: Colors.white),
                   ),
                   SizedBox(
                     width: size.width/2.3,
                     height: 45,
                     child: MaterialButton(
                         child: Text(language.text('reset')),
                         shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black12)),
                         onPressed: () {
                           Navigator.pushReplacement(
                             context,
                             PageRouteBuilder(
                               pageBuilder: (_, __, ___) => NonStockDemandsScreen(),
                               transitionDuration: const Duration(seconds: 0),
                             ),
                           );
                           //Navigator.push(context, MaterialPageRoute(builder: (context) => NonStockDemandsScreen()));
                         }, color: Colors.red, textColor: Colors.white),
                   ),
                 ],
               )]),
         ),
       ),
    );
  }
}
