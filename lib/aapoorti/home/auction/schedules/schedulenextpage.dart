import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonParamData.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/auction/schedules/schedule.dart';
import 'package:flutter_app/aapoorti/home/auction/schedules/schedulethirdpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Users1 {
  final String? lotid, des;
  const Users1({this.lotid, this.des});
}

class schedule2 extends StatefulWidget {
  get path => null;
  final Users? value1;
  schedule2({Key? key, this.value1}) : super(key: key);
  @override
  _schedule2State createState() => _schedule2State();
}

class _schedule2State extends State<schedule2> {
  List<dynamic>? jsonResult, jsonResult1, jsonResult2;
  final dbHelper = DatabaseHelper.instance;
  ProgressDialog? pr;
  String? _mySelection;
  String? _mySelection1;
  String? _mySelection2;
  var rowCount = -1;
  String? pgno;
  int? lotid, id;
  int? total_records, no_pages;
  int flag = 0;
  int? initialValRange;
  int? initalValueRange;
  int recordsPerPageCounter = 0;
  int final_value = 0;
  int? calculated_value;
  void initState() {
    super.initState();
    var fetchPost = this.fetchPost();
  }

  List data = [];
  void fetchPost() async {
    var url = AapoortiConstants.webServiceUrl +
        'Auction/CatalogueDesc?CID=${widget.value1!.sid}&CATEGORY=${widget.value1!.category}';
    final response = await http.post(Uri.parse(url));
    jsonResult = json.decode(response.body);
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
            backgroundColor: Colors.lightBlue[800],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Auction Schedule',
                        style: TextStyle(color: Colors.white))),
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
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                color: Color(0xFFE3F2FD),
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '   Auction Catalogue',
                  style: TextStyle(
                      color: Colors.lightBlue[800],
                      backgroundColor: Color(0xFFE3F2FD),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: jsonResult == null
                      ? SpinKitWave(
                          color: Colors.lightBlue[800],
                          size: 30.0,
                        )
                      : _myListView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    // Example of a spinner (this part won't affect background directly, it's for loading indication)
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return Container(
      color: Colors.white, // Change the background color here
      child: ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                                  color: Colors.lightBlue[800], fontSize: 15),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // Lot No.
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Lot No.:  ",
                                        style: TextStyle(
                                            color: Colors.lightBlue[800],
                                            //color: Color(0xFFFFE0B2),
                                            //color: Color(0xFFFFA726),
                                            // fontSize: MediaQuery.of(context).size.width * 0.04, // Dynamic font size based on screen width
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  // Status
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Status :",
                                        style: TextStyle(
                                          color: Colors.lightBlue[800],
                                          //color: Colors.teal[900],
                                          fontWeight: FontWeight.w600,
                                          // fontSize: MediaQuery.of(context).size.width * 0.04,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  // Lot No. value
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        jsonResult![index]['LOTNO'] != null
                                            ? jsonResult![index]['LOTNO']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            //color: Color(0xFFFFB74D),
                                            // decoration:
                                            //     TextDecoration.underline,
                                            fontSize: 15,
                                            // fontSize: MediaQuery.of(context).size.width * 0.05, // Dynamic font size for value
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  // Status value
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        jsonResult![index]['LOT_STATUS'] ??
                                            "", // Handle null case safely
                                        style: TextStyle(
                                          color: jsonResult![index]
                                                      ['LOT_STATUS'] ==
                                                  "Live"
                                              ? Colors
                                                  .green[600] // Green for Live
                                              : jsonResult![index]
                                                          ['LOT_STATUS'] ==
                                                      "No Bids Received"
                                                  ? Color(
                                                      0xFF1a237e) // Blue for No Bids Received
                                                  : jsonResult![index]
                                                              ['LOT_STATUS'] ==
                                                          "Rejected"
                                                      ? Colors.red[700]
                                                      // : jsonResult![index][
                                                      //             'LOT_STATUS'] ==
                                                      //         "Sold-Ready for Bid Sheet"
                                                          : Colors.orangeAccent,
                                          // Default color if none match
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines:
                                            1, // Ensures text is restricted to one line
                                        overflow: TextOverflow
                                            .ellipsis, // Adds "..." if text is too long
                                        softWrap:
                                            false, // Prevents text from wrapping to the next line
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                  color: Colors.blueGrey[200], // Divider color
                                  thickness: 1, // Divider thickness
                                  indent: 9, // Indentation from the left
                                  endIndent: 30 // Indentation from the right
                                  ),
                              //SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  // Lot No.
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Quantity.:  ",
                                        style: TextStyle(
                                            color: Colors.lightBlue[800],
                                            // fontSize: MediaQuery.of(context).size.width * 0.04, // Dynamic font size based on screen width
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  // Status
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Min Inc.(Rs.): ",
                                        style: TextStyle(
                                          color: Colors.lightBlue[800],
                                          fontWeight: FontWeight.w600,
                                          // fontSize: MediaQuery.of(context).size.width * 0.04,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  // Lot No. value
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        jsonResult![index]['LOT_QTY'] != null
                                            ? jsonResult![index]['LOT_QTY']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            //color: Color(0xFFFFB74D),
                                            fontSize: 15,
                                            // fontSize: MediaQuery.of(context).size.width * 0.05, // Dynamic font size for value
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  // Status value
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        jsonResult![index]['MIN_INCR_AMT'] !=
                                                null
                                            ? jsonResult![index]['MIN_INCR_AMT']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            //color: Color(0xFFFFB74D),//orange
                                            fontSize: 15,
                                            // fontSize: MediaQuery.of(context).size.width * 0.05, // Dynamic font size for value
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                  color: Colors.blueGrey[200], // Divider color
                                  thickness: 1, // Divider thickness
                                  indent: 9, // Indentation from the left
                                  endIndent: 30 // Indentation from the right
                                  ),
                              // SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  // Lot No.
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Lot Start:  ",
                                        style: TextStyle(
                                            color: Colors.lightBlue[800],
                                            // fontSize: MediaQuery.of(context).size.width * 0.04, // Dynamic font size based on screen width
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  // Status
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Lot End:",
                                        style: TextStyle(
                                          color: Colors.lightBlue[800],
                                          fontWeight: FontWeight.w600,
                                          // fontSize: MediaQuery.of(context).size.width * 0.04,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  // Lot No. value
                                  Expanded(
                                    child: Container(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: jsonResult![index]['LOT_START_DATETIME'] != null
                                                  ? jsonResult![index]['LOT_START_DATETIME'].split(" ")[0] + " " // Extract date
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.blueGrey, // Date in blue-grey
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            TextSpan(
                                              text: jsonResult![index]['LOT_START_DATETIME'] != null
                                                  ? jsonResult![index]['LOT_START_DATETIME'].split(" ")[1] // Extract time
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.green, // Time in green
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),
                                  // Status value
                                  Expanded(
                                    child: Container(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: jsonResult![index]['LOT_END_DATETIME'] != null
                                                  ? jsonResult![index]['LOT_END_DATETIME'].split(' ')[0] + " " // Extract Date
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.blueGrey, // Date in BlueGrey
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            TextSpan(
                                              text: jsonResult![index]['LOT_END_DATETIME'] != null
                                                  ? jsonResult![index]['LOT_END_DATETIME'].split(' ').length > 1
                                                  ? jsonResult![index]['LOT_END_DATETIME'].split(' ')[1] // Extract Time
                                                  : ""
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.red, // Time in Red
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 5),
                              Divider(
                                  color: Colors.blueGrey[200], // Divider color
                                  thickness: 1, // Divider thickness
                                  indent: 9, // Indentation from the left
                                  endIndent: 30 // Indentation from the right
                                  ),
                              Column(
                                children: <Widget>[
                                  // Row for "Description" and its value starting immediately after the label
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Ensures vertical alignment
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Description: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[800],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // Small space between label and value
                                      Expanded(
                                        child: Text(
                                          jsonResult![index]['LOTMATDESC'] !=
                                                  null
                                              ? jsonResult![index]['LOTMATDESC']
                                              : "",
                                          textAlign: TextAlign.start,
                                          softWrap: false,
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis, // Prevent text overflow
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                ],
                              )
                            ]))
                      ])
                ],
              ),
            ),
            onTap: () {
              if (jsonResult![index]['LOTMATDESC'] != 'NA') {
                Container(
                    child: Center(
                        child: Container(
                            child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 0),
                      child: livelotid(
                        context,
                        jsonResult![index]['LOTMATDESC'],
                        jsonResult![index]['LOTID'].toString(),
                      ),
                    ),
                  ),
                ]))));
              }
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 10,
          );
        },
      ),
    );
  }

  Widget livelotid(BuildContext context, String Description, String livelotid) {
    var lotid = livelotid;
    var des = Description;
    var route = MaterialPageRoute(
      builder: (BuildContext context) => schedule3(
          value3: Users1(
        lotid: lotid,
        des: des,
      )),
    );
    Navigator.of(context).push(route);
    return SizedBox();
  }
}
