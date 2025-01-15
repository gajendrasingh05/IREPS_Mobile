import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/localization/english.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/storeStkDepotProvider.dart';
import 'package:flutter_app/udm/screens/stock_list_screen.dart';
import 'package:flutter_app/udm/screens/storeStkDpt_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StoreStkDepotRightSideDrawer extends StatefulWidget {
  static const routeName = "/storeStockList-list-drawer";
  @override
  _StoreStkDepotRightSideDrawerState createState() =>
      _StoreStkDepotRightSideDrawerState();
}

class _StoreStkDepotRightSideDrawerState
    extends State<StoreStkDepotRightSideDrawer> {
  late StoreStkDepotStateProvider itemListProvider;
  String? railwayname = "Select Railway";
  String? railway;
  String? storeDepotName = "All";
  String? storeDepot;
  String? plNo;
  String? dropdownValue;

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController description = TextEditingController();

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMStoreDepot = [];

  late List<Map<String, dynamic>> dbResult;

  Error? _error;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
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
        title: Text(
          Provider.of<LanguageProvider>(context).text('storesDepotStock'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: searchDrawer(mq),
    );
  }

  Widget searchDrawer(Size mq) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(language.text('railway'),
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
                    items:(filter, loadProps) => dropdowndata_UDMRlyList.map((e) {
                      return e['value'].toString().trim();
                    }).toList(),
                    onChanged: (newValue) {
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
                          storeDepotName = "All";
                          storeDepot = "-1";
                          railway = rlycode;
                          railwayname = rlyname;
                          def_fetchUnit(railway, "");
                        });
                      } catch (e) {
                        print("execption" + e.toString());
                      }
                    },
                  ),
                ),
                //stockDropdown('Railway', '${language.text('select')} ${language.text('railway')}', dropdowndata_UDMRlyList, railway),
                SizedBox(height: 10),
                Text(language.text('storesDepot'),
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
                    selectedItem: storeDepotName,
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
                    items:(filter, loadProps) => dropdowndata_UDMStoreDepot.map((e) {
                      return e['value'].toString().trim();
                    }).toList(),
                    onChanged: (String? newValue){
                      var depotname;
                      var depotcode;
                      dropdowndata_UDMStoreDepot.forEach((element) {
                        if(newValue.toString() == element['value'].toString()) {
                          depotname = element['value'].toString().trim();
                          depotcode = element['intcode'].toString();
                        }
                      });
                      setState(() {
                        storeDepotName = depotname;
                        storeDepot = depotcode;
                      });
                    },
                  ),
                ),
                // FormBuilderDropdown(
                //   name: 'Stores Depot',
                //   focusColor: Colors.transparent,
                //   decoration: InputDecoration(
                //     labelText: language.text('storesDepot'),
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     contentPadding: EdgeInsetsDirectional.all(10),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(),
                //   ),
                //   initialValue: storeDepot,
                //   allowClear: false,
                //   hint: Text('${language.text('select')} Stores Depot'),
                //   validator: FormBuilderValidators.compose(
                //       [FormBuilderValidators.required(context)]),
                //   items: dropdowndata_UDMStoreDepot.map((item) {
                //     return DropdownMenuItem(
                //         child: Text(item['value']),
                //         value: item['intcode'].toString());
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     print("New value of store depot");
                //     setState(() {
                //       storeDepot = newValue;
                //     });
                //   },
                // ),
                SizedBox(height: 10),
                Text('${language.text('plNo')}/${language.text('description')}', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                TextFormField(
                  controller: description,
                  validator: (val) {
                    if (val == null || val.length < 3) {
                      return language.text('plNoErrorText');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 1.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: language.text('plNoDisplayText'),
                    errorText: _autoValidate ? language.text('plNoErrorText') : null,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    width: mq.width,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton (
                            height: 45,
                            minWidth: mq.width * 0.40,
                            child: Text(language.text('getDetails')),
                            shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                            onPressed: () async {
                              setState(() {
                                if(description.text.toString().trim().length < 3 || description.text.isEmpty) {
                                  IRUDMConstants().showSnack("PL no must be greater than three character", context);
                                } else {
                                  itemListProvider = Provider.of<StoreStkDepotStateProvider>(context, listen: false);
                                  Navigator.of(context).pushNamed(StoreStkDepotListScreen.routeName);
                                  itemListProvider.fetchAndStoreItemsListwithdata(
                                      railway,
                                      storeDepot,
                                      description.text.trim(),
                                      context);

                                }
                              });
                            }, color: Colors.blue, textColor: Colors.white),
                        MaterialButton (
                            height: 45,
                            minWidth: mq.width * 0.40,
                            child: Text(language.text('reset')),
                            shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                            onPressed: () {
                              description.text = '';
                              default_data();
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
                //             if(description.text.toString().trim().length < 3 || description.text.isEmpty) {
                //               IRUDMConstants().showSnack("PL no must be greater than three character", context);
                //             } else {
                //               itemListProvider = Provider.of<StoreStkDepotStateProvider>(context, listen: false);
                //               Navigator.of(context).pushNamed(StoreStkDepotListScreen.routeName);
                //               itemListProvider.fetchAndStoreItemsListwithdata(
                //                   railway,
                //                   storeDepot,
                //                   description.text.trim(),
                //                   context);
                //
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
                //             //_formKey.currentState!.fields['plNo']!.didChange("");
                //             setState(() {
                //               default_data();
                //             });
                //           });
                //         },
                //         child: Text(language.text('reset'),
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.red[300],
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
              ]),
        ),
      ],
    );
  }

  Widget stockDropdown(String key, String hint, List listData, String? initValue) {
    String name = englishText[key] ?? key;
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: name == key
            ? name
            : Provider.of<LanguageProvider>(context).text(key),
        contentPadding: EdgeInsetsDirectional.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: dropdownValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'field is required';
        }
        return null; // Return null if the value is valid
      },
      items: listData.map((item) {
        return DropdownMenuItem(
            child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        dropdownValue = newValue;
        setState(() {
          railway = newValue;
          def_fetchUnit(newValue, '');
        });
      },
    );
  }

  void reseteValues() {}

  void initState() {
    setState(() {
      default_data();
    });
    super.initState();
  }

  late SharedPreferences prefs;
  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  Future<dynamic> default_data() async {
    Future.delayed(Duration(milliseconds: 0), () {
      IRUDMConstants.showProgressIndicator(context);
    });
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
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
      myList_UDMRlyList.addAll(rlyData);
      setState(() {
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        railway = d_Json[0]['org_zone'];
        railwayname = d_Json[0]['account_name'];
        Future.delayed(Duration(milliseconds: 100), () async {
          def_fetchUnit(d_Json[0]['org_zone'], '-1');
        });
      });
      IRUDMConstants.removeProgressIndicator(context);
      //  _progressHide();
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

  Future<dynamic> def_fetchUnit(String? value, String unit_data) async {
    print("Unit Data here $unit_data");
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMStoreDepot.clear();
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMStoresDepot', value, prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      var unitData = UDMUnitType_body['data'];
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMStoreDepot.add(all);
          storeDepot = "-1";
          storeDepotName = "All";
          //_formKey.currentState!.fields['Stores Depot']!.setValue("-1");
        });
      } else {
        myList_UDMUnitType.add(all);
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMStoreDepot = myList_UDMUnitType;
          print(myList_UDMUnitType);
        });
      }
      if(unit_data != "") {
        storeDepot = unit_data;
        //_formKey.currentState!.fields['Stores Depot']!.setValue(unit_data);
      } else {
        storeDepot = "-1";
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
}
