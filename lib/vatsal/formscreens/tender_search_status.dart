import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';
import 'package:flutter_app/vatsal/components/datePicker.dart';
import 'package:flutter_app/vatsal/components/inputlabel.dart';
import '../components/dropdownSearch.dart';

class TenderSearchStatus extends StatefulWidget {
  const TenderSearchStatus({super.key});

  @override
  State<TenderSearchStatus> createState() => _TenderSearchStatusState();
}

class _TenderSearchStatusState extends State<TenderSearchStatus> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers and focus nodes
  final TextEditingController tenderNoController = TextEditingController();
  final FocusNode _firstFocus = FocusNode();

  // Selection variables
  String? selectedOrganization;
  String? selectedZone;
  String? selectedDepartment;

  // API data lists
  List<dynamic> organizationData = [];
  List<dynamic> zoneData = [];

  // Other variables
  ProgressDialog? pr;
  String date = "-1";
  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;
  bool _autoValidate = false;

  // API response variables
  List<dynamic>? jsonOrganizationResult;
  List<dynamic>? jsonZoneResult;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchOrganizations();
    });
  }

  @override
  void dispose() {
    tenderNoController.dispose();
    _firstFocus.dispose();
    super.dispose();
  }

  // Fetch organizations from API
  Future<void> fetchOrganizations() async {
    try {
      var url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        jsonOrganizationResult = json.decode(response.body);
        if (mounted) {
          setState(() {
            if (jsonOrganizationResult != null) {
              organizationData = jsonOrganizationResult!;
            }
          });
        }
      } else {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching organizations: ${e.toString()}');
    }
  }

  // Fetch zones based on selected organization
  Future<void> fetchZones(String organizationId) async {
    if (organizationId.isEmpty) return;

    try {
      AapoortiUtilities.getProgressDialog(pr!);
      var url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,$organizationId';
      final response = await http.post(Uri.parse(url));

      AapoortiUtilities.stopProgress(pr!);

      if (response.statusCode == 200) {
        jsonZoneResult = json.decode(response.body);
        if (mounted) {
          setState(() {
            zoneData = jsonZoneResult ?? [];
            selectedZone = null; // Reset zone selection when organization changes
          });
        }
      } else {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      AapoortiUtilities.stopProgress(pr!);
      debugPrint('Error fetching zones: ${e.toString()}');
    }
  }

  // Clear all selections
  void _onClear() {
    setState(() {
      tenderNoController.clear();
      selectedOrganization = null;
      selectedZone = null;
      selectedDepartment = null;
      date = "-1";
      selectedDate = DateTime.now();
      isDateSelected = false;
      zoneData.clear();
      _autoValidate = false;
    });
  }

  // Validate form
  bool _validateForm() {
    if (tenderNoController.text.trim().isEmpty) {
      _showSnackBar('Please enter Tender Number');
      return false;
    }
    if (selectedOrganization == null) {
      _showSnackBar('Please select Organization');
      return false;
    }
    if (selectedZone == null) {
      _showSnackBar('Please select Zone');
      return false;
    }
    return true;
  }

  // Show snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent[100],
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Handle search button press
  void _onSearch() async {
    if (!_validateForm()) return;

    try {
      var connectivityResult = await InternetAddress.lookup('google.com');
      if (connectivityResult.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Status(
              Date: date,
              content: tenderNoController.text.trim(),
              id: selectedZone!,
            ),
          ),
        );
      }
    } on SocketException catch (_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoConnection()),
      );
    }
  }

  // Handle date selection
  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      this.date = date.toString();
      isDateSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Color(0xffF7FFFC),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[500],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tender Status Search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ReusableInputField(label: 'Tender No.', icon: Icon(Icons.tag_outlined, size: 24,), controller: tenderNoController, color: Colors.black,),

                  SizedBox(height: 24),

                  // Organization Dropdown
                  ReusableDropDownSearch(
                    label: 'Organization',
                    items: organizationData.map((item) => item['NAME'].toString()).toList(),
                    value: selectedOrganization,
                    snackbartext: 'Please select organization',
                    onChanged: (value) {
                      setState(() {
                        selectedOrganization = value;
                        selectedZone = null;
                        zoneData.clear();
                      });

                      // Find the selected organization ID and fetch zones
                      var selectedOrgData = organizationData.firstWhere(
                            (item) => item['NAME'].toString() == value,
                        orElse: () => null,
                      );

                      if (selectedOrgData != null) {
                        fetchZones(selectedOrgData['ID'].toString());
                      }
                    },
                    icon: Icon(Icons.business),
                  ),

                  SizedBox(height: 24),

                  // Zone/Railway Dropdown
                  ReusableDropDownSearch(
                    enabled: selectedOrganization != null,
                    label: 'Railway/Zone',
                    items: zoneData.map((item) => item['NAME'].toString()).toList(),
                    value: selectedZone != null ?
                    zoneData.firstWhere(
                            (item) => item['ACCID'].toString() == selectedZone,
                        orElse: () => {'NAME': ''}
                    )['NAME'].toString() : null,
                    snackbartext: 'Please select Organization first',
                    onChanged: (value) {
                      setState(() {
                        var selectedZoneData = zoneData.firstWhere(
                              (item) => item['NAME'].toString() == value,
                          orElse: () => null,
                        );
                        selectedZone = selectedZoneData != null ?
                        selectedZoneData['ACCID'].toString() : null;
                      });
                    },
                    icon: Icon(Icons.directions_railway_filled_outlined),
                  ),

                  SizedBox(height: 24),

                  // Date Picker
                  ReusableDatePicker(
                    onDateSelected: _onDateSelected,
                    initialDate: selectedDate,
                  ),

                  SizedBox(height: 40),

                  // Action Buttons
                  Padding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: MaterialButton(
                            onPressed: _onSearch,
                            color: Color(0xff1564C0),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Show Result',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: MaterialButton(
                            onPressed: _onClear,
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: Color(0xff1564C0),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}