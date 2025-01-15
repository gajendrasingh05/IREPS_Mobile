import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/home/auction/publishedlots/vie_published_lot_details.dart';
import 'package:flutter_app/aapoorti/home/auction/publishedlots/view_published_lot_fiters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'dart:async';

import 'aac_home.dart';

String pageNumber = "1";

class aac2 extends StatefulWidget {
  get path => null;
  final DropDownState1? value;

  aac2({Key? key, this.value}) : super(key: key);

  @override
  _aac2State createState() => _aac2State();
}

class _aac2State extends State<aac2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult, jsonResult1, jsonResult2;
  String _mySelection = "-1";
  String _mySelection1 = "-1";
  String _mySelection2 = "-1";
  bool _isVisible = true;
  ProgressDialog? pr;
  List data2 = [];
  List data3 = [];
  List data1 = [];
  List<json5> items = <json5>[];
  String pgno = "1";
  int? lotid, id;
  int? total_records, no_pages;
  // int initalValueRange;
  int recordsPerPageCounter = 0;
  int final_value = 0;
  int? calculated_value;
  int flag = 0;
  // int initialValRange;
  int? intialValRange;
  json5? j1;

  bool keyboardOpen = false, dateSelection = true;
  int intialvalueRange = 0;
  int? finalwrittenvalue;
  void initState() {
    super.initState();
    fetchPost(pageNumber);
  }

  void fetchPost(String pageNumber) async {
    pgno = pageNumber;
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=HELPDESK_PRELOGIN,ITEM_AAC_REPORT,${widget.value!.catid},${this.pgno}';
    print(v);
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    print(response.body);
    finalwrittenvalue = jsonResult![0]['RECORD_COUNT'];
    setState(() {
      if (jsonResult != null)
        keyboardOpen = true;
      else
        keyboardOpen = false;
      finalwrittenvalue = jsonResult![0]['RECORD_COUNT'];
    });
    if (jsonResult!.isEmpty) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 4) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
  }

  void fetchPost1(String pageNumber) async {
    pgno = pageNumber;
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=HELPDESK_PRELOGIN,ITEM_AAC_REPORT,${widget.value!.catid},${this.pgno}';
    print(v);
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    _progressHide();
    print(response.body);
    finalwrittenvalue = jsonResult![0]['RECORD_COUNT'];
    setState(() {
      if (jsonResult != null)
        keyboardOpen = true;
      else
        keyboardOpen = false;
      finalwrittenvalue = jsonResult![0]['RECORD_COUNT'];
    });
    if (jsonResult!.isEmpty) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 4) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
  }

  _progressShow() {
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: true,
      showLogs: true,
    );
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        print(isHidden);
      });
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
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: Text('AAC-Item Annual Consum..',
                          style: TextStyle(color: Colors.white))),
                ),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                  },
                ),
              ],
            )),
        body: Builder(
          builder: (context) => Material(
            child: jsonResult == null
                ? SpinKitFadingCircle(
                    color: Colors.cyan,
                    size: 120.0,
                  )
                : Column(children: <Widget>[
                    if(finalwrittenvalue != null && finalwrittenvalue! > 250)
                      Container(
                        color: Colors.cyan[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  paginationFirstClick();
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  paginationPrevClick();
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  paginationNextClick();
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  paginationLastClick();
                                })
                          ],
                        ),
                      ),
                    Container(child: Expanded(child: _myListView(context)))
                  ]),
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.separated(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
//        if(jsonResult[0]['ErrorCode']==3)
//
//        {
//
//          Navigator.push(context,MaterialPageRoute(builder: (context) => MyAppnodata()));
//
//        }

//        if(jsonResult[index]['PL_NO']==null||jsonResult[index]['DESCR']==null||jsonResult[index]['AAC']==null||jsonResult[index]['UNIT_DESC']==null)
//
//        {     print("aaaaa");

//         // Navigator.push(context,MaterialPageRoute(builder: (context) => nodatafound()));
//        }

        intialvalueRange = jsonResult![index]['SR'];
        total_records = jsonResult![index]['RECORD_COUNT'];
        while (intialvalueRange < total_records!) {
          if (flag == 0) {
            intialValRange = jsonResult![index]['SR'];
            flag = 1;
          }
          intialvalueRange++;
          no_pages = jsonResult![index]['PAGE_COUNT'];
        }
        if (pgno == 1.toString()) {
          intialValRange = jsonResult![index]['SR'];
          final_value = jsonResult!.length;
        } else if (int.parse(pgno) < no_pages!) {
          intialValRange = jsonResult![index]['SR'];
          final_value = 250 + (250 * (int.parse(pgno) - 1));
        } else {
          intialValRange = jsonResult![index]['SR'];
          final_value = total_records!;
        }

        return GestureDetector(
            child: Column(
          children: <Widget>[
            Container(
              color: Colors.cyan[700],
              child: Row(
                children: <Widget>[
                  if (index == 0)
                    Text(
                      "                      " +
                          intialValRange.toString() +
                          "-" +
                          final_value.toString() +
                          " of " +
                          total_records.toString() +
                          " Records",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            jsonResult![index]['SR'] != null
                                ? (jsonResult![index]['SR']).toString() + ". "
                                : "",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                child: Text(
                                  "PL No.:",
                                  style: TextStyle(
                                      color: Colors.indigo, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                //  jsonResult[index]['PL_NO'],

                                jsonResult![index]['PL_NO'] != null
                                    ? jsonResult![index]['PL_NO']
                                    : "",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ))
                            ]),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    child: Text(
                                      "Item Description",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    // jsonResult[index]['DESCR'],

                                    jsonResult![index]['DESCR'] != null
                                        ? jsonResult![index]['DESCR']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  )),
                                ],
                              ),
//
                            ]),
                            Row(
                              children: <Widget>[
//
                                Expanded(
                                  child: Text(
                                    "AAC: ",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    // jsonResult[index]['AAC'].toString(),

//
                                    jsonResult![index]['AAC'] != null
                                        ? jsonResult![index]['AAC'].toString()
                                        : "",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Row(
                              children: <Widget>[
//
                                Expanded(
                                  child: Text(
                                    "Unit: ",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    jsonResult![index]['UNIT_DESC'] != null
                                        ? jsonResult![index]['UNIT_DESC']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ]))
                    ])),
          ],
        ));
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 2.5,
          color: Colors.cyan[100],
        );
      },
    );
  }

  void paginationFirstClick() {
    if (pageNumber == 1.toString()) {
      print("you are on the first page !");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the first page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));
    } else {
      pageNumber = "1";
      _progressShow();
      fetchPost1(pageNumber);
    }
  }

  void paginationPrevClick() {
    if (pageNumber == 1.toString()) {
      print("you are on the first page !");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the first page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));
    } else {
      int counter = int.parse(pageNumber);
      counter += -1;
      pageNumber = counter.toString();
      _progressShow();
      fetchPost1(pageNumber);
    }
  }

  void paginationNextClick() {
    if (pageNumber == no_pages.toString()) {
      print("you are on the last page !");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the last page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));
      // AapoortiUtilities.showInSnackBar(context,"you are on the last page !");
    } else {
      int counter = int.parse(pageNumber);
      counter += 1;
      pageNumber = counter.toString();
      _progressShow();
      fetchPost1(pageNumber);
    }
  }

  void paginationLastClick() {
    if (pageNumber == no_pages.toString()) {
      print("you are on the last page !");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the last page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));
    } else {
      pageNumber = no_pages.toString();
      _progressShow();
      fetchPost1(pageNumber);
    }
  }

  @override
  void dispose() {
    debugPrint('disposed...');
    super.dispose();
  }
}

class json5 {
  String? start_date;
  String? depot_id;
  json5({this.start_date, this.depot_id});
}
