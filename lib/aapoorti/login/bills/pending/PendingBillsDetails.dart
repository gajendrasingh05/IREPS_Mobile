import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/src/painting/text_style.dart' as textSt;

class PendingBillDetails extends StatefulWidget {
  final String? pokeyN, desc;
  PendingBillDetails({this.pokeyN, this.desc});
  @override
  _PendingBillDetailsState createState() =>
      _PendingBillDetailsState(this.pokeyN!, this.desc!);
}

class _PendingBillDetailsState extends State<PendingBillDetails> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? pokeyN, desc;
  _PendingBillDetailsState(String pokey, String desc) {
    this.pokeyN = pokey;
    this.desc = desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Text('My Pending Bills',
            style: textSt.TextStyle(color: Colors.white)),
      ),
      drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
      body: jsonResult == null
          ? SpinKitFadingCircle(
              color: Colors.cyan,
              size: 120.0,
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _expandList(context);
              },
              itemCount: 1,
            ),
    );
  }

  void initState() {
    super.initState();
    callWebService();
  }

  bool expandFlag = false;
  List<dynamic>? jsonResult;
  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID +
        "," +
        AapoortiUtilities.user!.CUSTOM_WK_AREA +
        "," +
        pokeyN.toString();
    print(inputParam1);
    print(inputParam2);
    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Login/PendingBillDtls', 'PendingBillDtls', inputParam1, inputParam2);
    if (jsonResult!.length == 0) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    print(jsonResult);
    setState(() {});
  }

  @override
  Widget _expandList(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.orange[50],
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "   Firm and Tender Details",
                  style: textSt.TextStyle(fontSize: 16, color: Colors.teal),
                ),
                IconButton(
                    icon: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: new Center(
                        child: new Icon(
                          expandFlag
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    })
              ],
            ),
          ),
          new ExpandableContainer(
            expanded: expandFlag,
            child: new Container(
                decoration: new BoxDecoration(
                    border: new Border.all(width: 1.0, color: Colors.teal),
                    color: Colors.white),
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Firm Name",
                                textAlign: TextAlign.left,
                                style: new textSt.TextStyle(color: Colors.teal),
                              ),
                              Padding(padding: EdgeInsets.only(left: 70)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["BIDDER_ACCT_NAME"],
                                  Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "User",
                                style: textSt.TextStyle(color: Colors.teal),
                              ),
                              Padding(padding: EdgeInsets.only(left: 110)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["NAME"], Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Address           ",
                                style: new textSt.TextStyle(color: Colors.teal),
                              ),
                              Padding(padding: EdgeInsets.only(left: 53)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["ADDR"], Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AapoortiUtilities.customTextView(
                                  "Tender No", Colors.teal),
                              Padding(padding: EdgeInsets.only(left: 75)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["TEND_NO"], Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AapoortiUtilities.customTextView(
                                  "Closing Date", Colors.teal),
                              Padding(padding: EdgeInsets.only(left: 60)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["TENDER_OPDATE"], Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AapoortiUtilities.customTextView(
                                  "Contract No", Colors.teal),
                              Padding(padding: EdgeInsets.only(left: 65)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["CONTRACT_NO"], Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AapoortiUtilities.customTextView(
                                  "Contract Date", Colors.teal),
                              Padding(padding: EdgeInsets.only(left: 55)),
                              AapoortiUtilities.customTextView(
                                  jsonResult![0]["CONTRACT_DATE"], Colors.black),
                            ]),
                      ),
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AapoortiUtilities.customTextView(
                                  "Name Of Work", Colors.teal),
                              Padding(padding: EdgeInsets.only(left: 50)),
                              Expanded(
                                child: AapoortiUtilities.customTextView(
                                    jsonResult![0]["WRK_NM"], Colors.black),
                              ),
                            ]),
                      ),
                    ])
                /*  leading: new Icon(
                Icons.local_pizza,
            color: Colors.white,
          ),*/
                ),
          ),
          _myListView(context)
        ],
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return Container(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Text("Bill Details",
                                        textAlign: TextAlign.center,
                                        style: textSt.TextStyle(
                                          color: Colors.teal,
                                          fontSize: 17,
                                        ),
                                        overflow: TextOverflow.ellipsis)),
                              ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Bill/GST Invoice No", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["INV_BILL_NO"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Bill/GST Invoice Date", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["INV_BILL_DATE"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Amount Claimed", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["BILL_AMT"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Amount Paid", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["AMT_PAID"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "GSTIN No", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["BIDDER_GSTN"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 40,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Bill Submitted to\nExec Dept On",
                                  Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["BILL_SUBMIT_DATE"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Remarks", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["CONTRACTOR_REMARK"].toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 90,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Certificate by\nContractor", Colors.teal),
                            ),
                            Expanded(
                              child: Text(
                                jsonResult![0]["CERTI_DESC"].toString(),
                                textAlign: TextAlign.justify,
                                style: textSt.TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              height: 30,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Bill Submitted To", Colors.teal),
                            ),
                            Container(
                              height: 30,
                              child: AapoortiUtilities.customTextView(
                                  jsonResult![0]["BILL_PREP_DESIG"].toString() +
                                      "/" +
                                      jsonResult![0]["DEPARTMENT_NAME"]
                                          .toString(),
                                  Colors.black),
                            )
                          ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(children: <Widget>[
                            Container(
                              // height: 50,
                              width: 150,
                              child: AapoortiUtilities.customTextView(
                                  "Current Status", Colors.teal),
                            ),
                            Expanded(
                              child: Container(
                                  // height: 50,
                                  child: Text(
                                desc!,
                                textAlign: TextAlign.justify,
                                style: textSt.TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                // AapoortiUtilities.customTextView(desc, Colors.black),
                              )),
                            )
                          ]),
                        ]),
                  ),
                ])));
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(
            border: new Border.all(width: 0.1, color: Colors.teal)),
      ),
    );
  }
}
