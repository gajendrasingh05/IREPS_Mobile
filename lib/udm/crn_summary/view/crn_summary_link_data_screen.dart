import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_app/udm/crn_summary/viewModel/crn_summary_viewmodel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';

class CrnSummarylinkDataScreen extends StatefulWidget {
  final String? fromdate;
  final String? todate;
  final String? rly;
  final String? consignee;
  final String? subconsignee;
  final String? actionname;
  CrnSummarylinkDataScreen(this.rly, this.consignee, this.subconsignee,this.fromdate, this.todate, this.actionname);

  @override
  State<CrnSummarylinkDataScreen> createState() =>
      _CrnSummarylinkDataScreenState();
}

class _CrnSummarylinkDataScreenState extends State<CrnSummarylinkDataScreen>
    with SingleTickerProviderStateMixin {
  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkShowScroll(false);
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkScrollValue(false);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 3) {
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkShowScroll(true);
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkScrollValue(true);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 5) {
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkShowScroll(true);
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkScrollValue(false);
    } else {
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkShowScroll(true);
      Provider.of<CrnSummaryViewModel>(context, listen: false).setCrnSummarylinkScrollValue(false);
    }
  }

  stt.SpeechToText _speech = stt.SpeechToText();

  Future<bool> _isAvailable() async {
    bool isAvailable = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (error) {
        print('Speech recognition error: $error');
      },
    );
    return isAvailable;
  }

  void _startListening() {
    Provider.of<CrnSummaryViewModel>(context, listen: false).showhidelinkmicglow(true);
    _speech.listen(
      onResult: (result) {
        _textsearchController.text = result.recognizedWords;
        Provider.of<CrnSummaryViewModel>(context, listen: false).searchingCRNSummarylinkData(_textsearchController.text, context);
        Provider.of<CrnSummaryViewModel>(context, listen: false).updatelinktextchangeScreen(true);
        Provider.of<CrnSummaryViewModel>(context, listen: false).showhidelinkmicglow(false);
      },
    );
  }

  void _stopListening() {
    _speech.stop();
  }

  void hideSoftKeyBoard(bool isVisible) {
    if(isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      Provider.of<CrnSummaryViewModel>(context, listen: false).showhidelinkmicglow(false);
    }
  }


  late AnimationController _animationController;
  late Animation<double> _animation;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    Provider.of<CrnSummaryViewModel>(context, listen: false).showhidelinkmicglow(false);
    Provider.of<CrnSummaryViewModel>(context, listen: false).updatelinktextchangeScreen(false);
    Provider.of<CrnSummaryViewModel>(context, listen: false).updatelinkScreen(false);
    return Future<bool>.value(true);
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    // print("from date ${widget.fromdate}");
    // print("to date ${widget.todate}");
    // print("Railway code ${widget.rly}");
    // print("Consignee ${widget.consignee}");
    // print("Subconsignee ${widget.subconsignee}");
    // print("action name ${widget.actionname}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<CrnSummaryViewModel>(context, listen: false).getCrnSummarylinkData(widget.rly, widget.consignee, widget.subconsignee,
          widget.fromdate, widget.todate, widget.actionname, context);
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
     listScrollController.removeListener(_onScrollEvent);
     _animationController.dispose();
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return KeyboardVisibilityProvider(
        child: WillPopScope(
           onWillPop: _onWillPop,
           child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
             backgroundColor: Colors.red[300],
              iconTheme: IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false,
             title: Consumer<CrnSummaryViewModel>(builder: (context, value, child) {
              if(value.getcrnSummarylinkSearchValue == true) {
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
                          suffixIcon: value.getchangelinktextlistener == false ? IconButton(
                            icon: Icon(Icons.mic, color: Colors.red[300]),
                            onPressed: () async {
                              hideSoftKeyBoard(KeyboardVisibilityProvider.isKeyboardVisible(context));
                              bool isAvailable = await _isAvailable();
                              if(isAvailable) {
                                _startListening();
                              } else {
                                UdmUtilities.showInSnackBar(context, 'Speech recognition not available');
                              }
                            },
                          ) : IconButton(
                            icon: Icon(Icons.clear, color: Colors.red[300]),
                            onPressed: () {
                              Provider.of<CrnSummaryViewModel>(context, listen: false).updatelinkScreen(false);
                              _textsearchController.text = "";
                              Provider.of<CrnSummaryViewModel>(context, listen: false).searchingCRNSummarylinkData(_textsearchController.text, context);
                              Provider.of<CrnSummaryViewModel>(context, listen: false).updatelinktextchangeScreen(false);
                            },
                          ),
                          focusColor: Colors.red[300],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade300, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade300, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade300, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none
                      ),
                      onChanged: (query) {
                        if(query.isNotEmpty) {
                          value.updatelinktextchangeScreen(true);
                          value.showhidelinkmicglow(false);
                          _stopListening();
                          Provider.of<CrnSummaryViewModel>(context, listen: false).searchingCRNSummarylinkData(query, context);
                        } else {
                          value.updatelinktextchangeScreen(false);
                          _textsearchController.text = "";
                          Provider.of<CrnSummaryViewModel>(context, listen: false).searchingCRNSummarylinkData(_textsearchController.text, context);
                        }
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
                          Provider.of<CrnSummaryViewModel>(context, listen: false)
                              .showhidelinkmicglow(false);
                          Provider.of<CrnSummaryViewModel>(context, listen: false)
                              .updatelinktextchangeScreen(false);
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white)),
                    SizedBox(width: 10),
                    Container(
                        height: size.height * 0.10,
                        width: size.width / 1.7,
                        child: Marquee(
                          text: " ${language.text('crnsum')}",
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
              Consumer<CrnSummaryViewModel>(builder: (context, value, child) {
                if (value.getcrnSummarylinkSearchValue == true) {
                  return SizedBox();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<CrnSummaryViewModel>(context, listen: false)
                              .updatelinkScreen(true);
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
                            Provider.of<CrnSummaryViewModel>(context, listen: false).getCrnSummarylinkData(widget.rly, widget.consignee, widget.subconsignee,
                                widget.fromdate, widget.todate, widget.actionname, context);
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
            floatingActionButton: Consumer<CrnSummaryViewModel>(builder: (context, value, child) {
            if(value.getCrnSummarylinkUiShowScroll == true) {
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
                        if(value.getCrnSummarylinkUiScrollValue == false) {
                          final position = listScrollController.position.maxScrollExtent;
                          listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                          value.setCrnSummarylinkScrollValue(true);
                        } else {
                          final position = listScrollController.position.minScrollExtent;
                          listScrollController.animateTo(
                            position,
                            duration: Duration(seconds: 3),
                            curve: Curves.easeInToLinear,
                          );
                          value.setCrnSummarylinkScrollValue(false);
                        }
                      }
                    },
                    child: value.getCrnSummarylinkUiScrollValue == true
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
              child : Stack(
                children: [
                  Consumer<CrnSummaryViewModel>(builder: (context, value, child) {
                    if(value.crnSummaryDatalinkState == CrnSummarylinkDataState.Busy) {
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
                    else if(value.crnSummaryDatalinkState == CrnSummarylinkDataState.Finished) {
                      return ListView.builder(
                          itemCount: value.crnsummarylinkData.length,
                          shrinkWrap: true,
                          controller: listScrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0), side: BorderSide(color: Colors.blue.shade500, width: 1.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(4.0))
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
                                          child: Text('${index + 1}', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white)),
                                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(5)))),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
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
                                                        Text(language.text('ponumdate'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.crnsummarylinkData[index].pono.toString()}\n${value.crnsummarylinkData[index].podate.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(language.text('poser'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.crnsummarylinkData[index].posr.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 16))
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
                                                    Text(language.text('venname'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.crnsummarylinkData[index].vendorname.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
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
                                                    Text(language.text('des1'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    ReadMoreText(
                                                      value.crnsummarylinkData[index].itemdesc ?? "NA",
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
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
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
                                                                .text('datereceipt'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.crnsummarylinkData[index].receiptdate.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(language.text('dmtrnum'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.crnsummarylinkData[index].vrno.toString() + "\n" + value.crnsummarylinkData[index].vrdate.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(language.text('qtyrecvd'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.crnsummarylinkData[index].qtyreceived.toString() + " " + value.crnsummarylinkData[index].pounit.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(language.text('qtyacpt'),
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.crnsummarylinkData[index].qtyaccepted.toString() + " " + value.crnsummarylinkData[index].pounit.toString()}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
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
                                                    Text(language.text('val1'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        "${value.crnsummarylinkData[index].povalue.toString().trim()}",
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
                                                    Text(language.text('curstatus'),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                        value.crnsummarylinkData[index].crnflag ?? "NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: 16))
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
                    }
                    else if (value.crnSummaryDatalinkState == CrnSummarylinkDataState.NoData) {
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
                                  TyperAnimatedText(language.text('dnf'),
                                      speed: Duration(milliseconds: 150),
                                      textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                ])
                          ],
                        ),
                      );
                    }
                    else if (value.crnSummaryDatalinkState == CrnSummarylinkDataState.FinishedWithError) {
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
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(language.text('badresp'),
                                      style:
                                      TextStyle(color: Colors.black, fontSize: 16)),
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
                    else {return SizedBox();}
                  }),
                  Consumer<CrnSummaryViewModel>(
                    builder: (context, value, child) {
                      return Positioned(
                        bottom: size.height * 0.08,
                        left: size.width * 0.25,
                        right: size.width * 0.25,
                        child: value.getshowhidelinkmicglow == true ? AvatarGlow(
                          glowColor: Colors.blue.shade400,
                          endRadius: 70.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: Icon(Icons.mic, color: Colors.white, size: 32),
                                onPressed: (){
                                  //_startListening();
                                },
                              ),
                              radius: 35.0,
                            ),
                          ),
                        ) : SizedBox(),
                      );
                    },
                  ),
                ],
              )
          ),
        ),
      ));
  }
}
