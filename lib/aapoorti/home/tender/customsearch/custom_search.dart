import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'custom_search_view.dart';

class CustomSearch extends StatefulWidget {
  @override
  CustomSearchState createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearch> {
  String content = "";
  final FocusNode _firstFocus = FocusNode();
  TextEditingController myController = TextEditingController();
  ProgressDialog? pr;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  GlobalKey<ScaffoldState> _snackKey = GlobalKey<ScaffoldState>();
  int countersc = 1;
  String counterwk = "PT";
  int counter = 0;
  DateTime? selected;
  double? width, height;
  var padding;
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;

  List dataRly = [];
  List dataZone = [];
  List dataUnit = [];
  List dataDept = [];
  String myselection = "-2;-2",
      myselection1 = "-1",
      myselection2 = "-2",
      myselection3 = "-2";

  bool visibilityOrg = false;
  bool visibilityRly = false;
  bool visibilityDept = false;
  bool visibilityUnit = false;

  bool visibilitysc = false;
  bool visibilitytno = false;
  bool visibilityidesc = false;

  bool visibilityTag = true;
  bool visibilityclose = true;
  bool visibilityupload = false;

  bool visibilitywk = true;
  bool visibilitygoods = true;
  bool visibilityworks = false;
  bool visibilitylt = false;

  static DateTime _valueto = DateTime.now();
  DateTime _valuefrom = _valueto.add(Duration(days: 1));
  DateTime _valuecond = _valueto.add(Duration(days: 30));

  Future<List<dynamic>>? future;

  void _validateInputs() async {
    if (_formKey.currentState!.validate()) {
      debugPrint("If all data are correct then save data to out variables");
      _formKey.currentState!.save();
    } else {
      debugPrint("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  navigate() async {
    _validateInputs();
    debugPrint(_valuefrom.difference(_valueto).inDays.toString() + "no of difference in date");
    try {
      if (visibilitysc == true && myController.text.length == 0) {
        debugPrint(myselection);
      } else if (myselection == "-2;-2" ||
          myselection1 == "-1" ||
          myselection2 == "-2" ||
          myselection3 == "-2") {
        debugPrint(myselection);
      } else if (_valuefrom.difference(_valueto).inDays < 1) {
        debugPrint("date is not correct");

        ScaffoldMessenger.of(context).showSnackBar(snackbar1);
      } else if (_valuefrom.difference(_valueto).inDays > 30) {
        debugPrint("date range is not correct");
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        debugPrint(myselection);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Custom_search_view(
                  workarea: counterwk,
                  SearchForstring: content,
                  RailZoneIn: '${myselection.substring(0, myselection.indexOf(';'))}',
                  Dt1In: DateFormat('dd/MMM/yyyy').format(_valueto).toString(),
                  Dt2In: DateFormat('dd/MMM/yyyy').format(_valuefrom).toString(),
                  searchOption: countersc.toString(),
                  OrgCode: myselection1.toString(),
                  ClDate: counter.toString(),
                  dept: myselection2.toString(),
                  unit: myselection3.toString()),
            ));
      }
    } catch (exception) {
      debugPrint('SharedProfile ' + exception.toString());
    }
  }

  _onClearText() {
    FocusScope.of(context).requestFocus(_firstFocus);
    setState(() {
      myController.text = "";
    });
  }

  @override
  _onClear() {
    setState(() {
      myController.text = "";

      visibilitysc = false;
      visibilitytno = false;
      visibilityidesc = false;

      visibilityTag = true;
      visibilityclose = true;
      visibilityupload = false;

      visibilitywk = true;
      visibilitygoods = true;
      visibilityworks = false;
      visibilitylt = false;

      visibilityOrg = false;
      visibilityRly = false;
      visibilityDept = false;
      visibilityUnit = false;

      _formKey.currentState!.reset();
      /* _formKey.currentState.save();*/
      _autoValidate = false;

      countersc = 1;
      counterwk = "PT";
      counter = 0;

      myselection = "-2;-2";
      myselection1 = "-1";
      myselection2 = "-2";
      myselection3 = "-2";

      _valueto = DateTime.now();
      _valuefrom = _valueto.add(Duration(days: 1));
      _valuecond = _valueto.add(Duration(days: 30));
    });
  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future _selectDateTo() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
    );
    if (picked != null)
      setState(() {
        _valueto = picked;
      });
  }

