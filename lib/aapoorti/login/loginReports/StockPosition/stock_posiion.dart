import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/login/loginReports/StockPosition/stockPositionDetailsPL.dart';
import 'package:flutter_app/aapoorti/models/stock_position_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/login/loginReports/StockPosition/stockPositionDescDetails.dart';

class StockPosition extends StatefulWidget {
  get path => null;
  @override
  _StockPositionState createState() => _StockPositionState();
}

class _StockPositionState extends State<StockPosition> {
  bool plNumberButtonPressed = true;
  bool descNumberPressed = false;
  List<dynamic>? jsonResult1;
  List<StockPositionData> dataZone = [];
  Color? pln_button = Colors.teal[700], desc_button = Colors.black;
  String? result;
  String? drop1error, drop2error;
  var _mySelection1, text, desc1, desc2, desc3;
  String? inputParam1, inputParam2, zone = '';
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  var item1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);

  Future<String> fetchPostZone() async {
    print('Fetching from service');
    var url = '${AapoortiConstants.webServiceUrl}/getData?input=SPINNERS,ZONE,01';
    print("URL: $url");

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the response body
        final List<dynamic> jsonResult = json.decode(response.body);

        // Convert the JSON into a list of StockPositionData
        List<StockPositionData> parsedData = jsonResult
            .map((jsonItem) => StockPositionData.fromJson(jsonItem))
            .toList();

        // Update state
        setState(() {
          dataZone = parsedData;
        });

        print("Fetched Data: $parsedData");
        return "Success";
      } else {
        print("Failed to fetch data");
        return "Failed";
      }
    } catch (e) {
      print("Error: $e");
      return "Error";
    }
  }

  void initState() {
    super.initState();
    plNumberButtonPressed = true;
    descNumberPressed = false;
    this.fetchPostZone();
    //callWebService();
  }

  void validateForm() async {
    if (_formKey.currentState!.validate() &&
        item1 != null &&
        plNumberButtonPressed) {
      _formKey.currentState!.save();
      print("text--" + text);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StockPLDetails(_mySelection1, text, dataZone, zone!)));
    } else if (item1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      setState(() {
        drop1error = "Please select zone";
      });
      drop1error = "Please select zone";
    }
  }

  void validateForm2() async {
    if (_formKey1.currentState!.validate() &&
        item1 != null &&
        descNumberPressed == true) {
      _formKey1.currentState!.save();
      if (desc1.length == 0 && desc2.length == 0 && desc3.length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar1);
      } else {
        print("desc1--" + desc1);
        print("desc2--" + desc2);
        print("desc3--" + desc3);

        if (desc1 != null && desc2 == null && desc3 == null) {
          result = desc1 + "\$";
        }
        if (desc1 != null && desc2 != null && desc3 == null) {
          result = desc1 + "\$" + desc2 + "\$";
        }
        if (desc1 != null && desc2 != null && desc3 != null) {
          result = desc1 + "\$" + desc2 + "\$" + desc3;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => StockPLDetailsDesc(result!, _mySelection1, dataZone, zone!)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
        return true;
      },
      child: Scaffold(
          key: _scaffoldkey,
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
            title: Text('View Stock Position',
                style: TextStyle(color: Colors.white)),
          ),
          body: Builder(
            builder: (context) => Container(
              color: Colors.grey[300],
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                  new Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 30, left: 10)),
                      Text(
                        "Select Search criteria: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  new Row(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          )),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: new EdgeInsets.only(left: 25),
                              ),
                              new MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      item1 = null;
                                      plNumberButtonPressed = true;
                                      descNumberPressed = false;
                                      pln_button = Colors.teal[700];
                                      desc_button = Colors.black;
                                    });

//                                _myListView(context);

                                    print("function called");
                                  },
                                  child: Text("PL Number",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: pln_button,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))),
                              if (plNumberButtonPressed)
                                Icon(Icons.check, color: Colors.black),
                            ],
                          )),
                      new Container(
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: new EdgeInsets.only(left: 25),
                              ),
                              new MaterialButton(
                                  onPressed: () {
                                    text = '';
                                    setState(() {
                                      item1 = null;
                                      pln_button = Colors.black;
                                      desc_button = Colors.teal[700];
                                      descNumberPressed = true;
                                      plNumberButtonPressed = false;
                                      text = '';
                                    });

//
                                  },
                                  child: Text("Description",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: desc_button,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))),

