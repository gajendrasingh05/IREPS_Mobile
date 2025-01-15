import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/udm/widgets/delete_dialog.dart';
import '../auctionReports/SoldLots/SoldLots.dart';
import '../auctionReports/catalogRpt/CatalogueSum.dart';
import '../auctionReports/consolidatedRpt/Consolidated.dart';
import '../auctionReports/invoice/Invoice.dart';
import '../bills/closed/ClosedBills.dart';
import '../helpdesk/MobileAppQuery/MobileAppQuery.dart';
import '../helpdesk/OnlinePaymentStatus/PendingPayment.dart';
import '../helpdesk/pendingQuery/PendingQuery.dart';
import '../loginReports/StockPosition/stock_posiion.dart';
import '../tenderpayments/closed/ClosedTender.dart';
import '../bills/pending/PendingBills.dart';
import '../contracts/PurchaseOrders.dart';
import '../tenderpayments/reverse/ReverseAuction.dart';


class UserHome extends StatefulWidget {
  String? userType, email, username, lastlogin, workarea;

  UserHome(this.userType, this.email);

  @override
  _UserHomeState createState() => _UserHomeState(userType!, email!);
}

class _UserHomeState extends State<UserHome> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? usertype = '', email = '', username = '', lastlogin = '', workarea = '';
  List<dynamic>? jsonResult;
  String? workareatype = '';
  String? moduleaccess = '';
  int? _buttonFilter = 0;
  int? _filter = 0;
  int? _user;
  Key? key;
  FocusNode? _dropDownFocus;
  final GlobalKey<OverlayState> _formKey = GlobalKey<OverlayState>();
  var users = <String>[
    'Goods & Services',
    'Works',
    'Earning& Leasing',
  ];
  var logOutSucc;
  _UserHomeState(String usertype, String email) {
    if (AapoortiUtilities.user != null) {
      this.usertype = AapoortiUtilities.user!.USER_TYPE.toString();
      this.email = AapoortiUtilities.user!.EMAIL_ID;

      this.username = AapoortiUtilities.user!.USER_NAME;
      if (usertype == "0")
        workarea = "HelpDesk";
      else if (usertype == "8" || usertype == "9")
        workarea = "Auction User";
      else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "PT") {
        workarea = "Goods and Services";
      } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "WT") {
        workarea = "Works";
      } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "LT") {
        workarea = "Earning/Leasing";
      }
      lastlogin = AapoortiUtilities.user!.LAST_LOG_TIME;
    }
  }

  @override
  void initState() {
    super.initState();
    var s = DateTime.now().toString();
    _dropDownFocus = FocusNode();


    if(AapoortiUtilities.user != null) {
      this.usertype = AapoortiUtilities.user!.USER_TYPE.toString();
      this.email = AapoortiUtilities.user!.EMAIL_ID;

      this.username = AapoortiUtilities.user!.USER_NAME;
      if (usertype == "0")
        workarea = "HelpDesk";
      else if (usertype == "8" || usertype == "9")
        workarea = "Auction User";
      else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "PT") {
        workarea = "Goods and Services";
      } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "WT") {
        workarea = "Works";
      } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "LT") {
        workarea = "Earning/Leasing";
      }
      lastlogin = AapoortiUtilities.user!.LAST_LOG_TIME;
    }
    AapoortiUtilities.loginflag = true;
    moduleaccess = AapoortiUtilities.user!.MODULE_ACCESS.toString();
    saveUserLoginDtls(email);
    Future.delayed(Duration.zero, () {
        if(((usertype == "4" && moduleaccess == "NA") || moduleaccess!.contains("4")) && AapoortiUtilities.loggedin == false){
           //debugPrint("user type is1 " + usertype!);
           showAlert();
        }
        else if(((usertype == "4" && moduleaccess == "NA" && AapoortiUtilities.user!.DEFAULT_WK_AREA == "NA") || (moduleaccess!.contains("4") && AapoortiUtilities.user!.DEFAULT_WK_AREA == "NA")) && AapoortiUtilities.loggedin == false){
          //debugPrint("user type is2 " + usertype!);
          showDialogBox(context);
        }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dropDownFocus!.dispose();
    super.dispose();
  }

  void _csfilter(int value) {
    setState(() {
      _buttonFilter = value;
      switch (_buttonFilter) {
        case 1:
          _filter = 1;
          break;
        case 2:
          _filter = 2;
          break;
        case 3:
          _filter = 3;
          break;
      }
    });
  }

  void showDialogBox(BuildContext context1) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        barrierDismissible: false,
        context: context1,
        builder: (context) {
          String contentText = "Content of Dialog";
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: new Container(
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Select the work area',
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                        Padding(padding: new EdgeInsets.only(top: 20)),
                        MaterialButton(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.work,
                                    color: (_filter == 1)
                                        ? Colors.green
                                        : Colors.black), onPressed: () {  },
                              ),
                              Text(
                                'Goods & Services',
                                style: TextStyle(
                                    color: (_filter == 1)
                                        ? Colors.green
                                        : Colors.black),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              _csfilter(1);
                              _user = users.indexOf('Goods & Services');
                              workarea = 'Goods & Services';
                              workareatype = "PT";
                              AapoortiUtilities.user!.CUSTOM_WK_AREA = "PT";
                              AapoortiUtilities.loggedin = true;
                              Navigator.pop(context);
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        MaterialButton(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.work,
                                    color: (_filter == 2)
                                        ? Colors.green
                                        : Colors.black), onPressed: () {  },
                              ),
                              Text(
                                'Works',
                                style: TextStyle(
                                    color: (_filter == 2)
                                        ? Colors.green
                                        : Colors.black),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              _csfilter(2);
                              _user = users.indexOf('Works');
                              workarea = 'Works';
                              workareatype = "WT";
                              AapoortiUtilities.user!.CUSTOM_WK_AREA = "WT";
                              AapoortiUtilities.loggedin = true;
                              Navigator.pop(context);
//                                if((usertype=="4"&&moduleaccess=="NA")||moduleaccess.contains("4"))
//                                  showAlert(context);
                            });
                          },
                        ),
                        Padding(padding: new EdgeInsets.only(top: 15)),
                        MaterialButton(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.work,
                                    color: (_filter == 3)
                                        ? Colors.green
                                        : Colors.black), onPressed: () {  },
                              ),
                              Text(
                                'Earning& Leasing',
                                style: TextStyle(
                                    color: (_filter == 3)
                                        ? Colors.green
                                        : Colors.black),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              _csfilter(3);
                              _user = users.indexOf('Earning& Leasing');
                              workarea = 'Earning& Leasing';
                              workareatype = "LT";
                              AapoortiUtilities.user!.CUSTOM_WK_AREA = "LT";
                              AapoortiUtilities.loggedin = true;
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    )),
              );
            },
          );
        },
      );
    });
  }

  void showAlert(){
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Note',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      Padding(padding: new EdgeInsets.only(top: 20)),
                      Text(
                        '> Please note that you cannot submit bids through IREPS App',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Padding(padding: new EdgeInsets.only(top: 5)),
                      Text(
                        '> For Bidding and other features please visit www.ireps.gov.in',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  )),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Okay",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                    if(((usertype == "4" && moduleaccess == "NA" &&
                        AapoortiUtilities.user!.DEFAULT_WK_AREA == "NA") ||
                        (moduleaccess!.contains("4") &&
                            AapoortiUtilities.user!.DEFAULT_WK_AREA ==
                                "NA")) &&
                        AapoortiUtilities.loggedin == false)
                      showDialogBox(context);
                    else
                      AapoortiUtilities.loggedin = true;
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //_onButtonPressed(context);
          WarningAlertDialog().logOut(context, () {AapoortiUtilities.callWebServiceLogout1(context);});
          return Future.value(false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.teal,
              title: Text(
                'IREPS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey, context),
            body: ListView(children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Last Successful Login',
                          style: TextStyle(color: Colors.teal, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          lastlogin!,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Work Area',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                            textAlign: TextAlign.right,
                          ),
                          if((usertype == "4" && moduleaccess == "NA") || moduleaccess!.contains("4"))
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(workarea!),
                              value: _user == null ? null : users[_user!],
                              items: users.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _user = users.indexOf(value!);
                                  debugPrint("index of ----" + _user.toString());
                                  if(_user == 0) {
                                    workareatype = "PT";
                                    workarea = "Goods & Services";
                                  } else if (_user == 1) {
                                    workareatype = "WT";
                                    workarea = "Works";
                                  } else {
                                    workareatype = "LT";
                                    workarea = "Earning/Leasing";
                                  }
                                  debugPrint("SELECTED VALUE----" + workareatype!);
                                  AapoortiUtilities.user!.CUSTOM_WK_AREA =
                                      workareatype!;
                                });
                              },
                            ),
                          if ((usertype != "4" && moduleaccess == "NA") ||
                              moduleaccess!.contains("8") ||
                              moduleaccess!.contains("9") ||
                              moduleaccess!.contains("1") ||
                              moduleaccess!.contains("0"))
                            Text(
                              workarea != null ? workarea! : '',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if((usertype == "4" && moduleaccess == "NA") || moduleaccess!.contains("4"))
                Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 0.0,
                  child: Column(children: <Widget>[
                    Container(child: Column(children: <Widget>[
                      Padding(padding: EdgeInsets.all(5.0)),
                      Text('My Quick Links',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () async {
                                  try {
                                    var connectivityresult = await AapoortiUtilities.check();
                                    if (connectivityresult) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PendingBill()));
                                    }
                                  } on SocketException catch (_) {
                                    debugPrint('internet not available');
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                  }
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/pending_bill_login.png',
                                  width: 50,
                                  height: 60,
                                )),
                            MaterialButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClosedBill()));
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/closed_bill_login.png',
                                  width: 50,
                                  height: 60,
                                )),
                          ],
                        ),
                      ),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            ' Pending Bills',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          Text(
                            '  Closed Bills',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ],
                      )),
                      Padding(padding: EdgeInsets.all(5.0)),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(5.0)),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                 MaterialButton(
                                      onPressed: () async {
                                        try {
                                          var connectivityresult = await AapoortiUtilities.check();
                                          if (connectivityresult) {
                                            Navigator.pushNamed(
                                                context, "/payments");
                                          }
                                        } on SocketException catch (_) {
                                          debugPrint('internet not available');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoConnection()));
                                        }
                                        //  AapoortiUtilities.stopProgress(pr);
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/payments_login.png',
                                        width: 50,
                                        height: 60,
                                      )),
                                  MaterialButton(
                                      onPressed: () async {
                                        try {
                                          var connectivityresult = await AapoortiUtilities.check();
                                          if (connectivityresult) {
                                            Navigator.pushNamed(
                                                context, "/livetender");
                                          }
                                        } on SocketException catch (_) {
                                          debugPrint('internet not available');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoConnection()));
                                        }
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/live_tender_login.png',
                                        width: 50,
                                        height: 60,
                                      )),
                                ],
                              ),
                            ),
                            Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                  Text(' Payments', style: TextStyle(color: Colors.black, fontSize: 12)),
                                  Text('Live Tenders', style: TextStyle(color: Colors.black, fontSize: 12)),
                              ],
                            )),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  MaterialButton(
                                      onPressed: () async {
                                        try {
                                          var connectivityresult = await AapoortiUtilities.check();
                                          if(connectivityresult) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ClosedTender()));
                                          }
                                        } on SocketException catch (_) {
                                          debugPrint('internet not available');
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                        }
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/closed_tender_login.png',
                                        width: 50,
                                        height: 60,
                                      )),
                                  MaterialButton(
                                      onPressed: () async {
                                        try {
                                          var connectivityresult = await AapoortiUtilities.check();
                                          if(connectivityresult) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ReverseAuction()));
                                          }
                                        } on SocketException catch (_) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                        }
                                      },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/reverse_auction_login.png',
                                        width: 50,
                                        height: 60,
                                      )),
                                ],
                              ),
                            ),
                            Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(' Closed Tenders', style: TextStyle(color: Colors.black, fontSize: 12)),
                                Text('  Reverse Auction', style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                              ],
                            )),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseOrders()));
                                      },
                                      padding: EdgeInsets.only(left: 70),
                                      child: Image.asset('assets/contracts.png', width: 50, height: 60)),
                                ],
                              ),
                            ),
                            Center(
                                child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 50.0, top: 20)),
                                Text(' View Contracts', style: TextStyle(color: Colors.black, fontSize: 12)),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ])),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Note: You may also change Work Area from top right corner.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ]),
              ),
              if(((usertype == "1" || usertype == "6") && moduleaccess == "NA") || moduleaccess!.contains("1"))
                Card(surfaceTintColor: Colors.white,
                    color: Colors.white,child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      child: Column(children: <Widget>[
                        Padding(padding: EdgeInsets.all(15.0)),
                        Text('My Reports',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.all(15.0)),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StockPosition()));
                                  },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset(
                                    'assets/stock.jpg',
                                    width: 50,
                                    height: 60,
                                  )),
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/IrepsProgress");
                                  },
                                  padding: EdgeInsets.all(0.0),
                                  //child: Image.asset('assets/avg_time_report.png',width: 50,height: 60,)),
                                  child: Image.asset(
                                    'assets/highvaluetender.png',
                                    width: 50,
                                    height: 60,
                                  )),
                            ],
                          ),
                        ),
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('Stock Position', style: TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text('IREPS Progress', style: TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        )),
                        Padding(padding: EdgeInsets.all(20.0)),
                      ]),
                    ),
                  ),
                ])),
              if((usertype == "8" || usertype == "9" && moduleaccess == "NA") ||
                  moduleaccess!.contains("8") ||
                  moduleaccess!.contains("9"))
                Card(surfaceTintColor: Colors.white,
                    color: Colors.white,child: Column(children: <Widget>[
                  Container(
                    height: 550,
                    child: Column(children: <Widget>[
                      Padding(padding: EdgeInsets.all(15.0)),
                      Text(
                        'My Reports',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(20.0)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () async {
                                  try {
                                    var connectivityresult = await AapoortiUtilities.check();
                                    if (connectivityresult) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Invoice()));
                                    }
                                  } on SocketException catch (_) {
                                    debugPrint('internet not available');
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));

                                  }
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/payments_login.png',
                                  width: 50,
                                  height: 60,
                                )),
                            MaterialButton(
                                onPressed: () async {
                                  try {
                                    var connectivityresult = await AapoortiUtilities.check();
                                    if(connectivityresult) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SoldLots()));
                                    }
                                  } on SocketException catch (_) {
                                    debugPrint('internet not available');
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));

                                  }
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/live_tender_login.png',
                                  width: 50,
                                  height: 60,
                                )),
                          ],
                        ),
                      ),
                      Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(' Invoice',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          Text('  Sold Lots',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ],
                      )),
                      Padding(padding: EdgeInsets.all(20.0)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CatalogueSum()));
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/report_icon.png',
                                  width: 50,
                                  height: 60,
                                )),
                            MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ConsolidatedSum()));
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/aac_home.png',
                                  width: 50,
                                  height: 60,
                                )),
                          ],
                        ),
                      ),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(' Catalogue Summary', style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          Text('  Consolidated Summary', style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ],
                      )),
                      Padding(padding: EdgeInsets.all(20.0)),
                    ]),
                  ),
                ])),
              if((usertype == "0" && moduleaccess == "NA") || moduleaccess!.contains("0"))
                Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    child: Column(children: <Widget>[
                  Container(
                    height: 550,
                    child: Column(children: <Widget>[
                      Padding(padding: EdgeInsets.all(15.0)),
                      Text(
                        'My Queries',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(20.0)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () async {
                                  try {
                                    var connectivityresult = await AapoortiUtilities.check();
                                    if (connectivityresult) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PendingQuery()));
                                    }
                                  } on SocketException catch (_) {
                                    debugPrint('internet not available');
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                  }
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/pendingquery.png',
                                  width: 50,
                                  height: 60,
                                )),
                            MaterialButton(
                                onPressed: () async {
                                  try {
                                    var connectivityresult = await AapoortiUtilities.check();
                                    if(connectivityresult) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MobileAppQuery()));
                                    }
                                  } on SocketException catch (_) {
                                    debugPrint('internet not available');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoConnection()));
                                  }
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/web.png',
                                  width: 50,
                                  height: 60,
                                )),
                          ],
                        ),
                      ),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            ' My Helpdesk Queries',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          Text('  Mobile App Queries',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ],
                      )),
                      Padding(padding: EdgeInsets.all(20.0)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingPayment()));
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/payments_login.png',
                                  width: 50,
                                  height: 60,
                                )),
                          ],
                        ),
                      ),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            ' Online Pending Payment Satus',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ],
                      )),
                    ]),
                  ),
                ])),
              // if(usertype != "0")
              //   Card(
              //     child: Column(
              //       children: <Widget>[
              //         Padding(
              //           padding: const EdgeInsets.all(5.0),
              //           child: Row(
              //             children: <Widget>[
              //               AapoortiUtilities.customTextView("To 'Report A Problem' :", Colors.grey),
              //               MaterialButton(
              //                 onPressed: () {
              //                   ReportaproblemOpt.rec = "1";
              //                   Navigator.push(context, MaterialPageRoute(builder: (context) => ReportaproblemOpt()));
              //                 },
              //                 textColor: Colors.black,
              //                 color: Colors.grey[100],
              //                 child: Text(
              //                   'Click Here',
              //                   style: TextStyle(fontWeight: FontWeight.bold),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(5.0),
              //           child: Row(
              //             children: <Widget>[
              //               AapoortiUtilities.customTextView("In case of any issue please call 011-23761525", Colors.grey),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
            ])));
  }

  final dbHelper = DatabaseHelper.instance;

  void saveUserLoginDtls(email) async {
    AapoortiConstants.loginUserEmailID = email;
    await dbHelper.deleteLoginUser(1);
    await dbHelper.deleteSaveLoginUser(1);
    Map<String, dynamic> row = {
      DatabaseHelper.Tbl5_Col1_EmailId: email,
      DatabaseHelper.Tbl5_Col2_LoginFlag: "1",
    };
    Map<String, dynamic> row2 = {
      DatabaseHelper.Tbl3_Col1_Hash: AapoortiConstants.hash,
      DatabaseHelper.Tbl3_Col2_Date: AapoortiConstants.date.toString(),
      DatabaseHelper.Tbl3_Col3_Ans: AapoortiConstants.ans,
      DatabaseHelper.Tbl3_Col4_Log: AapoortiConstants.check,
    };
    int id = await dbHelper.insertLoginUser(row);
    int id2 = await dbHelper.insertSaveLoginUser(row2);
    debugPrint("Id after insertion = " + id.toString());
    debugPrint("Id2 after insertion = " + id2.toString());
  }

  Future<String> _onButtonPressed(BuildContext context) async {
    // Show modal bottom sheet and wait for its result
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          height: 120,
          child: Container(
            child: _buildBottomNavigationMenu(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        );
      },
    );

    // Return the result from the bottom sheet
    return result ?? ''; // Return an empty string if the result is null
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.vpn_key,
              color: Colors.teal,
              size: 20,
            ),
            Text(
              "Logout from this device?",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 40.0)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.teal),
              ),
              color: Colors.grey[300],
              minWidth: 100,
            ),
            Padding(padding: EdgeInsets.only(left: 60.0, top: 40.0)),
            MaterialButton(
              onPressed: () async {
                if(AapoortiConstants.check == "true" && DateTime.now().toString().compareTo(AapoortiConstants.date) < 0) {
                  Navigator.of(context).pushReplacementNamed("/common_screen");
                } else {
                  AapoortiUtilities.callWebServiceLogout1(context);
                  AapoortiConstants.ans = "false";
                  await dbHelper.deleteLoginUser(1);
                  await dbHelper.deleteSaveLoginUser(1);
                }
              },
              child: Text("Confirm", style: TextStyle(color: Colors.teal)),
              color: Colors.grey[300],
              minWidth: 100,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 30.0)),
            InkWell(
                child: RichText(
                  text: TextSpan(
                    text: 'Login from different user',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.teal[900],
                    ),
                  ),
                ),
                onTap: () {
                  AapoortiUtilities.callWebServiceLogout1(context);
                  AapoortiConstants.ans = "false";
                  dbHelper.deleteLoginUser(1);
                  dbHelper.deleteSaveLoginUser(1);
                }),
          ],
        ),
      ],
    );
  }

}
