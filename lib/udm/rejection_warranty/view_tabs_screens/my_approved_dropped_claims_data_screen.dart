import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwadscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwadscreen_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwscreen_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/view_model/rejectionwarranty_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class MyApprovedDroppedClaimsDataScreen extends StatefulWidget {
  final String fromdate;
  final String todate;
  final String query;
  MyApprovedDroppedClaimsDataScreen(this.fromdate, this.todate, this.query);

  @override
  State<MyApprovedDroppedClaimsDataScreen> createState() =>
      _MyApprovedDroppedClaimsDataScreenState();
}

class _MyApprovedDroppedClaimsDataScreenState
    extends State<MyApprovedDroppedClaimsDataScreen> {
  ScrollController listScrollController = ScrollController();

  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCShowScroll(false);
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(false);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 3) {
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCShowScroll(true);
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(true);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 5) {
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCShowScroll(true);
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(false);
    } else {
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCShowScroll(true);
      Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(false);
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<RejectionWarrantyViewModel>(context, listen: false)
          .getRWADClaimsData(
              widget.fromdate, widget.todate, widget.query, context);
    });
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          title: Consumer<SearchRWADCScreenProvider>(
              builder: (context, value, child) {
            if (value.getrwadSearchValue == true) {
              return Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextField(
                    cursorColor: Colors.red[300],
                    controller: _textsearchController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.red[300]),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.red[300]),
                          onPressed: () {
                            Provider.of<SearchRWADCScreenProvider>(context,
                                    listen: false)
                                .updateScreen(false);
                            _textsearchController.text = "";
                            Future.delayed(const Duration(milliseconds: 400),
                                () {
                              Provider.of<RejectionWarrantyViewModel>(context,
                                      listen: false)
                                  .searchingRWADCData(
                                      _textsearchController.text
                                          .toString()
                                          .trim(),
                                      context);
                            });
                          },
                        ),
                        hintText: language.text('search'),
                        border: InputBorder.none),
                    onChanged: (query) {
                      Provider.of<RejectionWarrantyViewModel>(context,
                              listen: false)
                          .searchingRWADCData(
                              _textsearchController.text.toString().trim(),
                              context);
                    },
                  ),
                ),
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        //Navigator.popAndPushNamed(context, UserHomeScreen.routeName);
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white)),
                  SizedBox(width: 10),
                  Container(
                      height: size.height * 0.10,
                      width: size.width / 1.7,
                      child: Marquee(
                        text: " ${language.text('apdtitle')}",
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 30.0,
                        velocity: 100.0,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        pauseAfterRound: Duration(seconds: 1),
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ))
                ],
              );
            }
          }),
          actions: [
            Consumer<SearchRWADCScreenProvider>(
                builder: (context, value, child) {
              if (value.getrwadSearchValue == true) {
                return SizedBox();
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<SearchRWADCScreenProvider>(context, listen: false).updateScreen(true);
                      },
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'refresh',
                          child: Text(language.text('refresh'),
                              style: TextStyle(color: Colors.black)),
                        ),
                        PopupMenuItem(
                          value: 'exit',
                          child: Text(language.text('exit'),
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'refresh') {
                          Provider.of<RejectionWarrantyViewModel>(context,
                                  listen: false)
                              .getRWADClaimsData(widget.fromdate, widget.todate,
                                  widget.query, context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                );
              }
            })
          ],
        ),
        floatingActionButton: Consumer<ChangeRWADCScrollVisibilityProvider>(
            builder: (context, value, child) {
          if (value.getRWADCUiShowScroll == true) {
            return Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21.5),
                  color: Colors.blue),
              child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    if (listScrollController.hasClients) {
                      if (value.getRWADCUiScrollValue == false) {
                        final position =
                            listScrollController.position.maxScrollExtent;
                        listScrollController.jumpTo(position);
                        value.setRWADCScrollValue(true);
                      } else {
                        final position =
                            listScrollController.position.minScrollExtent;
                        listScrollController.jumpTo(position);
                        value.setRWADCScrollValue(false);
                      }
                    }
                  },
                  child: value.getRWADCUiScrollValue == true
                      ? Icon(Icons.arrow_upward, color: Colors.white)
                      : Icon(Icons.arrow_downward_rounded,
                          color: Colors.white)),
            );
          } else {
            return SizedBox();
          }
        }),
        body: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<RejectionWarrantyViewModel>(
                builder: (context, provider, child) {
                  if (provider.rwadcstate == RwadcDataState.Busy) {
                    return SizedBox();
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.grey, width: 0.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(language.text('totalCount')),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                provider.rwadctotcount.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // AnimatedTextKit(
                              //     isRepeatingAnimation: false,
                              //     animatedTexts: [
                              //       TyperAnimatedText(
                              //           provider.rwadctotcount.toString(),
                              //           speed: Duration(milliseconds: 150),
                              //           textStyle: TextStyle(
                              //               fontWeight: FontWeight.bold)),
                              //     ])
                            ],
                          ),
                          Container(
                              height: 50,
                              child: VerticalDivider(
                                  color: Colors.grey, width: 0.5)),
                          Column(
                            children: [
                              Text('${language.text('totalVal')}'),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                provider.rwadctotvalue.toStringAsFixed(2),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // AnimatedTextKit(
                              //     isRepeatingAnimation: false,
                              //     animatedTexts: [
                              //       TyperAnimatedText(
                              //           provider.rwadctotvalue
                              //               .toStringAsFixed(2),
                              //           speed: Duration(milliseconds: 150),
                              //           textStyle: TextStyle(
                              //               fontWeight: FontWeight.bold)),
                              //     ])
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 5.0),
              Expanded(child: Consumer<RejectionWarrantyViewModel>(
                  builder: (context, value, child) {
                if (value.rwadcstate == RwadcDataState.Busy) {
                  return SingleChildScrollView(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: SizedBox(height: size.height * 0.45),
                              );
                            })),
                  );
                } else if (value.rwadcstate == RwadcDataState.Finished) {
                  return ListView.builder(
                      itemCount: value.rwadcitems.length,
                      shrinkWrap: true,
                      controller: listScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                color: Colors.blue.shade500,
                                width: 1.0,
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      height: 30,
                                      width: 35,
                                      alignment: Alignment.center,
                                      child: Text('${index + 1}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(5)))),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('wcref'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.9),
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                          "${value.rwadcitems[index].voucherno.toString()} dt. ${value.rwadcitems[index].voucherdate.toString()}/ ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16)),
                                                      value.rwadcitems[index]
                                                                      .dmtrno !=
                                                                  null &&
                                                              value.rwadcitems[index].dmtrdate !=
                                                                  null
                                                          ? Text(
                                                              "${value.rwadcitems[index].dmtrno.toString()} dt. ${value.rwadcitems[index].dmtrdate.toString()}",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .blue))
                                                          : value.rwadcitems[index].dmtrno !=
                                                                      null &&
                                                                  value.rwadcitems[index].dmtrdate ==
                                                                      null
                                                              ? Text(
                                                                  "${value.rwadcitems[index].dmtrno.toString()} dt. NA",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .blue))
                                                              : Text(
                                                                  "NA dt. NA",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors.blue)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    language.text('rwvendorname'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                Text(
                                                    "${value.rwadcitems[index].vendorname.toString()}",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    language.text('pocontract'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.9),
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                          "${value.rwadcitems[index].pono.toString()} dt. ${value.rwadcitems[index].podate.toString()}/ ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16)),
                                                      value.rwadcitems[index]
                                                                      .challanno !=
                                                                  null &&
                                                              value.rwadcitems[index].challandate !=
                                                                  null
                                                          ? Text("${value.rwadcitems[index].challanno.toString()} dt. ${value.rwadcitems[index].challandate.toString()}",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .blue))
                                                          : value.rwadcitems[index].challanno !=
                                                                  null
                                                              ? Text("${value.rwadcitems[index].challanno.toString()} dt. NA",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .blue))
                                                              : Text("NA dt. NA",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight.w400,
                                                                      color: Colors.blue)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    language.text('rwitemdesc'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.9),
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                          "${value.rwadcitems[index].ledgerfolioplno.toString()} : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      ReadMoreText(
                                                        value.rwadcitems[index]
                                                                .itemdescription ??
                                                            "NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16),
                                                        trimLines: 2,
                                                        colorClickableText:
                                                            Colors.red[300],
                                                        trimMode: TrimMode.Line,
                                                        trimCollapsedText:
                                                            ' ...${language.text('more')}',
                                                        trimExpandedText:
                                                            ' ...${language.text('less')}',
                                                        delimiter: '',
                                                      ),
                                                      //Text("${value.rwadcitems[index].itemdescription.toString()}", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())
                                                    ],
                                                  ),
                                                ),
                                                //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        language.text('rejqty'),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(height: 4.0),
                                                    value.rwadcitems[index]
                                                                    .transqty !=
                                                                null &&
                                                            value
                                                                    .rwadcitems[
                                                                        index]
                                                                    .unitdes !=
                                                                null
                                                        ? Text(
                                                            "${value.rwadcitems[index].transqty.toString()} ${value.rwadcitems[index].unitdes.toString()}",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 16))
                                                        : Text("NA",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 16))
                                                    //Text("${value.rwadcitems[index].qtyrejected.toString()} ${value.rwadcitems[index].transunitdes.toString()}", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 16))
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        language.text('rwrate'),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.rwadcitems[index].transrate.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        language
                                                            .text('rwvalue'),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.rwadcitems[index].transvalue.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16))
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        language.text('status'),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(height: 4.0),
                                                    value.rwadcitems[index]
                                                                .statuswarranty
                                                                .toString() ==
                                                            "XX"
                                                        ? Text("Dropped",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                        : Text("Approved",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]))
                              ],
                            ),
                          ),
                        );
                      });
                } else if (value.rwadcstate == RwadcDataState.NoData) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Lottie.asset('assets/json/no_data.json'),
                        ),
                        AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TyperAnimatedText(
                                  language.text('dnf'),
                                  speed: Duration(milliseconds: 150),
                                  textStyle: TextStyle(fontWeight: FontWeight.bold)),
                            ])
                      ],
                    ),
                  );
                } else if(value.rwadcstate == RwadcDataState.FinishedWithError) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 85,
                            width: 85,
                            child: Image.asset('assets/no_data.png')),
                        InkWell(
                          onTap: () {
                            Provider.of<RejectionWarrantyViewModel>(context,
                                    listen: false)
                                .getRWFClaimsData(widget.fromdate,
                                    widget.todate, widget.query, context);
                          },
                          child: Row(
                            children: [
                              Text(language.text('badresp'),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              SizedBox(width: 2),
                              Text(language.text('tryagain'),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              })),
            ],
          ),
        ),
      ),
    );
  }
}
