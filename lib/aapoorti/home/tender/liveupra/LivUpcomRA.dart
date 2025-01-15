import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LivUpcomRA extends StatefulWidget {
  @override
  _LivUpcomRAState createState() => _LivUpcomRAState();
}

class _LivUpcomRAState extends State<LivUpcomRA> {
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResultUp;
  List<dynamic>? jsonResultLiv;
  int? resultCount;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getliveUpcomingRA();
    });
  }

  void getliveUpcomingRA() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      getliveUpcomingRAData();
    }
    else{
      getliveUpcomingRAData();
    }
  }

  void getliveUpcomingRAData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P5/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      "input_type" : "LiveAndUpcoming",
      "input": "",
      "key_ver" : "V1"
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        setState(() {
          jsonResult = listJson;
        });
        debugPrint('Response body livera: ${response.body}');
      } else {
        // Error, print the error response
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  var _snackKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _snackKey,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: Text('Live & Upcoming(RA)', style: TextStyle(color: Colors.white))),
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
        body: Builder(
            builder: (context) => Material(
              child: jsonResult == null ? SpinKitFadingCircle(color: Colors.cyan, size: 120.0) : Column(children: <Widget>[
                // Container(
                //   height: 55,
                //   color: Colors.cyan[50],
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text("Data Last Updated on:", style: TextStyle(fontWeight: FontWeight.bold)),
                //             RichText(text: TextSpan(
                //               text: '07-01-2025 ',
                //               style: DefaultTextStyle.of(context).style,
                //               children: const <TextSpan>[
                //                 TextSpan(
                //                     text: '11:05', style: TextStyle(fontWeight: FontWeight.bold)),
                //               ],
                //             ))
                //           ],
                //         ),
                //         InkWell(
                //           onTap: (){},
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Icon(Icons.refresh, size: 25, color: Colors.black),
                //               Text("refresh", style: TextStyle(color: Colors.black))
                //             ],
                //           ),
                //         )
                //
                //       ],
                //     ),
                //   ),
                // ),
                Container(child: Expanded(child: _myListView(context)))
              ]),
            ),
          )
          // body: Center(child: jsonResult == null ? SpinKitFadingCircle(color: Colors.cyan, size: 130.0) : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Container(
            child: Card(
              elevation: 4,
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              (index + 1).toString() + ". ",
                              style:
                                  TextStyle(color: Colors.indigo, fontSize: 16),
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
                                    jsonResult![index]['key1'] != null ? jsonResult![index]['key1'] : "",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ]),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Tender No.",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    //height: 30,
                                    child: Text(
                                      jsonResult![index]['key2'] != null
                                          ? jsonResult![index]['key2']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
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
                                          "Tender Title",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          //height: 30,
                                          child: Text(
                                            jsonResult![index]['key3'] !=
                                                    null
                                                ? jsonResult![index]
                                                    ['key3']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Work Area",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['key4'] != null
                                          ? jsonResult![index]['key4']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Start Date",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['key5'] != null
                                          ? jsonResult![index]['key5']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "End Date",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['key6'] != null ? jsonResult![index]['key6'] : "",
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Status",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['key10'] != null
                                          ? jsonResult![index]['key10']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Links",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                if (jsonResult![index]
                                                        ['key7'] !=
                                                    'NA') {
                                                  var fileUrl =
                                                      jsonResult![index]
                                                              ['key7']
                                                          .toString();
                                                  var fileName =
                                                      fileUrl.substring(fileUrl
                                                          .lastIndexOf("/"));
                                                  AapoortiUtilities.ackAlert(
                                                      context,
                                                      fileUrl,
                                                      fileName);
                                                } else {
                                                  AapoortiUtilities.showInSnackBar(
                                                      context,
                                                      "No PDF attached with this Tender!!");
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/pdf_home.png'),
                                                      height: 30,
                                                      width: 20),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text('NIT',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5)),
                                              ])),
                                          GestureDetector(
                                              onTap: () {
                                                if (jsonResult![index]
                                                        ['key8'] !=
                                                    'NA') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) => Material(
                                                          type: MaterialType
                                                              .transparency,
                                                          child: Center(
                                                              child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              55),
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              50),
                                                                  color: Color(
                                                                      0xAB000000),

                                                                  child: Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 20),
                                                                            child:
                                                                                AapoortiUtilities.attachDocsListView(context, jsonResult![index]['key8'].toString()),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                              },
                                                                              child: Image(
                                                                                image: AssetImage('images/close_overlay.png'),
                                                                                height: 50,
                                                                              )),
                                                                        )
                                                                      ])))));
                                                } else {
                                                  AapoortiUtilities.showInSnackBar(
                                                      context,
                                                      "No Documents attached with this Tender!!");
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/attach_icon.png'),
                                                      color: jsonResult![index][
                                                                  'key8'] !=
                                                              'NA'
                                                          ? Colors.green
                                                          : Colors.brown,
                                                      height: 30,
                                                      width: 20),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text('  DOCS',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5)),
                                              ])),
                                          GestureDetector(
                                              onTap: () {
                                                if (jsonResult![index]
                                                        ['key9'] !=
                                                    'NA') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) => Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Center(
                                                                child: Container(
                                                                    margin: EdgeInsets.only(top: 55),
                                                                    padding: EdgeInsets.only(bottom: 50),
                                                                    color: Color(0xAB000000),

                                                                    // Aligns the container to center
                                                                    child: Column(children: <Widget>[
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: 20),
                                                                          child: AapoortiUtilities.corrigendumListView(
                                                                              context,
                                                                              jsonResult![index]['key9'].toString()),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                            },
                                                                            child: Image(
                                                                              image: AssetImage('images/close_overlay.png'),
                                                                              height: 50,
                                                                            )),
                                                                      )
                                                                    ]))),
                                                          ));
                                                } else {
                                                  AapoortiUtilities.showInSnackBar(
                                                      context,
                                                      "No corrigendum issued with this Tender!!");
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Text(
                                                    "C",
                                                    style: TextStyle(
                                                        color: jsonResult![index]
                                                                    [
                                                                    'key9'] !=
                                                                'NA'
                                                            ? Colors.green
                                                            : Colors.brown,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text(
                                                      '  CORRIGENDA',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5)),
                                              ])),
                                          Padding(
                                            padding: EdgeInsets.only(right: 0),
                                          ),
                                        ]),
                                  ),
                                ]),
                              ]),
                        ),
                      ])
                ],
              ),
            ),
          ));
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 10,
          );
        });
  }
}
