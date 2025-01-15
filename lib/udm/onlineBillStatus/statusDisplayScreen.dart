import 'dart:async';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/widgets/custom_progress_indicator.dart';
import '../helpers/shared_data.dart';
import '../models/item_summary.dart';
import '../providers/itemsProvider.dart';
import '../widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusModel.dart';
import 'actionPage.dart';
import 'actionProvider.dart';


class StatusDiaplayScreen extends StatefulWidget {
  static const routeName = "/statusDisplay-screen";

  @override
  State<StatusDiaplayScreen> createState() => _StatusDiaplayScreenState();
}

class _StatusDiaplayScreenState extends State<StatusDiaplayScreen> with SingleTickerProviderStateMixin {
  //  final _listSearchDelegate _delegate = _listSearchDelegate();
  late StatusProvider statusProvider;
  bool _isAtEnd = false;

  TextStyle _normalTextStyle = TextStyle(
    color: Colors.redAccent,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  @override
  void initState() {
    //  saveToDB();
    statusProvider = Provider.of<StatusProvider>(context, listen: false);
    FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton')
        .then((value) {
      if (value == true) {
        setState(() {
          _isDiscovering = false;
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("status provider called");
    /* Future.delayed(
        Duration.zero, () => itemListProvider.fetchAndStoreItemsList());*/
    super.didChangeDependencies();
  }

  ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;



  var totalValue = 0.0;
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        floatingActionButton: _showFAB ? IRUDMConstants().floatingAnimat(_isScrolling, _isDiscovering, this, _scrollController, context) : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(
            title: language.text('billstatus'), labelData: 'statusData'),
        body: Stack(children: [
          Consumer<StatusProvider>(builder: (_, stateProvider, __) {
            if (stateProvider.state == StatusListState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (stateProvider.state == StatusListState.FinishedWithError) {
              Future.delayed(
                  Duration.zero,
                      () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      statusProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )));
              return Container();
            } else if (statusProvider.state == StatusListState.Finished) {
              Future.delayed(Duration.zero, () {
                if (_isInit) {
                  setState(() {
                    _showFAB = statusProvider.itemList!.length > 20;
                    _isScrolling = false;
                  });
                }
              }).then((value) async {
                if (_isInit)
                  FeatureDiscovery.discoverFeatures(context, {'JumpButton'});
                _isInit = false;
              });
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotif) {
                  if (scrollNotif is ScrollStartNotification ||
                      scrollNotif is ScrollUpdateNotification) {
                    setState(() {
                      _isScrolling = true;
                    });
                  }
                  if (scrollNotif is ScrollEndNotification) {
                    setState(() {
                      _isScrolling = false;
                    });
                  }
                  return false;
                },
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(language.text('totalCount'),
                                style: _normalTextStyle,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              IRUDMConstants.resultCount(
                                  stateProvider.countData, true),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Scrollbar(
                            thumbVisibility: true,
                            thickness: 8,
                            radius: Radius.circular(20),
                            // interactive: true,
                            controller: _scrollController,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: stateProvider.itemList!.length + 1,
                              itemBuilder: (_, i) {
                                if (i < stateProvider.itemList!.length) {
                                  return ProductBox(
                                    item: stateProvider.itemList![i],
                                    index: i,
                                  );
                                }
                                return const SizedBox(height: 75);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
        ]));
  }


  ackAlert(BuildContext context) {
    LanguageProvider language =
    Provider.of<LanguageProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder:
            (_) => Scaffold(
          body: Container(
              padding: EdgeInsets.only(bottom: 50),
              color: Colors.white,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "${language.text('totalVal')} = " +statusProvider.stkValue.toStringAsFixed(2),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue[700]),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      },
                      child:Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close,color: Colors.black87),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          border: Border.all(
                            width: 3,
                            color: Colors.blue[700]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    )
                ),
              ])),
        ));

  }



  Widget summaryList(BuildContext context, List<ItemSummary> itemSumary) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return DataTable(
      columnSpacing: MediaQuery.of(context).size.width / 13,
      showBottomBorder: true,
      columns: [
        DataColumn(
            label: FittedBox(
              child: Text(language.text('totalQuantity'),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            )),
        DataColumn(
          label: FittedBox(
            child: Text(
              language.text('unit'),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
        ),
        DataColumn(
            label: FittedBox(
              child: Text('${language.text('totalVal')}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            )),
      ],
      rows: itemSumary // Loops through dataColumnText, each iteration assigning the value to element
          .map(
        ((element) => DataRow(
          color: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (itemSumary.indexOf(element) % 2 == 0) {
                  return Colors.grey.shade300;
                }else{
                  return Colors.transparent;
                }
                // Use default value for other states and odd rows.
              }),
          selected: itemSumary.length % 2 == 0 ? true : false,
          cells: <DataCell>[
            DataCell(Text(
              element.totalqty!,
              style: TextStyle(color: Colors.black87),
            )),
            DataCell(Text(
              element.unitname!,
              style: TextStyle(color: Colors.black87),
            )),
            DataCell(Text(
              element.totalval!,
              style: TextStyle(color: Colors.black87),
            )),
          ],
        )),
      )
          .toList(),
    );
  }
}

class ProductBox extends StatefulWidget {
  final Status item;
  final int index;

  const ProductBox({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox>
    with SingleTickerProviderStateMixin {
  late final LanguageProvider language;
  @override
  void didChangeDependencies() {
    language = Provider.of<LanguageProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _cardTextStyle = TextStyle(
      color: Colors.indigo[900],
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    TextStyle _normalTextStyle = TextStyle(
      color: Colors.blue[900],
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 6, top: 9, right: 6),
          child: Card(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7.0,
                            horizontal: 12,)
                              .copyWith(right: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('consrly'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.cONSRLY),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('consname'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Text(widget.item.cONSIGNEE+
                                                " : " +widget.item.cONSNAME),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('ponumber'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.pONUMBER+
                                                " : " +widget.item.pODATE),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('posr'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.pOSR),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('accountname'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Text(widget.item.aCCOUNTNAME),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          language.text('itemDescription'),
                                          style: _normalTextStyle,
                                        ),
                                        const Expanded(
                                          child: SizedBox(width: 1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    ReadMoreText(
                                      /* widget.item.folioName +
                                    " : " +*/
                                      widget.item.iTEMDESCRIPTION,
                                      style: TextStyle(
                                        color: Colors.orange[900],
                                      ),
                                      trimLines: 2,
                                      colorClickableText: Colors.blue[700],
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText:
                                      ' ...${language.text('more')}',
                                      trimExpandedText:
                                      ' ...${language.text('less')}',
                                      delimiter: '',
                                    ),
                                    //SizedBox(height: 7),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.red.shade300
                              ),
                              onPressed: () {
                                //_formKey.currentState.save();
                                setState(() {
                                  //  reseteValues();
                                  var actionProvider =
                                  Provider.of<ActionProvider>(context, listen: false);
                                  Navigator.of(context)
                                      .pushNamed(ActionPage.routeName);
                                  actionProvider.fetchActionData(
                                      widget.item.rlyCode!,
                                      widget.item.pONUMBER!,
                                      widget.item.pOSR!,
                                      context);
                                });
                              },
                              //color: Theme.of(context).accentColor,
                              child: Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -7,
                  top: -10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue[700]!, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.white,
                      child: Text(
                        (widget.index + 1).toString(),
                        softWrap: false,
                        style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}

class CircleIconData extends StatelessWidget {
  const CircleIconData({
    Key? key,
    //@required this.opacity,
    //@required this.iconData,
    required this.circleBackgroundColor,
    //@required this.iconColor,
    required this.valueTextBackgroundColor,
    required this.valueTextColor,
    required this.descriptionTextColor,
    required this.value,
    required this.description,
    //@required this.iconSize,
    required this.textBgHeight,
    required this.radius,
    required this.fontSize,
    this.shouldSeparate = true,
  }) : super(key: key);

  //final double opacity;
  //final IconData iconData;
  final Color? circleBackgroundColor;
  //final Color iconColor;
  final Color valueTextBackgroundColor;
  final Color valueTextColor;
  final Color? descriptionTextColor;
  final String? value;
  final String description;
  //final double iconSize;
  final double textBgHeight;
  final double radius;
  final double fontSize;
  final bool shouldSeparate;
  @override
  Widget build(BuildContext context) {
    List<String> wordsList = value!.split(RegExp(r'[^a-zA-Z0-9]'));
    String? usableVal;
    if (shouldSeparate) {
      usableVal = value!.splitMapJoin(RegExp(r'[^a-zA-Z0-9]'), onMatch: (str) {
        String val = value!.substring(str.start, str.end).trim();
        //print(val);
        return val;
      }, onNonMatch: (str) {
        //print(str);
        return '\n' + str.trim();
      }).substring(1);
    } else {
      usableVal = value;
    }
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          backgroundColor: circleBackgroundColor,
          radius: radius,
          child: ClipOval(
            child: Center(
              child: Container(
                //alignment: Alignment.,
                color: valueTextBackgroundColor,
                constraints: BoxConstraints(
                  maxHeight: radius * 2 - 10,
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(3),

                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    usableVal!,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize,
                      color: valueTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Center(
          child: Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize * 0.8,
              color: descriptionTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}




