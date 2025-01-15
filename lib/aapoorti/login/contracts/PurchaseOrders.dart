import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/login/contracts/PurchaseOrder_filter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter/src/painting/text_style.dart' as textSt;

class PurchaseOrders extends StatefulWidget {
  get path => null;
  PurchaseOrders(
      {this.area,
      this.RailZoneIn,
      this.SearchForstring,
      this.Dt1In,
      this.Dt2In,
      this.searchOption});

  final String? area, RailZoneIn, SearchForstring, Dt1In, Dt2In, searchOption;
  @override
  _PurchaseOrdersState createState() => _PurchaseOrdersState(
      this.area,
      this.RailZoneIn,
      this.SearchForstring,
      this.Dt1In,
      this.Dt2In,
      this.searchOption);
}

class _PurchaseOrdersState extends State<PurchaseOrders> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  String selectedCriteria = "PO";
  String ponumber = "-1";
  String start = "-1";
  String end = "-1";
  String cross = "1";
  var rowCount = -1;
  List<String>? data;
  static bool sfilter = false, keyboardOpen = false;
  static DateTime _valueto = DateTime.now();
  DateTime _valuefrom = _valueto.add(Duration(days: 180));

  String? area, RailZoneIn, SearchForstring, Dt1In, Dt2In, searchOption;

  _PurchaseOrdersState(String? area, String? railZoneIn, String? searchForstring,
      String? dt1in, String? dt2in, String? searchOption) {
    this.area = area;
    this.RailZoneIn = railZoneIn;
    this.SearchForstring = searchForstring;
    this.Dt1In = dt1in;
    this.Dt2In = dt2in;
    this.searchOption = searchOption;
  }

  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," + AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2;
    if (searchOption != "#")
      inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + selectedCriteria + ",-1,-1," + DateFormat('dd/MMM/yyyy').format(_valuefrom) + "," + DateFormat('dd/MMM/yyyy').format(_valueto);
    else
      inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + area! + "," + RailZoneIn.toString() +
          "," +
          SearchForstring.toString() +
          ",${this.Dt1In},${this.Dt2In}";

    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Contra/PoFilterPr', 'PoFilterPr', inputParam1, inputParam2);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
            title: Text('View Contracts',
                style: textSt.TextStyle(color: Colors.white)),
          ),
          drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
          body: Center(
              child: jsonResult == null
                  ? SpinKitFadingCircle(
                      color: Colors.teal,
                      size: 120.0,
                    )
                  : _myListView(context)),
          floatingActionButton: keyboardOpen
              ? SizedBox()
              : FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    sfilter = true;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseOrder_filter()));
                  },
                  tooltip: 'View Contracts Filter',
                  elevation: 12,
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked),
    );
  }

  Widget _myListView(BuildContext context) {
    return (jsonResult!.isEmpty)
        ? Center(
            child: Text(
            ' Please use filter to Search contracts  ',
            style: textSt.TextStyle(
                color: Colors.teal, fontSize: 15, fontWeight: FontWeight.w600),
          ))
        : ListView.separated(
            itemCount: jsonResult != null ? jsonResult!.length : 0,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AapoortiUtilities.customTextView(
                            (index + 1).toString() + ". ", Colors.teal),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 125,
                                  child: AapoortiUtilities.customTextView(
                                      "Rly Unit/Depot", Colors.teal),
                                ),
                                Container(
                                  height: 30,
                                  child: AapoortiUtilities.customTextView(
                                      jsonResult![index]['RAILWAY'].toString(),
                                      Colors.black),
                                )
                              ]),
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 125,
                                      child: AapoortiUtilities.customTextView(
                                          "PO No", Colors.teal),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        child: AapoortiUtilities.customTextView(
                                            jsonResult![index]['PO_NO']
                                                .toString(),
                                            Colors.black),
                                      ),
                                    ),
                                  ]),
                              Row(children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 125,
                                  child: AapoortiUtilities.customTextView(
                                      "PO Date", Colors.teal),
                                ),
                                Container(
                                  height: 30,
                                  child: AapoortiUtilities.customTextView(
                                      jsonResult![index]['PO_DATE'].toString(),
                                      Colors.black),
                                )
                              ]),
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 125,
                                      child: AapoortiUtilities.customTextView(
                                          "Stock/Non-Stock", Colors.teal),
                                    ),
                                    Container(
                                      height: 30,
                                      child: AapoortiUtilities.customTextView(
                                          jsonResult![index]['NS'].toString(),
                                          Colors.black),
                                    )
                                  ]),
                              Row(children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 125,
                                  child: AapoortiUtilities.customTextView(
                                      "PO Value(INR)", Colors.teal),
                                ),
                                Container(
                                  height: 30,
                                  child: AapoortiUtilities.customTextView(
                                      jsonResult![index]['PO_VALUE'].toString(),
                                      Colors.black),
                                )
                              ]),
                              Row(children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 125,
                                  child: AapoortiUtilities.customTextView(
                                      "Links", Colors.teal),
                                ),
                                Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          print('pressing');
                                          print(jsonResult![index]['PO_URL']);

                                          if (jsonResult![index]['PO_URL'] !=
                                              'NA') {
                                            print('pressing11111');
                                            var fileUrl = jsonResult![index]
                                                    ['PO_URL']
                                                .toString();
                                            var fileName = fileUrl.substring(
                                                fileUrl.lastIndexOf("/"));
                                            print(fileUrl);
                                            AapoortiUtilities.ackAlert(
                                                context, fileUrl, fileName);
                                          } else {
                                            AapoortiUtilities.showInSnackBar(
                                                context,
                                                "No PDF attached with this Tender!!");
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          child: Image(
                                              image: AssetImage(
                                                  'images/pdf_home.png'),
                                              height: 30,
                                              width: 20),
                                        ),
                                      ),
                                    ])),
                              ]),
                            ])),
                      ]));
            },
            separatorBuilder: (context, index) {
              return Divider();
            });
  }

  /* overlay_Dialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          String contentText = "Content of Dialog";
          print(contentText);
          return StatefulBuilder(
            builder: (context, setState) {
              return
                Material(
                  type: MaterialType.transparency,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 300,
                            width: 600,
                            margin: EdgeInsets.only(
                                top: 200,
                                bottom: 50,
                                left: 30,
                                right: 30),
                            padding: EdgeInsets.only(
                                top: 30,
                                bottom: 0,
                                left: 30,
                                right: 30),
                            color: Colors.white,
                            // Aligns the container to center
                            child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets
                                          .only(top: 3, bottom: 5),
                                      child: new Row(
                                        children: <Widget>[
                                          new Icon(Icons.train,
                                            color: Colors.black,),
                                          new DropdownButton(
                                            hint: Text(
                                                '     Select Organization       '),
                                            items: data.map(
                                                    (item) {
                                                  return new DropdownMenuItem(
                                                      child:
                                                      new Text(
                                                        item['NAME'],
                                                        style: textSt.TextStyle(fontSize: 12),

                                                      ),
                                                      value: item['ID']
                                                          .toString()
                                                  );
                                                }).toList(),
                                            onChanged: (newVal1) {
                                              _mySelection1 = newVal1;
                                              print("my selection first" +
                                                  _mySelection1);

                                              setState(() {
                                                _mySelection1 = newVal1;
                                                print("my selection first-------" +
                                                    _mySelection1 + "      " +
                                                    newVal1);
                                                if (newVal1 == "-1") {

                                                  Navigator.pop(context);
                                                  getDatafirst();

                                                  Timer _timer = new Timer(const Duration(milliseconds: 1000), () {
                                                    overlay_Dialog();
                                                  });
                                                } else {

                                                  Navigator.pop(context);
                                                  getDatasecond();
                                                  Timer _timer = new Timer(const Duration(milliseconds: 1000), () {
                                                    overlay_Dialog();
                                                  });

                                                }
                                              });
                                            },
                                            value: _mySelection1,
                                          ),
                                        ],
//
                                      )
                                  ),
                                  Expanded(

                                    child: Container(
                                        child: new Row(
                                          children: <Widget>[
                                            new Image.asset(
                                              'images/depot.png', width: 20,
                                              height: 20,),
                                            new DropdownButton(
                                              hint: Text(
                                                  '     Select Depot Name       '),
                                              items: data2.map(
                                                      (item) {
                                                    return new DropdownMenuItem(
                                                      child:
                                                      new Text(
                                                        item['DEPOT_NAME']
                                                            .toString(),
                                                        style: textSt.TextStyle(fontSize: 12),
                                                      ),
                                                      value: item['DEPOT_ID']
                                                          .toString(),
                                                    );
                                                  }).toList(),

                                              onChanged: (newVal1) {
                                                setState(() {
                                                  _mySelection =
                                                      newVal1;
                                                  print(
                                                      "my selection first" +
                                                          _mySelection);
                                                });

                                                splitDate();

                                              },
                                              value: _mySelection,

                                            ),
                                          ],
//
                                        )
                                    ),
                                  ),
                                  (dateSelection)?
                                  Expanded(
                                    child: Container(
                                        child: new Row(
                                          children: <Widget>[
                                            new Icon(Icons.calendar_today,
                                              color: Colors.black,),
                                            new DropdownButton(
                                              hint: Text(
                                                  '     Select Date                '),
                                              items: items.map(
                                                      (item) {
                                                    return new DropdownMenuItem(
                                                        child: new Text(
                                                          item.start_date
                                                              .toString()+"                      ",
                                                          style: textSt.TextStyle(fontSize: 12),),

                                                        value: item.depot_id
                                                            .toString()
                                                    );
                                                  }).toList(),
                                              onChanged: (newVal1) {
                                                setState(() {
                                                  _mySelection2 = newVal1;
                                                  print("my selection first2" +
                                                      _mySelection2);
                                                });
                                              },
                                              value: _mySelection2,
                                            ),
                                          ],
//
                                        )
                                    ),
                                  ):SizedBox(height: 1,)
                                  ,


                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        */ /*MaterialButton(
                                            minWidth: 50,
                                            height: 40,
                                            padding: EdgeInsets
                                                .fromLTRB(
                                                25.0, 5.0, 25.0,
                                                5.0),
                                            // padding: const EdgeInsets.only(left:110.0,right:110.0),
                                            child: Text('Reset',
                                              textAlign: TextAlign
                                                  .center,
                                              style: textSt.TextStyle(
                                                  color: Colors
                                                      .white
                                              ),
                                            ),

                                            onPressed: () {
                                              _onclear();
                                              //Navigator.pop(context);
                                            },
                                            color: Colors.black26),*/ /*
                                        MaterialButton(

                                            height: 40,
                                            padding: EdgeInsets
                                                .fromLTRB(
                                                25.0, 5.0, 25.0,
                                                5.0),
                                            // padding: const EdgeInsets.only(left:110.0,right:110.0),
                                            child: Text('Apply',
                                              textAlign: TextAlign
                                                  .center,
                                              style: textSt.TextStyle(
                                                  color: Colors
                                                      .white
                                              ),
                                            ),

                                            onPressed: () {
                                              fetchPost(pageNumber);
                                              Navigator.of(
                                                  context,
                                                  rootNavigator: true)
                                                  .pop(
                                                  'dialog');

                                            },
                                            color: Colors.black26),
                                      ],
                                    ),
                                  ),

                                ]
                            )

                        ),
                        Container(
                          child: Align(
                            alignment: Alignment
                                .bottomCenter,
                            child:
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                      context,
                                      rootNavigator: true)
                                      .pop(
                                      'dialog');
                                },
                                child: Image(
                                  image: AssetImage(
                                      'assets/close_overlay.png'),
                                  color: Colors.white,
                                  height: 50,)
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),


                );
            },


          );
        }
    );
  }*/
}
