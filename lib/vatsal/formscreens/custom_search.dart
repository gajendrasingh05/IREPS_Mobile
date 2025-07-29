import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/vatsal/components/dateRangePicker.dart';
import 'package:flutter_app/vatsal/components/dropdownSearch.dart';
import 'package:flutter_app/vatsal/components/inputlabel.dart';
import 'package:flutter_app/vatsal/components/workareaButtons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/customsearch/custom_search_view.dart';
// import 'custom_search_view.dart'; // Import your existing search view here

class customSearch extends StatefulWidget {
  const customSearch({super.key});

  @override
  State<customSearch> createState() => _customSearchState();
}

class _customSearchState extends State<customSearch> {
  // Controllers and Focus Nodes
  TextEditingController tenderNoController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProgressDialog? pr;

  // API Data Lists
  List<dynamic> dataRly = [];
  List<dynamic> dataZone = [];
  List<dynamic> dataUnit = [];
  List<dynamic> dataDept = [];
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;

  // Selection Values
  String? selectedOrg;
  String? selectedZone;
  String? selectedDept;
  String? selectedUnit;

  // Internal selection tracking (for API compatibility)
  String myselection = "-2;-2";
  String myselection1 = "-1";
  String myselection2 = "-2";
  String myselection3 = "-2";

  // UI State
  bool isExpanded = false;
  String selectedWorkArea = "PT"; // PT, WT, LT
  String selectedDateType = "0"; // 0 for closing, 1 for uploading

