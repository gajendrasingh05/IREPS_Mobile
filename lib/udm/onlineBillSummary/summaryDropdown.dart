import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';

import 'package:flutter_app/udm/onlineBillSummary/summaryDisplayScreen.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryProvider.dart';
//import 'package:flutter_app/udm/providers/itemsProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/itemlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';


class SummaryDropdown extends StatefulWidget {
  static const routeName = "/summary-search";

  @override
  State<SummaryDropdown> createState() => _SummaryDropdownState();
}

class _SummaryDropdownState extends State<SummaryDropdown> {
  late SummaryProvider itemListProvider;
  double? sheetLeft;
  bool isExpanded = true;
  late SummaryProvider summaryProvider;
  String? railwayname = "All";
  String? railway;
  String? unittype = "All";
  String? unitType;
  String? unitname = "All";
  String? unitName;
  String? dept = "All";
  String? department;
  String? userDepotName= "All";
  String? userDepot;
  String? payingAuthName = "All";
  String? payingAuth;
  String? itemType;
  String? itemUsage;
  String? itemCategory;
  String? isStockItem;
  String? division;
  String? fromDate;
  String? toDate;
  //TextEditingController description = new TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMDivision = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMUserDepot = [];
  List  dropdowndata_UDMPayingAuthList = [];
  List dropdowndata_UDMItemsResult = [];
  late List<Map<String, dynamic>> dbResult;
  late SharedPreferences prefs;
  Error? _error;
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String intcodevalue = "-1";
  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(color: Colors.white),
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
        title: Text(language.text('on-lineBillSummary'),style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _key,
        child: Container(
          child: searchDrawer(mq, language),
        ),
      ),
    );
  }

  _all() {
    var all = {
      'intcode': intcodevalue,
      'value': 'All',
    };
    print("All data "+all.toString());
    return all;
  }

  Widget searchDrawer(Size mq, LanguageProvider language) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      children: [
         FormBuilder(
             key: _formKey,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Expanded(
                       child: FormBuilderDateTimePicker(
                         name: 'FromDate',
                         initialDate: DateTime.now().subtract(const Duration(days: 32)),
                         initialValue: DateTime.now().subtract(const Duration(days: 32)),
                         inputType: InputType.date,
                         format: DateFormat('dd-MM-yyyy'),
                         decoration: InputDecoration(
                             labelText: language.text('billsubdate'),
                             hintText:  language.text('billsubdate'),
                             contentPadding: EdgeInsetsDirectional.all(5),
                             suffixIcon: Icon(Icons.calendar_month),
                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))),
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
                         decoration: InputDecoration(
                             labelText: language.text('billsubdateto'),
                             hintText: language.text('billsubdateto'),
                             contentPadding: EdgeInsetsDirectional.all(5),
                             suffixIcon: Icon(Icons.calendar_month),
                             enabledBorder: OutlineInputBorder(
                                 borderSide:
                                 BorderSide(color: Colors.grey, width: 1))),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 10),
                 Text(language.text('railway'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Container(
                   height: 45,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                       border: Border.all(color: Colors.grey, width: 1)),
                   child: DropdownSearch<String>(
                     //mode: Mode.DIALOG,
                     //showSearchBox: true,
                     //showSelectedItems: true,
                     selectedItem: railwayname,
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
                     items: (filter, loadProps) => dropdowndata_UDMRlyList.map((e) {
                       return e['value'].toString().trim();
                     }).toList(),
                     onChanged: (newValue) {
                       var rlyname;
                       var rlycode;
                       dropdowndata_UDMRlyList.forEach((element) {
                         if(newValue.toString() == element['value'].toString()){
                           rlyname = element['value'].toString().trim();
                           rlycode = element['intcode'].toString();
                           try {
                             setState(() {
                               railway = rlycode;
                               railwayname = rlyname;
                               dropdowndata_UDMUnitType.clear();
                               dropdowndata_UDMDivision.clear();
                               dropdowndata_UDMUserDepot.clear();
                               unitName = null;
                               dropdowndata_UDMUnitType.add(_all());
                               dropdowndata_UDMDivision.add(_all());
                               dropdowndata_UDMUserDepot.add(_all());
                               unittype = "All";
                               dept = "All";
                               userDepotName = "All";
                               unitname = "All";
                               division = '-1';
                               department = '-1';
                               userDepot = '-1';
                               fetchUnit(railway, "");
                               fetchpayAuth(railway, department, unitName, division, "");
                             });
                           } catch (e) {
                             print("execption" + e.toString());
                           }
                         }
                       });
                       // try {
                       //   setState(() {
                       //     railway = rlycode;
                       //     railwayname = rlyname;
                       //     dropdowndata_UDMUnitType.clear();
                       //     dropdowndata_UDMDivision.clear();
                       //     dropdowndata_UDMUserDepot.clear();
                       //     unitName = null;
                       //     dropdowndata_UDMUnitType.add(_all());
                       //     dropdowndata_UDMDivision.add(_all());
                       //     dropdowndata_UDMUserDepot.add(_all());
                       //     unittype = "All";
                       //     dept = "All";
                       //     userDepotName = "All";
                       //     unitname = "All";
                       //     division = '-1';
                       //     department = '-1';
                       //     userDepot = '-1';
                       //     description.clear();
                       //     fetchUnit(railway, "");
                       //   });
                       // } catch (e) {
                       //   print("execption" + e.toString());
                       // }
                     },
                   ),
                 ),
                 // DropdownButtonFormField(
                 //   isExpanded: true,
                 //   value: railway,
                 //   icon: Icon(Icons.keyboard_arrow_down),
                 //   decoration: InputDecoration(
                 //     labelText: language.text('railway'),
                 //     hintText: '${language.text('select')} ${language.text('railway')}',
                 //     floatingLabelBehavior: FloatingLabelBehavior.always,
                 //     alignLabelWithHint: true,
                 //     labelStyle: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Colors.black),
                 //     border: const OutlineInputBorder(),
                 //     contentPadding: EdgeInsetsDirectional.all(10),
                 //   ),
                 //   disabledHint: Text('${language.text('select')} ${language.text('railway')}'),
                 //   items: dropdowndata_UDMRlyList.map((item) {
                 //     return DropdownMenuItem(
                 //         child: Text(item['value']),
                 //         value: item['intcode'].toString());
                 //   }).toList(),
                 //   onChanged: (String? newValue) {
                 //     try {
                 //       setState(() {
                 //         railway = newValue;
                 //         dropdowndata_UDMUnitType.clear();
                 //         dropdowndata_UDMDivision.clear();
                 //         dropdowndata_UDMUserDepot.clear();
                 //         unitName = null;
                 //         fetchUnit(railway, "");
                 //         dropdowndata_UDMUnitType.add(_all());
                 //         dropdowndata_UDMDivision.add(_all());
                 //         dropdowndata_UDMUserDepot.add(_all());
                 //         division = '-1';
                 //         department = '-1';
                 //         userDepot = '-1';
                 //         description.clear();
                 //       });
                 //     } catch (e) {
                 //       print("execption" + e.toString());
                 //     }
                 //   },
                 //   validator: (dynamic val) {
                 //     if (val != null) {
                 //       return null;
                 //     } else {
                 //       return 'Please select Railway ';
                 //     }
                 //   },
                 // ),
                 SizedBox(height: 10),
                 Text(language.text('unitType'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Container(
                   height: 45,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                       border: Border.all(color: Colors.grey, width: 1)),
                   child: DropdownSearch<String>(
                     //mode: Mode.DIALOG,
                     //showSearchBox: true,
                     //showSelectedItems: true,
                     selectedItem: unittype,
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
                     items: (filter, loadProps) => dropdowndata_UDMUnitType.map((e) {
                       return e['value'].toString().trim();
                     }).toList(),
                     onChanged: (String? newValue) {
                       var unittypecode;
                       var unittypename;
                       dropdowndata_UDMUnitType.forEach((element) {
                         if(newValue.toString() == element['value'].toString()){
                           unittypename = element['value'].toString().trim();
                           unittypecode = element['intcode'].toString();
                           try {
                             setState(() {
                               unitName = unittypecode;
                               unittype = unittypename;
                               division = '-1';
                               department = '-1';
                               userDepot = '-1';
                               fetchDivision(railway, unitName, "");
                             });
                           } catch (e) {
                             debugPrint("execption" + e.toString());
                           }
                         }
                       });
                     },
                   ),
                 ),
                 SizedBox(height: 10),
                 // DropdownButtonFormField(
                 //   isExpanded: true,
                 //   value: unitName,
                 //   icon: Icon(Icons.keyboard_arrow_down),
                 //   decoration: InputDecoration(
                 //     labelText: language.text('unitType'),
                 //     hintText: '${language.text('select')} ${language.text('unitType')}',
                 //     floatingLabelBehavior: FloatingLabelBehavior.always,
                 //     alignLabelWithHint: true,
                 //     labelStyle: Theme.of(context)
                 //         .primaryTextTheme
                 //         .caption!
                 //         .copyWith(color: Colors.black),
                 //     border: const OutlineInputBorder(),
                 //     contentPadding: EdgeInsetsDirectional.all(10),
                 //   ),
                 //   disabledHint:
                 //   Text('${language.text('select')} ${language.text('unitName')}'),
                 //   items: dropdowndata_UDMUnitType.map((item) {
                 //     return DropdownMenuItem(
                 //         child: Text(item['value']),
                 //         value: item['intcode'].toString());
                 //   }).toList(),
                 //   onChanged: (String? newValue) {
                 //     try {
                 //       setState(() {
                 //         unitName = newValue;
                 //         division = '-1';
                 //         department = '-1';
                 //         userDepot = '-1';
                 //         description.clear();
                 //         fetchDivision(railway, unitName, "");
                 //       });
                 //     } catch (e) {
                 //       print("execption" + e.toString());
                 //     }
                 //   },
                 //   validator: (dynamic val) {
                 //     if (val != null) {
                 //       return null;
                 //     } else {
                 //       return 'Please select Unit ';
                 //     }
                 //   },
                 // ),
                 // SizedBox(height: 8),
                 Text(language.text('unitName'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Container(
                   height: 45,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                       border: Border.all(color: Colors.grey, width: 1)),
                   child: DropdownSearch<String>(
                     //mode: Mode.DIALOG,
                     //showSearchBox: true,
                     //showSelectedItems: true,
                     selectedItem: unitname,
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
                     items: (filter, loadProps) => dropdowndata_UDMDivision.map((e) {
                       return e['value'].toString().trim();
                     }).toList(),
                     onChanged: (String? newValue) {
                       var unitnamecode;
                       var unittname;
                       dropdowndata_UDMDivision.forEach((element) {
                         if(newValue.toString() == element['value'].toString()){
                           unittname = element['value'].toString().trim();
                           unitnamecode = element['intcode'].toString();
                           try {
                             setState(() {
                               division = unitnamecode;
                               unitname = unittname;
                               userDepot = '-1';
                             });
                           } catch (e) {
                             print("execption" + e.toString());
                           }
                         }
                       });
                     },
                   ),
                 ),
                 // DropdownButtonFormField(
                 //   isExpanded: true,
                 //   value: division,
                 //   icon: Icon(Icons.keyboard_arrow_down),
                 //   decoration: InputDecoration(
                 //     labelText: language.text('unitName'),
                 //     hintText: '${language.text('select')} ${language.text('unitName')}',
                 //     floatingLabelBehavior: FloatingLabelBehavior.always,
                 //     alignLabelWithHint: true,
                 //     labelStyle: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Colors.black),
                 //     border: const OutlineInputBorder(),
                 //     contentPadding: EdgeInsetsDirectional.all(10),
                 //   ),
                 //   disabledHint: Text('${language.text('select')} ${language.text('unitName')}'),
                 //   items: dropdowndata_UDMDivision.map((item) {
                 //     return DropdownMenuItem(
                 //         child: Text(item['value']),
                 //         value: item['intcode'].toString());
                 //   }).toList(),
                 //   onChanged: (String? newValue) {
                 //     try {
                 //       setState(() {
                 //         division = newValue;
                 //         description.clear();
                 //         userDepot = '-1';
                 //       });
                 //     } catch (e) {
                 //       print("execption" + e.toString());
                 //     }
                 //   },
                 //   validator: (dynamic val) {
                 //     if (val != null) {
                 //       return null;
                 //     } else {
                 //       return 'Please select Division ';
                 //     }
                 //   },
                 // ),
                 SizedBox(height: 10),
                 Text(language.text('departmentName'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Container(
                   height: 45,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                       border: Border.all(color: Colors.grey, width: 1)),
                   child: DropdownSearch<String>(
                     //mode: Mode.DIALOG,
                     //showSearchBox: true,
                     //showSelectedItems: true,
                     selectedItem: dept,
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
                     items: (filter, loadProps) => dropdowndata_UDMDept.map((e) {
                       return e['value'].toString().trim();
                     }).toList(),
                     onChanged: (String? newValue) {
                       var deptt;
                       var deparmentt;
                       dropdowndata_UDMDept.forEach((element) {
                         if(newValue.toString() == element['value'].toString()){
                           deptt = element['value'].toString().trim();
                           deparmentt = element['intcode'].toString();
                           debugPrint("department code here $deparmentt");
                           try {
                             setState(() {
                               department = deparmentt;
                               dept = deptt;
                             });
                           } catch (e) {
                             print("execption" + e.toString());
                           }
                           fetchDepot(railway, department, unitName, division, "");
                         }
                       });
                       // try {
                       //   setState(() {
                       //     department = deparmentt;
                       //     dept = deptt;
                       //     description.clear();
                       //   });
                       // } catch (e) {
                       //   print("execption" + e.toString());
                       // }
                       // fetchDepot(railway, department, unitName, division, "");
                     },
                   ),
                 ),
                 SizedBox(height: 10),
                 // DropdownButtonFormField(
                 //   isExpanded: true,
                 //   value: department,
                 //   icon: Icon(Icons.keyboard_arrow_down),
                 //   decoration: InputDecoration(
                 //     labelText: language.text('departmentName'),
                 //     hintText: '${language.text('select')} ${language.text('departmentName')}',
                 //     floatingLabelBehavior: FloatingLabelBehavior.always, alignLabelWithHint: true,
                 //     labelStyle: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Colors.black),
                 //     border: const OutlineInputBorder(),
                 //     contentPadding: EdgeInsetsDirectional.all(10),
                 //   ),
                 //   disabledHint: Text('${language.text('select')} ${language.text('departmentName')}'),
                 //   items: dropdowndata_UDMDept.map((item) {
                 //     return DropdownMenuItem(
                 //         child: Text(item['value']),
                 //         value: item['intcode'].toString());
                 //   }).toList(),
                 //   onChanged: (String? newValue) {
                 //     try {
                 //       setState(() {
                 //         department = newValue;
                 //         description.clear();
                 //       });
                 //     } catch (e) {
                 //       print("execption" + e.toString());
                 //     }
                 //     fetchDepot(railway, department, unitName, division, "");
                 //   },
                 //   validator: (dynamic val) {
                 //     if (val != null) {
                 //       return null;
                 //     } else {
                 //       return 'Please select Department ';
                 //     }
                 //   },
                 // ),
                 Text(language.text('userDepot'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Container(
                   height: 45,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                       border: Border.all(color: Colors.grey, width: 1)),
                   child: DropdownSearch<String>(
                     //mode: Mode.DIALOG,
                     //showSearchBox: true,
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
                     selectedItem: userDepotName.toString().length > 35 ? userDepotName.toString().substring(0, 32) : userDepotName.toString(),
                     decoratorProps: DropDownDecoratorProps(
                       decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(12),
                               borderSide: BorderSide.none),
                           contentPadding: EdgeInsets.only(left: 10))
                     ),
                     items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((e) {
                       return e['value'].toString().trim() == "All" ? e['value'].toString().trim() : e['intcode'].toString().trim()+"-"+e['value'].toString().trim();
                     }).toList(),
                     onChanged: (String? newValue) {
                       debugPrint("onChanges User Depot value $newValue");
                       var userDepotname;
                       var userDepotCode;
                       dropdowndata_UDMUserDepot.forEach((element) {
                         if(newValue.toString().trim() == element['intcode'].toString().trim()+"-"+element['value'].toString().trim()){
                           userDepotname = element['intcode'].toString().trim()+"-"+element['value'].toString().trim();
                           userDepotCode = element['intcode'].toString();
                           debugPrint("user depot code here $userDepotCode");
                           try {
                             setState(() {
                               userDepot = userDepotCode;
                               userDepotName = userDepotname;
                             });
                           } catch (e) {
                             debugPrint("execption" + e.toString());
                           }
                         }
                         else{
                           setState((){
                             userDepotname = "All";
                             userDepotCode = "-1";
                           });
                         }
                       });
                     },
                   ),
                 ),
                 SizedBox(height: 10),
                 Text(language.text('payauth'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                 SizedBox(height: 10),
                 Container(
                   height: 45,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                       border: Border.all(color: Colors.grey, width: 1)),
                   child: DropdownSearch<String>(
                     //mode: Mode.DIALOG,
                     //showSearchBox: true,
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
                     selectedItem: payingAuthName.toString().length > 35 ? payingAuthName.toString().substring(0, 32) : payingAuthName.toString(),
                     decoratorProps: DropDownDecoratorProps(
                       decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(12),
                               borderSide: BorderSide.none),
                           contentPadding: EdgeInsets.only(left: 10))
                     ),
                     items: (filter, loadProps) => dropdowndata_UDMPayingAuthList.map((e) {
                       return e['value'].toString().trim() == "All" ? e['value'].toString().trim() : e['intcode'].toString().trim()+"-"+e['value'].toString().trim();
                     }).toList(),
                     onChanged: (String? newValue) {
                       var pyauthname;
                       var pyauthCode;
                       dropdowndata_UDMPayingAuthList.forEach((element) {
                         if(newValue.toString().trim() == element['intcode'].toString().trim()+"-"+element['value'].toString().trim()){
                           pyauthname = element['intcode'].toString().trim()+"-"+element['value'].toString().trim();
                           pyauthCode = element['intcode'].toString();
                           debugPrint("user pay auth code here $pyauthCode");
                           try {
                             setState(() {
                               payingAuth = pyauthCode;
                               payingAuthName = pyauthname;
                             });
                           } catch (e) {
                             debugPrint("execption" + e.toString());
                           }
                           fetchpayAuth(railway, "", "", "",  "");
                         }
                         else{
                           setState((){
                             payingAuth = "-1";
                             payingAuthName = "All";
                           });
                           fetchpayAuth(railway, "", "", "",  "");
                         }
                       });
                     },
                   ),
                 ),
                 // DropdownButtonFormField(
                 //   isExpanded: true,
                 //   value: userDepot,
                 //   icon: Icon(Icons.keyboard_arrow_down),
                 //   decoration: InputDecoration(
                 //     labelText: language.text('userDepot'),
                 //     hintText: '${language.text('select')} ${language.text('userDepot')}',
                 //     floatingLabelBehavior: FloatingLabelBehavior.always,
                 //     alignLabelWithHint: true,
                 //     labelStyle: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Colors.black),
                 //     border: const OutlineInputBorder(),
                 //     contentPadding: EdgeInsetsDirectional.all(10),
                 //   ),
                 //   disabledHint:
                 //   Text('${language.text('select')} ${language.text('userDepot')}'),
                 //   items: dropdowndata_UDMUserDepot.map((item) {
                 //     return DropdownMenuItem(
                 //         child: Text(() {
                 //           if (item['intcode'].toString() == '-1') {
                 //             return item['value'];
                 //           } else {
                 //             return item['intcode'].toString() + '-' + item['value'];
                 //           }
                 //         }()),
                 //         value: item['intcode'].toString());
                 //   }).toList(),
                 //   onChanged: (String? newValue) {
                 //     try {
                 //       setState(() {
                 //         userDepot = newValue;
                 //         description.clear();
                 //       });
                 //     } catch (e) {
                 //       print("execption" + e.toString());
                 //     }
                 //   },
                 //   validator: (dynamic val) {
                 //     if (val != null) {
                 //       return null;
                 //     } else {
                 //       return 'Please select Depot ';
                 //     }
                 //   },
                 // ),
                 SizedBox(height: 20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Container(
                       height: 50,
                       width: 160,
                       child: OutlinedButton(
                         style: IRUDMConstants.bStyle(),
                         onPressed: () {
                           setState(() {
                             summaryProvider = Provider.of<SummaryProvider>(context, listen: false);
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => SummaryDisplayScreen()));
                             summaryProvider.fetchAndStoreItemsListwithdata(
                                 railway!,
                                 _formKey.currentState!.fields['FromDate']!.value,
                                 _formKey.currentState!.fields['ToDate']!.value,
                                 unitName!,
                                 division!,
                                 department!,
                                 userDepot!,
                                 payingAuth!,
                                 context);
                           });
                         },
                         child: Text(language.text('getDetails'),
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
                           setState(() {
                             _formKey.currentState!.reset();
                             default_data();
                             //_formKey.currentState.reset();
                             // reseteValues();
                           });
                         },
                         // style: ButtonStyle(
                         //   backgroundColor:
                         // ),
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
               ],
             )
         )
      ],
    );
  }


  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      print("If all data are correct then save data to out variables");
      _formKey.currentState!.save();
    } else {
      print("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void reseteValues() {
    dropdowndata_UDMUnitType.clear();
    dropdowndata_UDMDivision.clear();
    dropdowndata_UDMUserDepot.clear();
    railway = null;
    unitName = null;
    unitType = null;
    department = null;
    userDepot = null;
    //description.clear();
  }

  void initState() {
    default_data();
    // post_result();
    super.initState();
  }

  Future<dynamic> fetchUnit(String? value, String unit_data) async {
    IRUDMConstants.showProgressIndicator(context);
    if(value == '1') {
      dropdowndata_UDMUnitType.clear();
      setState(() {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        dropdowndata_UDMUnitType.add(UnitType);
        unitName = intcodevalue;
        Future.delayed(Duration.zero, () {
          fetchDivision('', intcodevalue, '');
        });
      });
    } else {
      dropdowndata_UDMUnitType.clear();
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      var unitData = UDMUnitType_body['data'];
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMUnitType.add(UnitType);
          unitName = intcodevalue;
        });
        IRUDMConstants.removeProgressIndicator(context);

      } else {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        myList_UDMUnitType.add(UnitType);
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMUnitType = myList_UDMUnitType;
          unitName = intcodevalue;
          if (unit_data != "") {
            unitName = unit_data;
          }
        });
        IRUDMConstants.removeProgressIndicator(context);
      }
    }
  }

  Future<dynamic> fetchDivision(String? rai, String? unit, String division_name) async {
    print("rly and unitcode $rai  $unit");
    IRUDMConstants.showProgressIndicator(context);

    if (unit == intcodevalue) {
      dropdowndata_UDMDivision.clear();
      setState(() {
        var UnitType = {
          'intcode':intcodevalue,
          'value': "All",
        };
        dropdowndata_UDMDivision.add(UnitType);
        division = intcodevalue;
        Future.delayed(Duration.zero, () {
          fetchDepot(intcodevalue, '', '', '', '');
        });
        setState(() {
          Future.delayed(Duration.zero, () {});
        });
      });
    } else {
      dropdowndata_UDMDivision.clear();
      var result_UDMDivision=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai!+"~"+unit!,prefs.getString('token'));
      var UDMDivision_body = json.decode(result_UDMDivision.body);
      var divisionData = UDMDivision_body['data'];
      var myList_UDMDivision = [];
      if (UDMDivision_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMDivision.add(UnitType);
          division = intcodevalue;
        });
        IRUDMConstants.removeProgressIndicator(context);
      } else {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        myList_UDMDivision.add(UnitType);
        myList_UDMDivision.addAll(divisionData);
        setState(() {
          //dropdowndata_UDMUserDepot.clear();
          dropdowndata_UDMDivision = myList_UDMDivision; //2
          if (division_name != "") {
            division = division_name;
          }
        });
        IRUDMConstants.removeProgressIndicator(context);
      }
    }
  }

  Future<dynamic> fetchpayAuth(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id) async {
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMPayingAuthList.clear();
    if(rai == intcodevalue) {
      var payAuthName = {
        'intcode': intcodevalue,
        'value': "All",
      };
      dropdowndata_UDMPayingAuthList.add(payAuthName);
      payingAuth = intcodevalue;
      department = '';
    } else {
      payingAuth = intcodevalue;
      print("bhj"+payingAuth.toString());
      var result_UDMpayAuth = await Network().postDataWithAPIMList('UDMAppList','PayingAuthorityRailway' , rai! ,prefs.getString('token'));
      var UDMpayAuth_body = json.decode(result_UDMpayAuth.body);
      var depotData = UDMpayAuth_body['data'];
      var myList_UDMpayAuth = [];
      if (UDMpayAuth_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMPayingAuthList.add(UnitType);
          payingAuth = 'intcodevalue';
        });
      } else {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        myList_UDMpayAuth.add(UnitType);
        myList_UDMpayAuth.addAll(depotData);
        setState(() {
          dropdowndata_UDMPayingAuthList = myList_UDMpayAuth;
          if(depot_id != "") {
            userDepot = depot_id;
          }
        });
      }
    }
    IRUDMConstants.removeProgressIndicator(context);
  }


  // Future<dynamic> fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id) async {
  //   IRUDMConstants.showProgressIndicator(context);
  //
  //   dropdowndata_UDMUserDepot.clear();
  //   if(rai == '-1') {
  //     var depotName = {
  //       'intcode': '-1',
  //       'value': "All",
  //     };
  //     dropdowndata_UDMUserDepot.add(depotName);
  //     dept = "All";
  //     userDepotName = "All";
  //     userDepot = "-1";
  //     department = '-1';
  //   } else {
  //     var result_UDMUserDepot = await Network().postDataWithAPIMList(
  //         'UDMAppList','UDMUserDepot' , rai! +
  //         "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,prefs.getString('token'));
  //     var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
  //     var depotData = UDMUserDepot_body['data'];
  //     var myList_UDMUserDepot = [];
  //     if (UDMUserDepot_body['status'] != 'OK') {
  //       setState(() {
  //         var UnitType = {
  //           'intcode': '-1',
  //           'value': "All",
  //         };
  //         dropdowndata_UDMUserDepot.add(UnitType);
  //         userDepotName = "All";
  //         userDepot = '-1';
  //       });
  //     } else {
  //       var UnitType = {
  //         'intcode': '-1',
  //         'value': "All",
  //       };
  //       myList_UDMUserDepot.add(UnitType);
  //       myList_UDMUserDepot.addAll(depotData);
  //       setState(() {
  //         dropdowndata_UDMUserDepot = myList_UDMUserDepot;
  //         if (depot_id != "") {
  //           userDepot = depot_id;
  //         }
  //       });
  //     }
  //   }
  //   IRUDMConstants.removeProgressIndicator(context);
  // }

  Future<dynamic> fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id) async {
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMUserDepot.clear();
    if(rai == intcodevalue) {
      var depotName = {
        'intcode': intcodevalue,
        'value': "All",
      };
      dropdowndata_UDMUserDepot.add(depotName);
      userDepot = intcodevalue;
      department = intcodevalue;
    } else {
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
      var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
      var depotData = UDMUserDepot_body['data'];
      var myList_UDMUserDepot = [];
      if (UDMUserDepot_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMUserDepot.add(UnitType);
          userDepot = intcodevalue;
        });
      } else {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        myList_UDMUserDepot.add(UnitType);
        myList_UDMUserDepot.addAll(depotData);
        setState(() {
          dropdowndata_UDMUserDepot = myList_UDMUserDepot;
          if(depot_id != "") {
            userDepot = depot_id;
          }
        });
      }
    }
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> depart_result(String depart) async {
    IRUDMConstants.showProgressIndicator(context);
    var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
    var UDMDept_body = json.decode(result_UDMDept.body);
    var deptData = UDMDept_body['data'];
    var myList_UDMDept = [];
    myList_UDMDept.addAll(deptData);
    setState(() {
      dropdowndata_UDMDept = myList_UDMDept;
      department = depart;
    });
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> default_data() async {
    print("default calling here");
    Future.delayed(const Duration(milliseconds: 0), () async {
      IRUDMConstants.showProgressIndicator(context);
    });
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue', dbResult[0][DatabaseHelper.Tb3_col5_emailid], prefs.getString('token'));
      var d_JsonData = json.decode(d_response.body);
      print("default value "+d_JsonData.toString());
      var d_Json = d_JsonData['data'];
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','',prefs.getString('token'));
      var UDMRlyList_body = json.decode(result_UDMRlyList.body);
      var rlyData = UDMRlyList_body['data'];
      var myList_UDMRlyList = [];
      var myList_UDMPayingAuthList = [];
      var all = {
        'intcode': intcodevalue,
        'value': "All",
      };
      myList_UDMRlyList.add(all);
      myList_UDMRlyList.addAll(rlyData);
      myList_UDMPayingAuthList.add(all);
      setState(() {
        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList;
        dropdowndata_UDMPayingAuthList = myList_UDMPayingAuthList;
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        railway = d_Json[0]['org_zone'];
        railwayname = d_Json[0]['account_name'];
        unitType = d_Json[0]['org_unit_type'];
        unittype = d_Json[0]['unit_type'];
        unitName = d_Json[0]['admin_unit'];
        unitname = d_Json[0]['unit_name'];
        department = d_Json[0]['org_subunit_dept'];
        dept = d_Json[0]['dept_name'];
        userDepot = d_Json[0]['ccode'].toString() == "NA" ? "-1" : d_Json[0]['ccode'].toString();
        userDepotName = d_Json[0]['ccode'].toString() == "NA" ? "All" : d_Json[0]['ccode']+"-"+d_Json[0]['cname'];
        payingAuth = intcodevalue;
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        Future.delayed(const Duration(milliseconds: 0), () async {
          def_fetchUnit(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString());
        });
        Future.delayed(const Duration(milliseconds: 0), () async {
          fetchDepot(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString());
        });
      });
      //
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  String dropdownValue = 'First';
  String? newValue;

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String division, String depot) async {
    print("fetching unit");
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      var unitData = UDMUnitType_body['data'];
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMUnitType.add(UnitType);
          unitName = intcodevalue;
        });
      } else {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        myList_UDMUnitType.add(UnitType);
        myList_UDMUnitType.addAll(unitData);
      }

      setState(() {
        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMUnitType = myList_UDMUnitType; //2
        if (unit_data != "") {
          unitName = unit_data;
        }
        def_fetchDivision(value!, unit_data, division, depot, depart);
      });
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  Future<dynamic> def_fetchDivision(String rai, String unit, String division_name, String depot, String depart) async {
    try {
      var result_UDMDivision=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
      var UDMDivision_body = json.decode(result_UDMDivision.body);
      var divisionData = UDMDivision_body['data'];
      var myList_UDMDivision = [];
      if (UDMDivision_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMDivision.add(UnitType);
          division = intcodevalue;
        });
      } else {
        var UnitType = {
          'intcode':intcodevalue,
          'value': "All",
        };
        myList_UDMDivision.add(UnitType);
        myList_UDMDivision.addAll(divisionData);
      }
      IRUDMConstants.showProgressIndicator(context);

      setState(() {
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMDivision = myList_UDMDivision; //2
        if(division_name != "") {
          division = division_name;
        }
        def_fetchDepot(rai, depart.toString(), unit, division_name, depot);
      });
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  Future<dynamic> def_fetchDepot(String rai, String depart, String unit_typ, String Unit_Name, String depot_id) async {
    try {
      dropdowndata_UDMUserDepot.clear();
      if (depot_id == 'null') {
        var depotName = {
          'intcode': intcodevalue,
          'value': "All",
        };
        dropdowndata_UDMUserDepot.add(depotName);
        userDepot = intcodevalue;
        // department='-1';
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList','UDMUserDepot' , rai +
            "~" + depart + "~" + unit_typ + "~" + Unit_Name,prefs.getString('token'));
        var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
        var depotData = UDMUserDepot_body['data'];
        var myList_UDMUserDepot = [];
        if (UDMUserDepot_body['status'] != 'OK') {
          setState(() {
            var UnitType = {
              'intcode': intcodevalue,
              'value': "All",
            };
            dropdowndata_UDMUserDepot.add(UnitType);
            userDepot = intcodevalue;
          });
          // showInSnackBar("please select other value");
        } else {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          myList_UDMUserDepot.add(UnitType);
          myList_UDMUserDepot.addAll(depotData);
        }
        if (depot_id == 'NA') {
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot; //2
            userDepot = intcodevalue;
          });
        } else {
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot; //2
            if (depot_id != "") {
              userDepot = depot_id;
            }
          });
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } finally {
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_depart_result(String depart) async {
    try {
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
      setState(() {
        dropdowndata_UDMDept = myList_UDMDept; //5
        department = depart;
      });
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }
}
