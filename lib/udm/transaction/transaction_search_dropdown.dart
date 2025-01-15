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
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/transaction/model/folio_no.dart';
import 'package:flutter_app/udm/transaction/transactionListDataDisplayScreen.dart';
import 'package:flutter_app/udm/transaction/transactionListDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionSearchDropDown extends StatefulWidget {
  static const routeName = "/transaction-search";
  @override
  _TransactionSearchDropDownState createState() =>
      _TransactionSearchDropDownState();
}

class _TransactionSearchDropDownState extends State<TransactionSearchDropDown> {
  double? sheetLeft;
  bool isExpanded = true;
  late TransactionListDataProvider itemListProvider;
  String? railway;
  String? railwayValue;
  String? unittype;
  String? department;
  String? userDepot;
  String? userSubDepot;
  String? itemType;
  String? itemUsage;
  String? itemCategory;
  String? stockNonStk;
  //String? division;
  String? dropDownValue;
  String? stockAvl, stkReport;
  String? unitName;
  String? ledgerNo;
  String? folioNo;
  String? folioPLNo;
  String userSubDepotValue='';

  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMDivision = [];
  List dropdowndata_UDMunitName = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMItemsResult = [];
  List dropdowndata_UDMUserSubDepot = [];
  List dropdowndata_UDMLedgerNoList = [];
  List dropdowndata_UDMFolioNoList = [];
  List dropdowndata_UDMFolioPLNoList = [];
  TextEditingController controller = TextEditingController();
  List itemTypeList = [];
  List itemUsageList = [];
  List itemtCategryaList = [];
  List stockNonStockList = [];
  List stockAvailability = [];
  List<FolioNo> folioDynamicData = [];

  late List<Map<String, dynamic>> dbResult;

  var userDepotValue = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        title: Text(Provider.of<LanguageProvider>(context).text('transaction'), style: TextStyle(color: Colors.white)),
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
                debugPrint("new railway:: $newValue");
                _formKey.currentState!.fields['Unit Name']!.setValue(null);
                _formKey.currentState!.fields['Unit Type']!.setValue(null);
                _formKey.currentState!.fields['Department']!.setValue(null);
                //_formKey.currentState!.fields['User Depot']!.setValue(null);
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  railway = newValue;

