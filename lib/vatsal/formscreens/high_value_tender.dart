import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/vatsal/components/dateRangePicker.dart';
import 'package:flutter_app/vatsal/components/dropdownSearch.dart';
import 'package:flutter_app/vatsal/components/workareaButtons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';

class HighValueTender extends StatefulWidget {
  const HighValueTender({super.key});

  @override
  State<HighValueTender> createState() => _HighValueTenderState();
}

class _HighValueTenderState extends State<HighValueTender> {
  // Progress Dialog
  ProgressDialog? pr;

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // API Data Lists
  List<dynamic> dataOrganisation = [];
  List<dynamic> dataZone = [];
  List<dynamic> dataDepartment = [];
  List<dynamic> dataUnit = [];
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;

  // Selection Values for UI
  String? selectedOrg;
  String? selectedZone;
  String? selectedDept;
  String? selectedUnit;

  // Internal selection tracking (for API compatibility)
  String? _mySelection1;
  String? _mySelection2;
  String? _mySelection3;
  String? _mySelection4 = "-1";
  String? _mySelection5 = "PT";

  // Work Area Selection
  int _user = 0;
  final List<String> users = [
    'Goods & Services',
    'Works',
    'Earning& Leasing',
  ];

  // Date Selection - Updated to match first file
  DateTime _valueto = DateTime.now();
  DateTime _valuefrom = DateTime.now().add(Duration(days: 1));
  String selectedDateType = "0"; // Added date type selection like first file

