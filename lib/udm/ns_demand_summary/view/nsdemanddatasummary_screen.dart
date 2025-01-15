import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/change_nsdscroll_visibility_provider.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/search_nsdscreen_provider.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/NSDemandlinkScreen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/NSDemandtotallinkScreen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view_model/NSDemandSummaryViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NSDemandDataSummaryScreen extends StatefulWidget {
  static const routeName = "/ns-demanddata-screen";

  final String? fromdate;
  final String? todate;
  final String? rly;
  final String? unittype;
  final String? unitname;
  final String? department;
  final String? consignee;
  final String? indentorcode;
  final String? indentorname;
  NSDemandDataSummaryScreen(this.fromdate, this.todate, this.rly, this.unittype,
      this.unitname, this.department, this.consignee, this.indentorcode, this.indentorname);

  @override
  State<NSDemandDataSummaryScreen> createState() =>
      _NSDemandDataSummaryScreenState();
}

class _NSDemandDataSummaryScreenState extends State<NSDemandDataSummaryScreen> with SingleTickerProviderStateMixin{
  ScrollController listScrollController = ScrollController();
  //ScrollController totalScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    //final totextentAfter = listScrollController.position.pixels;
    Provider.of<NSDemandSummaryViewModel>(context, listen: false)
        .setexpandtotal(false);
    if (extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setNSDShowScroll(false);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(false);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 3) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setNSDShowScroll(true);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(true);
    } else if (extentAfter >
        listScrollController.position.maxScrollExtent / 5) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setNSDShowScroll(true);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(false);
    } else {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setNSDShowScroll(true);
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false)
          .setRWADCScrollValue(false);
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
    Provider.of<SearchNSDScreenProvider>(context, listen: false)
        .showhidemicglow(true);
    _speech.listen(
      onResult: (result) {
        _textsearchController.text = result.recognizedWords;
        Provider.of<NSDemandSummaryViewModel>(context, listen: false)
            .searchingNSDMD(_textsearchController.text, context);
        Provider.of<SearchNSDScreenProvider>(context, listen: false)
            .updatetextchangeScreen(true);
        Provider.of<SearchNSDScreenProvider>(context, listen: false)
            .showhidemicglow(false);
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
      Provider.of<SearchNSDScreenProvider>(context, listen: false).showhidemicglow(false);
    }
  }

  //final keyOne = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    //totalScrollController.addListener(_onScrollEvent);
    super.initState();
    // print("from date ${widget.fromdate}");
    // print("to date ${widget.fromdate}");
    // print("Railway code ${widget.rly}");
    // print("unit type ${widget.unittype}");
    // print("unit name ${widget.unitname}");
    // print("Department ${widget.department}");
    // print("Consignee ${widget.consignee}");
    // print("Indentor name ${widget.indentorname}");
    // print("Indentor code ${widget.indentorcode}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<NSDemandSummaryViewModel>(context, listen: false).getNSDemandData(
              widget.fromdate,
              widget.todate,
              widget.rly,
              widget.unittype,
              widget.unitname,
              widget.department,
              widget.consignee,
              widget.indentorname,
              widget.indentorcode,
              context);
    });

    //WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([keyOne]));

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
    Provider.of<NSDemandSummaryViewModel>(context, listen: false)
        .setexpandtotal(false);
    Provider.of<SearchNSDScreenProvider>(context, listen: false)
        .showhidemicglow(false);
    Provider.of<SearchNSDScreenProvider>(context, listen: false).updatetextchangeScreen(false);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return KeyboardVisibilityProvider(child: WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          title: Consumer<SearchNSDScreenProvider>(
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
                            )
                                : IconButton(
                              icon: Icon(Icons.clear, color: Colors.red[300]),
                              onPressed: () {
                                Provider.of<SearchNSDScreenProvider>(context,
                                    listen: false)
                                    .updateScreen(false);
                                _textsearchController.text = "";
                                Provider.of<NSDemandSummaryViewModel>(context,
                                    listen: false)
                                    .searchingNSDMD(
                                    _textsearchController.text, context);
                                Provider.of<SearchNSDScreenProvider>(context,
                                    listen: false)
                                    .updatetextchangeScreen(false);
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
                            Provider.of<NSDemandSummaryViewModel>(context,
                                listen: false)
                                .searchingNSDMD(query, context);
                          } else {
                            value.updatetextchangeScreen(false);
                            _textsearchController.text = "";
                            Provider.of<NSDemandSummaryViewModel>(context,
                                listen: false)
                                .searchingNSDMD(
                                _textsearchController.text, context);
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
                            Provider.of<NSDemandSummaryViewModel>(context, listen: false).setexpandtotal(false);
                            Provider.of<SearchNSDScreenProvider>(context, listen: false).showhidemicglow(false);
                            Provider.of<SearchNSDScreenProvider>(context, listen: false).updatetextchangeScreen(false);
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
            Consumer<SearchNSDScreenProvider>(builder: (context, value, child) {
              if (value.getrwadSearchValue == true) {
                return SizedBox();
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<SearchNSDScreenProvider>(context,
                            listen: false)
                            .updateScreen(true);
                      },
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        // PopupMenuItem(
                        //   value: 'total',
                        //   child: Text(language.text('total'),
                        //       style: TextStyle(color: Colors.black)),
                        // ),
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
                          Provider.of<NSDemandSummaryViewModel>(context,
                              listen: false)
                              .getNSDemandData(
                              widget.fromdate,
                              widget.todate,
                              widget.rly,
                              widget.unittype,
                              widget.unitname,
                              widget.department,
                              widget.consignee,
                              widget.indentorcode,
                              widget.indentorname,
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
        floatingActionButton: Consumer<ChangeNSDScrollVisibilityProvider>(
            builder: (context, value, child) {
              if (value.getNSDUiShowScroll == true) {
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
                            if (value.getNSDUiScrollValue == false) {
                              final position = listScrollController.position.maxScrollExtent;
                              listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear);
                              value.setRWADCScrollValue(true);
                            } else {
                              final position = listScrollController.position.minScrollExtent;
                              listScrollController.animateTo(position, duration: Duration(seconds: 3), curve: Curves.easeInToLinear,
                              );
                              value.setRWADCScrollValue(false);
                            }
                          }
                        },
                        child: value.getNSDUiScrollValue == true
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
                  Expanded(child: Consumer<NSDemandSummaryViewModel>(
                      builder: (context, value, child) {
                        if (value.nsDataState == NSDemandDataState.Busy) {
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
                        } else if (value.nsDataState ==
                            NSDemandDataState.Finished) {
                          return ListView.builder(
                              itemCount: value.nslistData.length,
                              shrinkWrap: true,
                              controller: listScrollController,
                              padding: EdgeInsets.only(bottom: size.height * 0.09),
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
                                                                "${value.nslistData[index].orgzone.toString()}",
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
                                                                "${value.nslistData[index].unittypename.toString()}",
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
                                                                Text("${value.nslistData[index].unitname.toString()}",
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
                                                              Text(
                                                                  "${value.nslistData[index].deptname.toString()}",
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
                                                            language.text('nsdcon'),
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.nslistData[index].ccode.toString()}/${value.nslistData[index].cname.toString().trim()}",
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
                                                            language.text(
                                                                'nsdindentor'),
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                            "${value.nslistData[index].indentorname.toString()}-${value.nslistData[index].initiatedbydesig.toString()}",
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
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        value.nslistData[index].total.toString() != "0" ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "1", "-1","-1", "-1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                                          },
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
                                                                      'total'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].total.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize:
                                                                      18))
                                                            ],
                                                          ),
                                                        ) : Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                                language.text(
                                                                    'total'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            SizedBox(height: 4.0),
                                                            Text(
                                                                "${value.nslistData[index].total.toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    16))
                                                          ],
                                                        ),
                                                        value.nslistData[index].draft.toString() != "0" ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "1","-1", "-1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                                          },
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
                                                                      'drf'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].draft.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize:
                                                                      18)),
                                                            ],
                                                          ),
                                                        ) : Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(language.text('drf'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                            SizedBox(height: 4.0),
                                                            Text("${value.nslistData[index].draft.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        value.nslistData[index].underfinanceconcurrence.toString() != "0" ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "-1","1", "-1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                                          },
                                                          child: Container(
                                                            width:
                                                            size.width *
                                                                0.35,
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
                                                                        'ufc'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                Text(
                                                                    "${value.nslistData[index].underfinanceconcurrence.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                        18))
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                            : Container(
                                                          width: size.width *
                                                              0.35,
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
                                                                      'ufc'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].underfinanceconcurrence.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16))
                                                            ],
                                                          ),
                                                        ),
                                                        value.nslistData[index]
                                                            .underfinancevetting !=
                                                            "0"
                                                            ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "-1","-1", "1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                                          },
                                                          child: Container(
                                                            width:
                                                            size.width *
                                                                0.35,
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
                                                                        'ufv'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                Text(
                                                                    "${value.nslistData[index].underfinancevetting.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                        18)),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                            : Container(
                                                          width: size.width *
                                                              0.35,
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
                                                                      'ufv'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(
                                                                  "${value.nslistData[index].underfinancevetting.toString()}",
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
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        value.nslistData[index]
                                                            .underprocess
                                                            .toString() !=
                                                            "0"
                                                            ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "-1","-1", "-1", "1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                                          },
                                                          child: Container(
                                                            width:
                                                            size.width *
                                                                0.35,
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
                                                                        'underprc'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                Text(
                                                                    "${value.nslistData[index].underprocess.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                        18)),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                            : Container(
                                                          width: size.width *
                                                              0.35,
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
                                                                      'underprc'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].underprocess.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16)),
                                                            ],
                                                          ),
                                                        ),
                                                        value.nslistData[index]
                                                            .approved
                                                            .toString() !=
                                                            "0"
                                                            ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "-1","-1", "-1", "-1","1","-1", "-1", widget.fromdate, widget.todate)));
                                                          },
                                                          child: Container(
                                                            width:
                                                            size.width *
                                                                0.35,
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
                                                                        'apfwd'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                Text(
                                                                    "${value.nslistData[index].approved.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                        18)),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                            : Container(
                                                          width: size.width *
                                                              0.35,
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
                                                                      'apfwd'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].approved.toString()}",
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
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        value.nslistData[index]
                                                            .returned
                                                            .toString() !=
                                                            "0"
                                                            ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "-1","-1", "-1", "-1","-1","1", "-1", widget.fromdate, widget.todate)));
                                                          },
                                                          child: Container(
                                                            width:
                                                            size.width *
                                                                0.35,
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
                                                                        'rtpurchase'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                Text(
                                                                    "${value.nslistData[index].returned.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                        18))
                                                              ],
                                                            ),
                                                          ),
                                                        ) : Container(
                                                          width: size.width *
                                                              0.35,
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
                                                                      'rtpurchase'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].returned.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16))
                                                            ],
                                                          ),
                                                        ),
                                                        value.nslistData[index]
                                                            .dropped
                                                            .toString() !=
                                                            "0"
                                                            ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandlinkScreen(value.nslistData[index].indentorpost, value.nslistData[index].indentorname, "-1", "-1","-1", "-1", "-1","-1","-1", "1", widget.fromdate, widget.todate)));
                                                          },
                                                          child: Container(
                                                            width:
                                                            size.width *
                                                                0.35,
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
                                                                        'dropped'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child: Text(
                                                                        "${value.nslistData[index].dropped.toString()}",
                                                                        style: TextStyle(
                                                                            color: Colors.blue,
                                                                            fontSize: 18))),
                                                              ],
                                                            ),
                                                          ),
                                                        ) : Container(
                                                          width: size.width *
                                                              0.35,
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
                                                                      'dropped'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(
                                                                  height:
                                                                  4.0),
                                                              Text(
                                                                  "${value.nslistData[index].dropped.toString()}",
                                                                  style: TextStyle(
                                                                      color:
                                                                      Colors.black,
                                                                      fontSize: 16)),
                                                            ],
                                                          ),
                                                        )
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
                        else if (value.nsDataState == NSDemandDataState.NoData) {
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
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ])
                              ],
                            ),
                          );
                        }
                        else if (value.nsDataState == NSDemandDataState.FinishedWithError) {
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
                                    Provider.of<NSDemandSummaryViewModel>(context,
                                        listen: false)
                                        .getNSDemandData(
                                        widget.fromdate,
                                        widget.todate,
                                        widget.rly,
                                        widget.unittype,
                                        widget.unitname,
                                        widget.department,
                                        widget.consignee,
                                        widget.indentorcode,
                                        widget.indentorname,
                                        context);
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
                        } else {
                          return SizedBox();
                        }
                      })),
                ],
              ),
              Consumer<SearchNSDScreenProvider>(
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
    ));
  }

  Widget showtotalDialog() {
    LanguageProvider language = Provider.of<LanguageProvider>(context, listen: false);
    return Consumer<NSDemandSummaryViewModel>(
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
                          child: Text(language.text('total'),
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
                                    Provider.of<ChangeNSDScrollVisibilityProvider>(
                                        context,
                                        listen: false)
                                        .setNSDShowScroll(true);
                                  } else {
                                    _animationController.forward();
                                    value.setexpandtotal(true);
                                    Provider.of<ChangeNSDScrollVisibilityProvider>(
                                        context,
                                        listen: false)
                                        .setNSDShowScroll(false);
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('total'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.total == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                     onTap: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "1", "-1","-1", "-1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                     },
                                    child: Text(value.total.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('drf'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              value.draft == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "1","-1", "-1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text(value.draft.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('ufc'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.ufc == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "-1","1", "-1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text(value.ufc.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('ufv'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.ufv == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "-1","-1", "1", "-1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text(value.ufv.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('underprc'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.underprc == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "-1","-1", "-1", "1","-1","-1", "-1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text(value.underprc.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('apfwd'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.appfwdpur == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "-1","-1", "-1", "-1","1","-1", "-1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text("${value.appfwdpur.toString()}",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('rtpurchase'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.rbypurunit == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "-1","-1", "-1", "-1","-1","1", "-1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text("${value.rbypurunit.toString()}",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('dropped'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.0),
                              value.drpped == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandtotallinkScreen(widget.rly, widget.unittype, widget.unitname, widget.department, widget.indentorcode, widget.consignee, widget.indentorname, "-1", "-1","-1", "-1", "-1","-1","-1", "1", widget.fromdate, widget.todate)));
                                    },
                                    child: Text("${value.drpped.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                        fontSize: 16)),
                                  )
                            ],
                          ),
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


  void dismissBottomSheet(context) {
    Navigator.pop(context);
  }
}
