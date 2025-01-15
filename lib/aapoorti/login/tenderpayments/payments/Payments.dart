import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/login/tenderpayments/payments/PaymentDtls.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Payments extends StatefulWidget {
  // get path => null;
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  String? worka;

  void fetchPost() async {
    String param1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String param2 = AapoortiUtilities.user!.MAP_ID +
        "," +
        AapoortiUtilities.user!.CUSTOM_WK_AREA;

    //JSON VALUES FOR POST PARAM
    Map<String, dynamic> urlinput = {"param1": "$param1", "param2": "$param2"};
    String urlInputString = json.encode(urlinput);

    //NAME FOR POST PARAM
    String paramName = 'PaymentList';

    //Form Body For URL
    String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

    var url = AapoortiConstants.webServiceUrl + 'Login/PaymentList';
    debugPrint("url = " + url);

    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formBody,
        encoding: Encoding.getByName("utf-8"));
    jsonResult = json.decode(response.body);
    debugPrint("form body = " + json.encode(formBody).toString());
    debugPrint("json result = " + jsonResult.toString());
    debugPrint("response code = " + response.statusCode.toString());
    if(jsonResult!.length == 0) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoResponse()));
    }

    setState(() {});
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // fetchPost();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('payment widget calling');
    return WillPopScope(
      onWillPop: () async {
        return true;
        // Navigator.of(context).pop();
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('My Payments', style: TextStyle(color: Colors.white)),
        ),
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
        //drawer :AapoortiUtilities.navigationdrawer(context),
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
                  InkWell(
                    child: Text(
                      "Work Area: ${workarea()}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                child: Expanded(
                    child: jsonResult == null
                        ? SpinKitFadingCircle(
                            color: Colors.teal,
                            size: 120.0,
                          )
                        : _myListView(context)))
          ],
        ),
      ),
    );
  }

  String? workarea() {
    if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'PT') {
      worka = "Goods and Services";
    } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'WT') {
      worka = "Works";
    } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'LT') {
      worka = "Earning/Leasing";
    }
    return worka;
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
                onTap: () async {
                  print("Condition check");
                  print(jsonResult![index]['AMOUNT'].toString().compareTo("0"));
                  bool check = await AapoortiUtilities.checkConnection();
                  if ((jsonResult![index]['AMOUNT'].toString().compareTo("0") ==
                          0) ||
                      (jsonResult![index]['AMOUNT']
                              .toString()
                              .compareTo("EXEMPTED") ==
                          0))
                    AapoortiUtilities.showInSnackBar(
                        context, "No further details available!!");
                  else if (check == true)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentDtls(
                                jsonResult![index]['TENDER_NUMBER'],
                                jsonResult![index]['RAILWAY_ZONE'] +
                                    "/" +
                                    jsonResult![index]['DEPARTMENT'],
                                jsonResult![index]['TENDER_OPENING_DATE'],
                                jsonResult![index]['IREPS_PMT_TYPE'],
                                jsonResult![index]['OID'].toString())));
                  else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoConnection()));
                },
                child: new Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    new Padding(padding: new EdgeInsets.only(top: 8)),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(3.0)),
                          Text(
                            (index + 1).toString() + ". ",
                            style: TextStyle(color: Colors.teal, fontSize: 16),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //new Padding(padding: new EdgeInsets.all(3.0)),
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        jsonResult![index]['RAILWAY_ZONE'] !=
                                                null
                                            ? jsonResult![index]
                                                    ['RAILWAY_ZONE'] +
                                                "/" +
                                                jsonResult![index]['DEPARTMENT']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    )
                                  ]),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),

                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          // height: 30,
                                          width: 125,
                                          child: Text(
                                            "Tender No.",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            // height: 30,
                                            child: Text(
                                              jsonResult![index]
                                                          ['TENDER_NUMBER'] !=
                                                      null
                                                  ? jsonResult![index]
                                                      ['TENDER_NUMBER']
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ]),
                                  SizedBox(height: 5),

                                  Row(children: <Widget>[
                                    Container(
                                      // height: 50,
                                      width: 125,
                                      child: Text(
                                        "Closing Date/Time",
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      // height: 30,
                                      child: Text(
                                        jsonResult![index]
                                                    ['TENDER_OPENING_DATE'] !=
                                                null
                                            ? jsonResult![index]
                                                ['TENDER_OPENING_DATE']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    )
                                  ]),
                                  SizedBox(height: 5),

                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          // height: 30,
                                          width: 125,
                                          child: Text(
                                            "Payment Type",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          // height: 30,

                                          child: Text(
                                            jsonResult![index]
                                                        ['IREPS_PMT_TYPE'] !=
                                                    null
                                                ? jsonResult![index]
                                                    ['IREPS_PMT_TYPE']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        )
                                      ]),
                                  SizedBox(height: 5),

                                  Row(children: <Widget>[
                                    Container(
                                      // height: 30,
                                      width: 125,
                                      child: Text(
                                        "Amount",
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      // height: 30,
                                      child: Text(
                                        jsonResult![index]['AMOUNT'] != null
                                            ? jsonResult![index]['AMOUNT']
                                            : "0",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    )),
                                  ]),
                                  SizedBox(height: 5),

                                  Row(children: <Widget>[
                                    Container(
                                      // height: 30,
                                      width: 125,
                                      child: Text(
                                        "Transaction ID",
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      // height: 30,
                                      child: Text(
                                        jsonResult![index]['IREPS_REF_ID'] !=
                                                null
                                            ? jsonResult![index]['IREPS_REF_ID']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    )
                                  ]),
                                  SizedBox(height: 5),

                                  Row(children: <Widget>[
                                    Container(
                                      // height: 35,
                                      width: 125,
                                      child: Text(
                                        "Trans. Date/Time",
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // height: 35,
                                      child: Text(
                                        jsonResult![index]['CREATION_TIME'] !=
                                                null
                                            ? jsonResult![index]['CREATION_TIME']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    )
                                  ]),
                                  SizedBox(height: 5),
                                ]),
                          ),
                        ])
                  ]),
                )),
          );
        },
        separatorBuilder: (context, index) {
          return Container();
        });
  }
}
