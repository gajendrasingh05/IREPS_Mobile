import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'SafetyReportDetails.dart';

class SafetyReport extends StatefulWidget
{
  @override
  SafetyReportState createState() => SafetyReportState();
}

class SafetyReportState extends State<SafetyReport> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  var optionsDropDown = <String>[
    '2018-19',
    '2019-20'
  ];
  int? _option;
  var dropdownvalue;



  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          key: _scaffoldkey,
          resizeToAvoidBottomInset: false,
          drawer: AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
            title: Text('Safety Report',
                style: TextStyle(
                    color: Colors.white
                )
            ),
          ),
          body: Builder(builder: (context)=>
              Container(
                width: MediaQuery.of(context).size.width,
                margin: new EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    //Padding(padding: EdgeInsets.fromLTRB(50.0,1.0,20,0)),
                    Padding(padding: EdgeInsets.only(top:30.0)),
                    DropdownButtonFormField(
                      hint: Text('Select'),
                      decoration: InputDecoration(icon: Icon(Icons.calendar_today, color: Colors.black)),
                      value: dropdownvalue,
                      items: optionsDropDown.map((String value) {
                        return new DropdownMenuItem<String>(
                          child: new Text(value),
                          value: value.toString(),
                        );
                      }).toList(),
                      onChanged: (value)
                      {
                        setState(() {

                          AapoortiUtilities.setPortraitOrientation();
                          if(optionsDropDown!=null)
                            {
                              dropdownvalue=value;
                              _option= optionsDropDown.indexOf(value as String);
                              print(_option);
                              print("Selected Year----"+_option.toString());
                            }
                        });
                      },
                      validator: (value)
                      {
                        if(value != null)
                          return null;
                        else
                          return 'Please select an option';
                      },
                    ),
                    Padding(
                      padding: new EdgeInsets.only(top: 50,bottom: 10),
                    ),
                    Container(
                      height: 40,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1,0.3,0.5,0.7,0.9],
                            colors: [
                              Colors.teal[400]!,
                              Colors.teal[300]!,
                              Colors.teal[600]!,
                              Colors.teal[300]!,
                              Colors.teal[400]!,
                            ]
                        ),
                      ),
                      child: MaterialButton(
                        minWidth: 350,
                        height:20,
                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        onPressed:() {
                          String? year;
                          if(dropdownvalue!=null)
                          {
                            if(_option==0)
                            {
                              year="18";
                            }
                            else if(_option==1)
                            {
                              year="19";
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SafetyDetails(year!)));
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }

                        },
                        child: Text('Submit',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
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
                            stops: [0.1,0.3,0.5,0.7,0.9],
                            colors: [
                              Colors.teal[400]!,
                              Colors.teal[300]!,
                              Colors.teal[600]!,
                              Colors.teal[300]!,
                              Colors.teal[400]!,
                            ]
                        ),
                      ),
                      child: MaterialButton(
                        minWidth: 350,
                        height:20,
                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        onPressed:() {
                          dropdownvalue=null;
                          setState(() {
                            dropdownvalue=null;
                          });
                        },
                        child: Text('Reset',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
          )
      ),);
  }
  final snackbar=   SnackBar(

    backgroundColor: Colors.redAccent[100],
    content: Container(

      child: Text('Please select an year!',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.teal),),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}