  // API URL
  String? url;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchPost();
    });
  }

  // API Methods
  Future<void> fetchPost() async {
    try {
      debugPrint('Fetching from service first spinner');

      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      AapoortiUtilities.getProgressDialog(pr!);
      final response = await http.post(Uri.parse(u)).timeout(Duration(seconds: 4));
      jsonResult1 = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }

      debugPrint(jsonResult1.toString());
      AapoortiUtilities.stopProgress(pr!);

      if (mounted) {
        setState(() {
          if (jsonResult1 != null) dataOrganisation = jsonResult1!;
        });
      }
    } catch (e) {
      debugPrint('fetchPost error: ${e.toString()}');
      if (pr != null) AapoortiUtilities.stopProgress(pr!);
    }
  }

  Future<String> fetchPostZone() async {
    if (_mySelection1 != "-1") {
      try {
        AapoortiUtilities.getProgressDialog(pr!);

        var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${_mySelection1}';
        debugPrint("url2-----" + v);

        final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 4));
        jsonResult2 = json.decode(response.body);

        debugPrint("jsonResult2------");
        debugPrint(jsonResult2.toString());
        AapoortiUtilities.stopProgress(pr!);

        if (mounted) {
          setState(() {
            dataZone = jsonResult2!;
          });
        }
      } catch (e) {
        debugPrint('fetchPostZone error: ${e.toString()}');
        if (pr != null) AapoortiUtilities.stopProgress(pr!);
      }
    }
    return "Success";
  }

  Future<void> fetchPostDepartment() async {
    debugPrint('Fetching from service first spinner');
    if (_mySelection2 != "-2") {
      try {
        AapoortiUtilities.getProgressDialog(pr!);
        var u = AapoortiConstants.webServiceUrl +
            '/getData?input=SPINNERS,DEPARTMENT,${_mySelection1},${_mySelection2}';
        debugPrint("ur13-----" + u);

        final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
        jsonResult3 = json.decode(response1.body);
        debugPrint("jsonResult3===");
        debugPrint(jsonResult3.toString());

        AapoortiUtilities.stopProgress(pr!);

        if (mounted) {
          setState(() {
            dataDepartment = jsonResult3!;
          });
        }
      } catch (e) {
        debugPrint('fetchPostDepartment error: ${e.toString()}');
        if (pr != null) AapoortiUtilities.stopProgress(pr!);
      }
    }
  }

  Future<void> fetchPostUnit(String url) async {
    debugPrint('Fetching from service first spinner');
    if (_mySelection3 != "-2") {
      try {
        AapoortiUtilities.getProgressDialog(pr!);
        var u = url;
        debugPrint("ur1-----" + u);

        final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
        jsonResult4 = json.decode(response1.body);
        debugPrint("jsonResult4===");
        debugPrint(jsonResult4.toString());
        AapoortiUtilities.stopProgress(pr!);

        if (mounted) {
          setState(() {
            dataUnit = jsonResult4!;
          });
        }
      } catch (e) {
        debugPrint('fetchPostUnit error: ${e.toString()}');
        if (pr != null) AapoortiUtilities.stopProgress(pr!);
      }
    }
  }

  // Helper Methods
  List<String> _getOrganizationItems() {
    return dataOrganisation.map<String>((item) => item['NAME'].toString()).toList();
  }

  List<String> _getZoneItems() {
    return dataZone.map<String>((item) => item['NAME'].toString()).toList();
  }

  List<String> _getDepartmentItems() {
    return dataDepartment.map<String>((item) => item['NAME'].toString()).toList();
  }

  List<String> _getUnitItems() {
    return dataUnit.map<String>((item) => item['NAME'].toString()).toList();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent[100],
        content: Container(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _search() {
    if (_mySelection1 != null &&
        _mySelection2 != null &&
        _mySelection3 != null &&
        _mySelection4 != null) {

      // Updated date formatting to match first file pattern
      String txt1 = DateFormat('dd/MMM/yyyy').format(_valueto);
      String txt2 = DateFormat('dd/MMM/yyyy').format(_valuefrom);

      if (_valuefrom.difference(_valueto).inDays < 1) {
        _showSnackBar('Please select a valid date range');
      } else if (_valuefrom.difference(_valueto).inDays > 30) {
        _showSnackBar('Maximum date difference must be 30 days');
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HighValueStatus(
                  item1: _mySelection1,
                  item2: _mySelection2,
                  item3: _mySelection3,
                  item4: _mySelection4,
                  item5: _mySelection5,
                  item6: txt1,
                  item7: txt2,
                )
            )
        );
      }
    } else {
      _showSnackBar('Please select all required fields');
    }
  }

  void _reset() {
    setState(() {
      // Clear UI selections
      selectedOrg = null;
      selectedZone = null;
      selectedDept = null;
      selectedUnit = null;

      // Clear API selections
      _mySelection1 = null;
      _mySelection2 = null;
      _mySelection3 = null;
      _mySelection4 = "-1";
      _mySelection5 = "PT";

      // Reset work area
      _user = 0;

      // Reset dates - Updated to match first file
      _valueto = DateTime.now();
      _valuefrom = DateTime.now().add(Duration(days: 1));
      selectedDateType = "0";

      // Clear data lists
      dataZone.clear();
      dataDepartment.clear();
      dataUnit.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffF7FFFC),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue.shade500,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('High Value Tender', style: TextStyle(color: Colors.white))
                ),
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )
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
                        child: Text('Select Work Area',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 8),
                      ReusableWorkArea(
                        onWorkAreaChanged: (workArea) {
                          setState(() {
                            if (workArea == "Goods & Services") {
                              _user = 0;
                              _mySelection5 = "PT";
                            } else if (workArea == "Works") {
                              _user = 1;
                              _mySelection5 = "WT";
                            } else if (workArea == "Earning& Leasing") {
                              _user = 2;
                              _mySelection5 = "LT";
                            }
                          });
                        },
                      ),
                      SizedBox(height: 24),

                      // Organization Dropdown
                      ReusableDropDownSearch(
                        snackbartext: '',
                        label: 'Organization',
                        items: _getOrganizationItems(),
                        value: selectedOrg,
                        onChanged: (value) {
                          setState(() {
                            selectedOrg = value;

                            // Find the corresponding ID for API
                            var selectedItem = dataOrganisation.firstWhere(
                                    (item) => item['NAME'] == value,
                                orElse: () => null
                            );
                            if (selectedItem != null) {
                              _mySelection1 = selectedItem['ID'].toString();
                              fetchPostZone();
                            }
                          });
                        },
                        icon: Icon(Icons.train),
                      ),
                      SizedBox(height: 24),

                      // Zone Dropdown
                      ReusableDropDownSearch(
                        snackbartext: 'Please Select Zones first',
                        enabled: selectedOrg != null,
                        label: 'Zone',
                        items: _getZoneItems(),
                        value: selectedZone,
                        onChanged: (value) {
                          setState(() {
                            selectedZone = value;
                            // Find the corresponding ID for API
                            var selectedItem = dataZone.firstWhere(
                                    (item) => item['NAME'] == value,
                                orElse: () => null
                            );
                            if (selectedItem != null) {
                              _mySelection2 = selectedItem['ID'].toString();
                              fetchPostDepartment();
                            }
                          });
                        },
                        icon: Icon(Icons.directions_railway_filled_outlined),
                      ),
                      SizedBox(height: 24),

                      // Department Dropdown
                      ReusableDropDownSearch(
                        enabled: selectedZone != null,
                        label: 'Department',
                        items: _getDepartmentItems(),
                        value: selectedDept,
                        snackbartext: 'Please select Zone first',
                        onChanged: (value) {
                          setState(() {
                            selectedDept = value;

                            // Find the corresponding ID for API
                            var selectedItem = dataDepartment.firstWhere(
                                    (item) => item['NAME'] == value,
                                orElse: () => null
                            );
                            if (selectedItem != null) {
                              _mySelection3 = selectedItem['ID'].toString();

                              if (_mySelection3 == "-1") {
                                url = AapoortiConstants.webServiceUrl +
                                    '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
                              } else {
                                url = AapoortiConstants.webServiceUrl +
                                    '/getData?input=SPINNERS,UNIT,${_mySelection1},${_mySelection2},${_mySelection3}';
                              }
                              fetchPostUnit(url!);
                            }
                          });
                        },
                        icon: Icon(Icons.account_balance),
                      ),
                      SizedBox(height: 24),

                      // Unit Dropdown
                      ReusableDropDownSearch(
                        enabled: selectedDept != null,
                        label: 'Unit',
                        items: _getUnitItems(),
                        value: selectedUnit,
                        snackbartext: 'Please select department first',
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value;
                            // Find the corresponding ID for API
                            var selectedItem = dataUnit.firstWhere(
                                    (item) => item['NAME'] == value,
                                orElse: () => null
                            );
                            if (selectedItem != null) {
                              _mySelection4 = selectedItem['ID'].toString();
                            }
                          });
                        },
                        icon: Icon(Icons.location_city),
                      ),
                      SizedBox(height: 20),

                      // Updated Date Range Section - Now using DateRangePicker component like first file
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text('Select Date Range',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                      SizedBox(height: 40)
                    ],
                  ),

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
                            onPressed: _reset,
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
      ),
    );
  }
}