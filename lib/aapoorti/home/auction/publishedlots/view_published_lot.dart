import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';

import 'package:flutter_app/aapoorti/home/auction/publishedlots/vie_published_lot_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'dart:async';

String pageNumber = "1";

class PublishedLot extends StatefulWidget {
  get path => null;

  @override
  _PublishedLotState createState() => _PublishedLotState();
}

class _PublishedLotState extends State<PublishedLot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  int initalValueRange = 0;
  int recordsPerPageCounter = 0;
  int final_value = 0;
  int? calculated_value;
  int flag = 0;
  int? initialValRange;
  json5? j1;

  int? finalwritevalue;
  bool keyboardOpen = false, dateSelection = true;
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchPost(pageNumber);
    });
  }

  void fetchPost(String pageNumber) async {
    pgno = pageNumber;
    var v =
        "https://www.ireps.gov.in/Aapoorti/ServiceCall/getData?input=AUCTION_PRELOGIN,VIEW_PUBLISHED_LOTS," +
            _mySelection1.toString() +
            "," +
            _mySelection.toString() +
            "," +
            _mySelection2.toString() +
            "," +
            pgno;

    final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
    jsonResult = json.decode(response.body);

    finalwritevalue = jsonResult![0][':B6'];
    if (this.mounted)
      setState(() {
        if ((jsonResult != null) &
            (!jsonResult.toString().contains('[{ErrorCode:'))) {
          keyboardOpen = true;

          finalwritevalue = jsonResult![0][':B6'];

          initalValueRange = jsonResult![0]['SR'];

          total_records = jsonResult![0][':B6'];
          while (initalValueRange < total_records!) {
            if(flag == 0) {
              initialValRange = jsonResult![0]['SR'];
              flag = 1;
            }
            initalValueRange++;
            no_pages = jsonResult![0][':B7'];
          }
          if (pgno == 1.toString()) {
            initialValRange = jsonResult![0]['SR'];
            final_value = jsonResult!.length;
          } else if (int.parse(pgno) < no_pages!) {
            initialValRange = jsonResult![0]['SR'];
            final_value = 250 + (250 * (int.parse(pgno) - 1));
          } else {
            initialValRange = jsonResult![0]['SR'];
            final_value = total_records!;
          }
        } else {
          if (!keyboardOpen) keyboardOpen = false;
        }
      });
  }

  void fetchPost1(String pageNumber) async {
    pgno = pageNumber;
    var v =
        "https://www.ireps.gov.in/Aapoorti/ServiceCall/getData?input=AUCTION_PRELOGIN,VIEW_PUBLISHED_LOTS," +
            _mySelection1.toString() +
            "," +
            _mySelection.toString() +
            "," +
            _mySelection2.toString() +
            "," +
            pgno;

    final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
    jsonResult = json.decode(response.body);
    finalwritevalue = jsonResult![0][':B6'];
    _progressHide();
    setState(() {
      if (jsonResult != null) {
        keyboardOpen = true;

        finalwritevalue = jsonResult![0][':B6'];

        initalValueRange = jsonResult![0]['SR'];

        total_records = jsonResult![0][':B6'];
        while (initalValueRange < total_records!) {
          if (flag == 0) {
            initialValRange = jsonResult![0]['SR'];
            flag = 1;
          }
          initalValueRange++;
          no_pages = jsonResult![0][':B7'];
        }

        if (pgno == 1.toString()) {
          initialValRange = jsonResult![0]['SR'];
          final_value = jsonResult!.length;
        } else if (int.parse(pgno) < no_pages!) {
          initialValRange = jsonResult![0]['SR'];
          final_value = 250 + (250 * (int.parse(pgno) - 1));
        } else {
          initialValRange = jsonResult![0]['SR'];
          final_value = total_records!;
        }
      } else {
        if (!keyboardOpen) keyboardOpen = false;
      }
    });
  }

  Future<void> getData(Function setState) async {
    try {
      var u = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,RLY_UNITS_AUCTION';
      final response1 = await http.post(Uri.parse(u));
      jsonResult1 = json.decode(response1.body);
      data1 = jsonResult1!;
      setState(() {
        data1 = jsonResult1!;
      });
    } catch (_) {}
  }

  void splitDate(Function setState) {
    String? start_date;
    String depot_id;
    int index;
    items.clear();
    for (index = jsonResult2!.length - 1; index >= 0; index--) {
      depot_id = jsonResult2![index]["DEPOT_ID"].toString();
      if (depot_id == _mySelection) {
        start_date = jsonResult2![index]["START_DATE"] ?? '';
        if (start_date == "Select Start Date") {
          start_date = null;
        }
        if (!["", null, false, 0].contains(start_date)) {
          List<String> s = start_date!.split("#");
          dateSelection = true;
          for (int j = s.length - 1; j >= 0; j--) {
            j1 = json5(
              start_date: s[j].replaceFirst('_', ' '),
              depot_id: s[j],
            );
            items.add(j1!);
          }
          break;
        }
      }
    }

    if (index == -1 && items.length == 0) {
      dateSelection = false;
      _mySelection2 = "-1";
    }
    items.add(json5(start_date: 'Select Date', depot_id: '-1'));
  }

  Future<void> getDatasecond(Function setState, String selectedValue1) async {

    var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,$selectedValue1';


    _progressShow();
    jsonResult2 = [];
    final response1 = await http.post(Uri.parse(u));
    setState(() {
      data2.clear();
      _mySelection = '-1';
      _mySelection2 = '-1';
      jsonResult2 = json.decode(response1.body);
      data2 = jsonResult2!;
      _progressHide();
      data2 = jsonResult2!;
      _mySelection1 = selectedValue1;
    });
  }

  Future<void> getDatafirst(Function setState) async {
    var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,-1';

    _progressShow();
    jsonResult2 = [];
    final response1 = await http.post(Uri.parse(u));
    jsonResult2 = json.decode(response1.body);
    data2 = jsonResult2!;

    _progressHide();
    setState(() {
      data2 = jsonResult2!;
    });
  }

  _progressShow() {
    pr = ProgressDialog(
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
        debugPrint(isHidden.toString());
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
                  Container(
                      child: Text('Published Lots', style: TextStyle(color: Colors.white))),
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
                      if(finalwritevalue != null && finalwritevalue! > 250)
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
          floatingActionButton: Visibility(
            visible: keyboardOpen,
            child: FloatingActionButton(
              onPressed: () {
                overlay_Dialog();

              },
              elevation: 12,
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked),
    );
  }

  Widget _myListView(BuildContext context) {
    return (jsonResult == null || jsonResult![0]['ErrorCode'] == 3)
        ? Center(
            child: Text(
            ' No Response Found ',
            style: TextStyle(
                color: Colors.indigo,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ))
        : ListView.separated(
            itemCount: jsonResult != null ? jsonResult!.length : 0,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if(index == 0)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.cyan[700],
                              child: Text(
                                "            " +
                                    initialValRange.toString() +
                                    " - " +
                                    final_value.toString() +
                                    " of " +
                                    total_records.toString() +
                                    " Records                                  ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(4.0)),
                      Card(
                          elevation: 4,
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 1, color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(left: 8)),
                                        Text(
                                          jsonResult![index]['SR'] != null
                                              ? (jsonResult![index]['SR'])
                                                      .toString() +
                                                  "  "
                                              : "",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          Row(children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 125,
                                              child: Text(
                                                "Railway",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              child: Text(
                                                jsonResult![index]['RAILWAY_NAME'] != null ? jsonResult![index]['RAILWAY_NAME'] : "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            )
                                          ]),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                          ),
                                          Row(children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 125,
                                              child: Text(
                                                "Depot Name",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                jsonResult![index]
                                                            ['DEPOT_NAME'] !=
                                                        null
                                                    ? jsonResult![index]
                                                        ['DEPOT_NAME']
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            )
                                          ]),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  width: 125,
                                                  child: Text(
                                                    "Lot No",
                                                    style: TextStyle(
                                                        color: Colors.indigo,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    child: Text(
                                                      jsonResult![index]
                                                                  ['LOT_NO'] !=
                                                              null
                                                          ? jsonResult![index]
                                                              ['LOT_NO']
                                                          : "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                          Row(children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 125,
                                              child: Text(
                                                "Category",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                jsonResult![index]
                                                            ['CATEGORY_NAME'] !=
                                                        null
                                                    ? jsonResult![index]
                                                        ['CATEGORY_NAME']
                                                    : "",
                                                maxLines: 4,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ]),
                                          Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  width: 125,
                                                  child: Text(
                                                    "Min Incr",
                                                    style: TextStyle(
                                                        color: Colors.indigo,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  child: Text(
                                                    jsonResult![index][
                                                                'MIN_INCR_AMT'] !=
                                                            null
                                                        ? (jsonResult![index][
                                                                'MIN_INCR_AMT'])
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 16),
                                                  ),
                                                )
                                              ]),
                                          Row(children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 125,
                                              child: Text(
                                                "Lot Published",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              child: Text(
                                                jsonResult![index][
                                                            'LOT_PUBLISH_DATE'] !=
                                                        null
                                                    ? jsonResult![index]
                                                        ['LOT_PUBLISH_DATE']
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16),
                                              ),
                                            )
                                          ]),
                                          Row(children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 125,
                                              child: Text(
                                                "Material Desc",
                                                style: TextStyle(
                                                  color: Colors.indigo,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            Expanded(
                                                child: Container(
                                              height: 55,
                                              child: Text(
                                                jsonResult![index][
                                                            'LOT_MATERIAL_DESC'] !=
                                                        null
                                                    ? jsonResult![index]
                                                        ['LOT_MATERIAL_DESC']
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ))
                                          ]),
                                        ]))
                                  ]),
                            ],
                          ))
                    ],
                  ),
                ),
                onTap: () {
                  _isVisible = false;
                  lotid = jsonResult![index]['LOT_ID'];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PublishedLotDetails(id: lotid)));

                },
              );
            },
            separatorBuilder: (context, index) {
              return Container();
            });
  }

  void paginationFirstClick() {
    if (pageNumber == 1.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the first page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));
    } else {
      _progressShow();
      pageNumber = "1";
      fetchPost1(pageNumber);
    }
  }

  void paginationPrevClick() {
    if (pageNumber == 1.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the first page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));

    } else {
      _progressShow();
      int counter = int.parse(pageNumber);
      counter += -1;
      pageNumber = counter.toString();

      fetchPost1(pageNumber);
    }
  }

  void paginationNextClick() {
    if (pageNumber == no_pages.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the last page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));
    } else {
      _progressShow();
      int counter = int.parse(pageNumber);
      counter += 1;
      pageNumber = counter.toString();

      fetchPost1(pageNumber);
    }
  }

  void paginationLastClick() {
    if (pageNumber == no_pages.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You are on the last page!"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent[100],
      ));

    } else {
      _progressShow();
      pageNumber = no_pages.toString();
      fetchPost1(pageNumber);
    }
  }

  overlay_Dialog() async {
    await getData(setState);
    return showDialog(
        context: context,
        builder: (context) {
          String contentText = "Content of Dialog";
          print(contentText);
          return StatefulBuilder(
            builder: (context, setState) {
              return Material(
                type: MaterialType.transparency,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 300,
                          width: 600,
                          margin: EdgeInsets.only(
                              top: 200, bottom: 50, left: 30, right: 30),
                          padding: EdgeInsets.only(
                              top: 30, bottom: 0, left: 30, right: 30),
                          color: Colors.white,
                          // Aligns the container to center
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(top: 3, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.train,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            hint: Text(
                                                '     Select Organization       '),
                                            items: data1.map((item) {
                                              return DropdownMenuItem(
                                                  child: Text(
                                                    item['NAME'],
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                  value: item['ID'].toString());
                                            }).toList(),
                                            onChanged: (newVal1) {
                                              getDatasecond(setState, newVal1 as String);
                                            },
                                            value: _mySelection1,
                                          ),
                                        ),
                                      ],
                                    )),
                                Expanded(
                                  child: Container(
                                      child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'images/depot.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text(
                                              '     Select Depot Name       '),
                                          items: data2.map((item) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                item['DEPOT_NAME'].toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              value:
                                                  item['DEPOT_ID'].toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            // Navigator.of(context).pop();
                                            setState(() {
                                              _mySelection = newVal as String;
                                              _mySelection2 = '-1';
                                              items.clear();

                                              splitDate(setState);
                                            });
                                          },
                                          value: _mySelection,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                                (dateSelection)
                                    ? Expanded(
                                        child: Container(
                                            child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.black,
                                            ),
                                            Expanded(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                hint: Text(
                                                    '     Select Date                '),
                                                items: items.map((item) {
                                                  return DropdownMenuItem(
                                                      child: Text(
                                                        item.start_date
                                                                .toString() +
                                                            "                      ",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      value: item.depot_id
                                                          .toString());
                                                }).toList(),
                                                onChanged: (newVal1) {
                                                  setState(() {
                                                    _mySelection2 = newVal1 as String;
                                                    debugPrint("my selection first2" + _mySelection2);
                                                  });
                                                },
                                                value: _mySelection2,
                                              ),
                                            ),
                                          ],
                                        )),
                                      )
                                    : Expanded(child: Container()),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      MaterialButton(
                                          height: 40,
                                          padding: EdgeInsets.fromLTRB(
                                              25.0, 5.0, 25.0, 5.0),
                                          // padding: const EdgeInsets.only(left:110.0,right:110.0),
                                          child: Text(
                                            'Apply',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            fetchPost(pageNumber);
                                            //  keyboardOpen = true;
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                          },
                                          color: Colors.black26),
                                    ],
                                  ),
                                ),
                              ])),
                      Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              },
                              child: Image(
                                image: AssetImage('assets/close_overlay.png'),
                                color: Colors.white,
                                height: 50,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

class json5 {
  String? start_date;
  String? depot_id;
  json5({this.start_date, this.depot_id});
}
