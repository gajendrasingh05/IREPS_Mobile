import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/helpdesk/problemreport/ReportOpt.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ReportaproblemOptYes extends StatefulWidget {
  @override
  ReportaproblemOptYesState createState() => new ReportaproblemOptYesState();
}

class ReportaproblemOptYesState extends State<ReportaproblemOptYes> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? username, emailid, phoneno, usertype;
  String? _name;
  String? _email;
  String? _mobile;
  String? _description;
  String myselection = "-2";
  String animation = "Fav";
  List<dynamic>? jsonResult1;
  String? content;
  String? content1;
  String? content2;
  String? content3;
  String? content4;
  String data_value = "";
  String issueType = "S";
  int _buttonFilter = 0;
  int _filter = 1;
  int lotType = -1;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var users = <String>['Custom Search', 'Lot Search', 'AAC'];
  final FocusNode _firstFocus = FocusNode();

  TextEditingController myController2 = TextEditingController();
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();

  List dataCat = [];
  late bool _isButtonDisabled;
  var index = 0;
  double? height, bottom;
  ProgressDialog? pr;
  bool visibilityTag = true;
  bool visibilityObs = false;

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context);
    fetchCat();
    _isButtonDisabled = false;
    if (ReportaproblemOpt.rec == "0") {
      username = "";
      usertype = "";
      emailid = "";
      phoneno = "";
    } else {
      username = AapoortiUtilities.user!.USER_NAME;
      usertype = AapoortiUtilities.user!.U_VALUE;
      emailid = AapoortiUtilities.user!.EMAIL_ID;
      phoneno = AapoortiUtilities.user!.MOBILE;
    }
    myController1.text = username!;
    myController2.text = emailid!;
    myController3.text = phoneno!;
  }

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    super.dispose();
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
        visibilityObs = false;
      }
      if (field == "obs") {
        visibilityObs = visibility;
        visibilityTag = false;
      }
    });
  }

  void _csfilter(int value) {
    setState(() {
      _buttonFilter = value;
      switch (_buttonFilter) {
        case 1:
          _filter = 1;
          break;
        case 2:
          _filter = 2;
          break;
        case 3:
          _filter = 3;
          break;
      }
      print(_filter);
    });
  }

  void _onClear() {
    visibilityTag = true;
    visibilityObs = false;

    setState(() {
      _isButtonDisabled = false;
      myController1.text = username!;
      myController2.text = emailid!;
      myController3.text = phoneno!;
      myController4.text = "";

      myselection = "-2";
      _name = null;
      _email = null;
      _mobile = null;
      _description = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:
            (ReportaproblemOpt.rec != "0") ? Colors.teal : Colors.cyan[400],
        title: Text(
          'Raise A Query',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                Padding(padding: EdgeInsets.all(5.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _csfilter(1);
                        lotType = 0;
                        print(lotType);
                        issueType = "S";
                        _changed(true, "tag");
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Text("Suggestions", style: TextStyle(color: _filter == 1 ? (ReportaproblemOpt.rec != "0" ? Colors.teal : Colors.cyan[400]) : Colors.grey)),
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Visibility(
                            child: Image.asset(
                              'assets/check_box.png',
                              width: 30,
                              height: 30,
                            ),
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visibilityTag,
                          ),
                        ],
                      ),
                      // color: Colors.white,
                      //borderSide: BorderSide(color: Colors.black),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _csfilter(2);
                        lotType = 1;
                        print(lotType);
                        issueType = "P";
                        _changed(true, "obs");
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Text("Problem",
                              style: TextStyle(
                                  color: _filter == 2
                                      ? (ReportaproblemOpt.rec != "0"
                                          ? Colors.teal
                                          : Colors.cyan[400])
                                      : Colors.grey)),
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Visibility(
                            child: Image.asset(
                              'assets/check_box.png',
                              width: 30,
                              height: 30,
                            ),
                            //Icon(Icons.assignment_turned_in),
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visibilityObs,
                          ),
                        ],
                      ),
                      //color: Colors.white,
                      //borderSide: BorderSide(color: Colors.black),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  //autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Icon(Icons.person),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled: ReportaproblemOpt.rec == "0", // Simplified condition
                              decoration: const InputDecoration(
                                labelText: 'Enter Name',
                              ),
                              keyboardType: TextInputType.text,
                              validator: validateName,
                              controller: myController1,
                              onEditingComplete: () {
                                // Update _name and move focus
                                _name = myController1.text;
                                FocusScope.of(context).requestFocus(_firstFocus);
                              },
                              onSaved: (String? val) {
                                _name = val ?? ''; // Handle null values
                                print(_name); // Print _name to ensure it's being set correctly
                              },
                            ),
                          ),
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 20.0)),
                          Icon(Icons.email),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Expanded(
                            child: new TextFormField(
                              enabled:
                                  (ReportaproblemOpt.rec != "0" ? false : true),
                              decoration: const InputDecoration(
                                  labelText: 'Enter Email ID'),
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              controller: myController2,
                              onEditingComplete: () {
                                _email = myController2.text;
                                FocusScope.of(context)
                                    .requestFocus(_firstFocus);
                              },
                              onSaved: (String? val) {
                                _email = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 20.0)),
                          Icon(Icons.phone_in_talk),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Expanded(
                            child: TextFormField(
                              enabled:
                                  (ReportaproblemOpt.rec != "0" ? false : true),
                              decoration: const InputDecoration(
                                  labelText: 'Enter Phone No'),
                              keyboardType: TextInputType.phone,
                              validator: validateMobile,
                              controller: myController3,
                              onEditingComplete: () {
                                _mobile = myController3.text;
                                FocusScope.of(context)
                                    .requestFocus(_firstFocus);
                              },
                              onSaved: (String? val) {
                                _mobile = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      Row(children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Icon(Icons.camera),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 10.0)),
                        new Expanded(
                          child: FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  errorText:
                                      state.hasError ? state.errorText : null,
                                ),
                                /* isEmpty: myselection == null,*/
                                child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton<String>(
                                    isDense: true,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    value:
                                        myselection == '-2' || myselection == ""
                                            ? null
                                            : myselection,
                                    disabledHint: Text('Select Category'),
                                    hint: Text('Select Category'),
                                    items: dataCat.map((item) {
                                      return DropdownMenuItem(
                                          child: Text(item['CATEGORY_NAME']),
                                          value: item['CATEGORY_ID'].toString());
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      try {
                                        setState(() {
                                          if (newValue != null) {
                                            print("my selection second newVal1" + newValue);
                                            myselection = (newValue == "-2" ||
                                                    newValue == ""
                                                ? null
                                                : newValue)!;
                                            print("my selection second" +
                                                myselection);
                                            state.didChange(newValue);
                                          }
                                        });
                                      } catch (e) {
                                        print("execption" + e.toString());
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            onSaved: (String? val) {
                              myselection = val!;
                            },
                            validator: (val) {
                              if (val != null) {
                                print("not null");

                                return null;
                              } else {
                                print("null in validation ");
                                return 'Please select Cateogry';
                              }
                            },
                          ),
                        )
                      ]),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 50)),
                          Icon(Icons.description),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          new Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText:
                                      'Enter Description,Maximum(500 characters)'),
                              keyboardType: TextInputType.emailAddress,
                              validator: validateDescription,
                              controller: myController4,
                              onEditingComplete: () {
                                _description = myController4.text;
                                FocusScope.of(context)
                                    .requestFocus(_firstFocus);
                              },
                              onSaved: (String? val) {
                                _description = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0))
                    ],
                  ),
                ),
              ],
            ),
            MaterialButton(
              minWidth: 210,
              height: 30,
              padding: EdgeInsets.fromLTRB(
                125.0,
                5.0,
                125.0,
                5.0,
              ),
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                if (_isButtonDisabled == false) {
                  if (validateAndLogin()) {
                    debugPrint("printing......");

                    debugPrint("Content==>$_name");
                    debugPrint("content1=====>" + _email!);
                    debugPrint("content3=====>" + _mobile!);
                    debugPrint("content4=====>" + _description!);
                    debugPrint("content5=====>" + myselection!);
                    fetchPost();
                  }
                }
              },
              color: ReportaproblemOpt.rec == "0" ? Colors.cyan.shade400 : Colors.teal,
            ),
            MaterialButton(
              minWidth: 210,
              height: 30,
              padding: EdgeInsets.fromLTRB(125.0, 5.0, 125.0, 5.0),
              child: Text('Reset',
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                _onClear();
              },
              color: ReportaproblemOpt.rec == "0"
                  ? Colors.cyan.shade400
                  : Colors.teal,
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchCat() async {
    debugPrint('Fetching the values from database');
    debugPrint(ReportaproblemOpt.rec);
    //debugPrint(ReportaproblemOpt.rec == "0");
    var u = AapoortiConstants.webServiceUrl + 'HD/ProbCat?TYPE=${ReportaproblemOpt.rec == "0" ? 99 : AapoortiUtilities.user!.USER_TYPE}';
    debugPrint("url----" + u);
    final response1 = await http.post(Uri.parse(u));
    setState(() {
      jsonResult1 = json.decode(response1.body);
      debugPrint("jsonresult1===");
      debugPrint(jsonResult1.toString());
      setState(() {
        dataCat = jsonResult1!;
      });
    });
  }

  Future<void> fetchPost() async {
    debugPrint('Fetching the values from database');
    debugPrint(ReportaproblemOpt.rec);
    //debugPrint(ReportaproblemOpt.rec == "0");
    var u = AapoortiConstants.webServiceUrl +
        'HD/NReportProblem?TYPE=${this.issueType}&NAME=${this._name}&EMAILID=${this._email}&MOBILE_NO=${this._mobile}&DESCRIPTION=${this._description}&MAPID=${ReportaproblemOpt.rec == "0" ? 0 : AapoortiUtilities.user!.MAP_ID}&CATID=${myselection}';
    print("url----" + u);
    final response1 = await http.post(Uri.parse(u));
    setState(() {
      jsonResult1 = json.decode(response1.body);
      debugPrint("jsonresult1===");
      debugPrint(jsonResult1.toString());

      if (jsonResult1![0]['THREEDAYSMSG'] != null) {
        data_value = jsonResult1![0]['THREEDAYSMSG'];
      } else {
        data_value = "Details submitted successfully with Reference ID " +
            jsonResult1![0]['U_ID'].toString() +
            ".";
      }
      _isButtonDisabled = true;
      debugPrint(data_value);
      '$_name'.trim();
      if (_name != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Overlay(context, data_value),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    _onClear();
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute<void>(
                    //         builder: (BuildContext context) => UserHome(
                    //             AapoortiUtilities.user.USER_TYPE,
                    //             AapoortiUtilities.user.EMAIL_ID)),
                    //     ModalRoute.withName('/'));
                  }),
            ],
          ),

          // Material(

          //       child: Center(
          //           child: Container(
          //               height: 200,
          //               //     margin: EdgeInsets.only(
          //               //         top: 250, bottom: 200, left: 30, right: 30),
          //               //     padding: EdgeInsets.only(
          //               //         top: 20, bottom: 20, left: 30, right: 30),
          //               color: Colors.white,
          //               //     // Aligns the container to center
          //               child: Column(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: <Widget>[
          //                     //Expanded(
          //                     // child:
          //                     Container(
          //                       padding: EdgeInsets.only(
          //                         bottom: 20,
          //                       ),
          //                       child: Overlay(context, data_value),
          //                     ),
          //                     // ),
          //                     Align(
          //                       alignment: Alignment.bottomRight,
          //                       child: GestureDetector(
          //                           onTap: () {
          //                             //Navigator.push(context,MaterialPageRoute(builder: (context)=> UserHome("","")));
          //                             // Navigator.of(context, rootNavigator: true)
          //                             //.pop('');
          //                             Navigator.pop(context);
          //                             Navigator.pop(context);
          //                             Navigator.pop(context);
          //                           },
          //                           child: new Text(
          //                             "OKAY",
          //                             style: TextStyle(
          //                                 color: Colors.blue,
          //                                 fontSize: 15,
          //                                 fontWeight: FontWeight.bold),
          //                           )),
          //                     )
          //                   ]))),
          //     )
        );
      }
      //_onClear();
    });
  }

  Widget Overlay(BuildContext context, String data_value) {
    var description1 = data_value;
    return Container(
      padding: EdgeInsets.all(0),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Text(
          data_value,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
        )),
      ]),
    );
  }

  bool isEmail(String em) {
    String p = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool _phoneNumberValidator(String value) {
    // Define a regex pattern to match a 10-digit phone number, optionally prefixed by '+9' or '09'
    final RegExp regex = RegExp(r'^(?:\+9|09)?[0-9]{10}$');

    // Check if the value matches the regex pattern
    return regex.hasMatch(value);
  }

  static bool _descriptionValidator(String value) {
    // Define a regex pattern to match allowed characters: letters, spaces, periods, and commas
    final RegExp regex = RegExp(r'^[A-Za-z., ]*$');

    // Check if the value matches the regex pattern
    return regex.hasMatch(value);
  }


  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Name cannot be empty';
    } else if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    } else {
      return null; // No error
    }
  }


  String? validateMobile(String? value) {
    // Remove any non-digit characters (optional, based on your requirements)
    value = value!.replaceAll(RegExp(r'\D'), '');

    // Check if the number starts with '91' and has 12 digits
    if (value.length == 12 && value.startsWith('91')) {
      value = value.substring(2); // Remove the country code
    }
    if (value.length != 10) {
      return 'Mobile Number must be 10 digits long';
    }
  }


  String? validateEmail(String? value) {
    // Define a more readable regex pattern for email validation
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    // Check if the email matches the regex pattern
    if (value!.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null; // No error
    }
  }


  bool validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      debugPrint("If all data are not valid then start auto validation.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Data. Please check!!"),
          backgroundColor: Colors.redAccent));
      return false;
    }
  }

  String? validateDescription(String? value) {
    if (value.toString().length < 20) {
      return 'Enter minimum 20 characters';
    } else if (value.toString().length > 500) {
      return 'Description can not exceed 500 characters';
    }
    return null;
  }
}
