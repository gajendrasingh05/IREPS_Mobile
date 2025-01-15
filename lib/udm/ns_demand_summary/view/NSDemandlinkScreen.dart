import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/change_nsdscroll_visibility_provider.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/view_demand_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view_model/NSDemandSummaryViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/search_nsdscreen_provider.dart';

class NSDemandlinkScreen extends StatefulWidget {
  final String? indentorPostId;
  final String? indentorName;
  final String? total;
  final String? draft;
  final String? underFinanceConcurrence;
  final String? underFinanceVetting;
  final String? underProcess;
  final String? approvedForwardPurchase;
  final String? returnedByPurchase;
  final String? dropped;
  final String? frmDate;
  final String? toDate;
  NSDemandlinkScreen(this.indentorPostId, this.indentorName, this.total, this.draft, this.underFinanceConcurrence, this.underFinanceVetting, this.underProcess,
      this.approvedForwardPurchase, this.returnedByPurchase, this.dropped, this.frmDate, this.toDate);

  @override
  State<NSDemandlinkScreen> createState() => _NSDemandlinkScreenState();
}

class _NSDemandlinkScreenState extends State<NSDemandlinkScreen> {

  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(false);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setRWADClinkScrollValue(false);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 3) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setRWADClinkScrollValue(true);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 5) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setRWADClinkScrollValue(false);
    } else {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDlinkShowScroll(true);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setRWADClinkScrollValue(false);
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<NSDemandSummaryViewModel>(context, listen: false).getNSDemandlinkData(widget.indentorPostId, widget.indentorName, widget.total, widget.draft, widget.underFinanceConcurrence, widget.underFinanceVetting, widget.underProcess,
          widget.approvedForwardPurchase, widget.returnedByPurchase, widget.dropped, widget.frmDate, widget.toDate, context);
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
          title: Consumer<SearchNSDScreenProvider>(
              builder: (context, value, child) {
                if (value.getnsdlinksearchValue == true) {
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
                                Provider.of<SearchNSDScreenProvider>(context, listen: false).updatelinkScreen(false);
                                _textsearchController.text = "";
                                Provider.of<NSDemandSummaryViewModel>(context, listen: false).searchingNSDMDlink(_textsearchController.text, context);
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
                          Provider.of<NSDemandSummaryViewModel>(context, listen: false).searchingNSDMDlink(query, context);
                        },
                      ),
                    ),
                  );
                }
                else {
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
                            text: " ${language.text('nsdemandtitle')}",
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
            Consumer<SearchNSDScreenProvider>(
                builder: (context, value, child) {
                  if (value.getnsdlinksearchValue == true) {
                    return SizedBox();
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<SearchNSDScreenProvider>(context, listen: false).updatelinkScreen(true);
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
                              Provider.of<NSDemandSummaryViewModel>(context, listen: false).getNSDemandlinkData(widget.indentorPostId, widget.indentorName, widget.total, widget.draft, widget.underFinanceConcurrence, widget.underFinanceVetting, widget.underProcess,
                                  widget.approvedForwardPurchase, widget.returnedByPurchase, widget.dropped, widget.frmDate, widget.toDate, context);
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
        floatingActionButton: Consumer<ChangeNSDScrollVisibilityProvider>(
            builder: (context, value, child) {
              if(value.getNSDlinkUiShowScroll == true) {
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
                          if(value.getNSDlinkUiScrollValue == false) {
                            final position = listScrollController.position.maxScrollExtent;
                            listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                            value.setRWADClinkScrollValue(true);
                          } else {
                            final position = listScrollController.position.minScrollExtent;
                            listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                            value.setRWADClinkScrollValue(false);
                          }
                        }
                      },
                      child: value.getNSDlinkUiScrollValue == true
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
              Expanded(child: Consumer<NSDemandSummaryViewModel>(
                  builder: (context, value, child) {
                    if(value.nslinkDataState == NSDemandDatalinkState.Busy) {
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
                    }
                    else if(value.nslinkDataState == NSDemandDatalinkState.Finished) {
                      return ListView.builder(
                          itemCount: value.nslinklistData.length,
                          shrinkWrap: true,
                          controller: listScrollController,
                          padding: EdgeInsets.zero,
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
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Column(children: <Widget>[
                                          Container(
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
                                                    Text(language.text('dmdnumdate'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text("${value.nslinklistData[index].dmdno.toString()} Dt. ${DateFormat('dd-MM-yyyy').format(DateTime.parse(value.nslinklistData[index].dmddate.toString()))}",
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16))
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(language.text('indetortitle'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.nslinklistData[index].indentorname.toString().split("<br/>")[0]}\n${value.nslinklistData[index].indentorname.toString().split("<br/>")[1]}",
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
                                                        language.text('itemdetails'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.nslinklistData[index].itemdescription == null ? Text("NA",style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)) : ReadMoreText(
                                                      removeHtmlTags(value
                                                          .nslinklistData[
                                                      index]
                                                          .itemdescription!) ??
                                                          "NA",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
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
                                                        language.text('valueminappr'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "Rs. ${value.nslinklistData[index].demandestval.toString()}/${value.nslinklistData[index].approvalvalue.toString().trim()}",
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
                                                        language.text('purunit'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.nslinklistData[index].purchageunit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.nslinklistData[index].purchageunit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
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
                                                    Text(language.text('currentlywith'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(value.nslinklistData[index].dmdstatus == "2" ? "Purchase Unit: ${value.nslinklistData[index].currentlywith.toString()}" : "${value.nslinklistData[index].username.toString()}\n${value.nslinklistData[index].currentlywith.toString()}\n${value.nslinklistData[index].useremail.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                                    Text("${value.nslinklistData[index].dmdstatusval.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ],
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(language.text('viemdmd'), style: TextStyle(color: Colors.red.shade300, fontSize: 16)),
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(shape: CircleBorder(),backgroundColor: Colors.red.shade300),
                                                        onPressed: () async {
                                                          bool check = await UdmUtilities.checkconnection();
                                                          if(check == true) {
                                                            //fileUrl = "https://www.trial.ireps.gov.in/ireps/etender/pdfdocs/MMIS/RN/DMD/2022/03/NR-33364-22-00121.pdf";
                                                            var fileUrl = "https://${value.nslinklistData[index].pdf_path}";
                                                            //var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                            if(fileUrl.toString().trim() == "https://www.ireps.gov.in") {
                                                              UdmUtilities.showWarningFlushBar(context, language.text('sdnf'));
                                                            } else {
                                                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                              UdmUtilities.openPdfBottomSheet(context, fileUrl, fileName, language.text('nsdemandtitle'));
                                                            }
                                                          } else{
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.feedback_outlined,
                                                          color: Colors.white,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ]))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    else if(value.nslinkDataState == NSDemandDatalinkState.NoData) {
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
                    }
                    else if(value.nslinkDataState == NSDemandDatalinkState.FinishedWithError) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 85,
                                width: 85,
                                child: Image.asset('assets/no_data.png')
                            ),
                            InkWell(
                              onTap: () {
                                //Provider.of<NSDemandSummaryViewModel>(context, listen: false).getNSDemandData(widget.fromdate, widget.todate,widget.rly,widget.unittype,widget.unitname,widget.department,widget.consignee,widget.indentor, context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                    }
                    else {
                      return SizedBox();
                    }
                  })),
            ],
          ),
        ),
      ),
    );
  }

  String removeHtmlTags(String htmlText) {
    final document = parse(htmlText);
    final String plainText = parse(document.body!.text).documentElement!.text;
    return plainText;
  }
}
