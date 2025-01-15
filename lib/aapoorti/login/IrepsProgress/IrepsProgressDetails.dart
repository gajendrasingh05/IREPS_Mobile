import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IrepsProgressDetails extends StatefulWidget {
  final String? OrgCode, RailZoneIn, dept, unit, uutype, workarea, Dt1In, Dt2In;

  IrepsProgressDetails(
      {this.OrgCode,
      this.RailZoneIn,
      this.dept,
      this.unit,
      this.uutype,
      this.workarea,
      this.Dt1In,
      this.Dt2In});

  @override
  _IrepsProgressDetailsState createState() => _IrepsProgressDetailsState(
      this.OrgCode!,
      this.RailZoneIn!,
      this.dept!,
      this.unit!,
      this.uutype!,
      this.workarea!,
      this.Dt1In!,
      this.Dt2In!);
}

class json12 {
  String? wk;
  String? dr, pm, mb, cfy, pfy, cumm;

  json12({
    this.wk,
    this.dr,
    this.pm,
    this.mb,
    this.cfy,
    this.pfy,
    this.cumm,
  });
}

class json12_cnt {
  String? wk;

  String? cdr, cpm, cmb, ccfy, cpfy, ccumm;
  json12_cnt(
      {this.wk,
      this.cdr,
      this.cpm,
      this.cmb,
      this.ccfy,
      this.cpfy,
      this.ccumm});
}

class json3 {
  String? wk;
  String? type, dr, pm, mb, cfy, pfy, cumm;
  json3(
      {this.wk,
      this.type,
      this.dr,
      this.pm,
      this.mb,
      this.cfy,
      this.pfy,
      this.cumm});
}

class json4 {
  String? wk;
  String? bstart, bdate, cdate;
  json4({this.wk, this.bstart, this.bdate, this.cdate});
}

class json5 {
  String? wk;
  int? ra;
  int? nra;
  int? total;
  json5({this.wk, this.ra, this.nra, this.total});
}

class _IrepsProgressDetailsState extends State<IrepsProgressDetails> {
  _IrepsProgressDetailsState(
    String OrgCode,
    String RailZoneIn,
    String dept,
    String unit,
    String uutype,
    String workarea,
    String Dt1In,
    String Dt2In,
  ) {
    this.OrgCode = OrgCode; //"01";
    this.RailZoneIn = RailZoneIn; //"561";
    this.dept = dept; // "-1";
    this.unit = unit; //"-1";
    this.uutype = uutype; //"2";
    this.workarea = workarea;
    this.Dt1In = Dt1In; //"12/Aug/2019";
    this.Dt2In = Dt2In; //"10/Sep/2019";
    AapoortiUtilities.setLandscapeOrientation();
  }

  int ptRACount = 0,
      ptNormalCount = 0,
      wtRACount = 0,
      wtNormalCount = 0,
      ltRACount = 0,
      ltNormalCount = 0,
      ptTotalCount = 0,
      wtTotalCount = 0,
      ltTotalCount = 0;

  String? workarea,
      SearchForstring,
      RailZoneIn,
      Dt1In,
      Dt2In,
      uutype,
      OrgCode,
      ClDate,
      dept,
      unit;

  double? fsize;
  bool tcount = true,
      tvalue = false,
      tdecision = false,
      vreg = false,
      raprogress = false;

  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;
  List<dynamic>? jsonResult5;
  String? res;

