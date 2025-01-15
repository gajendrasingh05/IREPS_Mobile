import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
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
import '../models/item.dart';
import 'item_details.dart';
import 'package:share_plus/share_plus.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = "/item-screen";

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen>
    with SingleTickerProviderStateMixin {
  late ItemListProvider itemListProvider;
  bool _isAtEnd = false;
  @override
  void initState() {
    itemListProvider = Provider.of<ItemListProvider>(context, listen: false);
    FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton').then((value) {
      if(value == true) {
        setState(() {
          _isDiscovering = false;
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Future.delayed(Duration.zero, () => itemListProvider.fetchAndStoreItemsList());
    super.didChangeDependencies();
  }

  _totalValue(List<Item> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].rate != 'NA') {
        totalValue = totalValue + double.parse(list[i].rate)*double.parse(list[i].qty);
        assert(totalValue is double);
      }
    }
    return totalValue.toStringAsFixed(2);
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
        floatingActionButton: _showFAB
            ? IRUDMConstants().floatingAnimat(
            _isScrolling, _isDiscovering, this, _scrollController, context)
            : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(title: language.text('itemList'), labelData: 'itemData'),
        body: Stack(children: [
          Consumer<ItemListProvider>(builder: (_, itemsListProvider, __) {
            if (itemsListProvider.state == ItemListState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (itemsListProvider.state == ItemListState.FinishedWithError) {
              Future.delayed(
                  Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      itemListProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )));
              return Container();
            } else if (itemListProvider.state == ItemListState.Finished) {
              Future.delayed(Duration.zero, () {
                if (_isInit) {
                  setState(() {
                    _showFAB = itemListProvider.itemList!.length > 20;
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
                              Text(language.text('totalCount')),
                              SizedBox(
                                height: 3,
                              ),
                              IRUDMConstants.resultCount(itemsListProvider.countData, true),
                            ],
                          ),
                          Container(
                              height: 50,
                              child: VerticalDivider(color: Colors.grey)),
                          Column(
                            children: [
                              Text('${language.text('totalVal')}'),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                _totalValue(itemsListProvider.itemList!)
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                              itemCount: itemsListProvider.itemList!.length + 1,
                              itemBuilder: (_, i) {
                                if (i < itemsListProvider.itemList!.length) {
                                  return ProductBox(
                                    item: itemsListProvider.itemList![i],
                                    index: i,
                                  );
                                }
                                return const SizedBox(height: 75);
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: MediaQuery.of(context).size.width / 2 - 56,
                            child: MaterialButton(
                              onPressed: () {
                                ackAlert(context);
                              },
                              color: Color(0xffffff00),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(language.text('summary')),
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
            //margin: EdgeInsets.only(top : 10),
              padding: EdgeInsets.only(bottom: 50),
              color: Colors.white,
              child: Column(children: <Widget>[
                /*  Align(
                child: Text("Items Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black87),
              ),
              ),
             */
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: summaryList(context,itemListProvider.summaryList!),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "${language.text('totalVal')} = " +itemListProvider.stkValue.toStringAsFixed(2),
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
      columnSpacing: MediaQuery.of(context).size.width / 15,
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
      rows:
      itemSumary // Loops through dataColumnText, each iteration assigning the value to element
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
  final Item item;
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
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
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
                        color: const Color(0xFFFDEDDE),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7.0,
                            horizontal: 12,
                          ).copyWith(right: 0),
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
                                            language.text('department'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Text(widget.item.isscongDept),
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
                                            language.text('railway'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.rlyName),
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
                                            language.text('userDepot'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.depoDetail),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //SizedBox(height: 7),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: CircleIconData(
                                  radius: 35,
                                  fontSize: 17,
                                  textBgHeight: 50,
                                  circleBackgroundColor: Colors.red[100],
                                  valueTextBackgroundColor: Colors.white70,
                                  valueTextColor: Colors.black,
                                  descriptionTextColor: Colors.grey[700],
                                  value: widget.item.cons_code,
                                  description: language.text('consigneeCode'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(7.0).copyWith(left: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              language.text('pl/itemCode'),
                              style: _normalTextStyle,
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(widget.item.item_code),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0).copyWith(left: 17),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                language.text('ledgerName'),
                                style: _normalTextStyle,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(widget.item.ledger_name ?? 'NA'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0).copyWith(left: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                language.text('itemCategory'),
                                style: _normalTextStyle,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(widget.item.itemcat),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0).copyWith(left: 17),
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 200),
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                                widget.item.folioName +
                                    " : " +
                                    widget.item.description,
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
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 17, top: 10),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 32,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF84BA6B),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 40,
                                //width: 80,
                                //alignment: Alignment.center,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: -16,
                                      left: -12,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.green[900]!,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          language.text('rate'),
                                          style: TextStyle(
                                            color: Colors.green[900],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.rupeeSign,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              widget.item.rate,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 32,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF67C7C1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 40,
                                width: 40,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: -16,
                                      left: -12,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.cyan[900]!,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          language.text('quantity'),
                                          style: TextStyle(
                                            color: Colors.cyan[900],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.hashtag,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              widget.item.qty +
                                                  " " +
                                                  widget.item.unit,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.item.plimagePath != "NA")
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                //fixedSize: Size(115, 36),
                              ),
                              onPressed: () {
                                Future.delayed(Duration.zero, () {
                                  IRUDMConstants.launchURL(
                                      IRUDMConstants.webUrl +
                                          widget.item.plimagePath);
                                });
                              },
                              //color: Theme.of(context).accentColor,
                              child: const Icon(
                                Icons.image,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.red.shade300
                            ),
                            onPressed: () => _onShareData(
                                "Consignee : " +
                                    widget.item.depoDetail +
                                    "\n" +
                                    widget.item.cons_code +
                                    " - " +
                                    widget.item.isscongDept +
                                    "\n" +
                                    widget.item.rlyName +
                                    "\nPL/Item Code : " +
                                    widget.item.item_code +
                                    "\nUser Depot : " +
                                    widget.item.depoDetail +
                                    "\nLedger Name : " +
                                    widget.item.ledger_name +
                                    "\nItem Category : " +
                                    widget.item.itemcat +
                                    "\nStock Quantity :" +
                                    widget.item.qty.toString() +
                                    " " +
                                    widget.item.unit +
                                    "\nUnit Rate : Rs" +
                                    widget.item.booavgrat +
                                    "\nItem Description : " +
                                    widget.item.description +
                                    ""
                                        "\n",
                                context),

                            //color: Theme.of(context).accentColor,
                            child: const Icon(
                              Icons.share,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(), backgroundColor: Colors.red.shade300
                            ),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemDetails(
                                          widget.item.orgZone,
                                          widget.item.cons_code,
                                          widget.item.subConsCode)),
                                );
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
    required this.circleBackgroundColor,

    required this.valueTextBackgroundColor,
    required this.valueTextColor,
    required this.descriptionTextColor,
    required this.value,
    required this.description,
    required this.textBgHeight,
    required this.radius,
    required this.fontSize,
    this.shouldSeparate = true,
  }) : super(key: key);


  final Color? circleBackgroundColor;

  final Color valueTextBackgroundColor;
  final Color valueTextColor;
  final Color? descriptionTextColor;
  final String? value;
  final String description;
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
        return val;
      }, onNonMatch: (str) {
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