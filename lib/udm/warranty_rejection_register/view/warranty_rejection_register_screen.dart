import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view/rejection_advice_register_screen.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view/warranty_rejection_register_list_screen.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view_model/warranty_rejection_register_view_model.dart';
import 'package:provider/provider.dart';

class WarrantyRejectionRegisterScreen extends StatefulWidget {
  static const routeName = "/warranty-rejection-register-screen";

  @override
  State<WarrantyRejectionRegisterScreen> createState() => _WarrantyRejectionRegisterScreenState();
}

class _WarrantyRejectionRegisterScreenState extends State<WarrantyRejectionRegisterScreen> {

  String fromdate = "";
  String todate = "";

  String? departmentname = "All";
  String? departmentcode = "-1";

  String? consignee = "All";
  String? consigneecode = "-1";

  String? subconsignne = "All";
  String? subconsigneecode = "-1";

  final searchvendorController = TextEditingController();
  final searchController = TextEditingController();

  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero,() async{
      await getInitData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getInitData() async{
    //IRUDMConstants.showProgressIndicator(context);
    DateTime frdate = DateTime.now().subtract(const Duration(days: 180));
    DateTime tdate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    fromdate = formatter.format(frdate);
    todate = formatter.format(tdate);
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setOptionsValue("all");
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setTxnOptionsValue("warrejreg");
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getRailwaylistData(context);
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getDepartment(context);
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getConsignee("", context);
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getSubConsignee("","","", context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text(language.text('wrrtitle'), style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Consumer<WarrantyRejectionRegisterViewModel>(builder: ((context, providervalue, child) {
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Text(language.text('wcfp'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 FormBuilderDateTimePicker(
                   name: 'FromDate',
                   initialDate: DateTime.now().subtract(const Duration(days: 180)),
                   initialValue: DateTime.now().subtract(const Duration(days: 180)),
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
                 Text(language.text('pt'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
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
                 Text(language.text('txntype'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     RadioListTile(
                       contentPadding: EdgeInsets.zero,
                       title: Text(language.text('rejadvreg')),
                       value: "rejadvreg",
                       groupValue: providervalue.getTxntypeOption,
                       onChanged: (value){
                         providervalue.setTxnOptionsValue(value.toString());
                         if(providervalue.getWrrOption == "all"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "A")));
                         }
                         else if(providervalue.getWrrOption == "pendingrcr"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "P")));
                         }
                         else if(providervalue.getWrrOption == "nilrcr"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "N")));
                         }
                         else if(providervalue.getWrrOption == "rtrvendor"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "V")));
                         }
                       },
                     ),
                     RadioListTile(
                       contentPadding: EdgeInsets.zero,
                       title: Text(language.text('warrejreg')),
                       value: "warrejreg",
                       groupValue: providervalue.getTxntypeOption,
                       onChanged: (value){
                         providervalue.setTxnOptionsValue(value.toString());
                         if(providervalue.getWrrOption == "all") {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(providervalue.rlyCode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "A")));
                         }
                         else if(providervalue.getWrrOption == "pendingrcr"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(providervalue.rlyCode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "P")));
                         }
                         else if(providervalue.getWrrOption == "nilrcr"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(providervalue.rlyCode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "N")));
                         }
                         else if(providervalue.getWrrOption == "rtrvendor"){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(providervalue.rlyCode, providervalue.consigneecode, providervalue.subconsigneecode,
                               fromdate, todate, searchController.text, searchvendorController.text, "V")));
                         }
                       },
                     ),
                   ],
                 ),
                 SizedBox(height: 10),
                 Text(language.text('stksummaryrly'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, value, child) {
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
                               Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getConsignee(value.rlyCode, context);
                             }
                           });
                         },
                       ),
                     );
                   }
                 }),
                 SizedBox(height: 10),
                 Text(language.text('slctdepart'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, value, child) {
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
                                 )
                             )
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
                               Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getConsignee(value.rlyCode,context);
                               Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getSubConsignee(value.rlyCode,value.consigneecode, value.deptcode, context);
                             }
                           });
                         },
                       ),
                     );
                   }
                 }),
                 SizedBox(height: 10),
                 Text(language.text('slctuserdepo'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, value, child) {
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
                         // popupShape: RoundedRectangleBorder(
                         //   borderRadius: BorderRadius.circular(5.0),
                         //   side: BorderSide(color: Colors.grey),
                         // ),
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
                               Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getSubConsignee(value.rlyCode,value.consigneecode, value.deptcode, context);
                             }
                             if(changedata.toString() == element['intcode'].toString().trim()+"-"+element['value'].toString().trim()){
                               consignee = changedata.toString();
                               value.consigneecode = element['intcode'].toString();
                               Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getSubConsignee(value.rlyCode,value.consigneecode, value.deptcode, context);
                             }
                           });
                         },
                       ),
                     );
                   }
                 }),
                 SizedBox(height: 10),
                 Text(language.text('subcons'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, value, child) {
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
                 SizedBox(height: 10),
                 Text(language.text('sv'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 TextFormField(
                   controller: searchvendorController,
                   decoration: InputDecoration(
                     contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 1.0),
                     focusedBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     hintText: language.text('svhint'),
                     //errorText: _autoValidate ? language.text('plNoErrorText') : null,
                     floatingLabelBehavior: FloatingLabelBehavior.auto,
                   ),
                 ),
                 SizedBox(height: 10),
                 Text(language.text('wrrsearch'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 TextFormField(
                   controller: searchController,
                   decoration: InputDecoration(
                     contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 1.0),
                     focusedBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     hintText: language.text('shint'),
                     //errorText: _autoValidate ? language.text('plNoErrorText') : null,
                     floatingLabelBehavior: FloatingLabelBehavior.auto,
                   ),
                 ),
                 SizedBox(height: 10),
                 Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, pvalue, child){
                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       RadioListTile(
                         contentPadding: EdgeInsets.zero,
                         title: Text(language.text('wrrall')),
                         value: "all",
                         groupValue: providervalue.getWrrOption,
                         onChanged: (value){
                           providervalue.setOptionsValue(value.toString());
                           if(providervalue.getTxntypeOption == "warrejreg"){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(pvalue.rlyCode, pvalue.consigneecode, pvalue.subconsigneecode,
                                 fromdate, todate, searchController.text, searchvendorController.text, "A")));
                           }
                           else{
                             Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                 fromdate, todate, searchController.text, searchvendorController.text, "A")));
                           }
                         },
                       ),
                       RadioListTile(
                         contentPadding: EdgeInsets.zero,
                         title: Text(language.text('wrrpenr')),
                         value: "pendingrcr",
                         groupValue: providervalue.getWrrOption,
                         onChanged: (value){
                           providervalue.setOptionsValue(value.toString());
                           if(providervalue.getTxntypeOption == "warrejreg"){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(pvalue.rlyCode, pvalue.consigneecode, pvalue.subconsigneecode,fromdate,
                                 todate, searchController.text, searchvendorController.text, "P")));
                           }
                           else{
                             Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                 fromdate, todate, searchController.text, searchvendorController.text, "P")));
                           }
                         },
                       ),
                       RadioListTile(
                         contentPadding: EdgeInsets.zero,
                         title: Text(language.text('wrrnilrcr')),
                         value: "nilrcr",
                         groupValue: providervalue.getWrrOption,
                         onChanged: (value){
                           providervalue.setOptionsValue(value.toString());
                           if(providervalue.getTxntypeOption == "warrejreg"){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(pvalue.rlyCode, pvalue.consigneecode, pvalue.subconsigneecode,fromdate,
                                 todate, searchController.text, searchvendorController.text, "N")));
                           }
                           else{
                             Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                 fromdate, todate, searchController.text, searchvendorController.text, "N")));
                           }
                         },
                       ),
                       RadioListTile(
                         contentPadding: EdgeInsets.zero,
                         title: Text(language.text('wrrretvendor')),
                         value: "rtrvendor",
                         groupValue: providervalue.getWrrOption,
                         onChanged: (value){
                           providervalue.setOptionsValue(value.toString());
                           if(providervalue.getTxntypeOption == "warrejreg"){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(pvalue.rlyCode, pvalue.consigneecode, pvalue.subconsigneecode,fromdate,
                                 todate, searchController.text, searchvendorController.text, "V")));
                           }
                           else{
                             Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                 fromdate, todate, searchController.text, searchvendorController.text, "V")));
                           }
                         },
                       ),
                     ],
                   );
                 }),
                 SizedBox(height: 20),
                 Container(
                     width: size.width,
                     padding: EdgeInsets.symmetric(horizontal: 5.0),
                     height: 45,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, value, child){
                            return MaterialButton(
                                height: 45,
                                minWidth: size.width * 0.45,
                                child: Text(language.text('wrrsubmit')),
                                shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                                onPressed: () {
                                  if(value.getWrrOption == "all" && value.getTxntypeOption == "warrejreg") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(value.rlyCode, value.consigneecode,
                                        value.subconsigneecode, fromdate, todate, searchController.text, searchvendorController.text, "A")));
                                  }
                                  else if(value.getWrrOption == "all" && value.getTxntypeOption == "rejadvreg") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                        fromdate, todate, searchController.text, searchvendorController.text, "A")));
                                  }
                                  else if(value.getWrrOption == "pendingrcr" && value.getTxntypeOption == "warrejreg"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(value.rlyCode, value.consigneecode, value.subconsigneecode,fromdate,
                                        todate, searchController.text, searchvendorController.text, "P")));
                                  }
                                  else if(value.getWrrOption == "pendingrcr" && value.getTxntypeOption == "rejadvreg") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                        fromdate, todate, searchController.text, searchvendorController.text, "P")));
                                  }
                                  else if(value.getWrrOption == "nilrcr" && value.getTxntypeOption == "warrejreg"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(value.rlyCode, value.consigneecode, value.subconsigneecode,fromdate,
                                        todate, searchController.text, searchvendorController.text, "N")));
                                  }
                                  else if(value.getWrrOption == "nilrcr" && value.getTxntypeOption == "rejadvreg"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                        fromdate, todate, searchController.text, searchvendorController.text, "N")));
                                  }
                                  else if(value.getWrrOption == "rtrvendor" && value.getTxntypeOption == "warrejreg"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionRegisterlistScreen(value.rlyCode, value.consigneecode, value.subconsigneecode,fromdate,
                                        todate, searchController.text, searchvendorController.text, "V")));
                                  }
                                  else if(value.getWrrOption == "rtrvendor" && value.getTxntypeOption == "rejadvreg") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RejectionAdviceRegisterScreen(providervalue.rlyCode, providervalue.deptcode, providervalue.consigneecode, providervalue.subconsigneecode,
                                        fromdate, todate, searchController.text, searchvendorController.text, "V")));
                                  }
                                }, color: Colors.blue, textColor: Colors.white
                            );
                         }),
                         MaterialButton(
                             height: 45,
                             minWidth: size.width * 0.45,
                             child: Text(language.text('wrrexit')),
                             shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                             onPressed: () {
                               Navigator.pop(context);
                             }, color: Colors.red, textColor: Colors.white),
                       ],
                     )
                 )
               ],
             );
          })),
        ),
      ),
    );
  }
}
