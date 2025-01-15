import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PendingTenderReportDetails extends StatefulWidget {
  final String? item1, item2, item3, item4, item5, item6;
  PendingTenderReportDetails({this.item1, this.item2, this.item3, this.item4, this.item5, this.item6});

  @override
  _PendingTenderReportDetailsState createState() =>
      _PendingTenderReportDetailsState(this.item1!, this.item2!, this.item3!,
          this.item4!, this.item5!, this.item6!);
}

class _PendingTenderReportDetailsState
    extends State<PendingTenderReportDetails> {
  String? item1, item2, item3, item4, item5, item6;
  List<dynamic>? jsonResult;
  List data = [];

  _PendingTenderReportDetailsState(String item1, String item2, String item3,
      String item4, String item5, String item6) {
    this.item1 = item1;
    this.item2 = item2;
    this.item3 = item3;
    this.item4 = item4;
    this.item5 = item5;
    this.item6 = item6;
  }

  Future<void> fetchPostOrganisation() async {
    var u =
        'https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=PENDING_TENDER_REPORT,ZONEWISE_REPORT,${this.item1},${this.item2},${this.item3},${this.item4},${this.item5},${this.item6}';

    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    jsonResult = json.decode(response1.body);
    // jsonResult1 = json.decode(response1.body);
    if (jsonResult!.length == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 4) {
      // jsonResult=null;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }

    setState(() {
      data = jsonResult!;
    });
  }

  void initState() {
    super.initState();
    this.fetchPostOrganisation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Closed RA',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pending Tender Report',
              style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: jsonResult == null
                            ? SpinKitFadingCircle(
                                color: Colors.teal,
                                size: 120.0,
                              )
                            : _myListView(context))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return Card(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
         Widget>[
           Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                        height: 25,
                        width: 350,
                        color: Colors.cyan[100],
                        child: Text(
                          jsonResult![index]['DEPARTMENT_NAME'] != null
                              ? ((index + 1).toString() +
                                  ".       " +
                                  jsonResult![index]['DEPARTMENT_NAME'])
                              : "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 240.0)),
                          Text(
                            "TC",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          Padding(padding: EdgeInsets.only(left: 45.0)),
                          Text(
                            "       DA",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ]),
                    Divider(
                      height: 10.0,
                      color: Colors.grey,
                    ),
                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Container(
                        height: 20,
                        width: 125,
                        child: Text(
                          "      Pending",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 120.0)),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Text(
                            jsonResult![index]['TC_CURRENT_PEND'] != null
                                ? (jsonResult![index]['TC_CURRENT_PEND'])
                                    .toString()
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 65.0)),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Text(
                            jsonResult![index]['DA_CURRENT_PEND'] != null
                                ? (jsonResult![index]['DA_CURRENT_PEND'])
                                    .toString()
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ]),
                    Divider(
                      height: 5.0,
                      color: Colors.grey,
                    ),
                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "   Pending With",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                    Column(
                      children: <Widget>[
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "      Tech Department",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_CURRENT_PEND'] != null
                                    ? (jsonResult![index]['TC_CURRENT_PEND'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_CURRENT_PEND'] != null
                                    ? (jsonResult![index]['DA_CURRENT_PEND'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "       TC Member",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_CURRENT_PEND'] != null
                                    ? (jsonResult![index]['TC_CURRENT_PEND'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_CURRENT_PEND'] != null
                                    ? (jsonResult![index]['DA_CURRENT_PEND'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "       Accepting Auth",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_ACCEPTANCE_AUTH'] != null
                                    ? (jsonResult![index]['TC_ACCEPTANCE_AUTH'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_ACCEPTANCE_AUTH'] != null
                                    ? (jsonResult![index]['DA_ACCEPTANCE_AUTH'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "      Convener",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_CONVERNOR'] != null
                                    ? (jsonResult![index]['TC_CONVERNOR'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_CONVERNOR'] != null
                                    ? (jsonResult![index]['DA_CONVERNOR'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.grey,
                    ),
                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Container(
                        height: 30,
                        width: 150,
                        child: Text(
                          "   Pending for(days)",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                    Column(
                      children: <Widget>[
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "       <30",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_PEND_30_DAYS'] != null
                                    ? (jsonResult![index]['TC_PEND_30_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_PEND_30_DAYS'] != null
                                    ? (jsonResult![index]['DA_PEND_30_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "       <60",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_PEND_60_DAYS'] != null
                                    ? (jsonResult![index]['TC_PEND_60_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_PEND_60_DAYS'] != null
                                    ? (jsonResult![index]['DA_PEND_60_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "       <30",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_PEND_30_DAYS'] != null
                                    ? (jsonResult![index]['TC_PEND_30_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_PEND_30_DAYS'] != null
                                    ? (jsonResult![index]['DA_PEND_30_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Container(
                            height: 30,
                            width: 150,
                            child: Text(
                              "       <90",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 120.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['TC_PEND_90_DAYS'] != null
                                    ? (jsonResult![index]['TC_PEND_90_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 65.0)),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text(
                                jsonResult![index]['DA_PEND_90_DAYS'] != null
                                    ? (jsonResult![index]['DA_PEND_90_DAYS'])
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ]),
            ),
          ]),
        );
      },
    );
  }
}
