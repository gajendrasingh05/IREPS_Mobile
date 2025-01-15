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
import 'package:flutter_app/udm/onlineBillStatus/statusDisplayScreen.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatusDropDown extends StatefulWidget {
  static const routeName = "/status-search";

  @override
  State<StatusDropDown> createState() => _StatusDropDownState();
}

class _StatusDropDownState extends State<StatusDropDown> {
  double? sheetLeft;
  bool isExpanded = true;
  late StatusProvider statusProvider;

  String rlyname = "--Select Railway--";

  String? railwayname = "All";
  String? railway;
  String? payingrlyname = "All";
  String? payingrlycode;
  String? unittype = "All";
  String? unitType;
  String? unitname = "All";
  String? unitName;
  String? dept = "All";
  String? department;
  String? userDepotName = "All";
  String? userDepot;
  String? itemType;
  String? itemUsage;
  String? itemCategory;
  String? isStockItem;
  String? division;
  String? consignee;
  String? plNo;
  String? payingAuthority;
  String? descriptionInput;
  String? tDate;
  String? fDate;
  TextEditingController description = new TextEditingController();
  //==============================================
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormState> _Key = GlobalKey<FormState>();
  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMDivision = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMItemsResult = [];
  List dropdowndata_UDMConsigneeInBillStatus = [];
  late List<Map<String, dynamic>> dbResult;
  late SharedPreferences prefs;
  Error? _error;
  bool _autoValidate = false;

