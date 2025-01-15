import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonParamData.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/home/auction/schedules/schedulenextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import "package:equatable/equatable.dart";
class Users {
  final String? sid, category;
  const Users({
    this.sid,
    this.category,
  });
}

class schedule extends StatefulWidget {
  @override
  _scheduleState createState() => _scheduleState();
}

class _scheduleState extends State<schedule> {
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowcount = -1;
  void initState() {
    super.initState();

    fetchPost();
  }

  void fetchPost() async {
    rowcount = (await dbHelper.rowCountSchedule())!;
    if (rowcount <= 0) {
      var v =
          AapoortiConstants.webServiceUrl + 'Auction/AucSchedule?PAGECOUNTER=1';
      final response = await http.post(Uri.parse(v));
      jsonResult = json.decode(response.body);
      for (int index = 0; index < jsonResult!.length; index++) {
        Map<String, dynamic> row = {
          DatabaseHelper.Tblb_Col1_rail: jsonResult![index]['RLYNAME'],
          DatabaseHelper.Tblb_Col2_dept: jsonResult![index]['DEPTNAME'],
          DatabaseHelper.Tblb_Col3_schdlno: jsonResult![index]['SCHDLNO'],
          DatabaseHelper.Tblb_Col4_start: jsonResult![index]['START_DATETIME'],
          DatabaseHelper.Tblb_Col5_end: jsonResult![index]['END_DATETIME'],
          DatabaseHelper.Tblb_Col7_desc: jsonResult![index]['DESCRIPTION'],
          DatabaseHelper.Tblb_Col8_catid: jsonResult![index]['CATID'],
          DatabaseHelper.Tblb_Col12_corr: AapoortiConstants.corr,
        };
        final id1 = dbHelper.insertSchedule(row);
      }
    } else {
      debugPrint("data present in local db");
      rowcount = (await dbHelper.rowCountSchedule())!;
      debugPrint(rowcount.toString());
      debugPrint(AapoortiConstants.common);
      // ignore: unrelated_type_equality_checks
      if (AapoortiConstants.common.compareTo(rowcount.toString()) == 0) {
        debugPrint("Equal..fetching from database");
        jsonResult = await dbHelper.fetchSchedule();
        debugPrint(jsonResult.toString());
      } else {
        debugPrint("not equal");
        debugPrint('Fetching from service');
        var v = AapoortiConstants.webServiceUrl +
            'Auction/AucSchedule?PAGECOUNTER=1';
        debugPrint("url===" + v);
        final response = await http.post(Uri.parse(v));
        jsonResult = json.decode(response.body);
        debugPrint("jsonresult===");
        debugPrint(jsonResult.toString());
        // print(jsonResult1.toString());
        //print(jsonResult1[0]['Count']);
        await dbHelper.deleteSchedule(1);
        debugPrint("saved function called");
        for (int index = 0; index < jsonResult!.length; index++) {
          Map<String, dynamic> row = {
            DatabaseHelper.Tblb_Col1_rail: jsonResult![index]['RLYNAME'],
            DatabaseHelper.Tblb_Col2_dept: jsonResult![index]['DEPTNAME'],
            DatabaseHelper.Tblb_Col3_schdlno: jsonResult![index]['SCHDLNO'],
            DatabaseHelper.Tblb_Col4_start: jsonResult![index]['START_DATETIME'],
            DatabaseHelper.Tblb_Col5_end: jsonResult![index]['END_DATETIME'],
            DatabaseHelper.Tblb_Col7_desc: jsonResult![index]['DESCRIPTION'],
            DatabaseHelper.Tblb_Col8_catid: jsonResult![index]['CATID'],
            DatabaseHelper.Tblb_Col12_corr: AapoortiConstants.corr,
          };

          final id = dbHelper.insertSchedule(row);
        }
      }
    }

    setState(() {});
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
                Container(
                    child: Text('Auction Schedule',
                        style: TextStyle(color: Colors.white))),
                Padding(padding: EdgeInsets.only(right: 35.0)),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),

        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.cyan.shade600,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '  Total Records',
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.cyan.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: jsonResult == null
                      ? SpinKitFadingCircle(
                          color: Colors.cyan,
                          size: 120.0,
                        )
                      : _myListView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    if (jsonResult!.isEmpty) {
      AapoortiUtilities.showInSnackBar(context, "No Schedule  Tender");
    } else {
      return ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                  elevation: 4,
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Padding(padding: EdgeInsets.only(left: 8)),
                              Text(
                                (index + 1).toString() + ". ",
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
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            jsonResult![index]['RLYNAME'] != null
                                                ? (jsonResult![index]
                                                        ['RLYNAME'] +
                                                    " / " +
                                                    jsonResult![index]
                                                        ['DEPTNAME'])
                                                : "",
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    )
                                  ]),
                                  Padding(padding: EdgeInsets.only(top: 5.0)),
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        width: 110,
                                        child: Text(
                                          "Schedule No :",
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            jsonResult![index]['SCHDLNO'] != null
                                                ? jsonResult![index]['SCHDLNO']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                        flex: 6),
                                  ]),
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        child: Text(
                                          'Auction Start',
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        child: Text(
                                          jsonResult![index]['START_DATETIME'] !=
                                                  null
                                              ? jsonResult![index]
                                                  ['START_DATETIME']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                      ),
                                      flex: 6,
                                    ),
                                  ]),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            'Auction End',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 16),
                                          ),
                                        ),
                                        flex: 4,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            (jsonResult![index]
                                                        ['END_DATETIME'] !=
                                                    null
                                                ? jsonResult![index]
                                                    ['END_DATETIME']
                                                : ""),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                        ),
                                        flex: 6,
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
//
                        ],
                      )
                    ],
                  )),
              onTap: () {
                if (jsonResult![index]['CORRI_DETAILS'] != 'NA') {
                  showDialog(
                      context: context,
                      builder: (_) => Material(
                            type: MaterialType.transparency,
                            child: Center(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 200,
                                        bottom: 200,
                                        left: 30,
                                        right: 30),
                                    padding: EdgeInsets.only(
                                        top: 30,
                                        bottom: 0,
                                        left: 30,
                                        right: 30),
                                    color: Colors.white,
                                    // Aligns the container to center
                                    child: Column(children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'List of Categories',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: 0,
                                          ),
                                          child: Overlay(
                                            context,
                                            jsonResult![index]['DESCRIPTION']
                                                .toString(),
                                            jsonResult![index]['CATID']
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('CLICK ON ANY CATEGORY',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.indigo)),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop('dialog');
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/close_overlay.png'),
                                              color: Colors.black,
                                              height: 50,
                                            )),
                                      )
                                    ]))),
                          ));
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 10,
            );
          },
          itemCount: jsonResult != null ? jsonResult!.length : 0);
    }
    return Container();
  }

  Widget Overlay(BuildContext context, String description, String catid) {
    var sArray = description.split('#');
    var scatid = catid;
    return ListView.separated(
        itemCount: description.isNotEmpty || description.length>0 ? sArray.length : 0,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            var route = MaterialPageRoute(
                              builder: (BuildContext context) => schedule2(
                                  value1: Users(
                                sid: scatid,
                                category: sArray[index],
                              )),
                            );
                            Navigator.of(context).push(route);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                sArray[index].toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ))),
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
            height: 20,
          );
        });
  }
}
