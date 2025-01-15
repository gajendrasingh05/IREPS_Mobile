import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter/material.dart';
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
    if(AapoortiConstants.count == '0' || DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
      fetchSavedBF();
  }

  _progressShow() {
    pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
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

    if(AapoortiConstants.jsonResult2 != null && DateTime.now().toString().compareTo(AapoortiConstants.date2) < 0) {
      jsonResult = AapoortiConstants.jsonResult2;
    }
    else if(DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0) {
      AapoortiConstants.count = '0';
      await dbHelper.deleteBanned(1);
      final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
      jsonResult = json.decode(response.body);
    } else {
      await dbHelper.deleteBanned(1);
      final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
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
            backgroundColor: Colors.cyan[400],
            actions: [
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
            title: Text('Banned/Suspended Firms', maxLines: 1, style: TextStyle(color: Colors.white))
        ),
        backgroundColor: Colors.grey[200],
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
                            color: Colors.teal[900],
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
                        ? SpinKitFadingCircle(
                            color: Colors.cyan,
                            size: 130.0,
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
        return Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Text(
              "\n" + (index + 1).toString() + ".       ",
              style: TextStyle(color: Colors.indigo, fontSize: 16),
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
                            color: Colors.indigo,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
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
                          "Letter No",
                          style: TextStyle(
                            color: Colors.indigo,
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
                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Date",
                          style: TextStyle(
                            color: Colors.indigo,
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
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Address",
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
                        //height: 30,
                        child: Text(
                          jsonResult![index]['VADDRESS'] != null
                              ? jsonResult![index]['VADDRESS']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ))
                    ]),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Type",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['SUBJ'] != null
                              ? (jsonResult![index]['SUBJ'] == 'Banning'
                                  ? "Banned"
                                  : jsonResult![index]['SUBJ'])
                              : "---",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Banned Upto",
                          style: TextStyle(
                            color: Colors.indigo,
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
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Remarks",
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
                        child: Text(
                          jsonResult![index]['REMARKS'] != null
                              ? jsonResult![index]['REMARKS']
                              : "---",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ))
                    ]),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "View Letter",
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (jsonResult![index]['DOC_PATH'].toString() !=
                                  'NA')
                                GestureDetector(
                                  onTap: () {
                                    //if(jsonResult[index]['DOC_PATH']!='NA'){
                                    var fileUrl =
                                        AapoortiConstants.contextPath +
                                            jsonResult![index]['DOC_PATH']
                                                .toString();
                                    var fileName = fileUrl
                                        .substring(fileUrl.lastIndexOf("/"));
                                    AapoortiUtilities.ackAlert(
                                        context, fileUrl, fileName);
                                  },
                                  child: Container(
                                    height: 30,
                                    child: Image(
                                        image:
                                            AssetImage('images/pdf_home.png'),
                                        height: 30,
                                        width: 20),
                                  ),
                                )
                              else
                                Container(
                                  height: 30,
                                  child: Text("---"),
                                ),
                            ]),
                      ),
                    ])
                  ]),
            ),
          ]),
        );
      },
    );
  }
}
