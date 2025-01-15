import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_app/udm/crc_summary/view/crc_summary_link_data_screen.dart';
import 'package:flutter_app/udm/crc_summary/view_model/crc_summary_viewmodel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class WarrantyCrnSummaryDataScreen extends StatefulWidget {
  final String? fromdate;
  final String? todate;
  final String? rlyname;
  final String? rlycode;
  final String? unittypename;
  final String? unittypecode;
  final String? unitname;
  final String? unitnamecode;
  final String? departmentname;
  final String? departmentcode;
  final String? consigneecode;
  final String? consigneename;
  final String? subconsigneename;
  final String? subconsigneecode;
  WarrantyCrnSummaryDataScreen(this.fromdate, this.todate, this.rlyname, this.rlycode, this.unittypename, this.unittypecode,
      this.unitname, this.unitnamecode, this.departmentname, this.departmentcode, this.consigneename, this.consigneecode, this.subconsigneename,this.subconsigneecode);

  @override
  State<WarrantyCrnSummaryDataScreen> createState() => _WarrantyCrnSummaryDataScreenState();
}

class _WarrantyCrnSummaryDataScreenState extends State<WarrantyCrnSummaryDataScreen> with SingleTickerProviderStateMixin{

  ScrollController listScrollController = ScrollController();
  //ScrollController totalScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    //final totextentAfter = listScrollController.position.pixels;
    Provider.of<CrcSummaryViewModel>(context, listen: false).setexpandtotal(false);
    if(extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryShowScroll(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryScrollValue(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).settopexpand(false);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 3) {
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummaryShowScroll(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false)
          .setCrcSummaryScrollValue(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false).settopexpand(false);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 5) {
      Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryShowScroll(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryScrollValue(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).settopexpand(false);
    }else if (extentAfter > 10.0) {
      Provider.of<CrcSummaryViewModel>(context, listen: false).settopexpand(false);
    } else {
      Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryShowScroll(true);
      Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryScrollValue(false);
      Provider.of<CrcSummaryViewModel>(context, listen: false).settopexpand(true);
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
    Provider.of<CrcSummaryViewModel>(context, listen: false).showhidemicglow(true);
    _speech.listen(
      onResult: (result) {
        _textsearchController.text = result.recognizedWords;
        Provider.of<CrcSummaryViewModel>(context, listen: false).searchingCRCSummaryData(_textsearchController.text, context);
        Provider.of<CrcSummaryViewModel>(context, listen: false).updatetextchangeScreen(true);
        Provider.of<CrcSummaryViewModel>(context, listen: false).showhidemicglow(false);
      },
    );
  }

  void _stopListening() {
    _speech.stop();
  }

  void hideSoftKeyBoard(bool isVisible){
    if(isVisible){
      FocusScope.of(context).requestFocus(FocusNode());
    }
    else{
      Provider.of<CrcSummaryViewModel>(context, listen: false).showhidemicglow(false);
    }
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    //totalScrollController.addListener(_onScrollEvent);
    super.initState();
    debugPrint("from date ${widget.fromdate}");
    debugPrint("to date ${widget.todate}");

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<CrcSummaryViewModel>(context, listen: false).getCrcSummaryData(
          widget.fromdate,
          widget.todate,
          widget.rlycode,
          widget.unittypecode,
          widget.unitnamecode,
          widget.departmentcode,
          widget.consigneecode,
          widget.subconsigneecode,
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
    //totalScrollController.removeListener(_onScrollEvent);
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    Provider.of<CrcSummaryViewModel>(context, listen: false).setexpandtotal(false);
    Provider.of<CrcSummaryViewModel>(context, listen: false).showhidemicglow(false);
    Provider.of<CrcSummaryViewModel>(context, listen: false).updatetextchangeScreen(false);
    Provider.of<CrcSummaryViewModel>(context, listen: false).updateScreen(false);
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
            title: Consumer<CrcSummaryViewModel>(
                builder: (context, value, child) {
                  if(value.getcrcSummarySearchValue == true) {
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
                              suffixIcon: value.getchangetextlistener == false
                                  ? IconButton(
                                icon: Icon(Icons.mic, color: Colors.red[300]),
                                onPressed: () async {
                                  hideSoftKeyBoard(KeyboardVisibilityProvider.isKeyboardVisible(context));
                                  bool isAvailable = await _isAvailable();
                                  if (isAvailable) {
                                    _startListening();
                                  } else {
                                    UdmUtilities.showInSnackBar(context, 'Speech recognition not available');
                                  }
                                },
                              ) : IconButton(
                                icon: Icon(Icons.clear, color: Colors.red[300]),
                                onPressed: () {
                                  Provider.of<CrcSummaryViewModel>(context, listen: false).updateScreen(false);
                                  _textsearchController.text = "";
                                  Provider.of<CrcSummaryViewModel>(context, listen: false).searchingCRCSummaryData(_textsearchController.text, context);
                                  Provider.of<CrcSummaryViewModel>(context, listen: false).updatetextchangeScreen(false);
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
                            if(query.isNotEmpty) {
                              value.updatetextchangeScreen(true);
                              value.showhidemicglow(false);
                              _stopListening();
                              Provider.of<CrcSummaryViewModel>(context, listen: false).searchingCRCSummaryData(query, context);
                            } else {
                              value.updatetextchangeScreen(false);
                              _textsearchController.text = "";
                              Provider.of<CrcSummaryViewModel>(context, listen: false).searchingCRCSummaryData(_textsearchController.text, context);
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
                              Provider.of<CrcSummaryViewModel>(context, listen: false).setexpandtotal(false);
                              Provider.of<CrcSummaryViewModel>(context, listen: false).showhidemicglow(false);
                              Provider.of<CrcSummaryViewModel>(context, listen: false).updatetextchangeScreen(false);
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back, color: Colors.white)),
                        SizedBox(width: 10),
                        Container(
                            height: size.height * 0.10,
                            width: size.width / 1.7,
                            child: Marquee(
                              text: " ${language.text('erstitle')}",
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
                if (value.getcrcSummarySearchValue == true) {
                  return SizedBox();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<CrcSummaryViewModel>(context, listen: false).updateScreen(true);
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
                            Provider.of<CrcSummaryViewModel>(context, listen: false).getCrcSummaryData(
                                widget.fromdate,
                                widget.todate,
                                widget.rlycode,
                                widget.unittypecode,
                                widget.unitnamecode,
                                widget.departmentcode,
                                widget.consigneecode,
                                widget.subconsigneecode,
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
          floatingActionButton: Consumer<CrcSummaryViewModel>(
              builder: (context, value, child) {
                if (value.getCrcSummaryUiShowScroll == true) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.09),
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
                              if (value.getCrcSummaryUiScrollValue == false) {
                                final position = listScrollController.position.maxScrollExtent;
                                listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                                value.setCrcSummaryScrollValue(true);
                              } else {
                                final position = listScrollController.position.minScrollExtent;
                                listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear,
                                );
                                value.setCrcSummaryScrollValue(false);
                              }
                            }
                          },
                          child: value.getCrcSummaryUiScrollValue == true
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
                     Expanded(child: Consumer<CrcSummaryViewModel>(
                         builder: (context, value, child) {
                           if(value.crcSummaryDataState == CrcSummaryDataState.Busy) {
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
                           else if(value.crcSummaryDataState == CrcSummaryDataState.Finished) {
                             return Column(
                               children: [
                                   value.topexpandvalue ? Padding(
                                     padding: EdgeInsets.all(4.0),
                                     child: Text("${language.text('desccrc')} ${widget.fromdate} ${language.text('crcto')} ${widget.todate}\n(${language.text('posason')} ${widget.todate})",
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                             fontWeight: FontWeight.w600,
                                             color: Colors.blueAccent))) : SizedBox(),
                                   value.topexpandvalue ? Container(decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.grey, width: 0.5))),
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
                                                     text: "${language.text('rly')}: ",
                                                     style: TextStyle(color: Colors.black, fontSize: 14)
                                                   ),
                                                   TextSpan(
                                                       text: "${widget.rlyname} ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)
                                                   ),
                                                   TextSpan(
                                                       text: "${language.text('unittype')} :",
                                                       style: TextStyle(color: Colors.black, fontSize: 14)
                                                   ),
                                                   TextSpan(
                                                       text: "${widget.unittypename} ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)
                                                   ),
                                                   TextSpan(
                                                       text: "${language.text('unit')}: ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14)
                                                   ),
                                                   TextSpan(
                                                       text: "${widget.unitname} ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)
                                                   ),
                                                   TextSpan(
                                                       text: "${language.text('depttitle')}: ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14)
                                                   ),
                                                   TextSpan(
                                                       text: "${widget.departmentname} ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)
                                                   ),
                                                   TextSpan(
                                                       text: "${language.text('userdepotconsignee')}:",
                                                       style: TextStyle(color: Colors.black, fontSize: 14)
                                                   ),
                                                   TextSpan(
                                                       text: "${widget.consigneename} ",
                                                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)
                                                   ),
                                                   TextSpan(
                                                       text: "(${language.text('subconsignee')}:",
                                                       style: TextStyle(color: Colors.black, fontSize: 14)
                                                   ),
                                                   TextSpan(
                                                       text: "${widget.subconsigneename})",
                                                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)
                                                   ),
                                                 ]
                                               ),
                                           ),
                                         )
                                       ],
                                     ),
                                   )
                                 ) : SizedBox(), value.topexpandvalue ? SizedBox(height: 5.0) : SizedBox(),
                                 Expanded(child: ListView.builder(
                                     itemCount: value.crcsummaryData.length,
                                     shrinkWrap: true,
                                     controller: listScrollController,
                                     padding: EdgeInsets.only(bottom: size.height * 0.09),
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
                                                             mainAxisAlignment:
                                                             MainAxisAlignment.spaceBetween,
                                                             crossAxisAlignment:
                                                             CrossAxisAlignment.start,
                                                             children: [
                                                               Column(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Text(
                                                                       language.text('nsdrly'),
                                                                       style: TextStyle(
                                                                           color: Colors
                                                                               .black,
                                                                           fontSize: 16,
                                                                           fontWeight:
                                                                           FontWeight
                                                                               .w500)),
                                                                   SizedBox(height: 4.0),
                                                                   Text(
                                                                       "${value.crcsummaryData[index].railname.toString()}",
                                                                       style: TextStyle(
                                                                           color: Colors
                                                                               .black,
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
                                                                           'nsdunittype'),
                                                                       style: TextStyle(
                                                                           color: Colors
                                                                               .black,
                                                                           fontSize: 16,
                                                                           fontWeight:
                                                                           FontWeight
                                                                               .w500)),
                                                                   SizedBox(height: 4.0),
                                                                   Text(
                                                                       "${value.crcsummaryData[index].unittype.toString()}",
                                                                       style: TextStyle(
                                                                           color: Colors
                                                                               .black,
                                                                           fontSize: 16)),
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                           SizedBox(height: 10),
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               Flexible(
                                                                 flex : 1,
                                                                 child: Container(
                                                                   child: Column(
                                                                     mainAxisAlignment:
                                                                     MainAxisAlignment.start,
                                                                     crossAxisAlignment:
                                                                     CrossAxisAlignment.start,
                                                                     children: [
                                                                       Text(
                                                                           language.text('nsdunitname'),
                                                                           style: TextStyle(
                                                                               color: Colors.black,
                                                                               fontSize: 16, fontWeight: FontWeight.w500)),
                                                                       SizedBox(height: 4.0),
                                                                       Text("${value.crcsummaryData[index].unitname.toString()}",
                                                                           maxLines: 2, style: TextStyle(color: Colors.black, fontSize: 16))
                                                                     ],
                                                                   ),
                                                                 ),
                                                               ),
                                                               Container(
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
                                                                             'nsddept'),
                                                                         style: TextStyle(
                                                                             color: Colors
                                                                                 .black,
                                                                             fontSize: 16,
                                                                             fontWeight:
                                                                             FontWeight
                                                                                 .w500)),
                                                                     SizedBox(height: 4.0),
                                                                     Text("${value.crcsummaryData[index].department.toString()}",
                                                                         style: TextStyle(
                                                                             color: Colors
                                                                                 .black,
                                                                             fontSize:
                                                                             16)),
                                                                   ],
                                                                 ),
                                                               )
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
                                                                   language.text('cons&subcons'),
                                                                   style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16,
                                                                       fontWeight:
                                                                       FontWeight.w500)),
                                                               SizedBox(height: 4.0),
                                                               Text("${value.crcsummaryData[index].consignee.toString().trim()}",
                                                                   style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontWeight:
                                                                       FontWeight.w400,
                                                                       fontSize: 16))
                                                             ],
                                                           ),
                                                           SizedBox(height: 10),
                                                           Column(
                                                             mainAxisAlignment: MainAxisAlignment.start,
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               value.crcsummaryData[index].openbal.toString() != "0" ? InkWell(
                                                                 onTap: (){
                                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(),
                                                                       widget.fromdate, widget.todate, "openBlnc", "Opening Balance of pending CRCs")));
                                                                 },
                                                                 child: Column(
                                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Text(language.text('openbalencecrc'), style: TextStyle(
                                                                         color: Colors.black,
                                                                         fontSize: 16,
                                                                         fontWeight: FontWeight.w500)),
                                                                     SizedBox(height: 4.0),
                                                                     Text(value.crcsummaryData[index].openbal.toString(), style: TextStyle(
                                                                         color: Colors.blue, fontSize: 18))
                                                                   ],
                                                                 ),
                                                               ) : Column(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Text(language.text('openbalencecrc'), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16,
                                                                       fontWeight: FontWeight.w500)),
                                                                   SizedBox(height: 4.0),
                                                                   Text(value.crcsummaryData[index].openbal.toString(), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16))
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                           SizedBox(height: 10),
                                                           Column(
                                                             mainAxisAlignment: MainAxisAlignment.start,
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               value.crcsummaryData[index].billreceived.toString() != "0" ? InkWell(
                                                                 onTap: (){
                                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(),
                                                                       widget.fromdate, widget.todate, "conrecvd", "Received Consignments")));
                                                                 },
                                                                 child: Column(
                                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Text(language.text('newconsrecvd'), style: TextStyle(
                                                                         color: Colors.black,
                                                                         fontSize: 16,
                                                                         fontWeight: FontWeight.w500)),
                                                                     SizedBox(height: 4.0),
                                                                     Text(value.crcsummaryData[index].billreceived.toString(), style: TextStyle(
                                                                         color: Colors.blue, fontSize: 18))
                                                                   ],
                                                                 ),
                                                               ) : Column(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Text(language.text('newconsrecvd'), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16,
                                                                       fontWeight: FontWeight.w500)),
                                                                   SizedBox(height: 4.0),
                                                                   Text(value.crcsummaryData[index].billreceived.toString(), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16))
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                           SizedBox(height: 10),
                                                           Column(
                                                             mainAxisAlignment: MainAxisAlignment.start,
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               value.crcsummaryData[index].billpassed.toString() != "0" ? InkWell(
                                                                 onTap: (){
                                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(), widget.fromdate, widget.todate, "crcissue", "Issued CRCs")));
                                                                 },
                                                                 child: Column(
                                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Text(language.text('conswheredigisigncrc'), style: TextStyle(
                                                                         color: Colors.black,
                                                                         fontSize: 16,
                                                                         fontWeight: FontWeight.w500)),
                                                                     SizedBox(height: 4.0),
                                                                     Text(value.crcsummaryData[index].billpassed.toString(), style: TextStyle(
                                                                         color: Colors.blue, fontSize: 18))
                                                                   ],
                                                                 ),
                                                               ) : Column(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Text(language.text('conswheredigisigncrc'), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16,
                                                                       fontWeight: FontWeight.w500)),
                                                                   SizedBox(height: 4.0),
                                                                   Text(value.crcsummaryData[index].billpassed.toString(), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16))
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                           SizedBox(height: 10),
                                                           Column(
                                                             mainAxisAlignment: MainAxisAlignment.start,
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               value.crcsummaryData[index].totalpending.toString() != "0" ? InkWell(
                                                                 onTap: (){
                                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(), widget.fromdate, widget.todate, "closingblnc", " Closing Balance of pending CRCs")));
                                                                 },
                                                                 child: Column(
                                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Text(language.text('closebalnccrc'), style: TextStyle(
                                                                         color: Colors.black,
                                                                         fontSize: 16,
                                                                         fontWeight: FontWeight.w500)),
                                                                     SizedBox(height: 4.0),
                                                                     Text(value.crcsummaryData[index].totalpending.toString(), style: TextStyle(
                                                                         color: Colors.blue, fontSize: 18))
                                                                   ],
                                                                 ),
                                                               ) : Column(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Text(language.text('closebalnccrc'), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16,
                                                                       fontWeight: FontWeight.w500)),
                                                                   SizedBox(height: 4.0),
                                                                   Text(value.crcsummaryData[index].totalpending.toString(), style: TextStyle(
                                                                       color: Colors.black,
                                                                       fontSize: 16))
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                           // SizedBox(height: 10),
                                                           // Text(language.text('breakuoppencrc'), textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                                                           // SizedBox(height: 10),
                                                           // Row(
                                                           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           //   crossAxisAlignment: CrossAxisAlignment.start,
                                                           //   children: [
                                                           //     value.crcsummaryData[index].pendsevendays.toString() != "0" ? InkWell(
                                                           //       onTap: (){
                                                           //         Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(), widget.fromdate, widget.todate, "lessseven", "CRCs pending for < 7 Days")));
                                                           //       },
                                                           //       child: Column(
                                                           //         mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('7days'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendsevendays.toString(), style: TextStyle(
                                                           //               color: Colors.blue, fontSize: 18))
                                                           //         ],
                                                           //       ),
                                                           //     ) : Column(mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('7days'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendsevendays.toString(), style: TextStyle(
                                                           //               color: Colors.black, fontSize: 16))
                                                           //         ]),
                                                           //     value.crcsummaryData[index].pendfifteendays.toString() != "0" ? InkWell(
                                                           //       onTap: (){
                                                           //         Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(), widget.fromdate, widget.todate, "seventofifteen", "CRCs pending for 7 to 15 Days")));
                                                           //       },
                                                           //       child: Column(
                                                           //         mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('7to15'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendfifteendays.toString(), style: TextStyle(
                                                           //               color: Colors.blue, fontSize: 18))
                                                           //         ],
                                                           //       ),
                                                           //     ) : Column(mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('7to15'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendfifteendays.toString(), style: TextStyle(
                                                           //               color: Colors.black, fontSize: 16))
                                                           //         ])
                                                           //   ],
                                                           // ),
                                                           // SizedBox(height: 10),
                                                           // Row(
                                                           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           //   crossAxisAlignment: CrossAxisAlignment.start,
                                                           //   children: [
                                                           //     value.crcsummaryData[index].pendthirtydays.toString() != "0" ? InkWell(
                                                           //       onTap: (){
                                                           //         Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(), widget.fromdate, widget.todate, "fifteentothirty", "CRCs pending for 15 to 30 Days")));
                                                           //       },
                                                           //       child: Column(
                                                           //         mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('15to30'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendthirtydays.toString(), style: TextStyle(
                                                           //               color: Colors.blue, fontSize: 18))
                                                           //         ],
                                                           //       ),
                                                           //     ) : Column(mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('15to30'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendthirtydays.toString(), style: TextStyle(
                                                           //               color: Colors.black, fontSize: 16))
                                                           //         ]),
                                                           //     value.crcsummaryData[index].pendmorethirty.toString() != "0" ? InkWell(
                                                           //       onTap: (){
                                                           //         Navigator.push(context, MaterialPageRoute(builder: (context) => CrcSummarylinkDataScreen(value.rlyCode, value.crcsummaryData[index].conscode.toString(), value.crcsummaryData[index].subconscode.toString(), widget.fromdate, widget.todate, "morethirty", "CRCs pending for > 30 Days")));
                                                           //       },
                                                           //       child: Column(
                                                           //         mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('30d'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendmorethirty.toString(), style: TextStyle(
                                                           //               color: Colors.blue, fontSize: 18))
                                                           //         ],
                                                           //       ),
                                                           //     ) : Column(mainAxisAlignment: MainAxisAlignment.start,
                                                           //         crossAxisAlignment: CrossAxisAlignment.start,
                                                           //         children: [
                                                           //           Text(language.text('30d'), style: TextStyle(
                                                           //               color: Colors.black,
                                                           //               fontSize: 16,
                                                           //               fontWeight: FontWeight.w500)),
                                                           //           SizedBox(height: 4.0),
                                                           //           Text(value.crcsummaryData[index].pendmorethirty.toString(), style: TextStyle(
                                                           //               color: Colors.black, fontSize: 16))
                                                           //         ])
                                                           //   ],
                                                           // ),
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
                             );}
                           else if(value.crcSummaryDataState == CrcSummaryDataState.NoData) {
                             return Center(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Lottie.asset('assets/json/no_data.json',height: 120, width: 120),
                                   AnimatedTextKit(
                                       isRepeatingAnimation: false,
                                       animatedTexts: [
                                         TyperAnimatedText(language.text('dnf'),
                                             speed: Duration(milliseconds: 150),
                                             textStyle: TextStyle(
                                                 fontWeight: FontWeight.bold)),
                                       ]
                                   )
                                 ],
                               ),
                             );
                           }
                           else if(value.crcSummaryDataState == CrcSummaryDataState.FinishedWithError) {
                             return Center(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset('assets/no_data.png', height: 85, width: 85),
                                   InkWell(
                                     onTap: () {

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
                         })
                     ),
                   ],
                 ),
                 Consumer<CrcSummaryViewModel>(
                   builder: (context, value, child) {
                     return Positioned(
                       bottom: size.height * 0.10,
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
                 showtotalDialog()
               ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showtotalDialog() {
    LanguageProvider language = Provider.of<LanguageProvider>(context, listen: false);
    return Consumer<CrcSummaryViewModel>(
      builder: (context, value, child) {
        return DraggableScrollableSheet(
          initialChildSize: value.expandvalue == true ? .45 : .1,
          minChildSize: value.expandvalue == true ? .45 : .1,
          maxChildSize: .45,
          //snap: value.expandvalue,
          //expand: value.expandvalue,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFDEDDE),
                    border: Border.all(color: Colors.red.shade200, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: ListView(
                  //controller: totalScrollController,
                  physics: value.expandvalue == true
                      ? AlwaysScrollableScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  children: [
                    Padding(padding: EdgeInsets.only(left: 15.0, right: 5.0, top: 5.0, bottom: 15.0), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(language.text('grandtotal'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: AvatarGlow(
                            endRadius: 25,
                            animate: true,
                            glowColor: Colors.blue.shade400,
                            child: IconButton(
                                onPressed: () {
                                  if(value.expandvalue) {
                                    _animationController.reset();
                                    value.setexpandtotal(false);
                                    Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryShowScroll(true);
                                  } else {
                                    _animationController.forward();
                                    value.setexpandtotal(true);
                                    Provider.of<CrcSummaryViewModel>(context, listen: false).setCrcSummaryShowScroll(false);
                                  }
                                },
                                icon: value.expandvalue == true
                                    ? Icon(Icons.arrow_circle_down_rounded,
                                    size: 32, color: Colors.blue)
                                    : Icon(Icons.arrow_circle_up_rounded,
                                    size: 32, color: Colors.blue)),
                          ),
                        ),
                      ],
                    )),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.text('openbalencecrc'), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                              SizedBox(height: 4.0),
                              Text(value.openblnctotal.toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.text('newconsrecvd'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                              SizedBox(height: 4.0),
                              Text(value.newconsrcvdtotal.toString(), style: TextStyle(color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.text('conswheredigisigncrc'), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                              SizedBox(height: 4.0),
                              Text(value.signedcrcissuetotal.toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.text('closebalnccrc'), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                              SizedBox(height: 4.0),
                              Text(value.crcpendingtotal.toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16))
                            ],
                          ),
                          // SizedBox(height: 10),
                          // Text(language.text('breakuoppencrc'), textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          // SizedBox(height: 10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Column(
                          //        mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(language.text('7days'), style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500)),
                          //           SizedBox(height: 4.0),
                          //           Text(value.seventotal.toString(), style: TextStyle(
                          //               color: Colors.black, fontSize: 16))
                          //         ]),
                          //     Column(mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(language.text('7to15'), style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500)),
                          //           SizedBox(height: 4.0),
                          //           Text(value.seventofiftytotal.toString(), style: TextStyle(
                          //               color: Colors.black, fontSize: 16))
                          //         ])
                          //   ],
                          // ),
                          // SizedBox(height: 10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Column(mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(language.text('15to30'), style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500)),
                          //           SizedBox(height: 4.0),
                          //           Text(value.fiftytothirtytotal.toString(), style: TextStyle(
                          //               color: Colors.black, fontSize: 16))
                          //         ]),
                          //     Column(mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(language.text('30d'), style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500)),
                          //           SizedBox(height: 4.0),
                          //           Text(value.morethirtytotal.toString(), style: TextStyle(
                          //               color: Colors.black, fontSize: 16))
                          //         ])
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
