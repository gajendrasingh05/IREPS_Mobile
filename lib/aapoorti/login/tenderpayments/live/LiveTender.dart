import 'dart:convert';
import 'dart:io';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveTender extends StatefulWidget {
  get path => null;
  @override
  _LiveTenderState createState() => _LiveTenderState();
}

class _LiveTenderState extends State<LiveTender> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  bool vis = false;
  String? worka;
  BuildContext? context1;
  int i = -1;

  bool _allowWriteFile = true;
  void initState() {
    super.initState();
    //  requestWritePermission();
    callWebService();
  }

// void requestWritePermission() async {
//   PermissionStatus permissionStatus = await PermissionHandler()
//       .checkPermissionStatus(PermissionGroup.storage);
//   if (permissionStatus != true) {
//     bool isopemed = await PermissionHandler().openAppSettings();
//     bool isshown = await PermissionHandler()
//         .shouldShowRequestPermissionRationale(PermissionGroup.storage);
//     Map<PermissionGroup,
//         PermissionStatus> permissions = await PermissionHandler()
//         .requestPermissions([PermissionGroup.storage]);
//     _allowWriteFile=true;
//     setState(() {
//       _allowWriteFile = true;
//     });
//   }
//   else {
//     setState(() {
//       _allowWriteFile = true;
//     });
//   }
// }
  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID +
        "," +
        AapoortiUtilities.user!.CUSTOM_WK_AREA;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Log/LiveTenderList', 'LiveTenderList', inputParam1, inputParam2);
    debugPrint(jsonResult!.length.toString());
    debugPrint(jsonResult.toString());
    if (jsonResult!.length == 0) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    }
    setState(() {});
  }

  /* void fetchPost() async {


    print('Fetching from service');

    var v = "https://ireps.gov.in/Aapoorti/ServiceCallLog/PendingBillList?PendingBillList="+ '{"param1":"87014271368745345742,921C6C01A29EDBBCE05340011E0A70C3,Android,0,0","param2":"1486485732,PT,"}';
    var v1='https://trial.ireps.gov.in/Aapoorti/ServiceCallLog/LiveTenderList?LiveTenderList={"param1":"61813473666154124344,921DB39C59F6F661E05340011E0AD822,Android,0,0","param2":"1486485732,PT,"}';
    final response =   await http.post(v1,headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, encoding: Encoding.getByName("utf-8"));
    print('url formed $v1');
    print('respnse is $response and');
    jsonResult = json.decode(response.body);


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
    setState(() {

    });

  }
*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Live Tender', style: TextStyle(color: Colors.white)),
        ),
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
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
                      "Work Area: " + workarea(),
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

  String workarea() {
    if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'PT') {
      worka = "Goods and Services";
    } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'WT') {
      worka = "Works";
    } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'LT') {
      worka = "Earning/Leasing";
    }
    return worka!;
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return GestureDetector(
        onTap: () {
          vis = false;
          i = -1;
          setState(() {
            vis = false;
            i = -1;
          });
        },
        child: ListView.separated(
            itemCount: jsonResult != null ? jsonResult!.length : 0,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(width: 1, color: Colors.grey[300]!),
                    ),
                    child: Column(children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(3.0)),
                            Text(
                              (index + 1).toString() + ". ",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 16),
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          jsonResult![index]['RAILWAY_ZONE'] !=
                                                  null
                                              ? jsonResult![index]
                                                      ['RAILWAY_ZONE'] +
                                                  "/" +
                                                  jsonResult![index]
                                                      ['DEPARTMENT']
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
                                              "Date",
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              // height: 30,
                                              child: Text(
                                                jsonResult![index][
                                                            'TENDER_OPENING_DATE'] !=
                                                        null
                                                    ? jsonResult![index]
                                                        ['TENDER_OPENING_DATE']
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(height: 3),
                                    Row(children: <Widget>[
                                      Container(
                                        // height: 30,
                                        width: 125,
                                        child: Text(
                                          "Tender Number",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        // height: 30,
                                        child: Text(
                                          jsonResult![index]['TENDER_NUMBER'] !=
                                                  null
                                              ? jsonResult![index]
                                                  ['TENDER_NUMBER']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      )
                                    ]),
                                    SizedBox(height: 3),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            // height: 30,
                                            width: 125,
                                            child: Text(
                                              "WorkArea",
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            // height: 30,

                                            child: Text(
                                              jsonResult![index]['WORK_AREA'] !=
                                                      null
                                                  ? jsonResult![index]
                                                      ['WORK_AREA']
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ]),
                                    SizedBox(height: 3),
                                    Row(children: <Widget>[
                                      Container(
                                        // height: 30,
                                        width: 125,
                                        child: Text(
                                          "Links",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 16),
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
                                                          ['URL'] !=
                                                      'NA') {
                                                    String name = "NIT";
                                                    var fileUrl =
                                                        jsonResult![index]['URL']
                                                            .toString();
                                                    var fileName = fileUrl
                                                        .substring(fileUrl
                                                            .lastIndexOf("/"));
                                                    AapoortiUtilities
                                                        .ackAlertLogin(
                                                            context,
                                                            fileUrl,
                                                            fileName,
                                                            name);

//                                                RenderBox renderBox = context.findRenderObject();
//                                                final RenderBox overlay = Overlay.of(context).context.findRenderObject();
//
//                                                var targetGlobalCenter =
//                                                renderBox.localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

                                                    // We create the tooltip on the first use

                                                    //Dismiss dialog
                                                  } else {
                                                    AapoortiUtilities
                                                        .showInSnackBar(context,
                                                            "No PDF attached with this Tender!!");
                                                  }
                                                },
                                                child:
                                                    Column(children: <Widget>[
                                                  Container(
                                                    // height: 30,

                                                    child: Image(
                                                        image: AssetImage(
                                                            'images/pdf_home.png'),
                                                        height: 30,
                                                        width: 20),
                                                  ),
                                                  new Padding(
                                                      padding:
                                                          EdgeInsets.all(0.0)),
                                                  new Container(
                                                    child: new Text('NIT',
                                                        style: new TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 9),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ]),
                                              ),
                                            ]),
                                      ),
                                    ]),
                                    SizedBox(height: 3),
                                  ]),
                            ),
                          ])
                    ]),
                  ));
            },
            separatorBuilder: (context, index) {
              return Container();
            }));
  }
}