  Future _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _valueto,
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
    );
    if(picked != null) setState(() => _valuefrom = picked);
  }

  void _changedwk(bool visibility, String field) {
    setState(() {
      if (field == "goods") {
        visibilitygoods = visibility;
        counterwk = "PT";
        visibilityworks = false;
        visibilitylt = false;
      } else if (field == "works") {
        visibilitygoods = false;
        visibilityworks = visibility;
        visibilitylt = false;
        counterwk = "WT";
      } else if (field == "earning") {
        visibilitygoods = false;
        visibilityworks = false;
        visibilitylt = visibility;
        counterwk = "LT";
      }
      visibilitywk = true;
    });
  }

  void _changedtick(bool visibility, String field) {
    setState(() {
      if (field == "yestick") {
        visibilityclose = visibility;
        visibilityupload = false;
        visibilityTag = true;
        counter = 0;
      } else {
        visibilityclose = false;
        visibilityupload = visibility;
        visibilityTag = true;
        counter = 1;
      }
    });
  }

  void _changedsc(bool visibility, String field) {
    setState(() {
      if (field == "tno") {
        visibilitytno = visibility;
        visibilityidesc = false;
        visibilitysc = visibility;
        countersc = 1;
      } else if (field == "idesc") {
        visibilityidesc = visibility;
        visibilitytno = false;
        visibilitysc = visibility;
        countersc = 2;
      }

      _validateInputs();
    });
  }

  Future<void> fetchPost() async {
    try {
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(u));
      jsonResult1 = json.decode(response.body);
      if(response.statusCode != 200) throw new Exception('HTTP request failed, statusCode: ${response.statusCode}');
      setState(() {
        if(jsonResult1 != null) dataRly = jsonResult1!;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _progressShow() {
    pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  Future<void> getZone() async {
    try {
      debugPrint('Fetching from service' + myselection1 + "     ----" + myselection);
      dataZone = [];
      _progressShow();
      var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${myselection1}';
      final response = await http.post(Uri.parse(v));
      debugPrint("GetZone response $response");
      jsonResult = json.decode(response.body);
      if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      debugPrint("GetZone jsonresult $jsonResult");
      myselection = "-2;-2";
      setState(() {
        if(jsonResult != null) dataZone = jsonResult!;
      });
      debugPrint('after Fetching from service' + myselection1 + "     ----" + myselection);
      _progressHide();
    } catch (e) {
      debugPrint("GetZone exception ${e.toString()}");
      _progressHide();
    }
  }

  Future<void> fetchDept() async {
    try {
      dataDept = [];
      _progressShow();
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${myselection1},${myselection.substring(myselection.indexOf(';') + 1)},,-1';
      final response = await http.post(Uri.parse(u));
      jsonResult = json.decode(response.body);
      if (json.decode(response.body) == null || response.statusCode != 200)
        throw new Exception(
            'HTTP request failed, statusCode: ${response.statusCode}');
      myselection2 = "-2";

      setState(() {
        if (jsonResult != null) dataDept = jsonResult!;
      });
      _progressHide();
    } catch (e) {
      debugPrint(e.toString());
    }
    // return jsonResult; //Future.delayed(Duration(seconds: 1), () => jsonResult);
  }

  Future<void> fetchUnit() async {
    try {
      dataUnit = [];
      var v;
      if((myselection.substring(myselection.indexOf(';') + 1) == "-1") || (myselection2 == "-1")) {
        v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
      } else if((myselection.substring(myselection.indexOf(';') + 1) != "-1") || (myselection2 != "-1")) {
        v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,${myselection1},${myselection.substring(myselection.indexOf(';') + 1)},${myselection2},';
      }
      _progressShow();
      final response = await http.post(Uri.parse(v));
      if(response == null || response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response?.statusCode}');
      jsonResult = json.decode(response.body);
      myselection3 = "-2";
      setState(() {
        if(jsonResult != null) dataUnit = jsonResult!;
      });
      _progressHide();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchPost();
    });
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    padding = MediaQuery.of(context).padding;
    return Scaffold(
      key: _snackKey,
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[500],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.only(left: 15.0)),
              Container(
                  alignment: Alignment.center,
                  child: Text('Custom Search', style: TextStyle(color: Colors.white))),
              Expanded(child: SizedBox()),
              IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          )),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: FormUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget> [
        Padding(padding: EdgeInsets.all(0)),
        Text("Select search criteria ", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: width! / 25), textAlign: TextAlign.start),
        SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Tender No TextField
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 10), // Add some space between the fields
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Tender No',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Handle tender number input here
                  },
                ),
              ),
            ),

            // Item Description TextField
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10), // Add some space between the fields
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Item Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Handle item description input here
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            "Select Work Area",
            style: TextStyle(
              color: visibilitywk ? Colors.black : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: width! / 25,
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Goods & Services Button
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 30% of the screen width
              height: 50, // Fixed height for buttons
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: visibilitygoods ? Colors.blue : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Consistent border radius
                  ),
                  elevation: 5, // Shadow effect for the floating button
                  padding: EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding to fit text
                ),
                onPressed: () {
                  setState(() {
                    visibilitygoods = !visibilitygoods; // Toggle visibility
                    visibilityworks = false;
                    visibilitylt = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                  children: <Widget>[
                    Text(
                      "Goods & Services",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12, // Increase font size slightly for readability
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Works Button
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 30% of the screen width
              height: 50, // Fixed height for buttons
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: visibilityworks ? Colors.blue : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding to fit text
                ),
                onPressed: () {
                  setState(() {
                    visibilityworks = !visibilityworks;
                    visibilitygoods = false;
                    visibilitylt = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                  children: <Widget>[
                    Text(
                      "Works",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12, // Increase font size slightly for readability
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Earning/Leasing Button
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 30% of the screen width
              height: 50, // Fixed height for buttons
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: visibilitylt ? Colors.blue : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding to fit text
                ),
                onPressed: () {
                  setState(() {
                    visibilitylt = !visibilitylt;
                    visibilitygoods = false;
                    visibilityworks = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                  children: <Widget>[
                    Text(
                      "Earning/Leasing",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12, // Increase font size slightly for readability
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Padding(padding: EdgeInsets.only(top: 5, left: 95.0)),
        // FormField(
        //   builder: (FormFieldState state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         icon: const Icon(Icons.train, color: Colors.black),
        //         errorText: state.hasError ? state.errorText : null,
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           isDense: true,
        //           isExpanded: true,
        //           icon: Icon(Icons.arrow_drop_down),
        //           iconSize: 24,
        //           elevation: 16,
        //           style: TextStyle(color: Colors.black),
        //           underline: Container(
        //             height: 2,
        //             color: Colors.black,
        //           ),
        //           value: myselection1,
        //           disabledHint: Text('Select Organization'),
        //           hint: Text('Select Organization'),
        //           items: dataRly.map((item) {
        //             return DropdownMenuItem(
        //                 child: Text(item['NAME']),
        //                 value: item['ID'].toString());
        //           }).toList(),
        //           onChanged: (String? newValue) {
        //             debugPrint("Select Organization test $newValue");
        //             try {
        //               setState(() {
        //                 debugPrint("Select Organization test0 $newValue");
        //                 myselection = "-2;-2";
        //                 myselection2 = "-2";
        //                 debugPrint("Select Organization test00 $newValue");
        //                 myselection3 = "-2";
        //                 dataZone.clear();
        //                 dataDept.clear();
        //                 debugPrint("Select Organization test000 $newValue");
        //                 //dataUnit.clear();
        //                 debugPrint("Select Organization test1 $newValue");
        //                 if(newValue != null) {
        //                   debugPrint("Select Organization test2 $newValue");
        //                   myselection = "-2;-2";
        //                   myselection1 = (newValue == "-2" || newValue == "" ? null : newValue)!;
        //                   state.didChange(newValue);
        //                   debugPrint("Select Organization test3 $newValue");
        //                 }
        //               });
        //             } catch (e) {
        //               debugPrint("execption resp " + e.toString());
        //             }
        //             getZone();
        //           },
        //         ),
        //       ),
        //     );
        //   },
        //   onSaved: (String? val) {
        //     myselection1 = val!;
        //   },
        //   validator: (val) {
        //     if (val != null) {
        //       return null;
        //     } else {
        //       return ' Please select Organization ';
        //     }
        //   },
        // ),
        // Padding(padding: EdgeInsets.only(top: 5, left: 5.0)),
        // FormField(
        //   builder: (FormFieldState state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         icon: const Icon(Icons.camera, color: Colors.black),
        //         errorText: state.hasError ? state.errorText : null,
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           isDense: true,
        //           isExpanded: true,
        //           icon: Icon(Icons.arrow_drop_down),
        //           iconSize: 24,
        //           elevation: 16,
        //           style: TextStyle(color: Colors.black),
        //           underline: Container(height: 2, color: Colors.black),
        //           value: myselection == '-2;-2' || myselection == ""
        //               ? null
        //               : myselection,
        //           disabledHint: Text('Select Railway'),
        //           hint: Text('Select Railway'),
        //           items: dataZone.map((item) {
        //             return DropdownMenuItem(
        //                 child: Text(item['NAME']),
        //                 value: item['ACCID'].toString() + ";" + item['ID'].toString());
        //           }).toList(),
        //           onChanged: (String? newValue) {
        //             try {
        //               setState(() {
        //                 myselection2 = "-2";
        //                 myselection3 = "-2";
        //                 dataDept.clear();
        //                 dataUnit.clear();
        //                 if (newValue != null) {
        //
        //                   myselection = (newValue == "-2;-2" || newValue == ""
        //                       ? null
        //                       : newValue)!;
        //                   state.didChange(newValue);
        //                 }
        //               });
        //             } catch (e) {
        //             }
        //             fetchDept();
        //           },
        //         ),
        //       ),
        //     );
        //   },
        //   onSaved: (String? val) {
        //     myselection = val!;
        //   },
        //   validator: (val) {
        //     if (val != null) {
        //       return null;
        //     } else {
        //       return 'Please select  Railway ';
        //     }
        //   },
        // ),
        // Padding(padding: EdgeInsets.only(top: 5, left: 5.0)),
        // FormField(
        //   builder: (FormFieldState state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         icon: const Icon(Icons.account_balance, color: Colors.black),
        //         errorText: state.hasError ? state.errorText : null,
        //       ),
        //       isEmpty: myselection2 == '-2',
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           isDense: true,
        //           isExpanded: true,
        //           icon: Icon(Icons.arrow_drop_down),
        //           iconSize: 24,
        //           elevation: 16,
        //           style: TextStyle(color: Colors.black),
        //           underline: Container(
        //             height: 2,
        //             color: Colors.black,
        //           ),
        //           value: myselection2 == "-2" ? null : myselection2,
        //           disabledHint: Text('Select Department'),
        //           hint: Text('Select Department'),
        //           items: dataDept.map((item) {
        //             return DropdownMenuItem(
        //                 child: Text(item['NAME']),
        //                 value: item['ID'].toString());
        //           }).toList(),
        //           onChanged: (String? newValue) {
        //             state.didChange(newValue);
        //             setState(() {
        //               myselection3 = "-2";
        //
        //               dataUnit.clear();
        //               debugPrint("my selection2 second newVal1" + newValue!);
        //               myselection2 = (newValue == "-2" ? null : newValue)!;
        //               debugPrint("my selection2 second" + myselection2);
        //             });
        //             fetchUnit();
        //           },
        //         ),
        //       ),
        //     );
        //    },
        //   validator: (val) {
        //     if (val != null) {
        //       return null;
        //     } else {
        //       return 'Please select Department ';
        //     }
        //   },
        // ),
        // Padding(padding: EdgeInsets.only(top: 5, left: 5.0)),
        // FormField(
        //   builder: (FormFieldState state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         icon: const Icon(Icons.device_hub, color: Colors.black),
        //         errorText: state.hasError ? state.errorText : null,
        //       ),
        //       isEmpty: myselection3 == '-2',
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           isDense: true,
        //           isExpanded: true,
        //           icon: Icon(Icons.arrow_drop_down),
        //           iconSize: 24,
        //           elevation: 16,
        //           style: TextStyle(color: Colors.black),
        //           underline: Container(
        //             height: 2,
        //             color: Colors.black,
        //           ),
        //           value: myselection3 == "-2" ? null : myselection3,
        //           hint: Text('Select Unit'),
        //           disabledHint: Text('Select Unit'),
        //           items: dataUnit.map((item) {
        //             return DropdownMenuItem(
        //                 child: Text(item['NAME']),
        //                 value: item['ID'].toString());
        //           }).toList(),
        //           onChanged: (String? newValue) {
        //             state.didChange(newValue);
        //             setState(() {
        //
        //               myselection3 = (newValue == "-2" ? null : newValue)!;
        //             });
        //             _validateInputs();
        //           },
        //         ),
        //       ),
        //     );
        //   },
        //   onSaved: (String? val) {
        //     myselection3 = val!;
        //   },
        //   validator: (val) {
        //     return val != null ? null : 'Please select unit';
        //   },
        // ),
        // Padding(padding: EdgeInsets.only(top: 15, left: 0)),

        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(8), // Rounded corners for the box
            color: Colors.white,
          ),
          padding: EdgeInsets.all(15), // Padding around the box
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Dropdown (Organization)
              Padding(
                padding: EdgeInsets.only(bottom: 10), // Add spacing between fields
                child: FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.train, color: Colors.black),
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          value: myselection1,
                          disabledHint: Text('Select Organization'),
                          hint: Text('Select Organization'),
                          items: dataRly.map((item) {
                            return DropdownMenuItem(
                                child: Text(item['NAME']),
                                value: item['ID'].toString());
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              myselection1 = (newValue == "-2" || newValue == "" ? null : newValue)!;
                              state.didChange(newValue);
                            });
                            getZone();
                          },
                        ),
                      ),
                    );
                  },
                  onSaved: (String? val) {
                    myselection1 = val!;
                  },
                  validator: (val) {
                    return val != null ? null : 'Please select Organization';
                  },
                ),
              ),

              // Second Dropdown (Railway)
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.camera, color: Colors.black),
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          value: myselection == '-2;-2' || myselection == "" ? null : myselection,
                          disabledHint: Text('Select Railway'),
                          hint: Text('Select Railway'),
                          items: dataZone.map((item) {
                            return DropdownMenuItem(
                                child: Text(item['NAME']),
                                value: item['ACCID'].toString() + ";" + item['ID'].toString());
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              myselection = (newValue == "-2;-2" || newValue == "" ? null : newValue)!;
                              state.didChange(newValue);
                            });
                            fetchDept();
                          },
                        ),
                      ),
                    );
                  },
                  onSaved: (String? val) {
                    myselection = val!;
                  },
                  validator: (val) {
                    return val != null ? null : 'Please select Railway';
                  },
                ),
              ),

              // Third Dropdown (Department)
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.account_balance, color: Colors.black),
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      isEmpty: myselection2 == '-2',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          value: myselection2 == "-2" ? null : myselection2,
                          disabledHint: Text('Select Department'),
                          hint: Text('Select Department'),
                          items: dataDept.map((item) {
                            return DropdownMenuItem(
                                child: Text(item['NAME']),
                                value: item['ID'].toString());
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              myselection2 = (newValue == "-2" ? null : newValue)!;
                              state.didChange(newValue);
                            });
                            fetchUnit();
                          },
                        ),
                      ),
                    );
                  },
                  validator: (val) {
                    return val != null ? null : 'Please select Department';
                  },
                ),
              ),

              // Fourth Dropdown (Unit)
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.device_hub, color: Colors.black),
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      isEmpty: myselection3 == '-2',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          value: myselection3 == "-2" ? null : myselection3,
                          hint: Text('Select Unit'),
                          disabledHint: Text('Select Unit'),
                          items: dataUnit.map((item) {
                            return DropdownMenuItem(
                                child: Text(item['NAME']),
                                value: item['ID'].toString());
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              myselection3 = (newValue == "-2" ? null : newValue)!;
                            });
                            _validateInputs();
                          },
                        ),
                      ),
                    );
                  },
                  onSaved: (String? val) {
                    myselection3 = val!;
                  },
                  validator: (val) {
                    return val != null ? null : 'Please select unit';
                  },
                ),
              ),
            ],
          ),
        ),

        Align(
          alignment: Alignment.topLeft,
          child: Text("Select Tender Date Criteria (Maximum difference 30 days)",
            style: TextStyle(
                color: visibilityTag ? Colors.grey : Colors.red,
                fontSize: width! / 30),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: width!/2.1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    if(counter == 1 || counter == 2) {
                      _changedtick(true, "yestick");
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Text("Closing Date", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      Visibility(
                        child: Image.asset(
                          "assets/check_box.png",
                          height: 20.0,
                          width: width! / (width! / 40),
                        ),
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visibilityclose,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: width!/2.2,
                child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    if (counter == 0 || counter == 2) {
                      _changedtick(true, "notick");
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Uploading Date",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Visibility(
                          child: Image.asset(
                            "assets/check_box.png",
                            height: 20.0,
                            width: width! / (width! / 40),
                          ),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visibilityupload,
                        ),
                      ),
                    ],
                  ),
                ),
              )

        ]),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            visibilityTag ? Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(10, 30, 0, 10)),
                        Padding(padding: EdgeInsets.symmetric()),
                        MaterialButton(
                            padding: const EdgeInsets.all(0.0),
                            onPressed: _selectDateTo,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: Colors.cyan,
                                ),
                                Padding(padding: EdgeInsets.only(left: 15)),
                                Text(DateFormat('dd-MM-yyyy').format(_valueto),
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.left),
                              ],
                            )),
                        Padding(padding: EdgeInsets.fromLTRB(50, 30, 0, 10)),
                        Padding(padding: EdgeInsets.symmetric()),
                        MaterialButton(
                            padding: const EdgeInsets.all(0.0),
                            onPressed: _selectDateFrom,
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.date_range,
                                color: Colors.cyan,
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text(DateFormat('dd-MM-yyyy').format(_valuefrom),
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left),
                            ])),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 5.0,
                  )
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  onPressed: () {

                    navigate();
                  },
                  textColor: Colors.white,
                  color: Colors.cyan,
                  child: Text(
                    "Show Results",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(top: 3.0),
          child: Column(
            children: <Widget>[
              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  onPressed: () => _onClear(),
                  textColor: Colors.white,
                  color: Colors.cyan,
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text('Maximum date difference must be 30 days', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white)),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  final snackbar1 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select a valid date',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}
