import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/home/implinks/aac/aacnextpage.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState1 createState() => DropDownState1();
}

class DropDownState1 extends State<DropDown> {
  List<dynamic>? jsonResult2, jsonResult1;
  ProgressDialog? pr;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  bool _autoValidate = false;
  bool pressed = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? myselection2, myselection1, catid;
  DropDownState1({
    this.catid,
  });

  List data = [];
  List data1 = [];

  Future<void> fetchPost() async {
    try {

      var u = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(u));
      jsonResult1 = json.decode(response.body);
      if (response == null || response.statusCode != 200)
        throw new Exception(
            'HTTP request failed, statusCode: ${response?.statusCode}');
      data = jsonResult1!;
      setState(() {
        if (jsonResult1 != null) data = jsonResult1!;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchdata() async {
    myselection2 = null;
    if (myselection1 != "-1") {
      AapoortiUtilities.getProgressDialog(pr!);
      var u = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,ZONE,${myselection1}';

      final response1 = await http.post(Uri.parse(u));
      jsonResult2 = json.decode(response1.body);
      debugPrint("jsonresult2===");
      debugPrint(jsonResult2.toString());

      AapoortiUtilities.stopProgress(pr!);

      setState(() {
        jsonResult2!.removeAt(0);
        data1 = jsonResult2!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchPost();
    });
  }

  String minus = "-1",
      minus1 = "01",
      minus2 = "02",
      minus3 = "03",
      minus4 = "04",
      minus5 = "05",
      minus6 = "06",
      minus7 = "07";

  Widget _myListView(BuildContext context) {
    return Container(
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: Text(myselection1 != null
                        ? myselection1!
                        : 'Select Organization'),

                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        icon: Icon(Icons.train, color: Colors.black)),
                    items: data.map((item) {
                      return DropdownMenuItem(
                          child: Text(
                            item['NAME'],
                          ),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        myselection2 = null;
                        data1.clear();
                        myselection1 = newVal1 as String?;
                        print("my selection first" + myselection1!);
                      });
                      //checkvalue();
                      fetchdata();
                    },
                    value: myselection1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 10.0, left: 20, right: 20, bottom: 30),
                  child: DropdownButtonFormField(
                    hint: Text('Select Railway'),
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_balance, color: Colors.black)),
                    items: data1.map((item) {
                      return DropdownMenuItem(
                          child: Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal2) {
                      setState(() {
                        myselection2 = newVal2 as String?;
                        debugPrint("my selection second" + myselection2!);
                      });
                    },
                    value: myselection2,
                  ),
                ),
                MaterialButton(
                  minWidth: 330,
                  height: 40,

                  padding: EdgeInsets.fromLTRB(
                    25.0,
                    5.0,
                    25.0,
                    5.0,
                  ),
                  // padding: const EdgeInsets.only(left:110.0,right:110.0),
                  child: Text(
                    'Show Results',
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    if (myselection1 != null && myselection2 != null) {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => aac2(
                                      value: DropDownState1(
                                    catid: myselection2,
                                  ))));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    checkvalue();
                  },
                  color: Colors.cyan.shade400,
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.cyan[400],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          child: Text('AAC-Item Annual Consumption',
                              style: TextStyle(color: Colors.white))),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                        //Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                )),
            backgroundColor: Colors.white,
            body: Builder(
              builder: (context) => Material(
                  child: ListView(
                children: <Widget>[_myListView(context)],
              )),
            )

            ));
  }

  void checkvalue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Navigator.push(context,MaterialPageRoute(builder: (context) => Status(content: text,id:_mySelection)));
    } else {
//    If all data are not valid then start auto validation.
      debugPrint("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select values',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
  );
}
