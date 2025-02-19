import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonParamData.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/home/auction/schedules/schedulenextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  int? _selectedIndex;
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
            backgroundColor: Colors.lightBlue[800],
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
                height: 30,
                color: Color(0xFFE3F2FD),
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  '  Total Records',
                  style: TextStyle(
                      color: Colors.lightBlue[800],
                      backgroundColor: Color(0xFFE3F2FD),
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
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
    return ListView.separated(
      itemBuilder: (context, index) {
        return Column(
          children: [
            Card(
              elevation: 6,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(width: 1, color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            "${index + 1}. ",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  jsonResult![index]['RLYNAME'] != null
                                      ? "${jsonResult![index]['RLYNAME']} / ${jsonResult![index]['DEPTNAME']}"
                                      : "",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 6.0)),
                                Divider(
                                  color: Colors.blue[200], // Divider color
                                  thickness: 1,  // Divider thickness
                                  indent:0,  // Indentation from the left
                                  endIndent: 0 // Indentation from the right
                                ),
                                // Schedule Number
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align all elements to the left
                                  children: [
                                    // Schedule Number
                                    Row(
                                      children: [
                                        Container(
                                          width: 120, // Fixed width for the label to align all colons
                                          child: Text(
                                            "Schedule No: ",
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 10, // Space between colon and value
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            jsonResult![index]['SCHDLNO'] ?? "N/A",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Ensures single-line text
                                            softWrap: false, // Prevents wrapping
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Auction Start
                                    Row(
                                      children: [
                                        Container(
                                          width: 120, // Fixed width for the label to align all colons
                                          child: Text(
                                            "Auction Start: ",
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 10, // Space between colon and value
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            jsonResult![index]['START_DATETIME'] ?? "Not Available",
                                            style: TextStyle(
                                              color: Colors.green[600],
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Ensures single-line text
                                            softWrap: false, // Prevents wrapping
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Auction End
                                    Row(
                                      children: [
                                        Container(
                                          width: 120, // Fixed width for the label to align all colons
                                          child: Text(
                                            "Auction End: ",
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 10, // Space between colon and value
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            jsonResult![index]['END_DATETIME'] ?? "Not Available",
                                            style: TextStyle(
                                              color: Colors.red[300],
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Ensures single-line text
                                            softWrap: false, // Prevents wrapping
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Colors.blue[200], // Divider color
                          thickness: 1,  // Divider thickness
                          indent: 0,  // Indentation from the left
                          endIndent: 0 // Indentation from the right
                      ),

                      // **Show Categories Button**
                      if (jsonResult![index]['CORRI_DETAILS'] != 'NA')
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _selectedIndex != index
                              ? Padding(
                            padding: EdgeInsets.only(top: 0.0), // Decrease space above the button
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = (_selectedIndex == index) ? null : index;
                                });
                              },
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                          )
                              : SizedBox(),
                        ),

                      // **Horizontal Scrollable Category List**
                      if (_selectedIndex == index)
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: _buildCategoryList(
                            jsonResult![index]['DESCRIPTION'].toString(),
                            jsonResult![index]['CATID'].toString(),
                          ),
                        ),
                    ],
                  ),



              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 5),
      itemCount: jsonResult?.length ?? 0,
    );
  }

  /// **Function to Display Category List in Horizontal Scroll**
  Widget _buildCategoryList(String description, String catid) {
    var categories = description.split('#');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
      child: Row(
        children: List.generate(categories.length, (index) {
          return GestureDetector(
            onTap: () {
              var route = MaterialPageRoute(
                builder: (BuildContext context) => schedule2(
                  value1: Users(
                    sid: catid,
                    category: categories[index],
                  ),
                ),
              );
              Navigator.of(context).push(route);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(color: Colors.blue[50],
                 //color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade800, width: 0.5),
              ),
              child: Text(
                categories[index].toString(),
                style: TextStyle(color: Colors.blue[800], fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ),
    );
  }
}

  /// **Function to Display Category List**
  Widget _buildCategoryList(String description, String catid) {
    var categories = description.split('#');
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.isNotEmpty ? categories.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) => schedule2(
                value1: Users(
                  sid: catid,
                  category: categories[index],
                ),
              ),
            );
            Navigator.of(context).push(route);
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              categories[index].toString(),
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 20),
    );
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

