import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/poSearchProvider.dart';
import 'package:flutter_app/udm/screens/poSearch_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class POSearchRightSideDrawer extends StatefulWidget {
  static const routeName = "/list-drawer";

  @override
  _POSearchRightSideDrawerState createState() {
    return _POSearchRightSideDrawerState();
  }
}

class _POSearchRightSideDrawerState extends State<POSearchRightSideDrawer> {
  double? sheetLeft;
  bool isExpanded = true;

  late PoSearchStateProvider itemListProvider;
  String? railway;
  String itmeDesc = '', pono = '', vName = '', poF = '', poT = '', itmeDesc2 = "";
  String? dropDownValue;
  String consigneeValue = '';
  String deptValue = '';
  String deptcode = '';
  String? skngStrDptValue = '';
  bool purchaseEnabl = false;

  bool deptVis = true;
  bool consgVis = true;
  bool stkngStrVis = false;
  bool pLVis = false;
  String? plNoValue = '';

  String? poPlacinginitV;
  String? purchasSec;
  String? coverStatusDefault;
  String? tenderDef;
  String? insAgenDef;
  String? indusDef;
  String? poTypeDef;

  bool poVis = true;
  bool itemDis1Vis = false;
  bool vendorNameVis = true;
  bool poValueVis = false;
  bool poValueButtonVis = true;
  bool vendrNameButtonVis = true;
  bool poNoButtonVis = true;
  bool itemDisButton = true;

  bool poPlacingVis = false;
  bool purchaseSVis = false;
  bool coverageSVis = false;
  bool tenderTVis = false;
  bool insAgenVis = false;
  bool industryTypVis = false;
  bool poTypeVis = false;

  bool poPlacButtonVis = true;
  bool purchsButtonVis = true;
  bool covrStatsButtonVis = true;
  bool tenderButtonVis = true;
  bool insAgeButtonVis = true;
  bool indusTypButtonVis = true;
  bool poTypButtonVis = true;

  final _formKey = GlobalKey<FormBuilderState>();

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMTenderList = [];
  List dropdowndata_UDMDeptList = [];
  List dropdowndata_UDMConsList = [];
  List dropdowndata_UDMPoPlacingList = [];
  List dropdowndata_UDMPurchaseList = [];
  List indusTypeList = [];

  List stockNonStockList = [];
  List coverageStatusList = [];
  List inspectionAgencyList = [];
  List stkStoreDepotList = [];

  List pOTypeList = [];

  late List<Map<String, dynamic>> dbResult;

  Error? _error;
  bool _autoValidate = false;

