import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/item_receipt_text_widget.dart';

class ItemReceiptDetails extends StatelessWidget {
  const ItemReceiptDetails({Key? key}) : super(key: key);

  static const String routeName = '/item-receipt-details';

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    String transCode = ModalRoute.of(context)!.settings.arguments as String;
    String? railway;
    String? cdCode;
    String? receivingDepot;
    String? subDepot;
    String? ward;
    String? plNo;
    String? demandNo;
    String? demandDate;
    String? itemUnit;
    String? itemQuantity;
    String? issueNoteNo;
    String? issueDate;
    String? itemCategory;
    String? issueDepotShop;
    String? remarks;
    String? receivingOfficial;
    String? itemValue;
    String? description;
    String? allocationValue;
    String? workOrderNo;
    String? voucherNo;
    String? voucherDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(language.text('itemReceiptDetails')),
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder(
          future: getApiData('TransactionItemReceiptDetails', transCode),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(language.text('somethingWentWrong')),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }
            if(snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = (snapshot.data == null) ? {} : snapshot.data as Map<String, dynamic>;
              railway = data['railwayissuingzone'];
              cdCode = data['cardcord'].toString();
              receivingDepot = data['consigneeissuename'];
              subDepot = data['consigneepostdesig'];
              plNo = data['ledgerfolioplno'];
              demandNo = data['dmdno'];
              demandDate = data['dmddate'];
              itemUnit = (data['trunit1'] ?? '') + (data['trunit'] ?? '');
              itemQuantity = (data['trqty'] ?? '') + (data['trunit'] ?? '');
              issueNoteNo = data['pono'];
              issueDate = data['podate'];
              // itemCategory;
              issueDepotShop = data['vendorname'];
              remarks = data['ackremarks'];
              receivingOfficial = data['receievingofficial'];
              itemValue = data['trvalue'];
              description = data['itemdesc'];
              // allocationValue;
              workOrderNo = data['workorder'].toString();
              voucherNo = data['vrno'];
              voucherDate = data['vrdate'];
            }
            return ListView(
              padding: EdgeInsets.all(4),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ItemReceiptTextWidget(language.text('railway'), railway),
                      ItemReceiptTextWidget(
                          '${language.text('cdCode')} / ${language.text('ward')}',
                          (cdCode ?? '_') + ' / ' + (ward ?? '_')),
                      ItemReceiptTextWidget(
                          language.text('receivingDepot'), receivingDepot),
                      ItemReceiptTextWidget(
                          language.text('subDepot'), subDepot),
                    ],
                  ),
                ),
                // ItemReceiptTextWidget('Ward', ward),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ItemReceiptTextWidget(
                        language.text('plNoOfMaterial'),
                        plNo,
                        blueColor: true,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 8,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -1,
                              child: Text(
                                language.text('description') + ':',
                                style: TextStyle(
                                  color: Color(0XFF0073ff),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            ExpandableText(
                              language.text('descriptionTabs') +
                                  (description ?? '_'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              expandText: language.text('more'),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          collapsedBackgroundColor: Colors.red[100],
                          backgroundColor: Colors.red[50],
                          title: Text(
                            language.text('itemDetails'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          children: [
                            ItemReceiptTextWidget(
                              language.text('unit'),
                              itemUnit,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('category'),
                              itemCategory,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('quantityReceived'),
                              itemQuantity,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('valueRs'),
                              itemValue,
                              blueColor: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.red[100],
                          backgroundColor: Colors.red[50],
                          title: Text(
                            language.text('demandAndIssueDetails'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          children: [
                            ItemReceiptTextWidget(
                              language.text('demandNo'),
                              demandNo,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('demandDate'),
                              demandDate,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('issueNoteNo'),
                              issueNoteNo,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('issueDate'),
                              issueDate,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('issueDepotShop'),
                              issueDepotShop,
                              blueColor: true,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: -1,
                                      child: Text(
                                        language.text('remarks') + ':',
                                        style: TextStyle(
                                          color: Color(0XFF0073ff),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ExpandableText(
                                      language.text('remarksTabs') +
                                          (remarks ?? '_'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      expandText: 'more',
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ItemReceiptTextWidget(
                              language.text('issuingOfficial'),
                              receivingOfficial,
                              blueColor: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.red[100],
                          backgroundColor: Colors.red[50],
                          title: Text(
                            language.text('allocationDetails'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          children: [
                            ItemReceiptTextWidget(
                              language.text('allocationPGR'),
                              allocationValue,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('workOrderNo'),
                              workOrderNo,
                              blueColor: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 0, bottom: 20),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.red[100],
                          backgroundColor: Colors.red[50],
                          title: Text(
                            language.text('voucherDetails'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          children: [
                            ItemReceiptTextWidget(
                              language.text('voucherNo'),
                              voucherNo,
                              blueColor: true,
                            ),
                            ItemReceiptTextWidget(
                              language.text('voucherDate'),
                              voucherDate,
                              blueColor: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

Future<Map<String, dynamic>>? getApiData(String inputType, String input) async {
  Map<String, String> apiMap = {"input_type": inputType, "input": input};
  var apiBody = json.encode(apiMap);
  Uri uri = Uri.parse('https://ireps.gov.in/EPSApi/UDM/transaction');
  var response = await http.post(uri, body: apiBody, headers: {
    "Accept": "application/json",
    "content-type": "application/json",
  });
  var apiData = jsonDecode(response.body);
  return apiData['data'][0];
}
