import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/view/components/text/read_more_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class BannedFirms extends StatefulWidget {
  @override
  _BannedFirmsState createState() => _BannedFirmsState();
}

class _BannedFirmsState extends State<BannedFirms> {
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;
  ProgressDialog? pr;

  void initState() {
    super.initState();
    fetchPost();
    if (AapoortiConstants.count == '0' ||
        DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
      fetchSavedBF();
  }

  _progressShow() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  ProgressStop(context) {
    ProgressDialog pr = ProgressDialog(context);

    Future.delayed(Duration(milliseconds: 100), () {
      pr.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  void onTap() {
    fetchPostTap();
    if (AapoortiConstants.count == '0' ||
        DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
      fetchSavedBF();
  }

  final dbHelper = DatabaseHelper.instance;
  void fetchSavedBF() async {
    AapoortiConstants.date2 = DateTime.now().add(Duration(days: 1)).toString();
    AapoortiConstants.count = '1';
    var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
    final response = await http.post(Uri.parse(v));
    jsonResult1 = json.decode(response.body);
    AapoortiConstants.jsonResult2 = jsonResult1!;
    await dbHelper.deleteBanned(1);
    for (int index = 0; index < jsonResult1!.length; index++) {
      Map<String, dynamic> row = {
        DatabaseHelper.Tblb_Col1_Title: jsonResult1![index]['VNAME'],
        DatabaseHelper.Tblb_Col2_Letter: jsonResult1![index]['LET_NO'],
        DatabaseHelper.Tblb_Col3_Date: jsonResult1![index]['LET_DT_S'],
        DatabaseHelper.Tblb_Col4_Address: jsonResult1![index]['VADDRESS'],
        DatabaseHelper.Tblb_Col5_Type: jsonResult1![index]['SUBJ'],
        DatabaseHelper.Tblb_Col6_Banned: jsonResult1![index]['BAN_UPTO'],
        DatabaseHelper.Tblb_Col7_Remarks: jsonResult1![index]['REMARKS'],
        DatabaseHelper.Tblb_Col8_Id: jsonResult1![index]['DOC_ID'],
        DatabaseHelper.Tblb_Col9_view: jsonResult1![index]['DOC_PATH'],
        DatabaseHelper.Tblb_Col10_Date: AapoortiConstants.date2.toString(),
        DatabaseHelper.Tblb_Col11_Count: AapoortiConstants.count,
      };
      final id = dbHelper.insertBanned(row);
    }
  }

  void fetchPost() async {
    var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";

    if (AapoortiConstants.jsonResult2 != null &&
        DateTime.now().toString().compareTo(AapoortiConstants.date2) < 0) {
      jsonResult = AapoortiConstants.jsonResult2;
    } else if (DateTime.now().toString().compareTo(AapoortiConstants.date2) >
        0) {
      AapoortiConstants.count = '0';
      await dbHelper.deleteBanned(1);
      final response =
          await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
      jsonResult = json.decode(response.body);
    } else {
      await dbHelper.deleteBanned(1);
      final response =
          await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
      jsonResult = json.decode(response.body);
    }
    setState(() {});
  }

  void fetchPostTap() async {
    var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";

    await dbHelper.deleteBanned(1);
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    _progressHide();
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/common_screen", (route) => false);
                  //Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
            title: Text('Banned/Suspended Firms',
                maxLines: 1, style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.white12,
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      child: RichText(
                        text: TextSpan(
                          text: 'To view latest data, click here',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue[800],
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _progressShow();
                        await dbHelper.deleteBanned(1);
                        AapoortiConstants.count = '0';
                        AapoortiConstants.jsonResult2 = null;
                        onTap();
                      }),
                ],
              ),
            ),
            Container(
                child: Expanded(
                    child: jsonResult == null
                        ? SpinKitWave(
                            color: Colors.lightBlue[800],
                            size: 30.0,
                          )
                        : _BannedFirmsListView(context)))
          ],
        ),
      ),
    );
  }
  Widget _BannedFirmsListView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 10, vertical: 3), // Reduced vertical spacing
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 1, // Spread the shadow
                  blurRadius: 1, // Blur radius
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: Card(
                elevation: 3,
                color: index % 2 == 0
                    ? Color(0xFFF0F8FF)
                    : Colors.white, // Alternating colors
                // surfaceTintColor: index.isEven ? Colors.white : Colors.grey[200],// Adds shadow for a shaded effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  side: BorderSide(
                      color: Colors.grey.shade400, width: 1), // Shaded border
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 1.0), // Add left and top padding
                        child: Text(
                          "\n" + (index + 1).toString() + ".       ",
                          style: TextStyle(
                              color: Colors.lightBlue[800], fontSize: 15),
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                jsonResult![index]['VNAME'] != null
                                    ? ("\n" + jsonResult![index]['VNAME'])
                                    : "",
                                style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ))
                            ]),

                            Row(
                              children: <Widget>[
                                if (jsonResult![index]['SUBJ'] !=
                                    null) // Show only if SUBJ is not null
                                  Text(
                                    " ( " +
                                        (jsonResult![index]['SUBJ'] == 'Banning'
                                            ? "Banned"
                                            : jsonResult![index]['SUBJ']) +
                                        " ) ",
                                    style: TextStyle(
                                      color: Colors.red, // Blue color
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 76,
                                child: Text(
                                  "Letter No",
                                  style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Text(
                                  jsonResult![index]['LET_NO'] != null
                                      ? jsonResult![index]['LET_NO']
                                      : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ]),
                            Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 76,
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                        color: Colors.lightBlue[800],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      child: Text(
                                        jsonResult![index]['LET_DT_S'] != null
                                            ? jsonResult![index]['LET_DT_S']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Address label
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          3), // Space between label and value
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                      color: Colors.lightBlue[800],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // Address value
                                ReadMoreText(
                                  jsonResult![index]['VADDRESS'] != null
                                      ? jsonResult![index]['VADDRESS']
                                      : "",
                                  trimLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  colorClickableText: Colors.grey,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '..More',
                                  trimExpandedText: '..Less',
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 4.0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Title "Remarks"
                                Container(
                                  height: 20,
                                  child: Text(
                                    "Remarks",
                                    style: TextStyle(
                                      color: Colors.lightBlue[800],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // Value of Remarks
                                SizedBox(
                                    height: 0), // Space between title and value
                                ReadMoreText(
                                  jsonResult![index]['REMARKS'] != null
                                      ? jsonResult![index]['REMARKS']
                                      : "---",
                                  trimLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  colorClickableText: Colors.grey,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '..More',
                                  trimExpandedText: '..Less',
                                ),
                              ],
                            ),
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 100,
                                child: Text(
                                  "Banned Upto",
                                  style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Text(
                                  jsonResult![index]['BAN_UPTO'] != null
                                      ? jsonResult![index]['BAN_UPTO']
                                      : "---",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              )
                            ]),

                            Row(
                              children: [
                              Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        if (jsonResult![index]['DOC_PATH'].toString() != 'NA')
                                          SizedBox.shrink()
                                        else
                                          Container(
                                            height: 15,
                                          ),
                                          SizedBox(height: 3), // Space between the URL and the text
                                          GestureDetector(
                                            onTap: () {
                                              if (jsonResult![index]['DOC_PATH'].toString() != 'NA') {
                                              var fileUrl = AapoortiConstants.contextPath + jsonResult![index]['DOC_PATH'].toString();
                                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Choose an option for file"),
                                                    content: Text(
                                                      "\"$fileName\"",
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("Download"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        var fileNme = jsonResult![index]['DOC_PATH'].toString().substring(jsonResult![index]['DOC_PATH'].toString().lastIndexOf("/"));
                                                        AapoortiUtilities.openPdf(context, jsonResult![index]['DOC_PATH'].toString(), fileNme);
                                                      },
                                                      child: Text("Open"),
                                                    ),
                                                  ],
                                                 );
                                                },
                                              );
                                            }
                                              else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("File not available as it was not uploaded by the Railway Department."),
                                                    backgroundColor: Colors.red[200],
                                                  ),
                                                );
                                               }
                                               },
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 10), // Space between text and card boundary
                                                 child: Text(
                                                    "View Letter",
                                                    style: TextStyle(
                                                      color: jsonResult![index]['DOC_PATH'].toString() != 'NA' ? Colors.green : Colors.red,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                              ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            )
                          ]))
                    ])));
      },
    );
  }
}
