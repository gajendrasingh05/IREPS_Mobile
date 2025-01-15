import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_app/udm/crc_summary/view_model/crc_summary_viewmodel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';

class CrcSummarylinkDataScreen extends StatefulWidget {
  final String? fromdate;
  final String? todate;
  final String? rly;
  final String? consignee;
  final String? subconsignee;
  final String? actionname;
  final String? type;
  CrcSummarylinkDataScreen(this.rly, this.consignee, this.subconsignee,
      this.fromdate, this.todate, this.actionname, this.type);

  @override
  State<CrcSummarylinkDataScreen> createState() =>
      _CrcSummarylinkDataScreenState();
}

class _CrcSummarylinkDataScreenState extends State<CrcSummarylinkDataScreen>
    with SingleTickerProviderStateMixin {
  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkShowScroll(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkScrollValue(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setlinktopexpand(false);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 3) {
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkShowScroll(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkScrollValue(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setlinktopexpand(false);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 5) {
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkShowScroll(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkScrollValue(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setlinktopexpand(false);
    }
    else if (extentAfter > 20.0) {
      Provider.of<CrcSummaryViewModel>(context, listen: false).setlinktopexpand(false);
    }
    else {
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkShowScroll(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummarylinkScrollValue(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setlinktopexpand(true);
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
    Provider.of<CrcSummaryViewModel>(context, listen: false)
        .showhidelinkmicglow(true);
    _speech.listen(
      onResult: (result) {
        _textsearchController.text = result.recognizedWords;
        Provider.of<CrcSummaryViewModel>(context, listen: false)
            .searchingCRCSummarylinkData(_textsearchController.text, context);
        Provider.of<CrcSummaryViewModel>(context, listen: false)
            .updatelinktextchangeScreen(true);
        Provider.of<CrcSummaryViewModel>(context, listen: false)
            .showhidelinkmicglow(false);
      },
    );
  }

  void _stopListening() {
    _speech.stop();
  }

  void hideSoftKeyBoard(bool isVisible) {
    if (isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .showhidelinkmicglow(false);
    }
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    Provider.of<CrcSummaryViewModel>(context, listen: false)
        .showhidelinkmicglow(false);
    Provider.of<CrcSummaryViewModel>(context, listen: false)
        .updatelinktextchangeScreen(false);
    Provider.of<CrcSummaryViewModel>(context, listen: false)
        .updatelinkScreen(false);
    return Future<bool>.value(true);
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<CrcSummaryViewModel>(context, listen: false).getCrcSummarylinkData(
              widget.rly,
              widget.consignee,
              widget.subconsignee,
              widget.fromdate,
              widget.todate,
              widget.actionname,
              context);
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
            automaticallyImplyLeading: false,
            title: Consumer<CrcSummaryViewModel>(builder: (context, value, child) {
              if (value.getcrcSummarylinkSearchValue == true) {
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
                          prefixIcon:
                              Icon(Icons.search, color: Colors.red[300]),
                          suffixIcon: value.getchangelinktextlistener == false
                              ? IconButton(
                                  icon: Icon(Icons.mic, color: Colors.red[300]),
                                  onPressed: () async {
                                    hideSoftKeyBoard(KeyboardVisibilityProvider
                                        .isKeyboardVisible(context));
                                    bool isAvailable = await _isAvailable();
                                    if (isAvailable) {
                                      _startListening();
                                    } else {
                                      UdmUtilities.showInSnackBar(context,
                                          'Speech recognition not available');
                                    }
                                  },
                                )
                              : IconButton(
                                  icon:
                                      Icon(Icons.clear, color: Colors.red[300]),
                                  onPressed: () {
                                    Provider.of<CrcSummaryViewModel>(context,
                                            listen: false)
                                        .updatelinkScreen(false);
                                    _textsearchController.text = "";
                                    Provider.of<CrcSummaryViewModel>(context,
                                            listen: false)
                                        .searchingCRCSummarylinkData(
                                            _textsearchController.text,
                                            context);
                                    Provider.of<CrcSummaryViewModel>(context,
                                            listen: false)
                                        .updatelinktextchangeScreen(false);
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
                          border: InputBorder.none),
                      onChanged: (query) {
                        if (query.isNotEmpty) {
                          value.updatelinktextchangeScreen(true);
                          value.showhidelinkmicglow(false);
                          _stopListening();
                          Provider.of<CrcSummaryViewModel>(context,
                                  listen: false)
                              .searchingCRCSummarylinkData(query, context);
                        } else {
                          value.updatelinktextchangeScreen(false);
                          _textsearchController.text = "";
                          Provider.of<CrcSummaryViewModel>(context,
                                  listen: false)
                              .searchingCRCSummarylinkData(
                                  _textsearchController.text, context);
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
                          Provider.of<CrcSummaryViewModel>(context,
                                  listen: false)
                              .showhidelinkmicglow(false);
                          Provider.of<CrcSummaryViewModel>(context,
                                  listen: false)
                              .updatelinktextchangeScreen(false);
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white)),
                    SizedBox(width: 10),
                    Container(
                        height: size.height * 0.10,
                        width: size.width / 1.7,
                        child: Marquee(
                          text: " ${language.text('crcsum')}",
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
              Consumer<CrcSummaryViewModel>(builder: (context, value, child) {
                if (value.getcrcSummarylinkSearchValue == true) {
                  return SizedBox();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<CrcSummaryViewModel>(context,
                                  listen: false)
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
                          if (value == 'refresh') {
                            Provider.of<CrcSummaryViewModel>(context,
                                    listen: false)
                                .getCrcSummarylinkData(
                                    widget.rly,
                                    widget.consignee,
                                    widget.subconsignee,
                                    widget.fromdate,
                                    widget.todate,
                                    widget.actionname,
                                    context);
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
          floatingActionButton: Consumer<CrcSummaryViewModel>(builder: (context, value, child) {
            if (value.getCrcSummarylinkUiShowScroll == true) {
              return Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.06),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21.5),
                      color: Colors.blue),
                  child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if (listScrollController.hasClients) {
                          if (value.getCrcSummarylinkUiScrollValue == false) {
                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.animateTo(position,
                                duration: Duration(seconds: 3),
                                curve: Curves.easeInToLinear);
                            value.setCrcSummarylinkScrollValue(true);
                          } else {
                            final position =
                                listScrollController.position.minScrollExtent;
                            listScrollController.animateTo(
                              position,
                              duration: Duration(seconds: 3),
                              curve: Curves.easeInToLinear,
                            );
                            value.setCrcSummarylinkScrollValue(false);
                          }
                        }
                      },
                      child: value.getCrcSummarylinkUiScrollValue == true
                          ? Icon(Icons.arrow_upward, color: Colors.white)
                          : Icon(Icons.arrow_downward_rounded,
                              color: Colors.white)),
                ),
              );
            } else {
              return SizedBox();
            }
          }),
          body: Container(
            height: size.height,
            width: size.width,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Consumer<CrcSummaryViewModel>(builder: (context, value, child) {
                  if (value.crcSummaryDatalinkState == CrcSummarylinkDataState.Busy) {
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child:
                                          SizedBox(height: size.height * 0.45),
                                    );
                                  }))
                        ],
                      ),
                    );
                  }
                  else if (value.crcSummaryDatalinkState == CrcSummarylinkDataState.Finished) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 45.0),
                        child: Column(
                          children: [
                            value.linktopexpandvalue ? Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text("${language.text('desccrc')} ${widget.fromdate} ${language.text('crcto')} ${widget.todate}\n(${language.text('posason')} ${widget.todate})",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueAccent))) : SizedBox(),
                            value.linktopexpandvalue ? Container(decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.grey, width: 0.5))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "${language.text('listingtype')} ",
                                                    style: TextStyle(color: Colors.red, fontSize: 14)
                                                ),
                                                TextSpan(
                                                    text: "${widget.type} ",
                                                    style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500)
                                                ),
                                              ]
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ) : SizedBox(), value.linktopexpandvalue ? SizedBox(height: 5.0) : SizedBox(),
                            Expanded(child: ListView.builder(
                                itemCount: value.crcsummarylinkData.length,
                                shrinkWrap: true,
                                controller: listScrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        side: BorderSide(
                                            color: Colors.blue.shade500,
                                            width: 1.0)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(4.0))
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                        bottomRight:
                                                        Radius.circular(10),
                                                        topLeft:
                                                        Radius.circular(5)))),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
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
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  language.text(
                                                                      'ponumdate'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                              SizedBox(height: 4.0),
                                                              SelectableText(
                                                                  "${value.crcsummarylinkData[index].pono.toString()}\n${value.crcsummarylinkData[index].podate.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      fontSize: 16))
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  language.text(
                                                                      'poser'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(
                                                                  value.crcsummarylinkData[index].posr ??
                                                                      "NA",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                              language
                                                                  .text('venname'),
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                          SizedBox(height: 4.0),
                                                          Text(
                                                              "${value.crcsummarylinkData[index].vendorname.toString()}",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  fontSize: 16))
                                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                              language.text('des1'),
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                          SizedBox(height: 4.0),
                                                          ReadMoreText(
                                                            value
                                                                .crcsummarylinkData[
                                                            index]
                                                                .itemdesc ??
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
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  language.text(
                                                                      'datereceipt'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(
                                                                  "${value.crcsummarylinkData[index].receiptdate.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      fontSize: 16))
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  language.text(
                                                                      'dmtrnum'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(
                                                                  "${value.crcsummarylinkData[index].vrno.toString() + "\n" + value.crcsummarylinkData[index].vrdate.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  language.text(
                                                                      'qtyrecvd'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(
                                                                  value
                                                                      .crcsummarylinkData[
                                                                  index]
                                                                      .qtyreceived ==
                                                                      null
                                                                      ? "NA"
                                                                      : "${value.crcsummarylinkData[index].qtyreceived.toString() + " " + value.crcsummarylinkData[index].pounit.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      fontSize: 16))
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  language.text(
                                                                      'qtyacpt'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(
                                                                  value
                                                                      .crcsummarylinkData[
                                                                  index]
                                                                      .qtyaccepted ==
                                                                      null
                                                                      ? "NA"
                                                                      : "${value.crcsummarylinkData[index].qtyaccepted.toString() + " " + value.crcsummarylinkData[index].pounit.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                              language.text('val1'),
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                          SizedBox(height: 4.0),
                                                          Text(
                                                              "${value.crcsummarylinkData[index].povalue.toString().trim()}",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  fontSize: 16))
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                              language.text(
                                                                  'curstatus'),
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                          SizedBox(height: 4.0),
                                                          Text(
                                                              value
                                                                  .crcsummarylinkData[
                                                              index]
                                                                  .crnflag ??
                                                                  "NA",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                }))
                          ],
                        )
                    );
                  }
                  else if (value.crcSummaryDatalinkState == CrcSummarylinkDataState.NoData) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/json/no_data.json',
                              height: 120, width: 120),
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
                  else if (value.crcSummaryDatalinkState == CrcSummarylinkDataState.FinishedWithError) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/no_data.png',
                              height: 85, width: 85),
                          InkWell(
                            onTap: () {},
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
                  } else {
                    return SizedBox();
                  }
                }),
                Consumer<CrcSummaryViewModel>(
                  builder: (context, value, child) {
                    return Positioned(
                      bottom: size.height * 0.08,
                      left: size.width * 0.25,
                      right: size.width * 0.25,
                      child: value.getshowhidelinkmicglow == true
                          ? AvatarGlow(
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
                                    icon: Icon(Icons.mic,
                                        color: Colors.white, size: 32),
                                    onPressed: () {
                                      //_startListening();
                                    },
                                  ),
                                  radius: 35.0,
                                ),
                              ),
                            )
                          : SizedBox(),
                    );
                  },
                ),
                Consumer<CrcSummaryViewModel>(
                  builder: (context, provalue, child) {
                    return Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: provalue.totalvalue == 0.0 ? SizedBox() : Container(
                          height: 45,
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(language.text('totvaluers'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Text(provalue.totalvalue.toStringAsFixed(2),  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        )
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