  List<json5> items = <json5>[];
  List<json12> items12 = <json12>[];
  List<json12_cnt> items12_cnt = <json12_cnt>[];
  List<json3> items3 = <json3>[];
  List<json4> items4 = <json4>[];

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID +
            "," +
            OrgCode! +
            "," +
            RailZoneIn! +
            ",-1," +
            unit! +
            "," +
            dept! +
            "," +
            uutype! +
            "," +
            Dt1In.toString() +
            "," +
            Dt2In.toString()
        /*+
        "," +
        workarea*/
        ;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'IREPS/TenderLot', 'TenderLot', inputParam1, inputParam2);

    setState(() {
      try {
        jsonResult1 = jsonResult![0]["tenderList"];
        jsonResult2 = jsonResult![0]["lotList"];
        jsonResult3 = jsonResult![0]["tDecision"];
        jsonResult4 = jsonResult![0]["venderList"];
        jsonResult5 = jsonResult![0]["rAProgress"];

        items12.clear();
        items12_cnt.clear();

        for (int index = 0; index < jsonResult2!.length; index++) {
          json12 j1 = json12(
            wk: jsonResult2![jsonResult2!.length - (index + 1)]["WORK_AREA"]
                .toString(),
            dr: double.parse(jsonResult2![jsonResult2!.length - (index + 1)]
                        ["DATE_RANGE_VAL"]
                    .toString())
                .toStringAsFixed(2),
            pm: double.parse(jsonResult2![jsonResult2!.length - (index + 1)]
                        ["MNTH_VAL"]
                    .toString())
                .toStringAsFixed(2),
            mb: double.parse(jsonResult2![jsonResult2!.length - (index + 1)]
                        ["MNTH_BEFORE_VAL"]
                    .toString())
                .toStringAsFixed(2),
            cfy: double.parse(jsonResult2![jsonResult2!.length - (index + 1)]
                        ["FIN_YR_VAL"]
                    .toString())
                .toStringAsFixed(2),
            pfy: double.parse(jsonResult2![jsonResult2!.length - (index + 1)]
                        ["PREV_FIN_YR_VAL"]
                    .toString())
                .toStringAsFixed(2),
            cumm: double.parse(jsonResult2![jsonResult2!.length - (index + 1)]
                        ["TOT_VAL"]
                    .toString())
                .toStringAsFixed(2),
          );

          json12_cnt j2 = json12_cnt(
              wk: jsonResult2![jsonResult2!.length - (index + 1)]["WORK_AREA"]
                  .toString(),
              cdr: jsonResult2![jsonResult2!.length - (index + 1)]
                      ["DATE_RANGE_CNT"]
                  .toString(),
              cpm: jsonResult2![jsonResult2!.length - (index + 1)]["MNTH_CNT"]
                  .toString(),
              cmb: jsonResult2![jsonResult2!.length - (index + 1)]["MNTH_BFR"]
                  .toString(),
              ccfy: jsonResult2![jsonResult2!.length - (index + 1)]["FIN_YR_CNT"]
                  .toString(),
              cpfy: jsonResult2![jsonResult2!.length - (index + 1)]
                      ["PREV_FIN_YR_CNT"]
                  .toString(),
              ccumm: jsonResult2![jsonResult2!.length - (index + 1)]["TOT_CNT"]
                  .toString());

          items12.add(j1);
          items12_cnt.add(j2);
        }

        for(int index = 0; index < jsonResult1!.length; index++) {
          json12 j1 = json12(
            wk: jsonResult1![index]["WORK_AREA"].toString(),
            dr: double.parse(jsonResult1![index]["DATE_RANGE"].toString())
                .toStringAsFixed(2),
            pm: double.parse(jsonResult1![index]["PREV_MONTH"].toString())
                .toStringAsFixed(2),
            mb: double.parse(jsonResult1![index]["MONTH_BEFORE"].toString())
                .toStringAsFixed(2),
            cfy: double.parse(jsonResult1![index]["CURRENT_YEAR"].toString())
                .toStringAsFixed(2),
            pfy: double.parse(jsonResult1![index]["PREV_YEAR"].toString())
                .toStringAsFixed(2),
            cumm: double.parse(
                    jsonResult1![index]["CUMULATIVE_TILL_DATE"].toString())
                .toStringAsFixed(2),
          );

          json12_cnt j2 = json12_cnt(
              wk: jsonResult1![index]["WORK_AREA"].toString(),
              cdr: jsonResult1![index]["DATE_RANGE_COUNT"].toString(),
              cpm: jsonResult1![index]["PREV_MONTH_COUNT"].toString(),
              cmb: jsonResult1![index]["MONTH_BEFORE_COUNT"].toString(),
              ccfy: jsonResult1![index]["CURRENT_YEAR_COUNT"].toString(),
              cpfy: jsonResult1![index]["PREV_YEAR_COUNT"].toString(),
              ccumm:
                  jsonResult1![index]["CUMULATIVE_TILL_DATE_COUNT"].toString());

          if (workarea!.compareTo("NA") == 0) {
            print("wkNA" + workarea!);
            items12.add(j1);
            items12_cnt.add(j2);
          } else if (workarea!
                  .compareTo(jsonResult1![index]["WORK_AREA"].toString()) ==
              0) {
            items12.clear();
            items12_cnt.clear();
            items12.add(j1);
            items12_cnt.add(j2);
          }
        }
        items3.clear();
        for (int index = 0; index < jsonResult3!.length; index++) {
          json3 j3 = json3(
            wk: jsonResult3![index]["WORK_AREA"].toString(),
            type: jsonResult3![index]["TEND_FINAL_STATUS"].toString(),
            dr: double.parse(jsonResult3![index]["INRANGE"].toString())
                .toStringAsFixed(2),
            pm: double.parse(jsonResult3![index]["PREV_MONTH"].toString())
                .toStringAsFixed(2),
            mb: double.parse(jsonResult3![index]["MONTH_BEFORE"].toString())
                .toStringAsFixed(2),
            cfy: double.parse(jsonResult3![index]["CUR_FIN_YR"].toString())
                .toStringAsFixed(2),
            pfy: double.parse(jsonResult3![index]["PRE_FIN_YR"].toString())
                .toStringAsFixed(2),
            cumm: double.parse(jsonResult3![index]["TILL_DATE"].toString())
                .toStringAsFixed(2),
          );

          if (workarea!.compareTo("NA") == 0) {
            print("wkNA" + workarea!);
            items3.add(j3);
          } else if (workarea
                  !.compareTo(jsonResult3![index]["WORK_AREA"].toString()) ==
              0) {
            items3.add(j3);
          }
        }
        items4.clear();
        for (int index = 0; index < jsonResult4!.length; index++) {
          json4 j4 = json4(
              wk: jsonResult4![index]["WORK_AREA"].toString(),
              bstart: jsonResult4![index]["BEFORE_START"].toString(),
              bdate: jsonResult4![index]["IN_RANGE"].toString(),
              cdate: (int.parse(jsonResult4![index]["IN_RANGE"].toString()) +
                      int.parse(jsonResult4![index]["BEFORE_START"].toString()))
                  .toString());

          if (workarea!.compareTo("NA") == 0) {
            print("wkNA" + workarea!);
            items4.add(j4);
          } else if (workarea
                  !.compareTo(jsonResult4![index]["WORK_AREA"].toString()) ==
              0) {
            items4.add(j4);
          }
        }

        for (int index = jsonResult5!.length - 1; index >= 0; index--) {
          print("---" + index.toString());
          print(jsonResult5![index]["WORKS_TENDER"].toString());
          print(jsonResult5![index]["SUPPLY_TENDER"].toString());
          print(jsonResult5![index]["WORK_AREA"].toString());
          print(jsonResult5![index]["BIDDING_STYLE"].toString());

          if (jsonResult5![index]["WORK_AREA"].toString().compareTo("PT") == 0) {
            if (jsonResult5![index]["BIDDING_STYLE"].toString().compareTo("3") ==
                0) {
              ptRACount =
                  int.parse(jsonResult5![index]["SUPPLY_TENDER"].toString());
            }
            if (jsonResult5![index]["BIDDING_STYLE"].toString().compareTo("1") ==
                0) {
              ptNormalCount =
                  int.parse(jsonResult5![index]["SUPPLY_TENDER"].toString());
            }
            ptTotalCount = ptNormalCount + ptRACount;
          }
          if (jsonResult5![index]["WORK_AREA"].toString().compareTo("WT") == 0) {
            if (jsonResult5![index]["BIDDING_STYLE"].toString().compareTo("3") ==
                0) {
              wtRACount =
                  int.parse(jsonResult5![index]["SUPPLY_TENDER"].toString());
            }
            if (jsonResult5![index]["BIDDING_STYLE"].toString().compareTo("1") ==
                0) {
              wtNormalCount =
                  int.parse(jsonResult5![index]["SUPPLY_TENDER"].toString());
            }
            wtTotalCount = wtNormalCount + wtRACount;
          }
          if (jsonResult5![index]["WORK_AREA"].toString().compareTo("LT") == 0) {
            if (jsonResult5![index]["BIDDING_STYLE"].toString().compareTo("3") ==
                0) {
              ltRACount =
                  int.parse(jsonResult5![index]["SUPPLY_TENDER"].toString());
            }
            if (jsonResult5![index]["BIDDING_STYLE"].toString().compareTo("1") ==
                0) {
              ltNormalCount =
                  int.parse(jsonResult5![index]["SUPPLY_TENDER"].toString());
            }
            ltTotalCount = ltNormalCount + ltRACount;
          }
        }
        json5 j1 = json5(
            wk: 'PT',
            ra: ptRACount,
            nra: ptNormalCount,
            total: ptRACount + ptNormalCount);
        json5 j2 = new json5(
            wk: 'LT',
            ra: ltRACount,
            nra: ltNormalCount,
            total: ltRACount + ltNormalCount);
        json5 j3 = json5(
            wk: 'WT',
            ra: wtRACount,
            nra: wtNormalCount,
            total: wtRACount + wtNormalCount);

        items.clear();
        if (workarea!.compareTo("NA") == 0) {
          items.add(j1);
          items.add(j2);
          items.add(j3);
        } else if (workarea!.compareTo("PT") == 0) {
          items.add(j1);
        } else if (workarea!.compareTo("WT") == 0) {
          items.add(j3);
        } else if (workarea!.compareTo("LT") == 0) {
          items.add(j2);
        }

        print(items.length);
        print("items12.length" + items12.length.toString());
        print("items12_cnt.length" + items12_cnt.length.toString());

        print(items12.toString());
        print(items12_cnt.toString());
        print(jsonResult3);
        print(jsonResult4);
        print(jsonResult5);
      } catch (ex) {
        print(ex);
      }
    });
  }

  void initState() {
    super.initState();
    callWebService();
  }

  void changed(bool tc, bool tv, bool td, bool vr, bool ra) {
    setState(() {
      tcount = tc;
      tvalue = tv;
      tdecision = td;
      vreg = vr;
      raprogress = ra;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = width - 10 - 10;
    double height2 = height - 10;
    fsize = height1;

    return WillPopScope(
        onWillPop: () async {
          AapoortiUtilities.setPortraitOrientation();
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            //resizeToAvoidBottomPadding: true,
            appBar: new AppBar(
                iconTheme: new IconThemeData(color: Colors.white),

                backgroundColor: Colors.teal,
                centerTitle: true,
                title: new Row(
                  children: [
            /*        new Padding(padding: new EdgeInsets.only(left: 1.0)),
                    new IconButton(
                      alignment: Alignment.centerLeft,
                      icon: new Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        AapoortiUtilities.setPortraitOrientation();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),*/
                    new Padding(padding: new EdgeInsets.only(left: 15.0)),
                    Container(
                        /*   padding: const EdgeInsets.all(20.0),*/
                      alignment: Alignment.center,
                      child: Text('   IREPS  Progress    ',style: TextStyle(color:Colors.white),),
                    ),
                    new Padding(padding: new EdgeInsets.only(right: 20.0)),
                    /*new IconButton(
                  alignment: Alignment.centerRight,
                  icon: new Icon(
                    Icons.home,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),*/
                  ],
                )),
            body: jsonResult == null
                ? SpinKitFadingCircle(
                    color: Colors.teal[100],
                    size: 120.0,
                  )
                : new Container(
                    child: 
                    Column(children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                        // new Padding(
                        //     padding: new EdgeInsets.only(
                        //         left: height1 / (height1 / 50))),
                        MaterialButton(
                          elevation: 12,
                           padding: EdgeInsets.all(8),

                          child: Text(
                                             'Tender/Lots Count',
                              style: TextStyle(
                                fontSize: height1 / 50,
                                fontWeight: FontWeight.bold,
                                color: tcount == true
                                    ? Colors.teal[800]
                                    : Colors.white,
                              ),
                            
                          ),
                          onPressed: () {
                            changed(true, false, false, false, false);
                          },

                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),

                          ),
                          color: tcount == true
                              ? Colors.teal[200]
                              : Colors.teal[800],
                          //specify background color for the button here
                          colorBrightness: Brightness.dark,
                          //specify the color brightness here, either `Brightness.dark` for darl and `Brightness.light` for light
                          disabledColor: Colors.blueGrey,
                          // specify color when the button is disabled
                          highlightColor: Colors.grey,
                          //color when the button is being actively pressed, quickly fills the button and fades out after
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: height2 / 500,
                          //     vertical:
                          //         height2 / 500),
                           // gives padding to the button
                        ),
                        // new Padding(
                        //     padding: new EdgeInsets.only(left: height1 / 300)),
                        MaterialButton(
                          elevation: 12,
                            padding: EdgeInsets.all(8),
                          child: Text(
                            'Tender/Lots Value',
                            style: TextStyle(
                              fontSize: height1 / 50,
                              fontWeight: FontWeight.bold,
                              color: tvalue == true
                                  ? Colors.teal[800]
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            changed(false, true, false, false, false);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: tvalue == true
                              ? Colors.teal[200]
                              : Colors.teal[800],
                          //specify background color for the button here
                          colorBrightness: Brightness.dark,
                          //specify the color brightness here, either `Brightness.dark` for darl and `Brightness.light` for light
                          disabledColor: Colors.blueGrey,
                          // specify color when the button is disabled
                          highlightColor: Colors.grey,
                          //color when the button is being actively pressed, quickly fills the button and fades out after
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: height2 / 500,
                          //     vertical:
                          //         height2 / 500), // gives padding to the button
                        ),
                        // new Padding(
                        //     padding: new EdgeInsets.only(left: height1 / 300)),
                        MaterialButton(
                          elevation: 12,
                            padding: EdgeInsets.all(8),
                          child: Text(
                            'Tender  Decision',
                            style: TextStyle(
                              fontSize: height1 / 50,
                              fontWeight: FontWeight.bold,
                              color: tdecision == true
                                  ? Colors.teal[800]
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            changed(false, false, true, false, false);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: tdecision == true
                              ? Colors.teal[200]
                              : Colors.teal[800],
                          //specify background color for the button here
                          colorBrightness: Brightness.dark,
                          //specify the color brightness here, either `Brightness.dark` for darl and `Brightness.light` for light
                          disabledColor: Colors.blueGrey,
                          // specify color when the button is disabled
                          highlightColor: Colors.grey,
                          //color when the button is being actively pressed, quickly fills the button and fades out after
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: height2 / 500,
                          //     vertical:
                          //         height2 / 500), // gives padding to the button
                        ),
                        // new Padding(
                        //     padding: new EdgeInsets.only(left: height1 / 300)),
                        MaterialButton(
                          elevation: 12,
                            padding: EdgeInsets.all(8),
                          child: Text(
                            'Vendor/Bidder Registered',
                            style: TextStyle(
                                fontSize: height1 / 50,
                                fontWeight: FontWeight.bold,
                                color: vreg == true
                                    ? Colors.teal[800]
                                    : Colors.white),
                          ),
                          onPressed: () {
                            changed(false, false, false, true, false);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color:
                              vreg == true ? Colors.teal[200] : Colors.teal[800],
                          //specify background color for the button here
                          colorBrightness: Brightness.dark,
                          //specify the color brightness here, either `Brightness.dark` for darl and `Brightness.light` for light
                          disabledColor: Colors.blueGrey,
                          // specify color when the button is disabled
                          highlightColor: Colors.grey,
                          //color when the button is being actively pressed, quickly fills the button and fades out after
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: height2 / 500,
                          //     vertical:
                          //         height2 / 500), // gives padding to the button
                        ),
                        // new Padding(
                        //     padding: new EdgeInsets.only(left: height1 / 300)),
                        MaterialButton(
                          elevation: 12,
                            padding: EdgeInsets.all(8),
                          child: Text(
                            'RA Progress',
                            style: TextStyle(
                              fontSize: height1 / 50,
                              fontWeight: FontWeight.bold,
                              color: raprogress == true
                                  ? Colors.teal[800]
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            changed(false, false, false, false, true);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: raprogress == true
                              ? Colors.teal[200]
                              : Colors.teal[800],
                          //specify background color for the button here
                          colorBrightness: Brightness.dark,
                          //specify the color brightness here, either `Brightness.dark` for darl and `Brightness.light` for light
                          disabledColor: Colors.blueGrey,
                          // specify color when the button is disabled
                          highlightColor: Colors.grey,
                          //color when the button is being actively pressed, quickly fills the button and fades out after
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: height2 / 500,
                          //     vertical:
                          //         height2 / 500), // gives padding to the button
                        ),
                      ]),
                    ),
                    new Row(children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.only(
                              left: height1 / (height1 / 60))),
                      Text(
                        (tcount == true)
                            ? 'Tenders Published / Lots Sold Count '
                            : ((tvalue == true)
                                ? 'Tenders Published / Lots Sold Value (in Crore)'
                                : ((tdecision == true)
                                    ? 'Online Tender Decision'
                                    : (vreg == true)
                                        ? 'Vendors / Contractors / Bidders Registered'
                                        : 'Excluding GT ( Tender value greater than 10Cr. for Goods & Services and 50 Cr. for Works )')),
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ]),
                    SingleChildScrollView(
                        child: Card(
                            borderOnForeground: true,
                            elevation: 5,
                            color: Color.fromRGBO(224, 255, 255, 0.6),
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blueGrey, width: 1.0),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(4.0)),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Padding(
                                      padding:
                                          new EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                  (tvalue == true)
                                      ? new DataTable(
                                          sortAscending: true,
                                          columnSpacing: 10,
                                          dataRowHeight: 30,
                                          headingRowHeight: 30,
                                          columns: [
                                            DataColumn(
                                              label: Text(
                                                'WorkArea',
                                                style: TextStyle(
                                                    color: Colors.teal[800],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            DataColumn(
                                                label: Text(
                                              'Range',
                                              style: TextStyle(
                                                  color: Colors.teal[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Prev Mo',
                                              style: TextStyle(
                                                  color: Colors.teal[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Mo Before',
                                              style: TextStyle(
                                                  color: Colors.teal[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'CurrFy',
                                              style: TextStyle(
                                                  color: Colors.teal[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'PrevFy',
                                              style: TextStyle(
                                                  color: Colors.teal[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Cumm',
                                              style: TextStyle(
                                                  color: Colors.teal[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )),
                                          ],
                                          rows: List.generate(
                                            items12 == null
                                                ? 0
                                                : items12.length,
                                            /*(jsonResult1 == null
                                                ? 0
                                                : jsonResult1.length),*/
                                            //(tcount == true || tvalue == true)
                                            /* ? (jsonResult1 == null
                                        ? 0
                                        : jsonResult1.length)
                                    : (jsonResult2 == null
                                        ? 0
                                        : jsonResult2.length),*/
                                            (index) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(items12[
                                                                items12.length -
                                                                    (index + 1)]
                                                            .wk
                                                            .toString() ==
                                                        'PT'
                                                    ? "Goods & Services"
                                                    : (items12[items12.length -
                                                                    (index + 1)]
                                                                .wk
                                                                .toString() ==
                                                            'WT')
                                                        ? "Works"
                                                        : (items12[items12.length -
                                                                        (index +
                                                                            1)]
                                                                    .wk
                                                                    .toString() ==
                                                                'LT')
                                                            ? "Earning / Leasing "
                                                            : "Sale")),
                                                DataCell(Text(double.parse(
                                                        items12[items12.length -
                                                                (index + 1)]
                                                            .dr
                                                            .toString())
                                                    .toStringAsFixed(2))),
                                                DataCell(Text(double.parse(
                                                        items12[items12.length -
                                                                (index + 1)]
                                                            .pm
                                                            .toString())
                                                    .toStringAsFixed(2))),
                                                DataCell(Text(double.parse(
                                                        items12[items12.length -
                                                                (index + 1)]
                                                            .mb
                                                            .toString())
                                                    .toStringAsFixed(2))),
                                                DataCell(Text(double.parse(
                                                        items12[items12.length -
                                                                (index + 1)]
                                                            .cfy
                                                            .toString())
                                                    .toStringAsFixed(2))),
                                                DataCell(Text(double.parse(
                                                        items12[items12.length -
                                                                (index + 1)]
                                                            .pfy
                                                            .toString())
                                                    .toStringAsFixed(2))),
                                                DataCell(Text(double.parse(
                                                        items12[items12.length -
                                                                (index + 1)]
                                                            .cumm
                                                            .toString())
                                                    .toStringAsFixed(2))),
                                              ],
                                            ),
                                          ))
                                      : ((tcount == true)
                                          ? new DataTable(
                                              sortAscending: true,
                                              columnSpacing: 12,
                                              dataRowHeight: 30,
                                              headingRowHeight: 30,
                                              columns: [
                                                DataColumn(
                                                    label: Text(
                                                  'WorkArea',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Range',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Prev Mo',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Mo Before',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'CurrFy',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'PrevFy',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Cumm',
                                                  style: TextStyle(
                                                      color: Colors.teal[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )),
                                              ],
                                              rows: List.generate(
                                                items12_cnt == null
                                                    ? 0
                                                    : items12_cnt.length,
                                                /*(jsonResult1 == null
                                                ? 0
                                                : jsonResult1.length),*/
                                                //(tcount == true || tvalue == true)
                                                /* ? (jsonResult1 == null
                                        ? 0
                                        : jsonResult1.length)
                                    : (jsonResult2 == null
                                        ? 0
                                        : jsonResult2.length),*/
                                                (index) => DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(Text(items12_cnt[
                                                                    items12_cnt
                                                                            .length -
                                                                        (index +
                                                                            1)]
                                                                .wk
                                                                .toString() ==
                                                            'PT'
                                                        ? "Goods & Services"
                                                        : (items12_cnt[items12_cnt
                                                                            .length -
                                                                        (index +
                                                                            1)]
                                                                    .wk
                                                                    .toString() ==
                                                                'WT')
                                                            ? "Works"
                                                            : (items12_cnt[items12_cnt.length -
                                                                            (index +
                                                                                1)]
                                                                        .wk
                                                                        .toString() ==
                                                                    'LT')
                                                                ? "Earning / Leasing "
                                                                : "Sale")),
                                                    DataCell(Text(items12_cnt[
                                                            items12_cnt.length -
                                                                (index + 1)]
                                                        .cdr
                                                        .toString())),
                                                    DataCell(Text(items12_cnt[
                                                            items12_cnt.length -
                                                                (index + 1)]
                                                        .cpm
                                                        .toString())),
                                                    DataCell(Text(items12_cnt[
                                                            items12_cnt.length -
                                                                (index + 1)]
                                                        .cmb
                                                        .toString())),
                                                    DataCell(Text(items12_cnt[
                                                            items12_cnt.length -
                                                                (index + 1)]
                                                        .ccfy
                                                        .toString())),
                                                    DataCell(Text(items12_cnt[
                                                            items12_cnt.length -
                                                                (index + 1)]
                                                        .cpfy
                                                        .toString())),
                                                    DataCell(Text(items12_cnt[
                                                            items12_cnt.length -
                                                                (index + 1)]
                                                        .ccumm
                                                        .toString())),
                                                  ],
                                                ),
                                              ))
                                          : ((tdecision == true)
                                              ? new DataTable(
                                                  sortAscending: true,
                                                  columnSpacing: 12,
                                                  dataRowHeight: 30,
                                                  headingRowHeight: 30,
                                                  columns: [
                                                    DataColumn(
                                                        label: Text(
                                                      'WorkArea',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Type',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Range',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Prev Mo',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Mo Before',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'CurrFy',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'PrevFy',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Cumm',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    )),
                                                  ],
                                                  rows: List.generate(
                                                    items3 == null
                                                        ? 0
                                                        : items3.length,
                                                    /*  jsonResult3 == null
                                                        ? 0
                                                        : jsonResult3.length,*/
                                                    (index) => DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(items3[
                                                                        index]
                                                                    .wk
                                                                    .toString() ==
                                                                'PT'
                                                            ? "Goods & Services"
                                                            : (items3[index]
                                                                        .wk
                                                                        .toString() ==
                                                                    'WT')
                                                                ? "Works"
                                                                : (items3[index]
                                                                            .wk
                                                                            .toString() ==
                                                                        'LT')
                                                                    ? "Earning / Leasing "
                                                                    : "Sale")),
                                                        DataCell(Text((items3[
                                                                        index]
                                                                    .type
                                                                    .toString()
                                                                    .compareTo(
                                                                        "11") ==
                                                                0)
                                                            ? "TC"
                                                            : "Non TC")),
                                                        DataCell(Text(
                                                            items3[index]
                                                                .dr
                                                                .toString())),
                                                        DataCell(Text(
                                                            items3[index]
                                                                .pm
                                                                .toString())),
                                                        DataCell(Text(
                                                            items3[index]
                                                                .mb
                                                                .toString())),
                                                        DataCell(Text(
                                                            items3[index]
                                                                .cfy
                                                                .toString())),
                                                        DataCell(Text(
                                                            items3[index]
                                                                .pfy
                                                                .toString())),
                                                        DataCell(Text(
                                                            items3[index]
                                                                .cumm
                                                                .toString())),
                                                      ],
                                                    ),
                                                  ))
                                              : ((vreg == true)
                                                  ? new DataTable(
                                                      sortAscending: true,
                                                      columnSpacing: 24,
                                                      dataRowHeight: 30,
                                                      headingRowHeight: 30,
                                                      columns: [
                                                        DataColumn(
                                                            label: Text(
                                                          'WorkArea',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                          'Before Start Date',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                          'Between Data Range',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                          'Cumulative',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                      ],
                                                      rows: List.generate(
                                                        items4 == null
                                                            ? 0
                                                            : items4.length,
                                                        (index) => DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(Text(items4[
                                                                            index]
                                                                        .wk
                                                                        .toString() ==
                                                                    'PT'
                                                                ? "Goods & Services"
                                                                : (items4[index]
                                                                            .wk
                                                                            .toString() ==
                                                                        'WT')
                                                                    ? "Works"
                                                                    : (items4[index].wk.toString() ==
                                                                            'LT')
                                                                        ? "Earning / Leasing "
                                                                        : "Sale")),
                                                            DataCell(Text(items4[
                                                                    index]
                                                                .bstart
                                                                .toString())),
                                                            DataCell(Text(items4[
                                                                    index]
                                                                .bdate
                                                                .toString())),
                                                            DataCell(Text(items4[
                                                                    index]
                                                                .cdate
                                                                .toString())),
                                                          ],
                                                        ),
                                                      ))
                                                  : new DataTable(
                                                      sortAscending: true,
                                                      columnSpacing: 42,
                                                      dataRowHeight: 30,
                                                      headingRowHeight: 30,
                                                      columns: [
                                                        DataColumn(
                                                            label: Text(
                                                          'Work Area',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                          'Total Tender',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                          'RA Tender',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                          'Non-RA Tender',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .teal[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        )),
                                                      ],

                                                      rows: List.generate(
                                                        items == null
                                                            ? 0
                                                            : items.length,
                                                        (index) => DataRow(
                                                          cells: [
                                                            DataCell(Text(items[
                                                                            index]
                                                                        .wk
                                                                        .toString() ==
                                                                    'PT'
                                                                ? "Goods & Services"
                                                                : (items[index]
                                                                            .wk
                                                                            .toString() ==
                                                                        'WT')
                                                                    ? "Works"
                                                                    : (items[index].wk.toString() ==
                                                                            'LT')
                                                                        ? "Earning / Leasing "
                                                                        : "Sale")),
                                                            DataCell(
                                                              Text(items[index]
                                                                  .ra
                                                                  .toString()),
                                                            ),
                                                            DataCell(
                                                              Text(items[index]
                                                                  .nra
                                                                  .toString()),
                                                            ),
                                                            DataCell(
                                                              Text(items[index]
                                                                  .total
                                                                  .toString()),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      /*rows: items.map(
                                            (json5) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(jsonResult5[index]
                                                        ["WORK_AREA"]
                                                    .toString())),
                                                DataCell(Text(jsonResult5[index]
                                                        ["TILL_DATE"]
                                                    .toString())),
                                                DataCell(Text(jsonResult5[index]
                                                        ["BEFORE_START"]
                                                    .toString())),
                                                DataCell(Text(jsonResult5[index]
                                                        ["IN_RANGE"]
                                                    .toString())),
                                              ],
                                            ),*/
                                                      //                                      )
                                                    ))))
                                ])))
                  ]))));
  }
}

/*class NumberCell extends StatelessWidget {
  NumberCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 5,
      padding: EdgeInsets.all(0),
      child: Text(
        text,
      ),
    );
  }
}*/