//                                if(descNumberPressed)
//                                  Padding(padding: new EdgeInsets.only(left: 10),),
                              if (descNumberPressed)
                                Icon(Icons.check, color: Colors.black),
                            ],
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      plNumberButtonPressed
                          ? Expanded(child: _myListView(context))
                          : Expanded(child: _myList2View(context))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _myListView(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<StockPositionData>(
                    hint: Text('Select'),
                    decoration: InputDecoration(
                        icon: Icon(Icons.ac_unit, color: Colors.blue[700])),
                    items: dataZone.map((StockPositionData item) {
                      return DropdownMenuItem<StockPositionData>(
                        value: item,
                        child: Text(item.nAME ?? 'Unknown'),
                      );
                    }).toList(),
                    onChanged: (newVal1) {
                      item1 = newVal1;
                      setState(() {
                        item1 = newVal1;
                        zone = newVal1?.nAME;
                        _mySelection1 = newVal1?.iD;
                        print("Selected ID: $_mySelection1");
                      });
                    },
                    value: item1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                if (descNumberPressed == false)
                  TextFormField(
                    initialValue: text,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ('Please enter PL No.');
                      }
                    },
                    onSaved: (value) {
                      text = value;
                    },

                    style: style,
                    decoration: InputDecoration(
                      hintText: "Enter PL Number",
                      icon: Icon(
                        Icons.description,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 100, bottom: 10),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          0.3,
                          0.5,
                          0.7,
                          0.9
                        ],
                        colors: [
                          Colors.teal[400]!,
                          Colors.teal[300]!,
                          Colors.teal[600]!,
                          Colors.teal[300]!,
                          Colors.teal[400]!,
                        ]),
                  ),
                  child: MaterialButton(
                    minWidth: 350,
                    height: 20,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () {
                      validateForm();
                    },
                    child: Text('Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 20),
                ),
                Container(
                  height: 40,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          0.3,
                          0.5,
                          0.7,
                          0.9
                        ],
                        colors: [
                          Colors.teal[400]!,
                          Colors.teal[300]!,
                          Colors.teal[600]!,
                          Colors.teal[300]!,
                          Colors.teal[400]!,
                        ]),
                  ),
                  child: MaterialButton(
                    minWidth: 350,
                    height: 20,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () {
                      reset();
                      _formKey.currentState!.reset();
                      //  _formKey1.currentState.reset();
                    },
                    child: Text('Reset',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                )
              ],
            )));
  }

  Widget _myList2View(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: Form(
            key: _formKey1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                DropdownButtonFormField<StockPositionData>(
                  hint: Text('Select'),
                  decoration: InputDecoration(
                      icon: Icon(Icons.ac_unit, color: Colors.blue[700])),
                  items: dataZone.map((StockPositionData item) {
                    return DropdownMenuItem<StockPositionData>(
                      value: item,
                      child: Text(item.nAME ?? 'Unknown'),
                    );
                  }).toList(),
                  onChanged: (newVal1) {
                    setState(() {
                      item1 = newVal1;
                      zone = newVal1?.nAME;
                      _mySelection1 = newVal1?.iD;
                      print("Selected ID: $_mySelection1");
                    });
                  },
                  value: item1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Enter Description",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextFormField(
                  onSaved: (value) {
                    desc1 = value;
                  },
                  style: style,
                  decoration: InputDecoration(
//                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
                    hintText: "Enter description1",
                    icon: Icon(
                      Icons.description,
                      color: Colors.brown,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  "And",
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 10),
                ),
                TextFormField(
                  initialValue: "",
                  onSaved: (value) {
                    desc2 = value;
                  },
                  style: style,
                  decoration: InputDecoration(
//                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
                    hintText: "Enter description2",
                    icon: Icon(
                      Icons.description,
                      color: Colors.brown,
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 10),
                ),
                Text(
                  "And",
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 10),
                ),
                TextFormField(
                  initialValue: '',
                  onSaved: (value) {
                    desc3 = value;
                  },
                  style: style,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
//                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
                    hintText: "Enter description3",
                    icon: Icon(
                      Icons.description,
                      color: Colors.brown,
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 50, bottom: 10),
                ),
                Container(
                  height: 40,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          0.3,
                          0.5,
                          0.7,
                          0.9
                        ],
                        colors: [
                          Colors.teal[400]!,
                          Colors.teal[300]!,
                          Colors.teal[600]!,
                          Colors.teal[300]!,
                          Colors.teal[400]!,
                        ]),
                  ),
                  child: MaterialButton(
                    minWidth: 350,
                    height: 20,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () {
                      validateForm2();
                    },
                    child: Text('Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 20),
                ),
                Container(
                  height: 40,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          0.3,
                          0.5,
                          0.7,
                          0.9
                        ],
                        colors: [
                          Colors.teal[400]!,
                          Colors.teal[300]!,
                          Colors.teal[600]!,
                          Colors.teal[300]!,
                          Colors.teal[400]!,
                        ]),
                  ),
                  child: MaterialButton(
                    minWidth: 350,
                    height: 20,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () {
                      reset();
                      //     _formKey.currentState.reset();
                      _formKey1.currentState!.reset();
                    },
                    child: Text('Reset',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                )
              ],
            )));
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select zone value',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
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
        'Enter atleast one description',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  void reset() {
    text = null;
    item1 = null;
    _mySelection1 = null;
    desc1 = null;
    desc2 = null;
    desc3 = null;
    setState(() {
      text = null;
      item1 = null;
      _mySelection1 = null;
      desc1 = null;
      desc2 = null;
      desc3 = null;
    });
  }
}
