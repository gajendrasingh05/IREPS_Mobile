import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/end_user/models/checkverification.dart';
import 'package:flutter_app/udm/end_user/models/enduser_list_data.dart';
import 'package:flutter_app/udm/end_user/view/issuetouser_screen.dart';
import 'package:flutter_app/udm/end_user/view_models/to_end_user_view_model.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class EndUserScreen extends StatefulWidget {

  final String? ledgerNum;
  final String? folioNum;
  final String? folioItem;
  final String? searchtxt;
  EndUserScreen(this.ledgerNum, this.folioNum, this.folioItem, this.searchtxt);

  @override
  State<EndUserScreen> createState() => _EndUserScreenState();
}

class _EndUserScreenState extends State<EndUserScreen> {

  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  int selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Ledger number ${widget.ledgerNum}");
    print("folioNum number ${widget.folioNum}");
    print("folioItem number ${widget.folioItem}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ToEndUSerViewModel>(context, listen: false).getenduserlistData(context, widget.ledgerNum.toString().trim(), widget.folioNum.toString().trim(), widget.folioItem.toString().trim());
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  void dispose() {
    listScrollController.dispose();
    _textsearchController.dispose();
    super.dispose();
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
          title: Consumer<ToEndUSerViewModel>(
              builder: (context, value, child) {
                if(value.getendusersearchValue == true) {
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
                                Provider.of<ToEndUSerViewModel>(context, listen: false).updateendusersearchScreen(false);
                                _textsearchController.text = "";
                                //Provider.of<ToEndUSerViewModel>(context, listen: false).searchingNSDMDlink(_textsearchController.text, context);
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
                          //Provider.of<NSDemandSummaryViewModel>(context, listen: false).searchingNSDMDlink(query, context);
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
                            Navigator.pop(context);
                          },
                      child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Container(
                          height: size.height * 0.10,
                          width: size.width / 1.7,
                          child: Marquee(
                            text: " ${language.text('endusertitle')}",
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
            Consumer<ToEndUSerViewModel>(
                builder: (context, value, child) {
                  if(value.getendusersearchValue == true) {
                    return SizedBox();
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<ToEndUSerViewModel>(context, listen: false).updateendusersearchScreen(true);
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
                              Provider.of<ToEndUSerViewModel>(context, listen: false).getenduserlistData(context, widget.ledgerNum.toString().trim(),
                                  widget.folioNum.toString().trim(), widget.folioItem.toString().trim());
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
        floatingActionButton: Consumer<ToEndUSerViewModel>(
            builder: (context, value, child) {
              if(value.getendUserUiShowScroll == true) {
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
                          if(value.getendUserUiShowScroll == false) {
                            final position = listScrollController.position.maxScrollExtent;
                            listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                            //value.setRWADClinkScrollValue(true);
                          } else {
                            final position = listScrollController.position.minScrollExtent;
                            listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                            //value.setRWADClinkScrollValue(false);
                          }
                        }
                      },
                      child: value.getendUserUiScrollValue == true
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
              Expanded(child: Consumer<ToEndUSerViewModel>(
                  builder: (context, value, child) {
                    if(value.getEndUserDataState == EndUserDataState.Busy) {
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
                                    })
                            )
                          ],
                        ),
                      );
                    }
                    else if(value.getEndUserDataState == EndUserDataState.Finished) {
                      return ListView.builder(
                          itemCount: value.getEndUserData.length,
                          shrinkWrap: true,
                          controller: listScrollController,
                          padding: EdgeInsets.zero,
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
                                                    Text(language.text('ledger'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text("${value.getEndUserData[index].ledgerNo.toString()}:${value.getEndUserData[index].ledgerName.toString()}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16))
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(language.text('ledgerfolio'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.getEndUserData[index].ledgerFolioNo.toString()}:${value.getEndUserData[index].ledgerFolioName.toString()}",
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
                                                        language.text('itemcodeplno'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.getEndUserData[index].itemCode.toString()}",
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
                                                    Text(
                                                        language.text('itemDesc'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.getEndUserData[index].itemDesc.toString()}",
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
                                                            language.text('stkqty'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        value.getEndUserData[index].stkQty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.getEndUserData[index].stkQty.toString()} ${value.getEndUserData[index].unitDes.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
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
                                                        Text(language.text('stkv'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text("${value.getEndUserData[index].stkVal.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red.shade300,
                                                  side: BorderSide(color: Colors.white30, width: 1),
                                                  textStyle: const TextStyle(
                                                      color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                  ),
                                                ),
                                          onPressed: () async{
                                          bool check = await UdmUtilities.checkconnection();
                                          selectedIndex = index;
                                          if(check == true) {
                                            EndUserlist list = EndUserlist(
                                              unifiedPlNo : value.getEndUserData[index].unifiedPlNo.toString(),
                                              ledgerNo : value.getEndUserData[index].ledgerNo.toString(),
                                              ledgerFolioNo : value.getEndUserData[index].ledgerFolioNo.toString(),
                                              ledgerKey : value.getEndUserData[index].ledgerKey.toString(),
                                              ledgerName : value.getEndUserData[index].ledgerName.toString(),
                                              ledgerFolioName : value.getEndUserData[index].ledgerFolioName.toString(),
                                              itemDesc : value.getEndUserData[index].itemDesc.toString(),
                                              itemCode : value.getEndUserData[index].itemCode.toString(),
                                              rate : value.getEndUserData[index].rate.toString(),
                                              stkQty : value.getEndUserData[index].stkQty.toString(),
                                              stkVal : value.getEndUserData[index].stkVal.toString(),
                                              unitDes: value.getEndUserData[index].unitDes.toString()
                                            );
                                            Provider.of<ToEndUSerViewModel>(context, listen: false).checkVerification(context, value.getEndUserData[index].ledgerKey!.trim(), list);
                                          }
                                          else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                          }
                                        },
                                        child: value.getVerificationDataState == VerificationDataState.Busy && index == selectedIndex ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(language.text('issuebtn'), style: TextStyle(color: Colors.white)))]), SizedBox(height: 5)]),
                                          ),
                                        ]))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    else if(value.getEndUserDataState == EndUserDataState.NoData) {
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
                    else if(value.getEndUserDataState == EndUserDataState.FinishedWithError) {
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
                  })
              ),
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