  var item_data = {"OR", "AND"};
  var stockValue = {"Stock", "Non-Stock", "Both(Stock or Non-Stock)"};

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
        title: Text(language.text('poSearch'), style: TextStyle(color: Colors.white)),
      ),
      body: searchDrawer(),
    );
  }

  Widget getSearchableDropdown(List<dynamic> listData, LanguageProvider languageProvider) {
    return DropdownSearch<String>(
      selectedItem: consigneeValue == '' ? "All" : consigneeValue,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        title: Text(languageProvider.text('consignee')),
        emptyBuilder: (ctx, val) {
            return Align(
              alignment: Alignment.topCenter,
              child: Text('No Data Found for $val'),
            );
          },
        menuProps: MenuProps(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.grey),
        ))
      ),
      items: (filter, loadProps) => dropdowndata_UDMConsList.map((item) {
        return item['intcode'].toString() == '-1' ? "All" : item['intcode'].toString()+ '-' + item['value'].toString().trim();
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          consigneeValue = newValue!;
        });
      },
    );
  }

  Widget getSearchableDept(List<dynamic> listData, LanguageProvider languageProvider) {
    return DropdownSearch<String>(
      selectedItem: deptValue == '' ? "All" : deptValue,
      popupProps: PopupProps.menu(
          showSearchBox: true,
          title: Text(languageProvider.text('selectdepartment')),
          emptyBuilder: (ctx, val) {
            return Align(
              alignment: Alignment.topCenter,
              child: Text('No Data Found for $val'),
            );
          },
          menuProps: MenuProps(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.grey),
          ))
      ),
      items: (filter, loadProps) => dropdowndata_UDMDeptList.map((item) {
        return item['value'].toString().trim();
      }).toList(),
      onChanged: (newValue) {
        dropdowndata_UDMDeptList.forEach((element) {
          if(newValue.toString().trim() == element['value'].toString().trim()){
            deptValue = element['value'].toString().trim();
            deptcode = element['intcode'].toString() == "-1" ? '' : element['intcode'].toString();
          }
        });
      },
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
              name: 'Railway',
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
                dropDownValue = newValue;
                setState(() {
                  railway = newValue;
                  deptValue = '';
                  deptcode = '';
                  def_fetchPoPlacing(newValue, '');
                  if(consgVis == true) {
                    consigneeData(newValue, '');
                  }
                  if (stkngStrVis == true) {
                    def_fetchStkStrDepot(newValue);
                  }
                });
              },
            ),
            // poSearchDropdown(
            //     'railway',
            //     '${language.text('select')} ${language.text('railway')}',
            //     dropdowndata_UDMRlyList,
            //     railway,
            //     name: 'Railway'),
            SizedBox(height: 10),
            FormBuilderRadioGroup(
              name: 'SNS',
              initialValue: "Both(Stock or Non-Stock)",
              decoration: InputDecoration(
                labelText: language.text('stockNonStock'),
                contentPadding: EdgeInsetsDirectional.all(0),
                border: InputBorder.none,
              ),
              autovalidateMode: AutovalidateMode.disabled,
              options: stockValue.map((lang) => FormBuilderFieldOption(value: lang)).toList(growable: false),
              onChanged: (String? newValue) {
                if(newValue == 'Stock') {
                  setState(() {
                    consgVis = false;
                    deptVis = false;
                    stkngStrVis = true;
                    pLVis = true;
                    consigneeValue = '';
                    deptcode = '';
                    def_fetchStkStrDepot(railway);
                  });
                } else {
                  setState(() {
                    consgVis = true;
                    deptVis = true;
                    stkngStrVis = false;
                    pLVis = false;
                    deptValue = '';
                    deptcode = '';
                    consigneeValue = '';
                    skngStrDptValue = '';
                  });
                }
              },
            ),
            SizedBox(height: 10),
            Visibility(
              visible: deptVis,
              child: getSearchableDept(dropdowndata_UDMDeptList, language),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: consgVis,
              child: getSearchableDropdown(dropdowndata_UDMConsList, language),
            ),
            Visibility(
              visible: stkngStrVis,
              child: FormBuilderDropdown(
                name: language.text('stockingStoreDepot'),
                focusColor: Colors.transparent,
                decoration: InputDecoration(
                  labelText: language.text('stockingStoreDepot'),
                  contentPadding: EdgeInsetsDirectional.all(10),
                  border: const OutlineInputBorder(),
                ),
                initialValue: skngStrDptValue,
                //allowClear: false,
                //hint: Text(language.text('select')+' '+language.text('stockingStoreDepot')),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'field is required';
                  }
                  return null; // Return null if the value is valid
                },
                //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                items: stkStoreDepotList.map((item) {
                  return DropdownMenuItem(
                      child: Text(item['value']),
                      value: item['intcode'].toString());
                }).toList(),
                onChanged: (String? newValue) {
                  skngStrDptValue = newValue;
                },
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: pLVis,
              child: FormBuilderTextField(
                name: 'PLNo.',
                initialValue: plNoValue,
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  labelText: 'PL No.',
                  contentPadding: EdgeInsetsDirectional.all(10),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(language.text('itemDescription')),
            ),
            SizedBox(height: 5),
            FormBuilderTextField(
              name: 'itemDesc1',
              initialValue: itmeDesc,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
            ),
            FormBuilderRadioGroup(
              name: 'AO',
              initialValue: "OR",
              decoration: InputDecoration(
                contentPadding: EdgeInsetsDirectional.all(0),
                border: InputBorder.none,
              ),
              autovalidateMode: AutovalidateMode.disabled,
              options: [
                'OR',
                'AND',
              ].map((lang) => FormBuilderFieldOption(value: lang)).toList(growable: false),
              onChanged: (String? newValue) {
                setState(() {
                  itemDis1Vis = true;
                });
              },
            ),
            FormBuilderTextField(
              name: 'itemDesc2',
              initialValue: itmeDesc2,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: poVis,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'PO No.',
                    initialValue: pono,
                    autovalidateMode: AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      labelText: language.text('PONo'),
                      hintText: language.text('enterPONo'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: vendorNameVis,
              child: FormBuilderTextField(
                name: 'Vendor Name',
                initialValue: vName,
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  labelText: language.text('vendorName'),
                  hintText: language.text('enterVendorName'),
                  contentPadding: EdgeInsetsDirectional.all(10),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Visibility(
              visible: poPlacingVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  poSearchDropdownStatic(
                      'POPlacingAuthority',
                      'Select PO Placing Authority',
                      dropdowndata_UDMPoPlacingList,
                      poPlacinginitV,
                      name: 'PO Placing Authority'),
                ],
              ),
            ),
            Visibility(
              visible: purchaseSVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'Purchase Section',
                    focusColor: Colors.transparent,
                    decoration: InputDecoration(
                      labelText: language.text('purchaseSection'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    initialValue: purchasSec,
                    //allowClear: false,
                    enabled: purchaseEnabl,
                    //hint: Text('${language.text('select')} ${language.text('purchaseSection')}'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'field is required';
                      }
                      return null; // Return null if the value is valid
                    },
                    items: dropdowndata_UDMPurchaseList.map((item) {
                      return DropdownMenuItem(
                          child: Text(() {
                            if (item['intcode'].toString() == '-1') {
                              return item['value'];
                            } else {
                              return item['intcode'].toString() + ' - ' + item['value'].toString();
                            }
                          }()),
                          value: item['intcode'].toString());
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        purchasSec = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: coverageSVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  poSearchDropdownStaticdrop(
                    'coverageStatus',
                    '${language.text('select')} ${language.text('coverageStatus')}',
                    coverageStatusList,
                    coverStatusDefault,
                    name: 'Coverage Status',
                  ),
                ],
              ),
            ),
            Visibility(
              visible: tenderTVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'Tender Type',
                    focusColor: Colors.transparent,
                    decoration: InputDecoration(
                      labelText: language.text('tenderType'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    initialValue: tenderDef,
                    //allowClear: false,
                    //hint: Text('${language.text('select')} ${language.text('tenderType')}'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'field is required';
                      }
                      return null; // Return null if the value is valid
                    },
                    items: dropdowndata_UDMTenderList.map((item) {
                      return DropdownMenuItem(
                          child: Text(() {
                            if (item['intcode'].toString() == '-1') {
                              return item['value'];
                            } else {
                              return item['intcode'].toString() +
                                  '-' +
                                  item['value'];
                            }
                          }()),
                          value: item['intcode'].toString());
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        tenderDef = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: insAgenVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  poSearchDropdownStaticdrop(
                    'inspectionAgency',
                    '${language.text('select')} ${language.text('inspectionAgency')}',
                    inspectionAgencyList,
                    insAgenDef,
                    name: 'Inspection Agency',
                  ),
                ],
              ),
            ),
            Visibility(
                visible: industryTypVis,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    FormBuilderDropdown(
                      name: 'Industry Type',
                      focusColor: Colors.transparent,
                      decoration: InputDecoration(
                        labelText: language.text('industryType'),
                        contentPadding: EdgeInsetsDirectional.all(10),
                        border: const OutlineInputBorder(),
                      ),
                      initialValue: indusDef,
                      //allowClear: false,
                      //hint: Text('${language.text('select')} ${language.text('industryType')}'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'field is required';
                        }
                        return null; // Return null if the value is valid
                      },
                      items: indusTypeList.map((item) {
                        return DropdownMenuItem(
                            child: Text(() {
                              if (item['intcode'].toString() == '-1') {
                                return item['value'];
                              } else {
                                return item['intcode'].toString() +
                                    '-' +
                                    item['value'];
                              }
                            }()),
                            value: item['intcode'].toString());
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          indusDef = newValue;
                        });
                      },
                    ),
                  ],
                )),
            Visibility(
              visible: poTypeVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  poSearchDropdownStaticdrop(
                    'POType',
                    '${language.text('select')} ${language.text('POType')}',
                    pOTypeList,
                    poTypeDef,
                    name: 'PO Type',
                  ),
                ],
              ),
            ),
            Visibility(
              visible: poValueVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'PO Value From',
                          initialValue: poF,
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: InputDecoration(
                            labelText: language.text('POValueFrom'),
                            labelStyle: TextStyle(fontSize: 14),
                            hintText: language.text('POValueFromHint'),
                            hintStyle: TextStyle(fontSize: 14),
                            contentPadding: EdgeInsetsDirectional.all(10),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'PO Value To',
                          initialValue: poT,
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: InputDecoration(
                            labelText: language.text('POValueTo'),
                            hintText: language.text('POValueToHint'),
                            hintStyle: TextStyle(fontSize: 14),
                            labelStyle: TextStyle(fontSize: 14),
                            contentPadding: EdgeInsetsDirectional.all(10),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'PO Date: From',
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now().subtract(const Duration(days: 92)),
                    initialValue: DateTime.now().subtract(const Duration(days: 92)),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('PODateFrom'),
                      hintText: language.text('enterPODateFrom'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'PO Date: To',
                    // firstDate: DateTime.now().subtract(const Duration(days: 180)),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(
                      labelText: language.text('PODateTo'),
                      hintText: language.text('enterPODateTo'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    // onChanged: _onChanged,
                  ),
                ),
                // SizedBox(height:10),
              ],
            ),
            Wrap(
              spacing: 8.0,
              children: [
                Visibility(
                  visible: poPlacButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          poPlacingVis = true;
                          poPlacButtonVis = false;
                          if (poPlacingVis) {
                            poPlacinginitV = '-1';
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
                            language.text('POPlacingAuthority'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: purchsButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          purchaseSVis = true;
                          purchsButtonVis = false;
                          if (purchaseSVis) {
                            purchasSec = '-1';
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
                            language.text('purchaseSection'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: covrStatsButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          coverageSVis = true;
                          covrStatsButtonVis = false;
                          if (coverageSVis) {
                            coverStatusDefault = '-1';
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
                            language.text('coverageStatus'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: tenderButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          tenderTVis = true;
                          tenderButtonVis = false;
                          if(tenderTVis) {
                            tenderDef = '-1';
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
                            language.text('tenderType'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: insAgeButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          insAgenVis = true;
                          insAgeButtonVis = false;
                          if(insAgenVis) {
                            insAgenDef = '-1';
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
                            language.text('inspectionAgency'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: indusTypButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          industryTypVis = true;
                          indusTypButtonVis = false;
                          if(industryTypVis) {
                            indusDef = '-1';
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
                            language.text('industryType'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: poTypButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          poTypeVis = true;
                          poTypButtonVis = false;
                          if(poTypeVis) {
                            poTypeDef = '-1';
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
                            language.text('POType'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: poValueButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          poValueVis = true;
                          poValueButtonVis = false;
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
                          Icon(Icons.add, color: Colors.white),
                          Text(language.text('POValue'), style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 50,
                  width: 160,
                  child: OutlinedButton(
                    style: IRUDMConstants.bStyle(),
                    onPressed: () {
                      final from = _formKey.currentState!.fields['PO Date: From']!.value;
                      final to = _formKey.currentState!.fields['PO Date: To']!.value;
                      final difference = to.difference(from).inDays;
                      if(_formKey.currentState!.fields['itemDesc1']!.value.toString().isEmpty && _formKey.currentState!.fields['PO No.']!.value.toString().isEmpty){
                        IRUDMConstants().showSnack(language.text('descpowarning'), context);
                      }
                      else if(difference > 92) {
                        IRUDMConstants().showSnack(language.text('pleaseSelectDatesTo'), context);
                      }
                      else if(railway == '-1') {
                        if(_formKey.currentState!.fields['itemDesc1']!.value.toString().length < 3) {
                          IRUDMConstants().showSnack('itemDescriptionWarning', context);
                        } else {
                          callValue();
                        }
                      }
                      else {
                        callValue();
                      }
                    },
                    child: Text(
                      language.text('getDetails'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  height: 50,
                  child: OutlinedButton(
                    style: IRUDMConstants.bStyle(),
                    onPressed: () {
                      //  _formKey.currentState.reassemble();
                      //   _formKey.currentState.fields['itemDesc1'].didChange('');
                      //  _formKey.currentState.fields['itemDesc2'].didChange('');
                      if (pLVis) {
                        _formKey.currentState!.fields['PLNo.']!.reset();
                      }
                      //   _formKey.currentState.fields['Vendor Name'].didChange('');
                      //  _formKey.currentState.fields['PO No.'].didChange('');
                      //  _formKey.currentState.fields['PO Value From']
                      //      .didChange('');
                      //  _formKey.currentState.fields['PO Value To'].didChange('');
                      setState(() {
                        poPlacingVis = false;
                        purchaseSVis = false;
                        coverageSVis = false;
                        tenderTVis = false;
                        insAgenVis = false;
                        industryTypVis = false;
                        poTypeVis = false;

                        poPlacButtonVis = true;
                        purchsButtonVis = true;
                        covrStatsButtonVis = true;
                        tenderButtonVis = true;
                        insAgeButtonVis = true;
                        indusTypButtonVis = true;
                        poTypButtonVis = true;

                        dropdowndata_UDMRlyList.clear();
                        dropdowndata_UDMTenderList.clear();
                        //dropdowndata_UDMConsList.clear();
                        dropdowndata_UDMPoPlacingList.clear();
                        dropdowndata_UDMPurchaseList.clear();
                        indusTypeList.clear();

                        stockNonStockList.clear();
                        coverageStatusList.clear();
                        inspectionAgencyList.clear();
                        stkStoreDepotList.clear();

                        pOTypeList.clear();

                        default_data();
                      });
                    },
                    child: Text(
                      language.text('reset'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  void callValue() {
    _formKey.currentState!.save();
    String fDate = DateFormat('dd-MM-yyyy').format(_formKey.currentState!.fields['PO Date: From']!.value);
    String tDate = DateFormat('dd-MM-yyyy').format(_formKey.currentState!.fields['PO Date: To']!.value);

    String? sns = '', flagData;
    if(_formKey.currentState!.validate()) {
        if(pLVis == false) {
          plNoValue = '';
        } else {
          plNoValue = _formKey.currentState!.fields['PLNo.']!.value;
        }
        if(skngStrDptValue == null || skngStrDptValue == '' || skngStrDptValue == '-1' || skngStrDptValue == "null") {
          skngStrDptValue = '';
        } else {
          skngStrDptValue = _formKey.currentState!.fields['Stocking Stores Depot']!.value;
        }
        if(consigneeValue == 'All') {
          consigneeValue = '';
        } else {
          var consValue = consigneeValue.split('-');
          consigneeValue = consValue[0];
        }
        String? rai, poplas, purchS, covrS, tndrT, insA, indsT, poType;
        if(_formKey.currentState!.fields['Railway']!.value == '-1') {
          rai = ' ';
        } else {
          rai = _formKey.currentState!.fields['Railway']!.value;
        }
        if(!poPlacingVis) {
          poplas = '';
        } else if (_formKey.currentState!.fields['PO Placing Authority']!.value == '-1') {
          poplas = '';
        } else {
          poplas = _formKey.currentState!.fields['PO Placing Authority']!.value;
        }
        if(!purchaseSVis) {
          purchS = '';
        }
        else if(_formKey.currentState!.fields['Purchase Section']!.value == '-1') {
          purchS = '';
        } else {
          purchS = _formKey.currentState!.fields['Purchase Section']!.value;
        }
        if (!coverageSVis) {
          covrS = '';
        } else if (_formKey.currentState!.fields['Coverage Status']!.value == '-1') {
          covrS = '';
        } else {
          covrS = _formKey.currentState!.fields['Coverage Status']!.value;
        }
        if (!tenderTVis) {
          tndrT = '';
        } else if (_formKey.currentState!.fields['Tender Type']!.value == '-1') {
          tndrT = '';
        } else {
          tndrT = _formKey.currentState!.fields['Tender Type']!.value;
        }
        if (!insAgenVis) {
          insA = '';
        } else if (_formKey.currentState!.fields['Inspection Agency']!.value == '-1') {
          insA = '';
        } else {
          insA = _formKey.currentState!.fields['Inspection Agency']!.value;
        }
        if (!industryTypVis) {
          indsT = '';
        } else if(_formKey.currentState!.fields['Industry Type']!.value == '-1') {
          indsT = '';
        } else {
          indsT = _formKey.currentState!.fields['Industry Type']!.value;
        }if (!poTypeVis) {
          poType = '';
        } else if (_formKey.currentState!.fields['PO Type']!.value == '-1') {
          poType = '';
        } else {
          poType = _formKey.currentState!.fields['PO Type']!.value;
        }
        if(_formKey.currentState!.fields['SNS']!.value == 'Stock') {
          sns = 'S';
        }
        else if(_formKey.currentState!.fields['SNS']!.value == 'Non-Stock'){
          sns = 'N';
        } else {
          sns = '';
        }
        String? item2 = '',
            ponoVale = '',
            vendorNameV = '',
            poVF = '',
            poVT = '',
            itemDis1 = '';

        item2 = _formKey.currentState!.fields['itemDesc2']!.value;
        itemDis1 = _formKey.currentState!.fields['itemDesc1']!.value;
        flagData = _formKey.currentState!.fields['AO']!.value;
        if(poVis == false) {
          ponoVale = '';
        } else {
          ponoVale = _formKey.currentState!.fields['PO No.']!.value;
        }
        if(vendorNameVis == false) {
          vendorNameV = '';
        } else {
          vendorNameV = _formKey.currentState!.fields['Vendor Name']!.value;
        }
        if(poValueVis == false) {
          poVT = '';
          poVF = '';
        } else {
          poVF = _formKey.currentState!.fields['PO Value From']!.value;
          poVT = _formKey.currentState!.fields['PO Value To']!.value;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => PoSearchListScreen(rai!, deptcode, skngStrDptValue!, purchS!, sns!, plNoValue!, covrS!, poVF!,
            poVT!, ponoVale!, indsT!, tndrT!,fDate.substring(0, 10), tDate.substring(0, 10),  poType!, vendorNameV!, consigneeValue, insA!, itemDis1!, item2!,flagData!, poplas!)));
      }
  }

  Widget poSearchDropdown(String key, String hint, List listData, String? initValue, {String? name}) {
    if(name == null) {
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
        return DropdownMenuItem(child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        dropDownValue = newValue;
        setState(() {
          railway = newValue;
          deptValue = '';
          deptcode = '';
          def_fetchPoPlacing(newValue, '');
          if(consgVis == true) {
            consigneeData(newValue, '');
          }
          if (stkngStrVis == true) {
            def_fetchStkStrDepot(newValue);
          }
        });
      },
    );
  }

  Widget poSearchDropdownStaticdrop(String key, String hint, List listData, String? initValue, {String? name}) {
    if (name == null) {
      name = key;
    }
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: name == key ? name : Provider.of<LanguageProvider>(context).text(key),
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
        return DropdownMenuItem(
            child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          initValue = newValue;
        });
      },
    );
  }

  Widget poSearchDropdownStatic(String key, String hint, List listData, String? initValue, {String? name}) {
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
        if (name == 'PO Placing Authority') {
          setState(() {
            if (newValue == '-1') {
              purchaseEnabl = false;
            } else {
              purchaseEnabl = true;
            }
          });
        }
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

  void initState() {
    default_data();
    // setState(() {
    //   default_data();
    // });
    super.initState();
  }

  late SharedPreferences prefs;

  Future<dynamic> default_data() async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    //IRUDMConstants.showProgressIndicator(context);
    // Future.delayed(Duration.zero, () {
    //   IRUDMConstants.showProgressIndicator(context);
    //   _formKey.currentState!.reset();
    // });
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    prefs = await SharedPreferences.getInstance();
    try {
      var d_response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue', dbResult[0][DatabaseHelper.Tb3_col5_emailid], prefs.getString('token'));
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
      var staticDataresponse = await Network.postDataWithAPIM('app/Common/UdmAppListStatic/V1.0.0/UdmAppListStatic', 'UdmAppListStatic', '',prefs.getString('token'));

      var staticData = json.decode(staticDataresponse.body);
      List staticDataJson = staticData['data'];
      var tenderDataUrl = await Network().postDataWithAPIMList('UDMAppList','TenderType','',prefs.getString('token'));

      var itemData = json.decode(tenderDataUrl.body);
      var itemCatDataJson = itemData['data'];
      for (int i = 0; i < staticDataJson.length; i++) {
        if(staticDataJson[i]['list_for'] == 'coverage_status') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            coverageStatusList.add(all);
          });
        }
        if (staticDataJson[i]['list_for'] == 'inspection_agency') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            inspectionAgencyList.add(all);
          });
        }
        if (staticDataJson[i]['list_for'] == 'po_type') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            pOTypeList.add(all);
          });
        }
      }
      setState(() {
        dropdowndata_UDMTenderList.add(all);
        dropdowndata_UDMTenderList.addAll(itemCatDataJson);
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        railway = d_Json[0]['org_zone'];
        Future.delayed(Duration(milliseconds: 0), () async {
          def_fetchPoPlacing(d_Json[0]['org_zone'], '');
          def_fetchIndusType();
          def_fetchPurchase(d_Json[0]['org_zone']);
          def_depart_result(context);
        });
        Future.delayed(Duration(milliseconds: 100), () async {
          consigneeData(d_Json[0]['org_zone'], d_Json[0]['ccode'].toString());
        });
      });

      _formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);
      //_formKey.currentState.fields['Tender Type'].setValue('-1');
      //_formKey.currentState.fields['Coverage Status'].setValue('-1');
      //_formKey.currentState.fields['Inspection Agency'].setValue('-1');
      //_formKey.currentState.fields['PO Type'].setValue('-1');
      //  _progressHide();
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<dynamic> def_depart_result(BuildContext context) async {
    try {
      dropdowndata_UDMDeptList.clear();
      //IRUDMConstants.showProgressIndicator(context);
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      if(UDMDept_body['status'] != 'OK'){
        //IRUDMConstants.removeProgressIndicator(context);
      }
      else{
        //IRUDMConstants.removeProgressIndicator(context);
        var deptData = UDMDept_body['data'];
        setState(() {
          dropdowndata_UDMDeptList.addAll(deptData);
          deptData.forEach((item) {
            if(item['intcode'].toString() == prefs.getString('orgsubunit')) {
              deptValue = item['value'].toString();
              deptcode = item['intcode'].toString();
            }
          });
        });
      }

    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> consigneeData(String? value, String consg) async {
    IRUDMConstants.showProgressIndicator(context);
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    try {
      var result_UDMCons = await Network().postDataWithAPIMList('UDMAppList','Consignee',value,prefs.getString('token'));
      var UDMCons_body = json.decode(result_UDMCons.body);
      var myList_UDMCons = [];
      if(UDMCons_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMConsList.add(all);
          consigneeValue = 'All';
        });
      }
      else {
        var consData = UDMCons_body['data'];
        myList_UDMCons.add(all);
        myList_UDMCons.addAll(consData);
        setState(() {
          dropdowndata_UDMConsList = myList_UDMCons; //2
        });
      }
      if (consg == "NA") {
        setState(() {
          consigneeValue = 'All';
        });
      }
      else {
        if (consg != "") {
          setState(() {
            int i = 0;
            dropdowndata_UDMConsList.forEach((item) {
              if (item['intcode'].toString().contains(consg.toLowerCase())) {
                consigneeValue = item['intcode'].toString() + '-' + item['value'];
              }
              i++;
            });
          });
        } else {
          setState(() {
            consigneeValue = 'All';
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

  Future<dynamic> def_fetchPoPlacing(String? rai, String poPlacing) async {
    IRUDMConstants.showProgressIndicator(context);
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    try {
      var result_UDMPoPlacing = await Network().postDataWithAPIMList(
          'UDMAppList','POPlacingAuthority',rai,prefs.getString('token'));

      var UDMPoPlacing_body = json.decode(result_UDMPoPlacing.body);
      var myList_UDMPoPlacing = [];
      if (UDMPoPlacing_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMPoPlacingList.add(all);
          _formKey.currentState!.fields['PO Placing Authority']!.setValue('-1');
          _formKey.currentState!.fields['Purchase Section']!.enabled;
          //def_fetchDepot(rai,depart.toString(),unit,division_name,depot,userSubDep);
        });
        // showInSnackBar("p lease select other value");
      } else {
        var poPlacingData = UDMPoPlacing_body['data'];
        // if(poPlacingData.toString().contains(null)){
        //  poPlacingData.toString().replaceAll(null, '');
        // }
        myList_UDMPoPlacing.addAll(poPlacingData);
        setState(() {
          dropdowndata_UDMPoPlacingList = myList_UDMPoPlacing;
          dropdowndata_UDMPoPlacingList.sort((a, b) => a['value'].compareTo(b['value'])); //2
          dropdowndata_UDMPoPlacingList.insert(0, all);
        });
      }
      if(poPlacing != "") {
        _formKey.currentState!.fields['PO Placing Authority']!.setValue(poPlacing);
        // def_fetchDepot(rai,depart.toString(),unit,division_name,depot,userSubDep);
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

  Future<dynamic> def_fetchPurchase(String? rai) async {
    IRUDMConstants.showProgressIndicator(context);
    try {
      dropdowndata_UDMPurchaseList.clear();
      var result_UDMPurchase = await Network().postDataWithAPIMList('UDMAppList','PurchaseSection',rai,prefs.getString('token'));
      var UDMPurchase_body = json.decode(result_UDMPurchase.body);
      var myList_UDMPurchase = [];
      if(UDMPurchase_body['status'] != 'OK') {

      } else {
        var purchaseData = UDMPurchase_body['data'];
        dropdowndata_UDMPurchaseList.clear();
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMPurchase.add(all);
        myList_UDMPurchase.addAll(purchaseData);
        setState(() {
          dropdowndata_UDMPurchaseList = myList_UDMPurchase; //2
          //_formKey.currentState.fields['Purchase Section'].didChange('-1');
        });
      }
      IRUDMConstants.removeProgressIndicator(context);
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

  Future<dynamic> def_fetchStkStrDepot(String? rai) async {
    IRUDMConstants.showProgressIndicator(context);
    try {
      stkStoreDepotList.clear();
      var result_UDMstrstkDpt = await Network().postDataWithAPIMList('UDMAppList','StockingStoresDepot',rai,prefs.getString('token'));
      var UDMstrStkDepot_body = json.decode(result_UDMstrstkDpt.body);
      var myList_UDMStrStkDepot = [];
      if(UDMstrStkDepot_body['status'] != 'OK') {
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          stkStoreDepotList.add(all);
          _formKey.currentState!.fields['Stocking Stores Depot']!.didChange('-1');
        });
      } else {
        var strStkdata = UDMstrStkDepot_body['data'];
        stkStoreDepotList.clear();
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMStrStkDepot.add(all);
        myList_UDMStrStkDepot.addAll(strStkdata);
        setState(() {
          stkStoreDepotList = myList_UDMStrStkDepot; //2
          _formKey.currentState!.fields['Stocking Stores Depot']!.didChange('-1');
        });
      }
      IRUDMConstants.removeProgressIndicator(context);
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

  Future<dynamic> def_fetchIndusType() async {
    IRUDMConstants.showProgressIndicator(context);
    try {
      indusTypeList.clear();
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','IndustryType','005',prefs.getString('token'));
      var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
      var myList_UDMUserDepot = [];
      if (UDMUserSubDepot_body['status'] != 'OK') {
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          indusTypeList.add(all);
          _formKey.currentState!.fields['Industry Type']!.setValue('-1');
        });
      } else {
        var subdepotdata = UDMUserSubDepot_body['data'];
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        myList_UDMUserDepot.add(all);
        myList_UDMUserDepot.addAll(subdepotdata);
        setState(() {
          indusTypeList = myList_UDMUserDepot;
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

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  int _checkDaysDiff(String fDate, String tDate){

    DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    // Parse the date strings into DateTime objects
    DateTime date1 = dateFormat.parse(fDate);
    DateTime date2 = dateFormat.parse(tDate);

    // Calculate the difference in days
    Duration difference = date2.difference(date1);
    int daysDifference = difference.inDays;
    print("Difference in days: $daysDifference days");

    return daysDifference;


  }
}
