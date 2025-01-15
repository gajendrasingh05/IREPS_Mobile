import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/login/loginReports/AvgSettlementRpt/AvgSetTimeNEXTpage.dart';

class AvgSetTimeReport extends StatefulWidget {
  @override
  _AvgSetTimeReportState createState() => _AvgSetTimeReportState();
}

class _AvgSetTimeReportState extends State<AvgSetTimeReport> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? _mySelection1;
  //List<String> Year={'Select','2018-2019','2019-2020'} as List<String>;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            children: <Widget>[
              Text("Avg Settlement Time Report"),
            ],
          ),
          backgroundColor: Colors.teal,
        ),
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body: Builder(
          builder: (context) => Material(
            child: Container(
              //color: Colors.black,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    //autovalidate: _autoValidate,
                    child: FormUI(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
          child: DropdownButtonFormField(
            hint: Text(
                _mySelection1 != null ? _mySelection1! : "Select Organization"),
            decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red),
                icon: Icon(Icons.train, color: Colors.black)),
            items: <String>['Select', '2018-2019', '2019-2020']
                .map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),

            onChanged: (newVal1) {
              setState(() {
                _mySelection1 = newVal1;
                print("my selection first" + _mySelection1!);
              });
              //checkvalue();
            },
            value: _mySelection1,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Container(
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
                  Colors.teal[400]!,
                  Colors.teal[800]!,
                  Colors.teal[400]!,
                  Colors.teal[400]!,
                ]),
          ),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  height: 10.0,
                  minWidth: 250.0,
                  onPressed: () {
                    _validateInputs();
                    navigate();
                  },
                  textColor: Colors.white,
                  //color: Colors.cyan,
                  child: Text(
                    "Show Results",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
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
                  Colors.teal[400]!,
                  Colors.teal[800]!,
                  Colors.teal[400]!,
                  Colors.teal[400]!,
                ]),
          ),
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
              ButtonTheme(
                //elevation: 4,
                //color: Colors.green,
                minWidth: double.infinity,
                child: MaterialButton(
                  height: 10.0,
                  minWidth: 250.0,
                  onPressed: () => _onClear(),
                  textColor: Colors.white,
                  //color: Colors.cyan,
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        /*],
        ),*/
      ],
    );
  }

  navigate() async {
    if (_mySelection1 != null) {
      try {
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AvgSetTimeNEXTpage(item1: _mySelection1),
            ));
      } catch (exception) {
        print('SharedProfile ' + exception.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select values',
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
  _onClear() {
    setState(() {
      _formKey.currentState!.reset();
      _formKey.currentState!.save();
      _autoValidate = false;

      _mySelection1 = null;
    });
  }

  void _validateInputs() async {
    if (_formKey.currentState!.validate()) {
      print("If all data are correct then save data to out variables");
      _formKey.currentState!.save();
    } else {
//    If all data are not valid then start auto validation.
      print("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
