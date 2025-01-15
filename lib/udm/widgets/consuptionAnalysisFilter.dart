import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/localization/english.dart';
import 'package:flutter_app/udm/providers/consAnalysisProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/consAnalysisiListScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumtionAnalysisFilter extends StatefulWidget {
  static const routeName = "/consumption-analysis-stock";
  @override
  _ConsumtionAnalysisFilterState createState() =>
      _ConsumtionAnalysisFilterState();
}

class _ConsumtionAnalysisFilterState extends State<ConsumtionAnalysisFilter> {
  double? sheetLeft;
  bool isExpanded = true;
  late ConsAnalysisProvider itemListProvider;
  String? railway;
  String? department;
  String? unittype;
  String? unitname;
  String? userDepot;
  String? userSubDepot;
  String? dropDownValue;
  String? itemType;
  String? itemUsage;
  final _formKey = GlobalKey<FormBuilderState>();

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMItemsResult = [];
  List dropdowndata_UDMUserSubDepot = [];
  List itemTypeList = [];
  List itemUsageList = [];

  bool itemTypeVis = false;
  bool itemUsageVis = false;

  bool itemTypeButtonVis = true;
  bool itemUsageBtnVis = true;

  String percntValue = '20.0';
  late List<Map<String, dynamic>> dbResult;

  Error? _error;
  bool _autoValidate = false;

  var userDepotValue = "All";