  String dropdownValue = 'First';
  var _screenStage;
  String? newValue;

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
        title: Text(language.text('onlinebillstatus'), style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _Key,
        child: Container(
          child: searchDrawer(mq, language),
        ),
      ),
    );
  }

  _all() {
    var all = {
      'intcode': '-1',
      'value': 'All',
    };
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
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        name: 'FromDate',
                        initialDate:
                            DateTime.now().subtract(const Duration(days: 367)),
                        initialValue:
                            DateTime.now().subtract(const Duration(days: 367)),
                        inputType: InputType.date,
                        format: DateFormat('dd-MM-yyyy'),
                        decoration: InputDecoration(
                            labelText: language.text('podatefrom'),
                            hintText: language.text('podatefrom'),
                            contentPadding: EdgeInsetsDirectional.all(10),
                            suffixIcon: Icon(Icons.calendar_month),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1))),
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
                            labelText: language.text('podateto'),
                            hintText: language.text('podateto'),
                            contentPadding: EdgeInsetsDirectional.all(10),
                            suffixIcon: Icon(Icons.calendar_month),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1))),
                      ),
                    ),
                  ],
                ),
                // DropdownButtonFormField(
                //   isExpanded: true,
                //   value: railway,
                //   icon: Icon(Icons.arrow_drop_down),
                //   decoration: InputDecoration(
                //     labelText: language.text('consigneerailway'),
                //     hintText: '${language.text('select')} ${language.text('railway')}',
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     alignLabelWithHint: true,
                //     labelStyle: Theme.of(context)
                //         .primaryTextTheme
                //         .caption!
                //         .copyWith(color: Colors.black),
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
                //         dropdowndata_UDMConsigneeInBillStatus.clear();
                //         unitName = null;
                //         fetchUnit(railway, "");
                //         fetchConsignee(railway, "", "", "",  "");
                //         dropdowndata_UDMUnitType.add(_all());
                //         dropdowndata_UDMDivision.add(_all());
                //         dropdowndata_UDMUserDepot.add(_all());
                //         dropdowndata_UDMConsigneeInBillStatus.add(_all());
                //
                //         division = '-1';
                //         department = '-1';
                //         userDepot = '-1';
                //         consignee = '-1';
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
                Text(language.text('consigneerailway'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400)),
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
                    onChanged: (String? newValue) {
                      var rlyname;
                      var rlycode;
                      dropdowndata_UDMRlyList.forEach((element) {
                        if (newValue.toString() ==
                            element['value'].toString()) {
                          rlyname = element['value'].toString().trim();
                          rlycode = element['intcode'].toString();
                        }
                      });
                      try {
                        setState(() {
                          railway = rlycode;
                          railwayname = rlyname;
                          payingrlyname = "All";
                          payingAuthority = "-1";
                          userDepotName = "All";
                          userDepot = "-1";
                          dropdowndata_UDMUnitType.clear();
                          dropdowndata_UDMDivision.clear();
                          dropdowndata_UDMUserDepot.clear();
                          dropdowndata_UDMConsigneeInBillStatus.clear();
                          unitName = null;
                          fetchUnit(railway, "");
                          fetchConsignee(railway, "", "", "", "");
                          dropdowndata_UDMUnitType.add(_all());
                          dropdowndata_UDMDivision.add(_all());
                          dropdowndata_UDMUserDepot.add(_all());
                          dropdowndata_UDMConsigneeInBillStatus.add(_all());

                          division = '-1';
                          department = '-1';
                          userDepot = '-1';
                          consignee = '-1';
                          description.clear();
                        });
                      } catch (e) {
                        print("execption" + e.toString());
                      }
                    },
                    validator: (dynamic val) {
                      if (val != null) {
                        return null;
                      } else {
                        return 'Please select Railway ';
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(language.text('payingauthorityrailway'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400)),
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
                    selectedItem: payingrlyname,
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
                    onChanged: (String? newValue) {
                      var payrlyname;
                      var payrlycode;
                      dropdowndata_UDMRlyList.forEach((element) {
                        if (newValue.toString() ==
                            element['value'].toString()) {
                          payrlyname = element['value'].toString().trim();
                          payrlycode = element['intcode'].toString();
                        }
                      });
                      try {
                        setState(() {
                          payingAuthority = payrlycode;
                          payingrlyname = payrlyname;
                          userDepotName = "All";
                          userDepot = "-1";
                          dropdowndata_UDMUnitType.clear();
                          dropdowndata_UDMDivision.clear();
                          dropdowndata_UDMUserDepot.clear();
                          dropdowndata_UDMConsigneeInBillStatus.clear();
                          unitName = null;
                          fetchUnit(railway, "");
                          fetchConsignee(railway, "", "", "", "");
                          dropdowndata_UDMUnitType.add(_all());
                          dropdowndata_UDMDivision.add(_all());
                          dropdowndata_UDMUserDepot.add(_all());
                          dropdowndata_UDMConsigneeInBillStatus.add(_all());

                          division = '-1';
                          department = '-1';
                          userDepot = '-1';
                          description.clear();
                        });
                      } catch (e) {
                        print("execption" + e.toString());
                      }
                    },
                    validator: (dynamic val) {
                      if (val != null) {
                        return null;
                      } else {
                        return 'Please select consignee details ';
                      }
                    },
                  ),
                ),
                // DropdownButtonFormField(
                //   isExpanded: true,
                //   value: payingAuthority,
                //   icon: Icon(Icons.arrow_drop_down),
                //   decoration: InputDecoration(
                //     labelText: language.text('payingauthorityrailway'),
                //     hintText: '${language.text('select')} ${language.text('railway')}',
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
                //   Text('${language.text('select')} ${language.text('railway')}'),
                //   // hint: Text('Select Railway'),
                //   items: dropdowndata_UDMRlyList.map((item) {
                //     return DropdownMenuItem(
                //         child: Text(item['value']),
                //         value: item['intcode'].toString());
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     try {
                //       setState(() {
                //         payingAuthority = newValue;
                //         dropdowndata_UDMUnitType.clear();
                //         dropdowndata_UDMDivision.clear();
                //         dropdowndata_UDMUserDepot.clear();
                //         dropdowndata_UDMConsigneeInBillStatus.clear();
                //         unitName = null;
                //         fetchUnit(railway, "");
                //         fetchConsignee(railway, "", "", "",  "");
                //         dropdowndata_UDMUnitType.add(_all());
                //         dropdowndata_UDMDivision.add(_all());
                //         dropdowndata_UDMUserDepot.add(_all());
                //         dropdowndata_UDMConsigneeInBillStatus.add(_all());
                //
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
                //       return 'Please select consignee details ';
                //     }
                //   },
                // ),
                SizedBox(height: 10),
                Text(language.text('consigneedetails'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
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
                    selectedItem: userDepotName.toString().length > 35 ? userDepotName.toString().substring(0, 32) : userDepotName.toString(),
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
                    items:(filter, loadProps) => dropdowndata_UDMConsigneeInBillStatus.map((e) {
                      return e['value'].toString().trim() == "All" ? e['value'].toString().trim() : e['intcode'].toString().trim()+"-"+e['value'].toString().trim();
                    }).toList(),
                    onChanged: (String? newValue) {
                      var userDepotname;
                      var userDepotCode;
                      dropdowndata_UDMConsigneeInBillStatus.forEach((element) {
                        if(newValue.toString().trim() == element['intcode'].toString().trim()+"-"+element['value'].toString().trim()){
                          userDepotname = element['intcode'].toString().trim()+"-"+element['value'].toString().trim();
                          userDepotCode = element['intcode'].toString();
                          print("user depot code here $userDepotCode");
                          setState(() {
                            userDepot = userDepotCode;
                            userDepotName = userDepotname;
                            description.clear();
                          });
                        }
                        else{
                          setState(() {
                            userDepotname = "All";
                            userDepotCode = "-1";
                          });
                        }
                      });
                    },
                  ),
                ),
                // DropdownButtonFormField(
                //   isExpanded: true,
                //   value: userDepot,
                //   icon: Icon(Icons.arrow_drop_down),
                //   decoration: InputDecoration(
                //     labelText: language.text('consigneedetails'),
                //     hintText:
                //         //'${language.text('select')} ${language.text('departmentName')}',
                //         '${language.text('consigneedetails')}',
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     alignLabelWithHint: true,
                //     labelStyle: Theme.of(context)
                //         .primaryTextTheme
                //         .caption!
                //         .copyWith(color: Colors.black),
                //     border: const OutlineInputBorder(),
                //     contentPadding: EdgeInsetsDirectional.all(10),
                //   ),
                //   disabledHint: Text(
                //       '${language.text('select')} ${language.text('consigneedetails')}'),
                //   // hint: Text('Select Railway'),
                //   items: dropdowndata_UDMConsigneeInBillStatus.map((item) {
                //     return DropdownMenuItem(
                //         child: Text(() {
                //           if (item['intcode'].toString() == '-1') {
                //             return item['value'];
                //           } else {
                //             return item['intcode'].toString() +
                //                 '-' +
                //                 item['value'];
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
                //     fetchConsignee(railway, "", "", "", "");
                //   },
                //   validator: (dynamic val) {
                //     if (val != null) {
                //       return null;
                //     } else {
                //       return 'Please select consignee details ';
                //     }
                //   },
                // ),
                SizedBox(height: 10),
                Text('${language.text('entersearchcriteria')}', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                TextFormField(
                  controller: description,
                  validator: (val) {
                    if(val == null || val.length < 3) {
                      return language.text('plNoErrorText1');
                    }
                    return null;
                  },
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
                    hintText: language.text('searchcriteria'),
                    errorText: _autoValidate ? language.text('plNoErrorText1') : null,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
                // TextFormField(
                //   controller: description,
                //   validator: (val) {
                //     if (val == null || val.length < 3) {
                //       return language.text('plNoErrorText1');
                //     }
                //     return null;
                //   },
                //   decoration: InputDecoration(
                //     labelText: '${language.text('entersearchcriteria')}',
                //     hintText: language.text('searchcriteria'),
                //     errorText:
                //         _autoValidate ? language.text('plNoErrorText1') : null,
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     alignLabelWithHint: true,
                //     labelStyle: Theme.of(context)
                //         .primaryTextTheme
                //         .caption!
                //         .copyWith(color: Colors.black),
                //     border: const OutlineInputBorder(),
                //     contentPadding: EdgeInsetsDirectional.all(10),
                //   ),
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
                          // print("from date ${_formKey.currentState!.fields['FromDate']!.value}");
                          // print("to date ${_formKey.currentState!.fields['ToDate']!.value}");
                          // print("railway code $railway");
                          // print("User depot $userDepot");
                          // print("paying auth $payingAuthority");
                          // print("discription ${description.text}");
                          setState(() {
                            if(division == null || railway == null || unitName == null || department == null || userDepot == null) {
                              _validateInputs();
                            } else if(description.text.toString().trim().length < 3 || description.text.isEmpty) {
                              _validateInputs();
                              IRUDMConstants().showSnack(language.text('plNoErrorText1'), context);
                            } else {
                              statusProvider = Provider.of<StatusProvider>(context, listen: false);
                              Navigator.of(context).pushNamed(StatusDiaplayScreen.routeName);
                              statusProvider.fetchAndStoreItemsListwithdata(railway!, _formKey.currentState!.fields['FromDate']!.value,
                                  _formKey.currentState!.fields['ToDate']!.value,
                                  userDepot!,
                                  payingAuthority!,
                                  description.text.trim(),
                                  context);
                            }
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
                            description.clear();
                            default_data();
                          });
                        },
                        child: Text(language.text('reset'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[300],
                            )),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
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
    //dropdowndata_UDMConsigneeInBillStatus.clear();
    railway = null;
    unitName = null;
    unitType = null;
    department = null;
    userDepot = null;
    // consignee = null;
    description.clear();
  }

  void initState() {
    setState(() {
      default_data();
    });
    // post_result();
    super.initState();
  }

  Future<dynamic> fetchUnit(String? value, String unit_data) async {
    IRUDMConstants.showProgressIndicator(context);

    if (value == '-1') {
      dropdowndata_UDMUnitType.clear();
      //dropdowndata_UDMDivision.clear();
      //dropdowndata_UDMUserDepot.clear();
      //dropdowndata_UDMUserDepot.clear();
      // dropdowndata_UDMConsigneeInBillStatus.clear();
      setState(() {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUnitType.add(UnitType);
        unitName = '-1';

        Future.delayed(Duration.zero, () {
          fetchDivision('', '-1', '');
        });
      });
    } else {
      dropdowndata_UDMUnitType.clear();
      var result_UDMUnitType = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMUnitType', value, prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      var unitData = UDMUnitType_body['data'];
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMUnitType.add(UnitType);
          unitName = '-1';
        });
        IRUDMConstants.removeProgressIndicator(context);
      } else {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMUnitType.add(UnitType);
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMUnitType.clear();
          dropdowndata_UDMUnitType = myList_UDMUnitType;
          unitName = '-1';
          if (unit_data != "") {
            unitName = unit_data;
          }
        });
        IRUDMConstants.removeProgressIndicator(context);
      }
    }
  }

  Future<dynamic> fetchDivision(
      String? rai, String? unit, String division_name) async {
    IRUDMConstants.showProgressIndicator(context);

    if (unit == '-1') {
      dropdowndata_UDMDivision.clear();
      setState(() {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMDivision.add(UnitType);
        division = '-1';
        Future.delayed(Duration.zero, () {
          //fetchDepot('-1', '', '', '', '');
        });
        setState(() {
          Future.delayed(Duration.zero, () {});
        });
      });
    } else {
      dropdowndata_UDMDivision.clear();
      var result_UDMDivision = await Network().postDataWithAPIMList(
          'UDMAppList',
          'UnitName',
          rai! + "~" + unit!,
          prefs.getString('token'));
      var UDMDivision_body = json.decode(result_UDMDivision.body);
      var divisionData = UDMDivision_body['data'];
      var myList_UDMDivision = [];
      if (UDMDivision_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMDivision.add(UnitType);
          division = '-1';
        });
        //  showInSnackBar("please select other value");
        IRUDMConstants.removeProgressIndicator(context);
      } else {
        var UnitType = {
          'intcode': '-1',
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

  Future<dynamic> fetchConsignee(String? rai, String? depart, String? unit_typ, String? Unit_Name, String consignee_id) async {
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMConsigneeInBillStatus.clear();
    if(rai == '-1') {
      var consigneeName = {
        'intcode': '-1',
        'value': "All",
      };
      dropdowndata_UDMConsigneeInBillStatus.add(consigneeName);
      userDepot = "-1";
      consignee = "-1";
      department = '-1';
    } else {
      var result_UDMConsignee = await Network().postDataWithAPIMList(
          'UDMAppList',
          'ConsigneeInBillStatus',
          rai!,
          prefs.getString('token'));
      var UDMConsignee_body = json.decode(result_UDMConsignee.body);
      print("udm consignee all data $UDMConsignee_body");
      var depotData = UDMConsignee_body['data'];
      var myList_UDMConsignee = [];
      if (UDMConsignee_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMConsigneeInBillStatus.add(UnitType);
          consignee = consignee_id;
        });
      } else {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        //myList_UDMConsignee.add(UnitType);
        myList_UDMConsignee.addAll(depotData);
        setState(() {
          dropdowndata_UDMConsigneeInBillStatus = myList_UDMConsignee;
          print(consignee_id);
          if(consignee_id != "") {
            consignee = consignee_id;
          }
        });
      }
    }
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> depart_result(String depart) async {
    IRUDMConstants.showProgressIndicator(context);

    var result_UDMDept = await Network().postDataWithAPIMList(
        'UDMAppList', 'UDMDept', '', prefs.getString('token'));
    var UDMDept_body = json.decode(result_UDMDept.body);
    var deptData = UDMDept_body['data'];
    var myList_UDMDept = [];
    myList_UDMDept.addAll(deptData);
    setState(() {
      dropdowndata_UDMDept = myList_UDMDept; //5
      department = depart;
    });
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> default_data() async {
    Future.delayed(const Duration(milliseconds: 0), () async {
      IRUDMConstants.showProgressIndicator(context);
    });
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      Uri default_url = Uri.parse(IRUDMConstants.apimDef);
      var d_response = await Network.postDataWithAPIM(
          'app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue',
          'GetListDefaultValue',
          dbResult[0][DatabaseHelper.Tb3_col5_emailid],
          prefs.getString('token'));
      var d_JsonData = json.decode(d_response.body);
      var d_Json = d_JsonData['data'];
      var result_UDMRlyList = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMRlyList', '', prefs.getString('token'));
      var UDMRlyList_body = json.decode(result_UDMRlyList.body);
      var rlyData = UDMRlyList_body['data'];
      var myList_UDMRlyList = [];
      var all = {
        'intcode': '-1',
        'value': "All",
      };
      myList_UDMRlyList.add(all);
      myList_UDMRlyList.addAll(rlyData);
      setState(() {
        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMConsigneeInBillStatus.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList;
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        railway = d_Json[0]['org_zone'];
        payingAuthority = d_Json[0]['org_zone'];
        railwayname = d_Json[0]['account_name'];
        payingrlyname = d_Json[0]['account_name'];
        unitType = d_Json[0]['org_unit_type'];
        unittype = d_Json[0]['unit_type'];
        unitName = d_Json[0]['admin_unit'];
        unitname = d_Json[0]['unit_name'];
        department = d_Json[0]['org_subunit_dept'];
        dept = d_Json[0]['dept_name'];
        userDepot = d_Json[0]['ccode'].toString() == "NA"
            ? "-1"
            : d_Json[0]['ccode'].toString();
        userDepotName = d_Json[0]['ccode'].toString() == "NA"
            ? "All"
            : d_Json[0]['ccode'] + "-" + d_Json[0]['cname'];
        consignee = d_Json[0]['ccode'];
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        Future.delayed(const Duration(milliseconds: 0), () async {
          def_fetchUnit(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString());

          fetchConsignee(
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

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String division, String depot) async {
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMUnitType', value, prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      var unitData = UDMUnitType_body['data'];
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMUnitType.add(UnitType);
          unitName = '-1';
        });
        // showInSnackBar("please select other value");
      } else {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMUnitType.add(UnitType);
        myList_UDMUnitType.addAll(unitData);
      }

      setState(() {
        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMConsigneeInBillStatus.clear();
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
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  Future<dynamic> def_fetchDivision(String rai, String unit, String division_name, String depot, String depart) async {
    try {
      var result_UDMDivision = await Network().postDataWithAPIMList(
          'UDMAppList', 'UnitName', rai + "~" + unit, prefs.getString('token'));
      var UDMDivision_body = json.decode(result_UDMDivision.body);
      var divisionData = UDMDivision_body['data'];
      var myList_UDMDivision = [];
      if (UDMDivision_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMDivision.add(UnitType);
          division = '-1';
        });
        // showInSnackBar("please select other value");
      } else {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMDivision.add(UnitType);
        myList_UDMDivision.addAll(divisionData);
      }
      IRUDMConstants.showProgressIndicator(context);

      setState(() {
        dropdowndata_UDMUserDepot.clear();
        // dropdowndata_UDMConsigneeInBillStatus.clear();
        dropdowndata_UDMDivision = myList_UDMDivision; //2
        if (division_name != "") {
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

  Future<dynamic> def_fetchDepot(String rai, String depart, String unit_typ,
      String Unit_Name, String depot_id) async {
    try {
      dropdowndata_UDMUserDepot.clear();
      if (depot_id == 'null') {
        var depotName = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserDepot.add(depotName);
        userDepot = "-1";
        // department='-1';
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList',
            'UDMUserDepot',
            rai + "~" + depart + "~" + unit_typ + "~" + Unit_Name,
            prefs.getString('token'));
        var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
        var depotData = UDMUserDepot_body['data'];
        var myList_UDMUserDepot = [];
        if (UDMUserDepot_body['status'] != 'OK') {
          setState(() {
            var UnitType = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserDepot.add(UnitType);
            userDepot = '-1';
          });
          // showInSnackBar("please select other value");
        } else {
          var UnitType = {
            'intcode': '-1',
            'value': "All",
          };
          myList_UDMUserDepot.add(UnitType);
          myList_UDMUserDepot.addAll(depotData);
        }
        if (depot_id == 'NA') {
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot; //2
            userDepot = '-1';
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
      var result_UDMDept = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMDept', '', prefs.getString('token'));
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

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  // void _validateInputs() {
  //   if (_formKey.currentState!.validate()) {
  //     print("If all data are correct then save data to out variables");
  //     _formKey.currentState!.save();
  //   } else {
  //     print("If all data are not valid then start auto validation.");
  //     setState(() {
  //       _autoValidate = true;
  //     });
  //   }
  // }
}