                  dropdowndata_UDMUnitType.clear();
                  dropdowndata_UDMDivision.clear();
                  dropdowndata_UDMUserDepot.clear();
                  dropdowndata_UDMUserSubDepot.clear();
                  dropdowndata_UDMUserSubDepot.add(_all());
                  dropdowndata_UDMUnitType.add(_all());
                  dropdowndata_UDMDivision.add(_all());
                  dropdowndata_UDMUserDepot.add(_all());
                  _formKey.currentState!.fields['Unit Name']!.setValue('-1');
                  _formKey.currentState!.fields['Unit Type']!.setValue('-1');
                  _formKey.currentState!.fields['Department']!.setValue('-1');
                  userDepotValue = "-1";
                  //_formKey.currentState!.fields['User Depot']!.setValue('-1');
                  _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
                  unittype = "-1";
                });
                def_fetchUnit(railway, '', '', '', '', '');
                // setState(() {
                //   railway = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'railway',
            //     '${language.text('select')} ${language.text('railway')}',
            //     dropdowndata_UDMRlyList,
            //     railway),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: englishText['unitType'] ?? 'unitType',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('unitType'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMUnitType.any((item) => item['intcode'].toString() == unittype) ? unittype : null,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMUnitType.map((item) {
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
                _formKey.currentState!.fields['Unit Name']!.setValue('-1');
                _formKey.currentState!.fields['Department']!.setValue('-1');
                setState(() {
                  unittype = newValue;
                  dropdowndata_UDMUserDepot.clear();
                  dropdowndata_UDMUserSubDepot.clear();
                  dropdowndata_UDMUserDepot.add(_all());
                  dropdowndata_UDMUserSubDepot.add(_all());
                  //_formKey.currentState!.fields['User Depot']!.setValue('-1');
                  userDepotValue = "-1";
                  _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
                });
                def_fetchunitName(railway!, unittype!, '', '', '', '');
                // setState(() {
                //   unittype = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'unitType',
            //     '${language.text('select')} ${language.text('unitType')}',
            //     dropdowndata_UDMUnitType,
            //     unitType),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: englishText['unitName'] ?? 'unitName',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('unitName'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMunitName.any((item) => item['intcode'].toString() == unitName) ? unitName : null,
              //initialValue: division,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMunitName.map((item) {
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
                  unitName = newValue;
                  itemType = null;
                  itemUsage = null;
                  itemCategory = null;
                  stockNonStk = null;
                  stockAvl = null;
                });
                // setState(() {
                //   division = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'unitName',
            //     '${language.text('select')} ${language.text('unitName')}',
            //     dropdowndata_UDMunitName,
            //     unitName),
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
                  itemCategory = null;
                  stockNonStk = null;
                  stockAvl = null;
                  def_fetchDepot(railway, department, unittype, unitName, '', '');
                });
                // setState(() {
                //   department = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'department',
            //     '${language.text('select')} ${language.text('department')}',
            //     dropdowndata_UDMDept,
            //     department),
            SizedBox(height: 10),
            DropdownSearch<String>(
              selectedItem: userDepotValue == "-1" || userDepotValue == "All" ? "All" : userDepotValue,
              //maxHeight:MediaQuery.of(context).size.height * 0.90,
              //mode: Mode.MENU,
               popupProps: PopupProps.menu(
                 showSearchBox: true,
                 showSelectedItems: true,
                   emptyBuilder: (ctx, val) {
                     return Align(
                       alignment: Alignment.topCenter,
                       child: Text('No Data Found for $val'),
                     );
                   },
                 searchFieldProps: TextFieldProps(
                   decoration: InputDecoration(
                     hintText: '${language.text('select')} ${language.text('userDepot')}',
                     contentPadding: EdgeInsetsDirectional.all(10),
                     border: const OutlineInputBorder(),
                   ),
                 ),
                 menuProps: MenuProps(shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(20),
                     topRight: Radius.circular(20),
                   ),
                 ))
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
              onChanged: (changedata) {
                print(changedata);
                if(changedata == null) return;
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  userDepotValue = changedata.toString();
                  var depot = userDepotValue.split('-');
                  // userDepotValue = depot[0];
                  def_fetchSubDepot(railway, depot[0], '');
                });
              },
            ),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: 'User Sub Depot',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('userSubDepot'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: userSubDepot,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '${language.text('select')} ${language.text('userDepot')}';
                }
                return null; // Return null if the value is valid
              },
              items: dropdowndata_UDMUserSubDepot.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['intcode'].toString() + '-' + item['value'];
                      }
                    }()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdowndata_UDMLedgerNoList.clear();
                  dropdowndata_UDMFolioNoList.clear();
                  dropdowndata_UDMFolioPLNoList.clear();
                  _formKey.currentState!.fields['LedgerNo']!.setValue(null);
                  _formKey.currentState!.fields['FolioNo']!.setValue(null);
                  _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
                  userSubDepot = newValue;
                  if(userSubDepot == "-1"){
                    print("user sub depot if value now $userSubDepot");
                    def_fetchLedgerNo(railway, userSubDepot, userSubDepot, '');
                  }
                  else{
                    print("user sub depot else value now $userSubDepot");
                    var depot = userDepotValue.split('-');
                    def_fetchLedgerNo(railway, depot[0], userSubDepot, '');
                    for(int i=0;i<dropdowndata_UDMUserSubDepot.length;i++){
                      if(newValue==dropdowndata_UDMUserSubDepot[i]['intcode']){
                        setState(() {
                          userSubDepotValue=dropdowndata_UDMUserSubDepot[i]['intcode'] + '-' + dropdowndata_UDMUserSubDepot[i]['value'];
                        });
                      }
                    }
                  }
                });
              },
            ),
            SizedBox(height: 10),
            Container(
              child: FormBuilderTextField(
                name: 'by',
                enableInteractiveSelection: true, // will disable paste operation
                autofocus: false,
                decoration: InputDecoration(
                  labelText: language.text('searchPLItemFolioDesc'),
                  hintText: language.text('searchPLItemFolioDescHint'),
                  contentPadding: EdgeInsetsDirectional.all(10),
                  border: const OutlineInputBorder(),
                ),
                onTap: () {
                  folioDynamicData.clear();
                  controller.text = '';
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Material(
                          child: setupAlertDialoadContainer(_scaffoldKey.currentContext),
                        );
                      });
                },
              ),
            ),
            SizedBox(height: 10),
            transactionDropdownNew('Ledger No.', 'LedgerNo', '${language.text('select')} ${language.text('ledgerNo')}', dropdowndata_UDMLedgerNoList, ledgerNo,language.text('ledgerNo')),
            SizedBox(height: 10),
            transactionDropdownNew('Folio No.','FolioNo', '${language.text('select')} ${language.text('folioNo')}', dropdowndata_UDMFolioNoList, folioNo,language.text('folioNo')),
            SizedBox(height: 10),
            transactionDropdownNew('Ledger Folio PL No.','LedgerFolioPlNo', '${language.text('select')} ${language.text('ledgerFolioPlNo')}', dropdowndata_UDMFolioPLNoList, folioPLNo,language.text('ledgerFolioPlNo')),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'From Date',
                    lastDate: DateTime.now(),
                    initialDate:
                    DateTime.now().subtract(const Duration(days: 90)),
                    initialValue:
                    DateTime.now().subtract(const Duration(days: 90)),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('fromDate'),
                      hintText: language.text('fromDate'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'To Date',
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('toDate'),
                      hintText: language.text('toDate'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
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
                        if(_formKey.currentState!.validate()) {
                          if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1"){
                            itemListProvider = Provider.of<TransactionListDataProvider>(context, listen: false);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionListDataDisplayScreen(userDepotValue.toString(),userSubDepotValue.toString())));
                            //var depot = userDepotValue.split('-');
                            itemListProvider.fetchTransactionListData(
                                railway,
                                unittype,
                                _formKey.currentState!.fields['Unit Name']!.value,
                                _formKey.currentState!.fields['Department']!.value,
                                "-1",
                                //_formKey.currentState!.fields['User Depot']!.value,
                                _formKey.currentState!.fields['User Sub Depot']!.value,
                                _formKey.currentState!.fields['LedgerNo']!.value,
                                _formKey.currentState!.fields['FolioNo']!.value,
                                _formKey.currentState!.fields['LedgerFolioPlNo']!.value,
                                _formKey.currentState!.fields['From Date']!.value,
                                _formKey.currentState!.fields['To Date']!.value,
                                context);
                          }
                          else{
                            itemListProvider = Provider.of<TransactionListDataProvider>(context, listen: false);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionListDataDisplayScreen(userDepotValue.toString(),userSubDepotValue.toString())));
                            var depot = userDepotValue.split('-');
                            itemListProvider.fetchTransactionListData(
                                railway,
                                unittype,
                                _formKey.currentState!.fields['Unit Name']!.value,
                                _formKey.currentState!.fields['Department']!.value,
                                depot[0],
                                _formKey.currentState!.fields['User Sub Depot']!.value,
                                _formKey.currentState!.fields['LedgerNo']!.value,
                                _formKey.currentState!.fields['FolioNo']!.value,
                                _formKey.currentState!.fields['LedgerFolioPlNo']!.value,
                                _formKey.currentState!.fields['From Date']!.value,
                                _formKey.currentState!.fields['To Date']!.value,
                                context);
                          }

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
                        default_data();
                      });
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
        labelText: name == key ? name : Provider.of<LanguageProvider>(context).text(key),
        contentPadding: EdgeInsetsDirectional.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: dropDownValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return hint;
        }
        return null; // Return null if the value is valid
      },
      items: listData.map((item) {
        return DropdownMenuItem(child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        dropDownValue = newValue;
        if(name == 'Railway') {
          _formKey.currentState!.fields['Unit Name']!.setValue(null);
          _formKey.currentState!.fields['Unit Type']!.setValue(null);
          _formKey.currentState!.fields['Department']!.setValue(null);
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            railway = newValue;
            dropdowndata_UDMUnitType.clear();
            dropdowndata_UDMunitName.clear();
            dropdowndata_UDMUserDepot.clear();
            dropdowndata_UDMUserSubDepot.clear();
            dropdowndata_UDMUserSubDepot.add(getAll());

            dropdowndata_UDMUnitType.add(getAll());
            dropdowndata_UDMunitName.add(getAll());
            dropdowndata_UDMUserDepot.add(getAll());
            _formKey.currentState!.fields['Unit Name']!.setValue('-1');
            _formKey.currentState!.fields['Unit Type']!.setValue('-1');
            _formKey.currentState!.fields['Department']!.setValue('-1');
            userDepotValue = "-1";
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');

            //userDepotValue = _formKey.currentState!.fields['User Depot']!.value;
            unittype = _formKey.currentState!.fields['Unit Type']!.value;
          });
          def_fetchUnit(railway, '', '', '', '', '');
        } else if(name == 'Unit Type') {
          _formKey.currentState!.fields['Unit Name']!.setValue('-1');
          _formKey.currentState!.fields['Department']!.setValue('-1');
          setState(() {
            unittype = newValue;
            dropdowndata_UDMUserDepot.clear();
            dropdowndata_UDMUserSubDepot.clear();
            dropdowndata_UDMUserDepot.add(getAll());
            dropdowndata_UDMUserSubDepot.add(getAll());
            userDepotValue = "-1";
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
          });
          def_fetchunitName(railway!, unittype!, '', '', '', '');
        } else if (name == 'Unit Name') {
          _formKey.currentState!.fields['Department']!.setValue(null);
          //userDepotValue = null;
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            unitName = newValue;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
          });
        } else if(name == 'Department') {
          //userDepotValue = null;
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            department = newValue;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
            def_fetchDepot(railway, department, unittype, unitName, '', '');
          });
        }
      },
    );
  }

  Widget setupAlertDialoadContainer(context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 50, left: 10, right: 10, top: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(language.text('searchPLItemFolioDescHint')),
          ),
          Card(
            elevation: 8,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: myFocusNode,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding: EdgeInsetsDirectional.all(10),
                    ),
                  ),
                ),
                Container(
                  height: 47,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
                    ),
                    onPressed: () { getFolioData(controller.text); },
                    child: Row(
                      children: [
                        Text('Fetch',style: TextStyle(fontSize:18),),
                        SizedBox(width: 3,),
                        Icon(Icons.arrow_forward_outlined,size: 20,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: listViewWidget(folioDynamicData),
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewWidget(List<FolioNo> article) {
    return Container(
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: ScrollPhysics(),
        itemCount: article.length,
        itemBuilder: (context, position) {
          return GestureDetector(
              child: Container(
                  padding:
                  EdgeInsets.only(left: 6, top: 9, right: 6, bottom: 9),
                  //padding: EdgeInsets.all(4),
                  child: Text(
                    article[position].ledgername! +
                        ': (' +
                        article[position].ledgerfolioshortdesc! +
                        ' #' +
                        article[position].ledgerkey!,maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      wordSpacing: 1,
                      height: 1.2,
                      //fontWeight: FontWeight.bold,

                    ),
                  )),
              onTap: () {
                //FocusScope.of(context).requestFocus(FocusNode());
                _formKey.currentState!.fields['LedgerNo']!.setValue(article[position].ledgerno);
                _formKey.currentState!.fields['by']!.didChange(
                    article[position].ledgername! +
                        ': (' +
                        article[position].ledgerfolioshortdesc! +
                        ' #' +
                        article[position].ledgerkey!);
                Navigator.pop(context);
                var depot = userDepotValue.split('-');
                print("user depot value ontab is $userDepotValue");
                def_fetchFolioNo(
                    railway,
                    depot[0],
                    _formKey.currentState!.fields['User Sub Depot']!.value,
                    article[position].ledgerno,
                    article[position].ledgerfoliono);
                def_fetchFolioPLNo(
                    railway,
                    depot[0],
                    _formKey.currentState!.fields['User Sub Depot']!.value,
                    article[position].ledgerno,
                    article[position].ledgerfoliono,
                    article[position].ledgerfolioplno);
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 3,
            color: Colors.black87,
          );
        },
      ),
    );
  }

  Widget transactionDropdown(String name, String hint, List listData, String? initValue,String key) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: key,
        contentPadding: EdgeInsetsDirectional.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: dropDownValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return hint;
        }
        return null; // Return null if the value is valid
      },
      items: listData.map((item) {
        return DropdownMenuItem(
            child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        dropDownValue = newValue;
        if (name == 'Railway') {
          setState(() {
            railway = newValue;
            //userDepotValue=null;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
            dropdowndata_UDMUnitType.clear();
            dropdowndata_UDMunitName.clear();
            dropdowndata_UDMUserDepot.clear();
            dropdowndata_UDMLedgerNoList.clear();
            dropdowndata_UDMFolioNoList.clear();
            dropdowndata_UDMFolioPLNoList.clear();
          });
          _formKey.currentState!.fields['Unit Name']!.setValue(null);
          _formKey.currentState!.fields['Unit Type']!.setValue(null);
          _formKey.currentState!.fields['Department']!.setValue(null);
          _formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          _formKey.currentState!.fields['by']!.reset();
          _formKey.currentState!.fields['LedgerNo']!.setValue(null);
          _formKey.currentState!.fields['FolioNo']!.setValue(null);
          _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
          def_fetchUnit(railway, '', '', '', '', '');
        } else if(name == 'Unit Type') {
          setState(() {
            unittype = newValue;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
            dropdowndata_UDMLedgerNoList.clear();
            dropdowndata_UDMFolioNoList.clear();
            dropdowndata_UDMFolioPLNoList.clear();
          });
          _formKey.currentState!.fields['Unit Name']!.setValue(null);
          _formKey.currentState!.fields['Department']!.setValue(null);
          _formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          _formKey.currentState!.fields['by']!.reset();
          _formKey.currentState!.fields['LedgerNo']!.setValue(null);
          _formKey.currentState!.fields['FolioNo']!.setValue(null);
          _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
          def_fetchunitName(railway!, unittype!, '', '', '', '');
        } else if (name == 'Unit Name') {
          setState(() {
            unitName = newValue;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
            dropdowndata_UDMLedgerNoList.clear();
            dropdowndata_UDMFolioNoList.clear();
            dropdowndata_UDMFolioPLNoList.clear();
          });
          _formKey.currentState!.fields['Department']!.setValue(null);
          _formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          _formKey.currentState!.fields['by']!.reset();
          _formKey.currentState!.fields['LedgerNo']!.setValue(null);
          _formKey.currentState!.fields['FolioNo']!.setValue(null);
          _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
        } else if (name == 'Department') {
          _formKey.currentState!.fields['User Depot']!.setValue(null);
          setState(() {
            department = newValue;
            itemType = null;
            itemUsage = null;
            //userDepotValue=null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
            dropdowndata_UDMLedgerNoList.clear();
            dropdowndata_UDMFolioNoList.clear();
            dropdowndata_UDMFolioPLNoList.clear();
          });
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          _formKey.currentState!.fields['by']!.reset();
          _formKey.currentState!.fields['LedgerNo']!.setValue(null);
          _formKey.currentState!.fields['FolioNo']!.setValue(null);
          _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
          def_fetchDepot(railway, department, unittype, unitName, '', '');
        }
      },
    );
  }

  Widget transactionDropdownNew(String hintName, String name, String hint, List listData, String? initValue,String key) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: hintName,
        contentPadding: EdgeInsets.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: dropDownValue,
      //hint: Text(key),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'field is required';
        }
        return null; // Return null if the value is valid
      },
      items: listData.map((item){
        if(item['intcode'].toString() == "-1"){
          return DropdownMenuItem(child: Text(item['value'].toString(),maxLines: 2), value: item['intcode'].toString());
        }
        else{
          return DropdownMenuItem(child: Text(item['intcode'].toString() + '-' + item['value'],maxLines: 2), value: item['intcode'].toString());
        }
      }).toList(),
      onChanged: (String? newValue) {
        var depot = userDepotValue.split('-');
        dropDownValue = newValue;
        if(name == 'LedgerNo') {
          dropdowndata_UDMFolioNoList.clear();
          dropdowndata_UDMFolioPLNoList.clear();
          _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
          _formKey.currentState!.fields['FolioNo']!.setValue(null);
          setState(() {
            _formKey.currentState!.fields['by']!.didChange('');
            ledgerNo = newValue;
            def_fetchFolioNo(railway, depot[0], userSubDepot, ledgerNo, '');
          });
        } else if(name == 'FolioNo') {
          dropdowndata_UDMFolioPLNoList.clear();
          _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(null);
          setState(() {
            folioNo = newValue;
            def_fetchFolioPLNo(railway, depot[0], userSubDepot, ledgerNo, folioNo, '');
          });
        }
      },
    );
  }

  Widget stockDropdownStatic(String name, String hint, List listData, String initValue) {
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: name,
        contentPadding: EdgeInsetsDirectional.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: dropDownValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return hint;
        }
        return null; // Return null if the value is valid
      },
      items: listData.map((item) {
        return DropdownMenuItem(
            child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        if (initValue != '') {
          setState(() {
            dropDownValue = initValue;
          });
        } else {
          dropDownValue = newValue;
        }
      },
    );
  }

  void reseteValues() {
    dropdowndata_UDMUnitType.clear();
    dropdowndata_UDMunitName.clear();
    dropdowndata_UDMUserDepot.clear();
  }
  late FocusNode myFocusNode;

  void initState() {
    myFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_){
      FocusScope.of(context).requestFocus(myFocusNode);
    });
    setState(() {
      default_data();
    });
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }
  late SharedPreferences prefs;

  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  Future<dynamic> default_data() async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response=await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue',
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

      setState(() {
        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMunitName.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railway = d_Json[0]['org_zone'];
        department = d_Json[0]['org_subunit_dept'];
        unitName = d_Json[0]['admin_unit'].toString();
        unittype = d_Json[0]['org_unit_type'].toString();
        Future.delayed(Duration(milliseconds: 0), () async {
          def_fetchUnit(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString(),
              d_Json[0]['sub_cons_code'].toString());
        });
      });
      _formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);
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

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  // new code of Unit
  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String unitName, String depot, String userSubDep) async {
    print("unit type calling now here new");
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMUnitType.add(getAll());
          _formKey.currentState!.fields['Unit Type']!.setValue("-1");
          def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        });
      } else {
        var unitData = UDMUnitType_body['data'];
        myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMUnitType = myList_UDMUnitType; //2
          print("calling new unit type $myList_UDMUnitType");
        });
        if(value == '-1') {
          def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        }
      }
      if(unit_data != "") {
        _formKey.currentState!.fields['Unit Type']!.setValue(unit_data);
        def_fetchunitName(value!, unit_data, unitName, depot, depart, userSubDep);
      } else {
        _formKey.currentState!.fields['Unit Type']!.setValue("-1");
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

  Future<dynamic> def_fetchunitName(String rai, String unit, String unitName_name, String depot, String depart, String userSubDep) async {
    try {
      var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      var myList_UDMunitName = [];
      if (UDMunitName_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMunitName.add(getAll());
          _formKey.currentState!.fields['Unit Name']!.setValue('-1');
          def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        });
        // showInSnackBar("please select other value");
      } else {
        var divisionData = UDMunitName_body['data'];
        myList_UDMunitName.add(getAll());
        myList_UDMunitName.addAll(divisionData);
        setState(() {
          //dropdowndata_UDMUserDepot.clear();
          //dropdowndata_UDMUserSubDepot.clear();
          dropdowndata_UDMunitName = myList_UDMunitName; //2
        });
        if (unit == '-1') {
          _formKey.currentState!.fields['Department']!.setValue('-1');
          def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        }
      }
      if (unitName_name != "") {
        _formKey.currentState!.fields['Unit Name']!.setValue(unitName_name);
        def_fetchDepot(
            rai, depart.toString(), unit, unitName_name, depot, userSubDep);
      } else {
        _formKey.currentState!.fields['Unit Name']!.setValue('-1');
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
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
        if (UDMUserDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserDepot.add(all);
            userDepotValue = "-1";
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
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
              //_formKey.currentState!.fields['User Depot']!.setValue(depot_id);
              dropdowndata_UDMUserDepot.forEach((item) {
                if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
                  userDepotValue = item['intcode'].toString() + '-' + item['value'];
                }
              });
              print("sub depot calling now new");
              def_fetchSubDepot(rai, depot_id, userSubDep);
            } else {

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

  Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String userSDepo) async {
    try {
      dropdowndata_UDMUserSubDepot.clear();
      if(userSDepo == 'NA') {
        print("Fetch sub depot if condition");
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserSubDepot.add(all);
        _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
        def_fetchLedgerNo(rai, depot_id, userSDepo, '');
      } else {
        print("Fetch sub depot else condition");
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if(UDMUserSubDepot_body['status'] != 'OK') {
          print("Fetch sub depot internal if condition");
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserSubDepot.add(all);
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
          });
        } else {
          print("Fetch sub depot internal else condition");
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          var subDepotData = UDMUserSubDepot_body['data'];
          myList_UDMUserDepot.add(all);
          myList_UDMUserDepot.addAll(subDepotData);
          setState(() {
            dropdowndata_UDMUserSubDepot = myList_UDMUserDepot; //2
            if(userSDepo != "") {
              def_fetchLedgerNo(rai, depot_id, userSDepo, '');
              userSubDepot = userSDepo;
              _formKey.currentState!.fields['User Sub Depot']!.setValue(userSDepo);
              for(int i=0;i<dropdowndata_UDMUserSubDepot.length;i++){
                if(userSDepo==dropdowndata_UDMUserSubDepot[i]['intcode']){
                  setState(() {
                    userSubDepotValue=dropdowndata_UDMUserSubDepot[i]['intcode'] + '-' + dropdowndata_UDMUserSubDepot[i]['value'];
                  });
                }
              }
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
        if (depart != '') {
          _formKey.currentState!.fields['Department']!.setValue(depart);
        } else {
          _formKey.currentState!.fields['Department']!.setValue('-1');
        }
      });
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

  Future<dynamic> def_fetchLedgerNo(String? rai, String? depot_id, String? userSDepo, String ledgerNo) async {
    try {
      dropdowndata_UDMLedgerNoList.clear();
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList', 'LedgerNo', rai! + "~" + depot_id! + "~" + userSDepo!,prefs.getString('token'));
      var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
      var myList_UDMUserDepot = [];
      if(UDMUserSubDepot_body['status'] != 'OK') {
        print("ledger number if condition");
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMLedgerNoList.add(all);
          _formKey.currentState!.fields['LedgerNo']!.setValue('-1');
        });
      } else {
        print("ledger number else condition");
        var subDepotData = UDMUserSubDepot_body['data'];
        myList_UDMUserDepot.addAll(subDepotData);
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMLedgerNoList.add(all);
          dropdowndata_UDMLedgerNoList = myList_UDMUserDepot; //2
          if(ledgerNo != "") {
            ledgerNo = ledgerNo;
            //_formKey.currentState!.fields['LedgerNo']!.setValue(ledgerNo);
          } else {
            // _formKey.currentState!.fields['LedgerNo']!.setValue('-1');
          }
        });
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
    }finally {
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchFolioNo(String? rai, String? depot_id, String? userSDepo, String? ledgerNo, String? folioNo) async {
    IRUDMConstants.showProgressIndicator(context);
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      dropdowndata_UDMFolioNoList.clear();
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList', 'LedgerFolioNo', rai! + "~" + depot_id! + "~" + userSDepo! + "~" + ledgerNo!,prefs.getString('token'));
      var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
      var myList_UDMUserDepot = [];
      if(UDMUserSubDepot_body['status'] != 'OK') {
        print("folio number if condition");
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMFolioNoList.add(all);
          _formKey.currentState!.fields['FolioNo']!.setValue('-1');
        });
      }
      else {
        print("folio number else condition");
        var subDepotData = UDMUserSubDepot_body['data'];
        myList_UDMUserDepot.addAll(subDepotData);
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMFolioNoList.add(all);
          dropdowndata_UDMFolioNoList = myList_UDMUserDepot; //2
          print("folio number $folioNo");
          if(folioNo != "" || folioNo!.isNotEmpty) {
            print("folio number if condition $folioNo");
            folioNo = folioNo;
            _formKey.currentState!.fields['FolioNo']!.setValue(folioNo);
          } else {
            print("folio number else condition $folioNo");
            //_formKey.currentState!.fields['FolioNo']!.setValue('-1');
          }
        });
      }
      IRUDMConstants.removeProgressIndicator(context);
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

  Future<dynamic> def_fetchFolioPLNo(String? rai, String? depot_id, String? userSDepo, String? ledgerNo, String? folioNo, String? folioPLNo) async {
    IRUDMConstants.showProgressIndicator(context);
    try {
      dropdowndata_UDMFolioPLNoList.clear();
      if (userSDepo == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        //dropdowndata_UDMFolioPLNoList.add(all);
        // _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue('-1');
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList',
            'LedgerFolioItem',
            rai! +
                "~" +
                depot_id! +
                "~" +
                userSDepo! +
                "~" +
                ledgerNo! +
                "~" +
                folioNo!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserSubDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            // dropdowndata_UDMFolioPLNoList.add(all);
            // _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue('-1');
          });
        } else {
          var subDepotData = UDMUserSubDepot_body['data'];
          myList_UDMUserDepot.addAll(subDepotData);
          setState(() {
            dropdowndata_UDMFolioPLNoList = myList_UDMUserDepot; //2
            if (folioPLNo != "") {
              folioPLNo = folioPLNo;
              _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(folioPLNo);
            } else {
              //  _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue('-1');
            }
          });
        }
      }
      IRUDMConstants.removeProgressIndicator(context);
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

  Future<List?> getFolioData(String query) async {
    IRUDMConstants.showProgressIndicator(context);
    setState(() {
      folioDynamicData.clear();
    });
    try {
      if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1" || userDepotValue == null){
        print("fetch folio data now.....1 $userDepotValue");
        var response = await Network.postDataWithAPIM(
            'UDM/transaction/V1.0.0/transaction',
            'TransactionsLedgerFolioDtls',
            railway! +
                "~" +
                _formKey.currentState!.fields['User Depot']!.value +
                "~" +
                _formKey.currentState!.fields['User Sub Depot']!.value +
                "~" +
                query,prefs.getString('token'));

        print(jsonEncode({
          'input_type': 'TransactionsLedgerFolioDtls',
          'input': railway! +
              "~" +
              _formKey.currentState!.fields['User Depot']!.value +
              "~" +
              _formKey.currentState!.fields['User Sub Depot']!.value +
              "~" +
              query
        }));
        var actionData = json.decode(response.body);
        IRUDMConstants.removeProgressIndicator(context);
        if(actionData['status'] != 'OK') {IRUDMConstants().showSnack("No Data Found", context);
        } else {
          if(response.statusCode == 200) {
            var data = actionData['data'];
            var users =
            data.map<FolioNo>((json) => FolioNo.fromJson(json)).toList();
            setState(() {
              folioDynamicData.addAll(users);
            });
            return users;
          } else {
            throw Exception('Failed to load post');
          }
        }
      }
      else{
        print("fetch folio data now.....2 $userDepotValue");
        var depot = userDepotValue.split('-');
        var response = await Network.postDataWithAPIM('UDM/transaction/V1.0.0/transaction', 'TransactionsLedgerFolioDtls', railway! + "~" + depot[0] + "~" + _formKey.currentState!.fields['User Sub Depot']!.value + "~" + query,prefs.getString('token'));
        print(jsonEncode({
          'input_type': 'TransactionsLedgerFolioDtls',
          'input': railway! +
              "~" +
              depot[0] +
              "~" +
              _formKey.currentState!.fields['User Sub Depot']!.value +
              "~" +
              query
        }));
        var actionData = json.decode(response.body);
        IRUDMConstants.removeProgressIndicator(context);
        if (actionData['status'] != 'OK') {IRUDMConstants().showSnack("No Data Found", context);
        } else {
          if (response.statusCode == 200) {
            var data = actionData['data'];
            var users =
            data.map<FolioNo>((json) => FolioNo.fromJson(json)).toList();
            setState(() {
              folioDynamicData.addAll(users);
              // FocusScope.of(context).requestFocus(FocusNode());
            });
            return users;
          } else {
            throw Exception('Failed to load post');
          }
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
      //  IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }


  // Widget getSearchableDropdown(List<dynamic> listData) {
  //   LanguageProvider language = Provider.of<LanguageProvider>(context);
  //   return DropdownSearch(
  //     selectedItem: userDepotValue == "-1" ? "All" : userDepotValue,
  //     showSearchBox: true,
  //     showSelectedItems: true,
  //     maxHeight:MediaQuery.of(context).size.height * 0.80,
  //     mode: Mode.BOTTOM_SHEET,
  //     dropdownSearchDecoration: InputDecoration(
  //       labelText: language.text('userDepot'),
  //       hintText: '${language.text('select')} ${language.text('userDepot')}',
  //       alignLabelWithHint: true,
  //       contentPadding: EdgeInsetsDirectional.all(10),
  //       border: const OutlineInputBorder(),
  //     ),
  //     searchFieldProps: TextFieldProps(
  //       decoration: InputDecoration(
  //         hintText: '${language.text('select')} ${language.text('userDepot')}',
  //         contentPadding: EdgeInsetsDirectional.all(10),
  //         border: const OutlineInputBorder(),
  //       ),
  //     ),
  //     popupShape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     popupSafeArea: const PopupSafeArea(
  //       top: true,
  //       bottom: true,
  //     ),
  //     emptyBuilder: (ctx, val) {
  //       return Align(
  //         alignment: Alignment.topCenter,
  //         child: Text('No Data Found for $val'),
  //       );
  //     },
  //     popupTitle: Align(
  //       alignment: Alignment.topRight,
  //       child: Container(
  //         height: 45,
  //         margin: EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.black87, width: 2),
  //           shape: BoxShape.circle,
  //         ),
  //         child: IconButton(
  //           icon: const Icon(Icons.close),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ),
  //     ),
  //     items: listData.map((item) {
  //       return item['intcode'].toString() + '-' + item['value'];
  //     }).toList(),
  //     onChanged: (newValue) {
  //       print(newValue);
  //       if(newValue == null) return;
  //       _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
  //       setState(() {
  //         userDepotValue = newValue.toString();
  //         var depot = userDepotValue.split('-');
  //         // userDepotValue = depot[0];
  //         def_fetchSubDepot(railway, depot[0], '');
  //       });
  //     },
  //   );
  // }
}