  // Date Selection
  DateTime _valueto = DateTime.now();
  DateTime _valuefrom = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchOrganizations();
    });
  }

  @override
  void dispose() {
    tenderNoController.dispose();
    itemDescController.dispose();
    super.dispose();
  }

  // API Methods
  Future<void> fetchOrganizations() async {
    try {
      var url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        jsonResult1 = json.decode(response.body);
        setState(() {
          if (jsonResult1 != null) dataRly = jsonResult1!;
        });
      } else {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('fetchOrganizations error: ${e.toString()}');
    }
  }

  Future<void> fetchZones() async {
    try {
      debugPrint('Fetching zones for organization: $myselection1');
      dataZone = [];
      _showProgress();

      var url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,$myselection1';
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        jsonResult = json.decode(response.body);
        setState(() {
          if (jsonResult != null) dataZone = jsonResult!;
          myselection = "-2;-2";
          selectedZone = null;
          myselection2 = "-2";
          selectedDept = null;
          myselection3 = "-2";
          selectedUnit = null;
          dataDept.clear();
          dataUnit.clear();
        });
      } else {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }
      _hideProgress();
    } catch (e) {
      debugPrint('fetchZones error: ${e.toString()}');
      _hideProgress();
    }
  }

  Future<void> fetchDepartments() async {
    try {
      dataDept = [];
      _showProgress();

      var url = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,DEPARTMENT,$myselection1,${myselection.substring(myselection.indexOf(';') + 1)},,-1';
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        jsonResult = json.decode(response.body);
        setState(() {
          if (jsonResult != null) dataDept = jsonResult!;
          myselection2 = "-2";
          selectedDept = null;
          myselection3 = "-2";
          selectedUnit = null;
          dataUnit.clear();
        });
      } else {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }
      _hideProgress();
    } catch (e) {
      debugPrint('fetchDepartments error: ${e.toString()}');
      _hideProgress();
    }
  }

  Future<void> fetchUnits() async {
    try {
      dataUnit = [];
      String url;

      if ((myselection.substring(myselection.indexOf(';') + 1) == "-1") || (myselection2 == "-1")) {
        url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
      } else {
        url = AapoortiConstants.webServiceUrl +
            '/getData?input=SPINNERS,UNIT,$myselection1,${myselection.substring(myselection.indexOf(';') + 1)},$myselection2,';
      }

      _showProgress();
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        jsonResult = json.decode(response.body);
        setState(() {
          if (jsonResult != null) dataUnit = jsonResult!;
          myselection3 = "-2";
          selectedUnit = null;
        });
      } else {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }
      _hideProgress();
    } catch (e) {
      debugPrint('fetchUnits error: ${e.toString()}');
      _hideProgress();
    }
  }

  // Progress Dialog Methods
  void _showProgress() {
    pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  void _hideProgress() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr?.hide().then((isHidden) {
        debugPrint('Progress hidden: $isHidden');
      });
    });
  }

  // Navigation and Validation
  void _search() async {
    try {
      // Validation
      if (myselection == "-2;-2" || myselection1 == "-1" || myselection2 == "-2" || myselection3 == "-2") {
        _showSnackBar("Please select all required fields");
        return;
      }

      if (_valuefrom.difference(_valueto).inDays < 1) {
        _showSnackBar("Please select a valid date range");
        return;
      }

      if (_valuefrom.difference(_valueto).inDays > 30) {
        _showSnackBar("Maximum date difference must be 30 days");
        return;
      }

      // Navigate to results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Custom_search_view(
            workarea: selectedWorkArea,
            SearchForstring: isExpanded ? (tenderNoController.text.isNotEmpty ? tenderNoController.text : itemDescController.text) : "",
            RailZoneIn: myselection.substring(0, myselection.indexOf(';')),
            Dt1In: DateFormat('dd/MMM/yyyy').format(_valueto).toString(),
            Dt2In: DateFormat('dd/MMM/yyyy').format(_valuefrom).toString(),
            searchOption: isExpanded ? (tenderNoController.text.isNotEmpty ? "1" : "2") : "1",
            OrgCode: myselection1,
            ClDate: selectedDateType,
            dept: myselection2,
            unit: myselection3,
          ),
        ),
      );

      // Alternative: Show success message instead of navigation
      // _showSnackBar("Search completed successfully!");
    } catch (e) {
      debugPrint('Search error: ${e.toString()}');
    }
  }

  void _clear() {
    setState(() {
      // Clear controllers
      tenderNoController.clear();
      itemDescController.clear();

      // Reset selections
      selectedOrg = null;
      selectedZone = null;
      selectedDept = null;
      selectedUnit = null;

      // Reset internal tracking
      myselection = "-2;-2";
      myselection1 = "-1";
      myselection2 = "-2";
      myselection3 = "-2";

      // Reset dates
      _valueto = DateTime.now();
      _valuefrom = DateTime.now().add(Duration(days: 1));

      // Reset work area and date type
      selectedWorkArea = "PT";
      selectedDateType = "0";

      // Clear data lists
      dataZone.clear();
      dataDept.clear();
      dataUnit.clear();

      // Reset UI state
      isExpanded = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent[100],
        duration: Duration(milliseconds: 1000),
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  // Create dropdown items from API data
  List<String> _getOrganizationItems() {
    return dataRly.map<String>((item) => item['NAME'].toString()).toList();
  }

  List<String> _getZoneItems() {
    return dataZone.map<String>((item) => item['NAME'].toString()).toList();
  }

  List<String> _getDepartmentItems() {
    return dataDept.map<String>((item) => item['NAME'].toString()).toList();
  }

  List<String> _getUnitItems() {
    return dataUnit.map<String>((item) => item['NAME'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF7FFFC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[500],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text('Custom Search', style: TextStyle(color: Colors.white)),
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text('Select Work Area', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 8),
                    ReusableWorkArea(
                      onWorkAreaChanged: (workArea) {
                        setState(() {
                          selectedWorkArea = workArea;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    // Organization Dropdown
                    ReusableDropDownSearch(
                      label: 'Organization',
                      items: _getOrganizationItems(),
                      value: selectedOrg,
                      snackbartext: '',
                      onChanged: (value) {
                        setState(() {
                          selectedOrg = value;
                          var selectedItem = dataRly.firstWhere((item) => item['NAME'] == value, orElse: () => null);
                          if (selectedItem != null) {
                            myselection1 = selectedItem['ID'].toString();
                            fetchZones();
                          }
                        });
                      },
                      icon: Icon(Icons.menu),
                    ),
                    SizedBox(height: 24),

                    // Zone Dropdown
                    ReusableDropDownSearch(
                      enabled: selectedOrg != null ,
                      label: 'Zone',
                      items: _getZoneItems(),
                      value: selectedZone,
                      snackbartext: 'Please Select Organization first',
                      onChanged: (value) {
                        setState(() {
                          selectedZone = value;
                          var selectedItem = dataZone.firstWhere((item) => item['NAME'] == value, orElse: () => null);
                          if (selectedItem != null) {
                            myselection = selectedItem['ACCID'].toString() + ";" + selectedItem['ID'].toString();
                            fetchDepartments();
                          }
                        });
                      },
                      icon: Icon(Icons.directions_railway_filled_outlined),
                    ),
                    SizedBox(height: 24),

                    // Department Dropdown
                    ReusableDropDownSearch(
                      enabled: selectedZone != null ,
                      label: 'Department',
                      items: _getDepartmentItems(),
                      value: selectedDept,
                      snackbartext: 'Please Select Zone first',
                      onChanged: (value) {
                        setState(() {
                          selectedDept = value;
                          // Find the corresponding ID for API
                          var selectedItem = dataDept.firstWhere((item) => item['NAME'] == value, orElse: () => null);
                          if (selectedItem != null) {
                            myselection2 = selectedItem['ID'].toString();
                            fetchUnits();
                          }
                        });
                      },
                      icon: Icon(Icons.account_balance_outlined),
                    ),
                    SizedBox(height: 24),

                    // Unit Dropdown
                    ReusableDropDownSearch(
                      enabled: selectedDept != null ,
                      label: 'Unit',
                      items: _getUnitItems(),
                      value: selectedUnit,
                      snackbartext: 'Please Select Department first',
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                          // Find the corresponding ID for API
                          var selectedItem = dataUnit.firstWhere((item) => item['NAME'] == value, orElse: () => null);
                          if (selectedItem != null) {
                            myselection3 = selectedItem['ID'].toString();
                          }
                        });
                      },
                      icon: Icon(Icons.location_city),
                    ),
                    SizedBox(height: 12),

                    // Expandable Search Criteria
                    if (isExpanded) ...[
                      SizedBox(height: 12),
                      ReusableInputField(label: 'Tender No.', icon: Icon(Icons.tag_outlined), controller: tenderNoController),
                      SizedBox(height: 24),
                      ReusableInputField(label: 'Item Description', icon: Icon(Icons.short_text), controller: itemDescController),
                      SizedBox(height: 12),
                    ],

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () => setState(() => isExpanded = !isExpanded),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: Color(0xff0046F6),
                              ),
                              Text(
                                isExpanded ? 'hide search criteria' : 'more search criteria',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1564C0),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xff1564C0),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text('Select Date Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 8),
                    DateRangePicker(
                      onDateRangeChanged: (start, end) {
                        setState(() {
                          _valueto = start;
                          _valuefrom = end;
                        });
                      },
                      onDateTypeChanged: (dateType) {
                        setState(() {
                          selectedDateType = dateType;
                        });
                      },
                    ),
                    SizedBox(height: 40),
                  ],
                ),

                // Action Buttons
                Padding(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: MaterialButton(
                          onPressed: _search,
                          color: Color(0xff1564C0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'Search',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: MaterialButton(
                          onPressed: _clear,
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: Color(0xff1564C0), width: 2),
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}