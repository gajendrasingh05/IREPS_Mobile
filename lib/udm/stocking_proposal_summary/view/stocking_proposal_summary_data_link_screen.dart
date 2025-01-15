import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view_model/stocking_prosposal_summary_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class StockingProposalSummaryDatalinkScreen extends StatefulWidget {
  final String? rly;
  final String? department;
  final String? unitinitproposal;
  final String? unifyingrly;
  final String? storesdepot;
  final String? fromdate;
  final String? todate;
  final String? status;
  StockingProposalSummaryDatalinkScreen(this.rly, this.department, this.unitinitproposal, this.unifyingrly, this.storesdepot,this.fromdate, this.todate, this.status);

  @override
  State<StockingProposalSummaryDatalinkScreen> createState() => _StockingProposalSummaryDatalinkScreenState();
}

class _StockingProposalSummaryDatalinkScreenState extends State<StockingProposalSummaryDatalinkScreen> {

  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkShowScroll(false);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkScrollValue(false);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 3) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkShowScroll(true);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkScrollValue(true);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 5) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkShowScroll(true);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkScrollValue(false);
    } else {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkShowScroll(true);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummrylinkScrollValue(false);
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    // print("Railway value ${widget.rly}");
    // print("Department value ${widget.department}");
    // print("Init proposal value ${widget.unitinitproposal!}");
    // print("Unifyingrly value ${widget.unifyingrly}");
    // print("Strores depot value ${widget.storesdepot}");
    // print("From date value ${widget.fromdate}");
    // print("To date value ${widget.todate}");
    // print("Status value ${widget.status!}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStkSummarylinkData(widget.rly, widget.department, widget.unitinitproposal!,
          widget.unifyingrly, widget.storesdepot, widget.fromdate, widget.todate, widget.status!, context);
    });
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Provider.of<StockingProposalSummaryProvider>(context, listen: false).updatelinkScreen(false);
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
          title: Consumer<StockingProposalSummaryProvider>(
              builder: (context, value, child) {
                if (value.getstksmrylinksearchValue == true) {
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
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).updatelinkScreen(false);
                                _textsearchController.text = "";
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).getSearchStkSummarylinkData(_textsearchController.text, context);
                              },
                            ),
                            focusColor: Colors.red[300],
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: language.text('search'),
                            border: InputBorder.none
                        ),
                        onChanged: (query) {
                          Provider.of<StockingProposalSummaryProvider>(context, listen: false).getSearchStkSummarylinkData(query, context);
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
                            Provider.of<StockingProposalSummaryProvider>(context, listen: false).updatelinkScreen(false);
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Container(
                          height: size.height * 0.10,
                          width: size.width / 1.7,
                          child: Marquee(
                            text: " ${language.text('stkprptitle')}",
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 30.0,
                            velocity: 100.0,
                            style: TextStyle(fontSize: 18,color: Colors.white),
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
            Consumer<StockingProposalSummaryProvider>(
                builder: (context, value, child) {
                  if (value.getstksmrylinksearchValue == true) {
                    return SizedBox();
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<StockingProposalSummaryProvider>(context, listen: false).updatelinkScreen(true);
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
                            if(value == 'refresh') {
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStkSummarylinkData(widget.rly, widget.department, widget.unitinitproposal!,
                                  widget.unifyingrly, widget.storesdepot, widget.fromdate, widget.todate, widget.status!, context);
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
        floatingActionButton: Consumer<StockingProposalSummaryProvider>(
            builder: (context, value, child) {
              if(value.getStkPrpSummrylinkUiShowScroll == true) {
                return Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21.5),
                      color: Colors.blue),
                  child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if(listScrollController.hasClients) {
                          if(value.getStkPrpSummrylinkUiScrollValue == false) {
                            final position = listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                            value.setStkPrpSummrylinkScrollValue(true);
                          } else {
                            final position = listScrollController.position.minScrollExtent;
                            listScrollController.jumpTo(position);
                            value.setStkPrpSummrylinkScrollValue(false);
                          }
                        }
                      },
                      child: value.getStkPrpSummrylinkUiScrollValue == true
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
              Expanded(child: Consumer<StockingProposalSummaryProvider>(
                  builder: (context, value, child) {
                    if(value.stksmryDatalinkstate == StksmryDatalinkState.Busy) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
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
                                    }))
                          ],
                        ),
                      );
                    } else if(value.stksmryDatalinkstate == StksmryDatalinkState.Finished) {
                      return ListView.builder(
                          itemCount: value.stksummarylinkData.length,
                          shrinkWrap: true,
                          controller: listScrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                    color: Colors.blue.shade500,
                                    width: 1.0,
                                  )),
                              child: Container(
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
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            language.text('stksummaryrly'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.stksummarylinkData[index].rlyname.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
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
                                                        Text(language.text('stksummarydept'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.stksummarylinkData[index].subUnitName.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
                                                        //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
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
                                                        language.text('unitinitprpsl'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.stksummarylinkData[index].unitName == null ? Text(
                                                        "NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: 16)) : Text("${value.stksummarylinkData[index].unitName.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: 16))
                                                    //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            language.text('storedepot'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.stksummarylinkData[index].storesDepot.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
                                                        //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
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
                                                            language.text('unifyingrly'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        value.stksummarylinkData[index].uplRly == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.stksummarylinkData[index].uplRly.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                        //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
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
                                                    Text(language.text('stkappnumdate'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text("${value.stksummarylinkData[index].formNo.toString()} Dt: ${value.stksummarylinkData[index].formDate ?? "NA"}",
                                                        style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                                        language.text('plsubgroup'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.stksummarylinkData[index].grpId.toString()}/${value.stksummarylinkData[index].subGrpId.toString()}",
                                                        style: TextStyle(color: Colors.black, fontSize: 16))
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
                                                        language.text('itemdesc'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    ReadMoreText(
                                                      value.stksummarylinkData[index].des ?? "NA",
                                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                                      trimLines: 3,
                                                      colorClickableText:
                                                      Colors.red[300],
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                      ' ...${language.text('more')}',
                                                      trimExpandedText:
                                                      ' ...${language.text('less')}',
                                                      delimiter: '',
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
                                                        language.text('stkinitiatorname'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.stksummarylinkData[index].username.toString()} - ${value.stksummarylinkData[index].postName.toString()}",
                                                        style: TextStyle(color: Colors.black, fontSize: 16))
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
                                                        language.text('currentwith'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "-",
                                                        style: TextStyle(color: Colors.black, fontSize: 16))
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
                                                        language.text('status'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.stksummarylinkData[index].status.toString()} (Since : ${value.stksummarylinkData[index].formDate.toString()})",
                                                        style: TextStyle(color: Colors.black, fontSize: 16))
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
                    } else if(value.stksmryDatalinkstate == StksmryDatalinkState.NoData) {
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
                    } else if(value.stksmryDatalinkstate == StksmryDatalinkState.FinishedWithError) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(height: 85, width: 85, child: Image.asset('assets/no_data.png')),
                            InkWell(
                              onTap: () {
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStkSummarylinkData(widget.rly, widget.department, widget.unitinitproposal!,
                                    widget.unifyingrly, widget.storesdepot, widget.fromdate, widget.todate, widget.status!, context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(language.text('badresp'), style: TextStyle(color: Colors.black, fontSize: 16)),
                                  SizedBox(width: 2),
                                  Text(language.text('tryagain'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
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