  @override
  Widget build(BuildContext context) {
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
        title: Text(language.text('consAnalysis'),style: TextStyle(color: Colors.white)),
      ),
      body: searchDrawer(),
    );
  }

  Widget searchDrawer() {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(children: <Widget>[
            FormBuilderDropdown(
              name: englishText['railway'] ?? 'railway',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('Railway'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: railway,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMRlyList.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                _formKey.currentState!.fields['Department']!.setValue(null);
                //_formKey.currentState!.fields['User Depot']!.setValue(null);
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  railway = newValue;
                  dropdowndata_UDMUserDepot.clear();
                  dropdowndata_UDMUserSubDepot.clear();
                  dropdowndata_UDMDept.clear();
                  dropdowndata_UDMUserSubDepot.add(_all());
                  dropdowndata_UDMUserDepot.add(_all());
                  dropdowndata_UDMDept.add(_all());
                  _formKey.currentState!.fields['Department']!.setValue('-1');
                  userDepotValue = "-1";
                  //_formKey.currentState!.fields['User Depot']!.setValue('-1');
                  _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
                });
                def_depart_result(railway!);
                fetchConsignee(railway, '', '', '');
              },
            ),
            // stockDropdown(
            //     'railway',
            //     '${language.text('select')} ${language.text('railway')}',
            //     dropdowndata_UDMRlyList,
            //     railway),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: englishText['department'] ?? 'department',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('department'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMDept.any((item) => item['intcode'].toString() == department) ? department : null,
              //initialValue: division,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMDept.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return  item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  department = newValue;
                  itemType = null;
                  itemUsage = null;
                });
                fetchConsignee(railway, department, '', '');
              },
            ),
            // stockDropdown(
            //     'department',
            //     '${language.text('select')} ${language.text('department')}',
            //     dropdowndata_UDMDept,
            //     department),
            SizedBox(height: 10),
            DropdownSearch<String>(
              //showSearchBox: true,
              //showSelectedItems: true,
              selectedItem: userDepotValue == "-1" || userDepotValue == "All" ? "All" : userDepotValue,
              //maxHeight:MediaQuery.of(context).size.height * 0.90,
              //mode: Mode.MENU,
              popupProps: PopupPropsMultiSelection.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
                showSelectedItems: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: '${language.text('select')} ${language.text('userDepot')}',
                    contentPadding: EdgeInsetsDirectional.all(10),
                    border: const OutlineInputBorder(),
                  ),
                ),
                emptyBuilder: (ctx, val) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Text('No Data Found for $val'),
                  );
                },
                menuProps: MenuProps(
                    shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.grey), // You can customize the border color
                    )
                ),
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: language.text('userDepot'),
                  hintText: '${language.text('select')} ${language.text('userDepot')}',
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 5.0, top: 5.0),
                  border: const OutlineInputBorder(),
                )
              ),

              // popupShape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(20),
              //     topRight: Radius.circular(20),
              //   ),
              // ),
              // popupSafeArea: const PopupSafeArea(
              //   top: true,
              //   bottom: true,
              // ),
              //
              // popupTitle: Align(
              //   alignment: Alignment.topRight,
              //   child: Container(
              //     height: 45,
              //     margin: EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.black87, width: 2),
              //       shape: BoxShape.circle,
              //     ),
              //     child: IconButton(
              //       icon: const Icon(Icons.close),
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //     ),
              //   ),
              // ),
              items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((item) {
                return item['intcode'].toString() != "-1" ? item['intcode'].toString() + '-' + item['value'] : item['value'].toString();
              }).toList(),
              onChanged: (String? newValue) {
                dropDownValue = newValue;
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  userDepotValue = newValue.toString();
                  var depot = userDepotValue.split('-');
                  def_fetchSubDepot(railway, depot[0], '');
                });
              },
            ),
            // FormBuilderDropdown(
            //   name: 'User Depot',
            //   focusColor: Colors.transparent,
            //   decoration: InputDecoration(
            //     labelText: language.text('userDepot'),
            //     contentPadding: EdgeInsetsDirectional.all(10),
            //     border: const OutlineInputBorder(),
            //   ),
            //   initialValue: dropDownValue,
            //   allowClear: false,
            //   hint: Text(
            //       '${language.text('select')} ${language.text('userDepot')}'),
            //   validator: FormBuilderValidators.compose(
            //       [FormBuilderValidators.required(context)]),
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
            //     dropDownValue = newValue;
            //     _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
            //     setState(() {
            //       userDepot = newValue;
            //       def_fetchSubDepot(railway, dropDownValue, '');
            //     });
            //   },
            // ),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: 'User Sub Depot',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('userSubDepot'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMUserSubDepot.any((item) => item['intcode'].toString() == userSubDepot) ? userSubDepot : null,
              //initialValue: userSubDepot,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'field is required';
                }
                return null; // Return null if the value is valid
              },
              items: dropdowndata_UDMUserSubDepot.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if (item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['intcode'].toString() + '-' + item['value'];
                      }
                    }()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  userSubDepot = newValue;
                });
              },
            ),
            Visibility(
              visible: itemTypeVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  stockDropdownStatic(
                      'itemType', 'Select Item Type', itemTypeList, itemType,
                      name: 'Item Type'),
                ],
              ),
            ),
            Visibility(
              visible: itemUsageVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  stockDropdownStatic(
                    'itemUsage',
                    'Select Item Usage',
                    itemUsageList,
                    itemUsage,
                    name: 'Item Usage',
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(language.text('currentPeriod')),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'CFrom',
                    lastDate: DateTime.now(),
                    initialDate:
                    DateTime.now().subtract(const Duration(days: 60)),
                    initialValue:
                    DateTime.now().subtract(const Duration(days: 60)),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('from'),
                      hintText: 'Current Period: From',
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'CTo',
                    // firstDate: DateTime.now().subtract(const Duration(days: 180)),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('to'),
                      hintText: 'Current Period: To',
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    // onChanged: _onChanged,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(language.text('previousPeriod')),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'PFrom',
                    //firstDate: DateTime.now().subtract(const Duration(days: 120)),
                    lastDate: DateTime.now(),
                    initialDate:
                    DateTime.now().subtract(const Duration(days: 121)),
                    initialValue:
                    DateTime.now().subtract(const Duration(days: 121)),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('from'),
                      hintText: 'Previous Period: From',
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    // onChanged: _onChanged,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'PTo',
                    // firstDate: DateTime.now().subtract(const Duration(days: 180)),
                    lastDate: DateTime.now(),
                    initialDate:
                    DateTime.now().subtract(const Duration(days: 61)),
                    initialValue:
                    DateTime.now().subtract(const Duration(days: 61)),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('to'),
                      hintText: 'Previous Period: To',
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    // onChanged: _onChanged,
                  ),
                ),
                // SizedBox(height:10),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FormBuilderRadioGroup(
                    name: 'perc',
                    initialValue: language.text('increase'),
                    decoration: InputDecoration(
                      labelText: language.text('percentageChange'),
                      contentPadding: EdgeInsetsDirectional.all(0),
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.disabled,
                    options: [
                      language.text('increase'),
                      language.text('decrease')
                    ].map((lang) => FormBuilderFieldOption(value: lang)).toList(growable: false),
                    onChanged: (String? newValue) {

                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: FormBuilderTextField(
                        name: 'by',
                        initialValue: percntValue,
                        decoration: InputDecoration(
                          labelText: language.text('by'),
                          contentPadding: EdgeInsetsDirectional.all(10),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "%",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                // Expanded(child: Icon(IconData(0xf73f))),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                Visibility(
                  visible: itemTypeButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          itemTypeVis = true;
                          itemTypeButtonVis = false;
                          if (itemTypeVis) {
                            itemType = '-1';
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            language.text('itemType'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: itemUsageBtnVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          itemUsageVis = true;
                          itemUsageBtnVis = false;
                          if (itemUsageVis) {
                            itemUsage = '-1';
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            language.text('itemUsage'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                        if (_formKey.currentState!.validate()) {
                          if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1"){
                            itemListProvider = Provider.of<ConsAnalysisProvider>(
                                context,
                                listen: false);
                            Navigator.of(context)
                                .pushNamed(ConsAnalysisScreen.routeName);
                            _formKey.currentState!.save();
                            String pFrom = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['PFrom']!.value);
                            String pTo = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['PTo']!.value);

                            String cFrom = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['CFrom']!.value);
                            String cTo = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['CTo']!.value);
                            String percValue = '';
                            if (_formKey.currentState!.fields['perc']!.value ==
                                language.text('decrease')) {
                              percValue = '2';
                            } else {
                              percValue = '1';
                            }

                            if (!itemUsageVis) {
                              itemUsage = '-1';
                            } else {
                              itemUsage = _formKey
                                  .currentState!.fields['Item Usage']!.value;
                            }
                            String? itemUnit;
                            if (!itemTypeVis) {
                              itemUnit = '-1';
                            } else {
                              itemUnit = _formKey
                                  .currentState!.fields['Item Type']!.value;
                            }
                            itemListProvider.fetchAndStoreItemsListwithdata(
                                railway,
                                _formKey.currentState!.fields['Department']!.value,
                                "-1",
                                //_formKey.currentState!.fields['User Depot']!.value,
                                _formKey.currentState!.fields['User Sub Depot']!.value,
                                itemUsage,
                                itemUnit,
                                cFrom,
                                cTo,
                                pFrom,
                                pTo,
                                percValue,
                                _formKey.currentState!.fields['by']!.value,
                                context);
                          }
                          else {
                            itemListProvider = Provider.of<ConsAnalysisProvider>(
                                context,
                                listen: false);
                            Navigator.of(context).pushNamed(ConsAnalysisScreen.routeName);
                            var depot = userDepotValue.split('-');
                            _formKey.currentState!.save();
                            String pFrom = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['PFrom']!.value);
                            String pTo = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['PTo']!.value);

                            String cFrom = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['CFrom']!.value);
                            String cTo = DateFormat('dd/MM/yyyy').format(
                                _formKey.currentState!.fields['CTo']!.value);
                            String percValue = '';
                            if (_formKey.currentState!.fields['perc']!.value ==
                                language.text('decrease')) {
                              percValue = '2';
                            } else {
                              percValue = '1';
                            }

                            if (!itemUsageVis) {
                              itemUsage = '-1';
                            } else {
                              itemUsage = _formKey
                                  .currentState!.fields['Item Usage']!.value;
                            }
                            String? itemUnit;
                            if (!itemTypeVis) {
                              itemUnit = '-1';
                            } else {
                              itemUnit = _formKey
                                  .currentState!.fields['Item Type']!.value;
                            }
                            itemListProvider.fetchAndStoreItemsListwithdata(
                                railway,
                                _formKey.currentState!.fields['Department']!.value,
                                depot[0],
                                //_formKey.currentState!.fields['User Depot']!.value,
                                _formKey.currentState!.fields['User Sub Depot']!.value,
                                itemUsage,
                                itemUnit,
                                cFrom,
                                cTo,
                                pFrom,
                                pTo,
                                percValue,
                                _formKey.currentState!.fields['by']!.value,
                                context);
                          }
                        }
                      });
                    },
                    // style: ButtonStyle(
                    //   backgroundColor:
                    // ),
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
                        itemTypeVis = false;
                        itemUsageVis = false;

                        itemTypeButtonVis = true;
                        itemUsageBtnVis = true;
                        _formKey.currentState!.reset();
                        default_data();
                        //reseteValues();
                      });
                    },
                    // style: ButtonStyle(
                    //   backgroundColor:
                    // ),
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

  _all() {
    var all = {
      'intcode': '-1',
      'value': 'All',
    };
    return all;
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
      initialValue: dropDownValue,
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
        dropDownValue = newValue;
        if(name == 'Railway') {
          _formKey.currentState!.fields['Department']!.setValue(null);
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            railway = newValue;
            dropdowndata_UDMUserDepot.clear();
            dropdowndata_UDMUserSubDepot.clear();
            dropdowndata_UDMDept.clear();
            dropdowndata_UDMUserSubDepot.add(_all());
            dropdowndata_UDMUserDepot.add(_all());
            dropdowndata_UDMDept.add(_all());
            _formKey.currentState!.fields['Department']!.setValue('-1');
            userDepotValue = "-1";
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
          });
          def_depart_result(railway!);
          fetchConsignee(railway, '', '', '');
        }
        else if (name == 'Department') {
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            department = newValue;
            itemType = null;
            itemUsage = null;
          });
          fetchConsignee(railway, department, '', '');
        }
      },
    );
  }

  Widget stockDropdownStatic(String key, String hint, List listData, String? initValue, {String? name}) {
    if (name == null) {
      name = key;
    }
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
      initialValue: initValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'field is required';
        }
        return null; // Return null if the value is valid
      },
      items: listData.map((item) {
        return DropdownMenuItem(child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          initValue = newValue;
        });
      },
    );
  }

  void reseteValues() {
    dropdowndata_UDMUserDepot.clear();
  }

  void initState() {
    setState(() {
      default_data();
    });
    super.initState();
  }
  late SharedPreferences prefs;
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  Future<dynamic> default_data() async {
    Future.delayed(
        Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    itemTypeList.clear();
    itemUsageList.clear();
    //Item Usage Item Category Whether Stock/Non-Stock
    // _formKey.currentState.fields['Item Type'].reset();
    //_formKey.currentState.fields['Item Type'].reset();
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
      myList_UDMRlyList.addAll(rlyData);

      var staticDataresponse =
      await Network.postDataWithAPIM('app/Common/UdmAppListStatic/V1.0.0/UdmAppListStatic', 'UdmAppListStatic', '',prefs.getString('token'));

      var staticData = json.decode(staticDataresponse.body);
      List staticDataJson = staticData['data'];

      var itemCatDataUrl = await Network().postDataWithAPIMList(
          'UDMAppList','ItemCategory','',prefs.getString('token'));
      var itemData = json.decode(itemCatDataUrl.body);
      var itemCatDataJson = itemData['data'];

      for (int i = 0; i < staticDataJson.length; i++) {
        if (staticDataJson[i]['list_for'] == 'ItemType') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            itemTypeList.add(all);
          });
        }

        if(staticDataJson[i]['list_for'] == 'ItemUsage') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            itemUsageList.add(all);
          });
        }
      }

      setState(() {
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railway = d_Json[0]['org_zone'];
        department = d_Json[0]['org_subunit_dept'];
        unittype = d_Json[0]['org_unit_type'].toString();
        unitname = d_Json[0]['admin_unit'].toString();
        userDepot = d_Json[0]['ccode'].toString();
        userSubDepot = d_Json[0]['sub_cons_code'].toString();
        Future.delayed(Duration(milliseconds: 0), () async {
          def_fetchDepot(
              d_Json[0]['org_zone'],
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString(),
              d_Json[0]['sub_cons_code'].toString());
        });
      });
      _formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);
      if (staticDataresponse.statusCode == 200) {
        //  _formKey.currentState.fields['Item Usage' ].setValue('-1');
        //  _formKey.currentState.fields['Item Type'].setValue('-1');
        //  _formKey.currentState.fields['Item Category'].setValue('-1');
        //  _formKey.currentState.fields['Whether Stock/Non-Stock'].setValue('-1');
      }
      //  _progressHide();
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<dynamic> fetchConsignee(String? rai, String? depart, String depot_id, String userSubDep) async {
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMUserDepot.clear();
    if(rai == '-1') {
      var consigneeName = {
        'intcode': '-1',
        'value': "All",
      };
      dropdowndata_UDMUserDepot.add(consigneeName);
    } else {
      var result_UDMConsignee = await Network().postDataWithAPIMList(
          'UDMAppList','ConsigneeInBillStatus' , rai! ,prefs.getString('token'));
      var UDMConsignee_body = json.decode(result_UDMConsignee.body);
      var depotData = UDMConsignee_body['data'];
      var myList_UDMConsignee = [];
      if (UDMConsignee_body['status'] != 'OK') {
        setState(() {
          var _all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMUserDepot.add(_all);
          userDepotValue = _all['intcode'].toString();
        });
      } else {
        myList_UDMConsignee.addAll(depotData);
        setState(() {
          dropdowndata_UDMUserDepot = myList_UDMConsignee;
          if(depot_id != "") {
            userDepot = depot_id;
            dropdowndata_UDMUserDepot.forEach((item) {
              if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
                userDepotValue = item['intcode'].toString() + '-' + item['value'];
              }
            });
            print("sub depot calling now new");
            def_fetchSubDepot(rai, depot_id, userSubDep);
          } else {
            userDepotValue = "-1";
          }
        });
      }
    }
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
    try {
      dropdowndata_UDMUserDepot.clear();
      if(depot_id == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserDepot.add(all);
        userDepotValue = "-1";
        //_formKey.currentState!.fields['User Depot']!.setValue('-1');
        def_fetchSubDepot(rai, depot_id, userSubDep);
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
        var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if(UDMUserDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserDepot.add(all);
            userDepotValue = "-1";
            def_fetchSubDepot(rai, depot_id, userSubDep);
          });
        } else {
          var depoData = UDMUserDepot_body['data'];
          dropdowndata_UDMUserSubDepot.clear();
          myList_UDMUserDepot.addAll(depoData);
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot;
            if(depot_id != "") {
              userDepot = depot_id;
              dropdowndata_UDMUserDepot.forEach((item) {
                if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
                  userDepotValue = item['intcode'].toString() + '-' + item['value'];
                }
              });
              print("sub depot calling now new");
              def_fetchSubDepot(rai, depot_id, userSubDep);
            } else {
              userDepotValue = "-1";
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
    }
  }

  // Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
  //   try {
  //     dropdowndata_UDMUserDepot.clear();
  //     if (depot_id == 'NA') {
  //       var all = {
  //         'intcode': '-1',
  //         'value': "All",
  //       };
  //       userDepot = '-1';
  //       dropdowndata_UDMUserDepot.add(all);
  //       _formKey.currentState!.fields['User Depot']!.setValue('-1');
  //       def_fetchSubDepot(rai, depot_id, userSubDep);
  //     } else {
  //
  //       var result_UDMUserDepot = await Network().postDataWithAPIMList(
  //           'UDMAppList','UDMUserDepot' ,
  //           rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,prefs.getString('token'));
  //       var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
  //       var myList_UDMUserDepot = [];
  //       if (UDMUserDepot_body['status'] != 'OK') {
  //         setState(() {
  //           var all = {
  //             'intcode': '-1',
  //             'value': "All",
  //           };
  //           dropdowndata_UDMUserDepot.add(all);
  //           _formKey.currentState!.fields['User Depot']!.setValue('-1');
  //           def_fetchSubDepot(rai, depot_id, userSubDep);
  //         });
  //       } else {
  //         var depoData = UDMUserDepot_body['data'];
  //         dropdowndata_UDMUserSubDepot.clear();
  //         var all = {
  //           'intcode': '-1',
  //           'value': "All",
  //         };
  //         myList_UDMUserDepot.add(all);
  //         myList_UDMUserDepot.addAll(depoData);
  //         setState(() {
  //           dropdowndata_UDMUserDepot = myList_UDMUserDepot; //2
  //           if (depot_id != "") {
  //             userDepot = depot_id;
  //             _formKey.currentState!.fields['User Depot']!.setValue(depot_id);
  //             def_fetchSubDepot(rai, depot_id, userSubDep);
  //           } else {
  //             _formKey.currentState!.fields['User Depot']!.didChange('-1');
  //           }
  //         });
  //       }
  //     }
  //   } on HttpException {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   } on SocketException {
  //     IRUDMConstants()
  //         .showSnack("No connectivity. Please check your connection.", context);
  //   } on FormatException {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   } catch (err) {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   }
  // }

  Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String userSDepo) async {
    try {
      dropdowndata_UDMUserSubDepot.clear();
      if (userSDepo == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserSubDepot.add(all);
        _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserSubDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserSubDepot.add(all);
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
          });
        } else {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          var subDepotData = UDMUserSubDepot_body['data'];
          myList_UDMUserDepot.add(all);
          myList_UDMUserDepot.addAll(subDepotData);
          setState(() {
            dropdowndata_UDMUserSubDepot = myList_UDMUserDepot; //2
            if (userSDepo != "") {
              userSubDepot = userSDepo;
              _formKey.currentState!.fields['User Sub Depot']!
                  .setValue(userSDepo);
            } else {
              _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
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
        if(depart != '') {
          _formKey.currentState!.fields['Department']!.setValue(depart);
        } else {
          _formKey.currentState!.fields['Department']!.setValue('-1');
        }
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

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }


}
