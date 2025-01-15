import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view/warranty_rejection_advice_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_app/udm/warranty_rejection_register/view_model/warranty_rejection_register_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WarrantyRejectionRegisterlistScreen extends StatefulWidget {
  final String? rlycode;
  final String? concode;
  final String? subconcode;
  final String? fromdate;
  final String? todate;
  final String? iquery;
  final String? vensearch;
  final String? searchtype;
  WarrantyRejectionRegisterlistScreen(
      this.rlycode, this.concode, this.subconcode, this.fromdate, this.todate, this.iquery, this.vensearch, this.searchtype);

  @override
  State<WarrantyRejectionRegisterlistScreen> createState() =>
      _WarrantyRejectionRegisterlistScreenState();
}

class _WarrantyRejectionRegisterlistScreenState
    extends State<WarrantyRejectionRegisterlistScreen> {
  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  @override
  void initState() {
    // print("From date : ${widget.fromdate}");
    // print("to date : ${widget.todate}");
    // print("Iquery : ${widget.iquery}");
    // print("Vensearch : ${widget.vensearch}");
    // print("Searchtype : ${widget.searchtype}");
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setWrrShowScroll(false);
    if(widget.iquery.toString().isEmpty && widget.vensearch.toString().isEmpty) {
      //Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWrrlistData(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, " ", " ", widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantyRejectionReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, " ", " ", widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantySummaryReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, " ", " ", widget.searchtype!, context);
    } else if (widget.iquery!.isNotEmpty && widget.vensearch!.isEmpty) {
      //Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWrrlistData(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, widget.iquery!, " ", widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantyRejectionReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, widget.iquery!, " ", widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantySummaryReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, widget.iquery!, " ", widget.searchtype!, context);
    } else if (widget.iquery!.isEmpty && widget.vensearch!.isNotEmpty) {
      //Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWrrlistData(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, " ", widget.vensearch!, widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantyRejectionReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, " ", widget.vensearch!, widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantySummaryReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, " ",widget.vensearch!, widget.searchtype!, context);

    } else if (widget.iquery!.isNotEmpty && widget.vensearch!.isNotEmpty) {
      //Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWrrlistData(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, widget.iquery!, widget.vensearch!, widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantyRejectionReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, widget.iquery!, widget.vensearch!, widget.searchtype!, context);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getWarrantySummaryReport(widget.rlycode, widget.concode, widget.subconcode,widget.fromdate, widget.todate, widget.iquery!,widget.vensearch!, widget.searchtype!, context);
    }
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setWrrShowScroll(false);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setWrrScrollValue(false);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 3) {
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setWrrShowScroll(true);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setWrrScrollValue(true);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 5) {
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
          .setWrrShowScroll(true);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
          .setWrrScrollValue(false);
    } else {
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
          .setWrrShowScroll(true);
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
          .setWrrScrollValue(false);
      if (listScrollController.position.minScrollExtent == extentAfter) {
        Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
            .setexpandtotal(true);
      } else {
        Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
            .setexpandtotal(false);
      }
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
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
        .showhidemicglow(true);
    _speech.listen(
      onResult: (result) {
        _textsearchController.text = result.recognizedWords;
        Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
            .getSearchWrrData(_textsearchController.text, context);
        Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
            .updatetextchangeScreen(true);
        Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
            .showhidemicglow(false);
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
      Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
          .showhidemicglow(false);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
        .updateScreen(false);
    Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false)
        .setexpandtotal(true);
    return Future<bool>.value(true);
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
            title: Consumer<WarrantyRejectionRegisterViewModel>(
                builder: (context, value, child) {
              if (value.getwrrSearchValue == true) {
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
                          suffixIcon: value.getchangetextlistener == false
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
                                    _textsearchController.text = "";
                                    Provider.of<WarrantyRejectionRegisterViewModel>(
                                            context,
                                            listen: false)
                                        .getSearchWrrData(
                                            _textsearchController.text,
                                            context);
                                    Provider.of<WarrantyRejectionRegisterViewModel>(
                                            context,
                                            listen: false)
                                        .updatetextchangeScreen(false);
                                    Provider.of<WarrantyRejectionRegisterViewModel>(
                                            context,
                                            listen: false)
                                        .updateScreen(false);
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
                          value.updatetextchangeScreen(true);
                          value.showhidemicglow(false);
                          _stopListening();
                          Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getSearchWrrData(query, context);
                        } else {
                          value.updatetextchangeScreen(false);
                          _textsearchController.text = "";
                          Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).getSearchWrrData(_textsearchController.text, context);
                        }
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
                          Provider.of<WarrantyRejectionRegisterViewModel>(
                                  context,
                                  listen: false)
                              .updateScreen(false);
                          Provider.of<WarrantyRejectionRegisterViewModel>(
                                  context,
                                  listen: false)
                              .setexpandtotal(true);
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white)),
                    SizedBox(width: 10),
                    Container(
                        height: size.height * 0.10,
                        width: size.width / 1.7,
                        child: Marquee(
                          text: " ${language.text('wrrtitle')}",
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
              Consumer<WarrantyRejectionRegisterViewModel>(
                  builder: (context, value, child) {
                if(value.getwrrSearchValue == true) {
                  return SizedBox();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<WarrantyRejectionRegisterViewModel>(
                                  context,
                                  listen: false)
                              .updateScreen(true);
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
                            Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setexpandtotal(true);
                            getData();
                          } else {
                            Provider.of<WarrantyRejectionRegisterViewModel>(context, listen: false).setexpandtotal(true);
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
          floatingActionButton: Consumer<WarrantyRejectionRegisterViewModel>(
              builder: (context, value, child) {
            if (value.getWrrUiShowScroll == true) {
              return Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.00),
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
                          if (value.getWrrScrollValue == false) {
                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.animateTo(position,
                                curve: Curves.linearToEaseOut,
                                duration: Duration(seconds: 3));
                            value.setWrrScrollValue(true);
                          } else {
                            final position =
                                listScrollController.position.minScrollExtent;
                            listScrollController.animateTo(position,
                                curve: Curves.linearToEaseOut,
                                duration: Duration(seconds: 3));
                            value.setWrrScrollValue(false);
                          }
                        }
                      },
                      child: value.getWrrScrollValue == true
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Consumer<WarrantyRejectionRegisterViewModel>(builder: (context, value, child) {
                      if(value.warrantyrejectionreportstate == WarrantyRejectionreportState.Busy || value.warrantysummaryreportstate == WarrantySummaryReportState.Busy) {
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
                                          child: SizedBox(
                                              height: size.height * 0.45),
                                        );
                                      }))
                            ],
                          ),
                        );
                      }
                      else if (value.warrantyrejectionreportstate == WarrantyRejectionreportState.Finished && value.warrantysummaryreportstate == WarrantySummaryReportState.Finished) {
                        return Column(
                          children: [
                            value.expandvalue
                                ? Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                        '${language.text('swcf')} ${widget.fromdate} ${language.text('wrrto')} ${widget.todate}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueAccent)))
                                : SizedBox(),
                            value.expandvalue
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.fromBorderSide(
                                            BorderSide(
                                                color: Colors.grey,
                                                width: 0.5))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: size.width * 0.45,
                                          child: Column(
                                            children: [
                                              Text(language.text('twcao'),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              SizedBox(height: 3),
                                              Text(
                                                  'Rs. ${value.warrantysummaryreportdata[0].totalorigrecovery}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            height: 65,
                                            child: VerticalDivider(
                                                color: Colors.grey,
                                                width: 0.5)),
                                        Container(
                                          width: size.width * 0.45,
                                          child: Column(
                                            children: [
                                              Text(language.text('twcac'),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              SizedBox(height: 3),
                                              Text(
                                                  'Rs. ${value.warrantysummaryreportdata[0].totalbalrecovery}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            value.expandvalue
                                ? SizedBox(height: 5.0)
                                : SizedBox(),
                            Expanded(
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                      itemCount: value.warrantyrejectionreportData.length,
                                      shrinkWrap: true,
                                      controller: listScrollController,
                                      itemBuilder: (BuildContext context, int index) {
                                        return AnimationConfiguration.staggeredList(
                                                position: index,
                                                duration: const Duration(milliseconds: 375),
                                                child: SlideAnimation(
                                                   verticalOffset: 50.0,
                                                   child: FadeInAnimation(child: Card(
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(4.0),
                                              side: BorderSide(
                                                color: Colors.blue.shade500,
                                                width: 1.0,
                                              )
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0))
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                              color: Colors
                                                                  .white)),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                              Radius
                                                                  .circular(
                                                                  10),
                                                              topLeft: Radius
                                                                  .circular(
                                                                  5)))),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        margin:
                                                        EdgeInsets.all(10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                                language.text(
                                                                    'condepot'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            Text('${value.warrantyrejectionreportData[index].rlyname ?? "NA"}-${value.warrantyrejectionreportData[index].depodetail ?? "NA"}', style: TextStyle(
                                                                color:
                                                                Colors.black,
                                                                fontSize: 16)),
                                                            SizedBox(height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'wcrrd'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].voucherno ?? "NA"} dt. ${value.warrantyrejectionreportData[index].voucherdate ?? "NA"} / ',
                                                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                      text: value.warrantyrejectionreportData[index].wardtls == null ? '${value.warrantyrejectionreportData[index].dmtrno} dt. ${value.warrantyrejectionreportData[index].dmtrdate}' : '${value.warrantyrejectionreportData[index].wardtls}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'vendor'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            SelectableText(
                                                              value
                                                                  .warrantyrejectionreportData[
                                                              index]
                                                                  .vendorname ??
                                                                  "NA",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.red,
                                                                  fontSize: 16),
                                                            ),
                                                            SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'wrrponumdate'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].pono ?? "NA"} dt. ${value.warrantyrejectionreportData[index].podate ?? "NA"} / ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].challanno ?? "NA"} dt. ${value.warrantyrejectionreportData[index].challandate ?? "NA"}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                          16)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 10.0),
                                                            Text(language.text('itemdesc'),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight.w500)),
                                                            SizedBox(height: 4.0),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                SelectableText(
                                                                    '${value.warrantyrejectionreportData[index].ledgerfolioplno ?? "NA"} : ',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w600)),
                                                                Expanded(
                                                                  child:
                                                                  ReadMoreText(
                                                                    value.warrantyrejectionreportData[index]
                                                                        .itemdescription ??
                                                                        "NA",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                                    trimLines: 3,
                                                                    colorClickableText:
                                                                    Colors.red[
                                                                    300],
                                                                    trimMode:
                                                                    TrimMode
                                                                        .Line,
                                                                    trimCollapsedText:
                                                                    ' ...${language.text('more')}',
                                                                    trimExpandedText:
                                                                    ' ...${language.text('less')}',
                                                                    delimiter: '',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            // RichText(
                                                            //   text: TextSpan(
                                                            //     text: '12345678 : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                                                            //     children: <TextSpan>[
                                                            //       TextSpan(text: '${value.wrrlistData[index].itemdescription ?? "NA"}', style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.normal)),
                                                            //     ],
                                                            //   ),
                                                            // ),
                                                            SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'qrcwwb'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].transqty ?? "NA"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"} / ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize: 16),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].qtywithdrawn ?? "NA"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"} / ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].balrejqty ?? "NA"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'qrarrr'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].totalreinspqty ?? "NA"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"} / ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].qtyacceptedreinsp ?? "0"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"} /  ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].returnedqty ?? "NA"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"} / ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].warrepqty ?? "NA"} ${value.warrantyrejectionreportData[index].unitdes ?? "NA"}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'orwarabr'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].origrecovery ?? "NA"} / ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize: 16),
                                                                children:<
                                                                    TextSpan>[
                                                                  // TextSpan(
                                                                  //     text:
                                                                  //     '${value.warrantyrejectionreportData[index].withheldamt ?? "NA"} / ',
                                                                  //     style: TextStyle(
                                                                  //         color: Colors
                                                                  //             .black,
                                                                  //         fontSize:
                                                                  //         16,
                                                                  //         fontWeight:
                                                                  //         FontWeight.normal)),
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].withheldamt ?? "NA"} / ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].balrecovery ?? "NA"}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'vorqbrqau'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].origrecovery ?? "NA"} / ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].balrejvalue ?? "NA"} / ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  //TextSpan(text: '${value.wrrlistData[index].balrejqty ?? "NA"}', style: TextStyle(color: Colors.blue, fontSize: 16,fontWeight: FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                                language.text(
                                                                    'rrrml'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                '${value.warrantyrejectionreportData[index].rejectionrej ?? "NA"}/',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                      '${value.warrantyrejectionreportData[index].curstockinglocation ?? "NA"}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  //TextSpan(text: '${value.wrrlistData[index].balrejqty ?? "NA"}', style: TextStyle(color: Colors.blue, fontSize: 16,fontWeight: FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text(language.text('viewwrntyclaim'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500)),
                                                            ElevatedButton(
                                                                style: ElevatedButton.styleFrom(shape: CircleBorder(),backgroundColor: Colors.blue),
                                                                onPressed: () async {
                                                                  bool check = await UdmUtilities.checkconnection();
                                                                  if(check == true) {
                                                                    //var fileUrl = "https://www.trial.ireps.gov.in/ireps/etender/ct/MMIS/CRC/WAR/2022/03/190080/33364-22-100034.pdf";
                                                                    var fileUrl = "https://${value.warrantyrejectionreportData[index].pdf_path}";
                                                                    //var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                                    //UdmUtilities.openPdfBottomSheet(context, fileUrl, fileName);
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyRejectionAdviceScreen(fileUrl, value.warrantyrejectionreportData[index].transkey)));
                                                                  } else{
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons.feedback_outlined,
                                                                  color: Colors.white,
                                                                )),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                            ))
                                        );
                                      }),
                                )
                            )
                          ],
                        );
                      }
                      else if (value.warrantyrejectionreportstate == WarrantyRejectionreportState.NoData) {
                        return Center(child: Column(
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
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ])
                            ],
                          ));
                      }
                      else if (value.warrantyrejectionreportstate == WarrantyRejectionreportState.FinishedWithError) {
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
                                  getData();
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
                      else {return SizedBox();}
                    })),
                  ],
                ),
                Consumer<WarrantyRejectionRegisterViewModel>(
                  builder: (context, value, child) {
                    return Positioned(
                      bottom: size.height * 0.08,
                      left: size.width * 0.25,
                      right: size.width * 0.25,
                      child: value.getshowhidemicglow == true
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _profileimgFromCamera() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile photo =
  //   await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
  //   setState(() {
  //     _profilepath = photo.path;
  //   });
  // }

  // _profileimgFromGallery() async {
  //   final ImagePicker _picker = ImagePicker();
  //   XFile image =
  //   await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  //   setState(() {
  //     _profilepath = image.path;
  //   });
  // }
}
