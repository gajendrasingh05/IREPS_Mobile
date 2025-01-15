import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PendingPayment extends StatefulWidget {
  get path => null;
  @override
  _PendingPaymentState createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  List<dynamic>?jsonResult;
  Color? repback, reptext, repbor, nrepback, nreptext, nrepbor;
  bool replied = false, pending = true;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;

  void initState() {
    super.initState();
    repback = Colors.white;
    repbor = Colors.blue[700];
    reptext = Colors.blue[700];
    pending = true;
    nrepback = Colors.white;
    nrepbor = Colors.black;
    nreptext = Colors.black;
    // setState(() {
    //   repback=Colors.white;
    //   repbor=Colors.blue[700];
    //   reptext=Colors.blue[700];

    //   nrepback=Colors.black;
    //   nrepbor=Colors.white;
    //   nreptext=Colors.white;
    // });
    Future.delayed(Duration.zero, () {
      fetchPost();
    });
  }

  void fetchPost() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    var v =
        "https://ireps.gov.in/Aapoorti/ServiceCallHDPostLogin/OnlinePayment?input=GET_ONLINE_PAYMENT_STATUS";
    final response = await http.post(Uri.parse(v));
    // jsonResult = json.decode(response.body);
    // print("jsonresult");
    print(jsonResult);
    setState(() {
      repback = Colors.white;
      repbor = Colors.blue[700];
      reptext = Colors.blue[700];

      nrepback = Colors.black;
      nrepbor = Colors.white;
      nreptext = Colors.white;
      jsonResult = json.decode(response.body);
    });
  }

  /* void callWebService() async {
    String inputParam1=AapoortiUtilities.user.C_TOKEN + "," + AapoortiUtilities.user.S_TOKEN + ",Flutter,0,0";
    String inputParam2="GET_ONLINE_PAYMENT_STATUS";

    jsonResult=await AapoortiUtilities.fetchPostPostLogin(
        'HDPostLogin/OnlinePayment', 'input', inputParam1,inputParam2);

    print(jsonResult.length);
    print(jsonResult.toString());
    if(jsonResult.length==0)
    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    else if(jsonResult[0]['ErrorCode']==3)
    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
    }
    setState(() {});
  }*/
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldkey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
            title: Text('Online Payment Status',
                style: TextStyle(color: Colors.white)),
          ),
          drawer: AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
          body: Column(
            children: <Widget>[
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: nrepback,
                            border: Border.all(
                              color: nrepbor!,
                            ),
                            borderRadius: BorderRadius.circular(2.0)),
                        width: 150,
                        height: 40,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              repback = Colors.white;
                              repbor = Colors.blue[700];
                              reptext = Colors.blue[700];

                              nrepback = Colors.black;
                              nrepbor = Colors.white;
                              nreptext = Colors.white;
                              pending = true;
                              replied = false;
                              //  callWebService();
                            });
                          },
                          child: Text(
                            'Tender',
                            style: TextStyle(
                                fontSize: 17,
                                color: nreptext,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: repback,
                            border: Border.all(color: repbor!),
                            borderRadius: BorderRadius.circular(2.0)),
                        width: 150,
                        height: 40,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              repback = Colors.blue[700];
                              repbor = Colors.white;
                              reptext = Colors.white;

                              nrepback = Colors.white;
                              nrepbor = Colors.black;
                              nreptext = Colors.black;
                              replied = true;
                              pending = false;
                              //  callWebService();
                            });
                            //callWebService();
                          },
                          child: Text(
                            'Auction',
                            style: TextStyle(
                                fontSize: 17,
                                color: reptext,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
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
                    : pending == true
                        ? jsonResult![0]['ErrorCode'] != 3
                            ? _myListView(context)
                            : Center(
                                child: Text(
                                'No pending payment!!',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ))
                        : _myListView1(context),
              )),
            ],
          )),
    );
  }

  Widget _myListView(BuildContext context) {
    print("jsonresult");

    return ListView.separated(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        print("first");
        String aString = jsonResult![index]['LAST_NB_SUCCESS'];
        aString.trim();
        var nbsuccess = aString.split("~");

        String bString = jsonResult![index]['LAST_PG_SUCCESS'];
        bString.trim();
        var pgsuccess = bString.split("~");

        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "    Total Pending Transactions    :  ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            jsonResult![index]['TOTAL_PENDING_COUNT'] != null
                                ? jsonResult![index]['TOTAL_PENDING_COUNT']
                                    .toString()
                                : "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ))
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "    Double Verification Pending    :  ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            jsonResult![index]['DV_PENDING_COUNT'] != null
                                ? jsonResult![index]['DV_PENDING_COUNT']
                                    .toString()
                                : "           ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ))
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "    Last Success Transaction - SBI NB ",
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),

                    new Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    IREPS Ref. ID : ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                nbsuccess[0],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Amount :          ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                nbsuccess[1],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Date-Time :     ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                nbsuccess[2],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "    Last Success Transaction - SBI ePay ",
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),

                    new Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    IREPS Ref. ID : ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                pgsuccess[0],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Amount :          ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                pgsuccess[1],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Date-Time :     ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                pgsuccess[2],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 270,
                          child: Text(
                            "    Total NB Success Transaction" +
                                "\n" +
                                "    in Last Hour                                 :  ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            jsonResult![index]['TOTAL_NB_SUCCESS'] != null
                                ? jsonResult![index]['TOTAL_NB_SUCCESS']
                                    .toString()
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ))
                      ],
                    ),
                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 270,
                          child: Text(
                            "    Total PG Success Transaction" +
                                "\n" +
                                "    in Last Hour                               :  ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            jsonResult![index]['TOTAL_PG_SUCCESS'] != null
                                ? jsonResult![index]['TOTAL_PG_SUCCESS']
                                    .toString()
                                : "\t  " + "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ))
                      ],
                    ),

                    //  new Divider(color: Colors.blueAccent
                    //  ,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _myListView1(BuildContext context) {
    print("jsonresult");

    return ListView.separated(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        String cString = jsonResult![index]['LAST_LIEN_SYNCHRONIZED'];
        cString.trim();
        var llsync = cString.split("~");

        String dString = jsonResult![index]['LAST_LIEN_TRANSACTION'];
        dString.trim();
        var lltrans = dString.split("~");

        String eString = jsonResult![index]['LAST_LIEN_FUND_TRANSFER_SUCCESS'];
        eString.trim();
        var lltranssuccess = eString.split("~");

        print("avni");
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "    Last Lien Synchronized ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Bidder ID :        ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                llsync[0],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 50,
                              child: Text(
                                "     Bidder Name : ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 230,
                              //MediaQuery.of(context).size.width,
                              child: Text(
                                llsync[1],
                                maxLines: 3,
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Date-Time :     ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                llsync[2],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),

                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "    Last Lien Transactions ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),

                    new Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Bidder ID :        ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                lltrans[0],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 50,
                              child: Text(
                                "    Bidder Name : ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 230,
                              //MediaQuery.of(context).size.width,
                              child: Text(
                                lltrans[1],
                                maxLines: 3,
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Date-Time :     ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                lltrans[2],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "    Last Lien Fund Transfer        ",
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),

                    new Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    IREPS Ref ID :           ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                lltranssuccess[0],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Bidder Account ID : ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                lltranssuccess[1],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Date-Time :               ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                lltranssuccess[2],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "    Amount :                    ",
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                lltranssuccess[3],
                                //  jsonResult[index]['LAST_LIEN_TRANSACTION'] != null
                                //      ? jsonResult[index]['LAST_LIEN_TRANSACTION'].toString()
                                //     : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    new Divider(
                      color: Colors.blueAccent,
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "    Pending Lien Fund Transfer        :  ",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            jsonResult![index]
                                        ['PENDING_LIEN_FUND_TRANSFER_60DAYS'] !=
                                    null
                                ? jsonResult![index]
                                        ['PENDING_LIEN_FUND_TRANSFER_60DAYS']
                                    .toString()
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ))
                      ],
                    ),
                    //  new Divider(color: Colors.blueAccent
                    //  ,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
