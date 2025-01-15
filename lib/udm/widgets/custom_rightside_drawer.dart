import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/itemsProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/itemlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomRightSideDrawer extends StatefulWidget {
  static const routeName = "/item-list-drawer";
  @override
  _CustomRightSideDrawerState createState() => _CustomRightSideDrawerState();
}

class _CustomRightSideDrawerState extends State<CustomRightSideDrawer> {
  double? sheetLeft;
  bool isExpanded = true;
  late ItemListProvider itemListProvider;
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
  String? userSubDepotName;
  String? userSubDepot;
  String? itemType;
  String? itemUsage;
  String? itemCategory;
  String? isStockItem;
  String? division;
  TextEditingController description = TextEditingController();
  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMDivision = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMItemsResult = [];
  late List<Map<String, dynamic>> dbResult;
  late SharedPreferences prefs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Text(language.text('searchItem'), style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: searchDrawer(size, language),
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


  Widget searchDrawer(Size size, LanguageProvider language) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      children: [
        Text(language.text('railway'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey, width: 1)),
          child: DropdownSearch<String>(
            selectedItem: railwayname,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey), // You can customize the border color
              ))
            ),
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
              var rlyname;var rlycode;
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
                      description.clear();
                      fetchUnit(railway, "");
                    });
                  } catch (e) {
                    print("execption" + e.toString());
                  }
                }
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Text(language.text('unitType'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey, width: 1)),
          child: DropdownSearch<String>(
            selectedItem: unittype,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey), // You can customize the border color
              ))
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none),
    contentPadding: EdgeInsets.only(left: 10)),
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
                      description.clear();
                      fetchDivision(railway, unitName, "");
                    });
                  } catch (e) {
                    print("execption" + e.toString());
                  }
                }
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Text(language.text('unitName'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey, width: 1)),
          child: DropdownSearch<String>(
            selectedItem: unitname,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey), // You can customize the border color
              ))
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none),
    contentPadding: EdgeInsets.only(left: 10)),
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
                  debugPrint("unit name code here $unitnamecode");
                  try {
                    setState(() {
                      division = unitnamecode;
                      unitname = unittname;
                      description.clear();
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
        SizedBox(height: 10),
        Text(language.text('departmentName'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey, width: 1)),
          child: DropdownSearch<String>(
            selectedItem: dept,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey), // You can customize the border color
              ))
            ),
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
                  print("department code here $deparmentt");
                  try {
                    setState(() {
                      department = deparmentt;
                      dept = deptt;
                      description.clear();
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
        Text(language.text('userDepot'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey, width: 1)),
          child: DropdownSearch<String>(
            selectedItem: userDepotName.toString().length > 35 ? userDepotName.toString().substring(0, 32) : userDepotName.toString(),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey), // You can customize the border color
              ))
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none),
    contentPadding: EdgeInsets.only(left: 10)),
            ),
            items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((e) {
              return e['value'].toString().trim() == "All" ? e['value'].toString().trim() : e['intcode'].toString().trim()+"-"+e['value'].toString().trim();
            }).toList(),
            onChanged: (String? newValue) {
              print("onChanges User Depot value $newValue");
              var userDepotname;
              var userDepotCode;
              dropdowndata_UDMUserDepot.forEach((element) {
                if(newValue.toString().trim() == element['intcode'].toString().trim()+"-"+element['value'].toString().trim()){
                  userDepotname = element['intcode'].toString().trim()+"-"+element['value'].toString().trim();
                  userDepotCode = element['intcode'].toString();
                  print("user depot code here $userDepotCode");
                  try {
                    setState(() {
                      userDepot = userDepotCode;
                      userDepotName = userDepotname;
                      description.clear();
                    });
                  } catch (e) {
                    print("execption" + e.toString());
                  }
                }
                else{
                  setState((){
                    userDepotname = "All";
                    userDepotCode = "-1";
                  });
                }
              });
              try {
                setState(() {
                  userDepot = userDepotCode;
                  userDepotName = userDepotname;
                  description.clear();
                });
              } catch (e) {
                print("execption" + e.toString());
              }
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
        SizedBox(height: 10),
        Text('${language.text('plNo')}/${language.text('description')}', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        TextFormField(
          controller: description,
          validator: (val) {
            if(val == null || val.length < 3) {
              return language.text('plNoErrorText');
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
            hintText: language.text('plNoDisplayText'),
            errorText: _autoValidate ? language.text('plNoErrorText') : null,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),

        ),
        SizedBox(height: 20),
        Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton (
                    height: 45,
                    minWidth: size.width * 0.40,
                    child: Text(language.text('getDetails')),
                    shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                    onPressed: () async {
                      setState(() {
                        itemListProvider = Provider.of<ItemListProvider>(context, listen: false);
                        if(division == null || railway == null || unitName == null || department == null || userDepot == null) {
                          _validateInputs();
                        } else if(description.text.toString().trim().length < 3 || description.text.isEmpty) {
                          _validateInputs();
                          IRUDMConstants().showSnack(language.text('plNoErrorText'), context);
                        } else {
                          Navigator.of(context).pushNamed(ItemsListScreen.routeName);
                          itemListProvider.fetchAndStoreItemsListwithdata(
                              railway!,
                              unitName!,
                              division!,
                              department!,
                              userDepot!,
                              description.text.trim(),
                              context);
                        }
                      });
                    }, color: Colors.blue, textColor: Colors.white),
                MaterialButton (
                    height: 45,
                    minWidth: size.width * 0.40,
                    child: Text(language.text('reset')),
                    shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                    onPressed: () {
                      setState(() {
                        description.clear();
                        default_data();
                      });
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandDataSummaryScreen(fromdate, todate, rlycode, unittypecode, unitnamecode, departmentcode, consigneecode, indentorcode)));
                    }, color: Colors.red, textColor: Colors.white),
              ],
            )
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Container(
        //       height: 50,
        //       width: 160,
        //       child: OutlinedButton(
        //         style: IRUDMConstants.bStyle(),
        //         onPressed: () {
        //           setState(() {
        //             itemListProvider = Provider.of<ItemListProvider>(context, listen: false);
        //             if(division == null || railway == null || unitName == null || department == null || userDepot == null) {
        //               _validateInputs();
        //             } else if(description.text.toString().trim().length < 3 || description.text.isEmpty) {
        //               _validateInputs();
        //               IRUDMConstants().showSnack(language.text('plNoErrorText'), context);
        //             } else {
        //               Navigator.of(context).pushNamed(ItemsListScreen.routeName);
        //               itemListProvider.fetchAndStoreItemsListwithdata(
        //                   railway!,
        //                   unitName!,
        //                   division!,
        //                   department!,
        //                   userDepot!,
        //                   description.text.trim(),
        //                   context);
        //             }
        //           });
        //         },
        //         child: Text(language.text('getDetails'),
        //             style: TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.red[300],
        //             )),
        //       ),
        //     ),
        //     Container(
        //       width: 160,
        //       height: 50,
        //       child: OutlinedButton(
        //         style: IRUDMConstants.bStyle(),
        //         onPressed: () {
        //           setState(() {
        //             description.clear();
        //             default_data();
        //           });
        //         },
        //         child: Text(
        //           language.text('reset'),
        //           style: TextStyle(
        //             fontSize: 18,
        //             fontWeight: FontWeight.bold,
        //             color: Colors.red[300],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
    description.clear();
  }

  void initState() {
    setState(() {
      default_data();
    });
    super.initState();
  }

  Future<dynamic> fetchUnit(String? value, String unit_data) async {
    IRUDMConstants.showProgressIndicator(context);
    if (value == '-1') {
      dropdowndata_UDMUnitType.clear();
      setState(() {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUnitType.add(UnitType);
        unittype = "All";
        unitName = '-1';
        Future.delayed(Duration.zero, () {
          fetchDivision('', '-1', '');
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
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMUnitType.add(UnitType);
          unittype = "All";
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
          unittype = "All";
          unitName = '-1';
          if(unit_data != "") {
            unitName = unit_data;
          }
        });
        IRUDMConstants.removeProgressIndicator(context);
      }
    }
  }

  Future<dynamic> fetchDivision(String? rai, String? unit, String division_name) async {
    IRUDMConstants.showProgressIndicator(context);
    if (unit == '-1') {
      dropdowndata_UDMDivision.clear();
      setState(() {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMDivision.add(UnitType);
        unitname = "All";
        division = '-1';
        Future.delayed(Duration.zero, () {
          fetchDepot('-1', '', '', '', '');
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
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMDivision.add(UnitType);
          unitname = "All";
          division = '-1';
        });
        IRUDMConstants.removeProgressIndicator(context);
      } else {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMDivision.add(UnitType);
        myList_UDMDivision.addAll(divisionData);
        setState(() {
          dropdowndata_UDMDivision = myList_UDMDivision; //2
          if (division_name != "") {
            division = division_name;
          }
        });
        IRUDMConstants.removeProgressIndicator(context);
      }
    }
  }

  Future<dynamic> fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id) async {
    IRUDMConstants.showProgressIndicator(context);

    dropdowndata_UDMUserDepot.clear();
    if(rai == '-1') {
      var depotName = {
        'intcode': '-1',
        'value': "All",
      };
      dropdowndata_UDMUserDepot.add(depotName);
      dept = "All";
      userDepotName = "All";
      userDepot = "-1";
      department = '-1';
    } else {
      var result_UDMUserDepot = await Network().postDataWithAPIMList(
          'UDMAppList','UDMUserDepot' , rai! +
          "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,prefs.getString('token'));
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
          userDepotName = "All";
          userDepot = '-1';
        });
      } else {
        var UnitType = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMUserDepot.add(UnitType);
        myList_UDMUserDepot.addAll(depotData);
        setState(() {
          dropdowndata_UDMUserDepot = myList_UDMUserDepot;
          if (depot_id != "") {
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
      var d_response=await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue',
          'GetListDefaultValue',
          dbResult[0][DatabaseHelper.Tb3_col5_emailid],
          prefs.getString('token'));
      var d_JsonData = json.decode(d_response.body);
      var d_Json = d_JsonData['data'];
      var result_UDMRlyList = await Network().postDataWithAPIMList(
          'UDMAppList','UDMRlyList','',prefs.getString('token'));
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
        dropdowndata_UDMRlyList = myList_UDMRlyList;
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value']));
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

        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        Future.delayed(const Duration(milliseconds: 0), () async {
          def_fetchUnit(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString());
        });
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

  String dropdownValue = 'First';
  var _screenStage;
  String? newValue;

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String division, String depot) async {
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
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
      var result_UDMDivision=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
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

  Future<dynamic> def_fetchDepot(String rai, String depart, String unit_typ, String Unit_Name, String depot_id) async {
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
            'UDMAppList','UDMUserDepot' , rai +
            "~" + depart + "~" + unit_typ + "~" + Unit_Name,prefs.getString('token'));
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
