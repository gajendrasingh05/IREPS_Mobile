import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/item_receipt_text_widget.dart';

class IssueNoteDetails extends StatelessWidget {
  const IssueNoteDetails({Key? key}) : super(key: key);
  static const String routeName = '/issue-note';
  @override
  Widget build(BuildContext context) {
    String? transCode = ModalRoute.of(context)!.settings.arguments as String?;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.text('issueNote')),
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder(future: getApiData('TransactionViewIssueNote', transCode ?? ''),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
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
          var snapshotData = snapshot.data;
          IssueNoteData data;
          if (snapshotData != null) {
            data = snapshotData as IssueNoteData;
          }
          else {
            data = IssueNoteData.fromMap({});
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
                    ItemReceiptTextWidget(
                      language.text('railway'),
                      data.railway,
                    ),
                    ItemReceiptTextWidget(
                      language.text('cdCode') + ' / ' + language.text('ward'),
                      (data.cdCode ?? '_') + ' / ' + (data.ward ?? '_'),
                    ),
                    ItemReceiptTextWidget(
                      language.text('issuingDepot'),
                      data.issuingDepot,
                    ),
                    ItemReceiptTextWidget(
                      language.text('date'),
                      data.issueDate,
                    ),
                  ],
                ),
              ),
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
                      data.plNo,
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
                              language.text('description'),
                              style: TextStyle(
                                color: Color(0XFF0073ff),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ExpandableText(
                            language.text('descriptionTabs') +
                                (data.description ?? '_'),
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
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.red[100],
                        backgroundColor: Colors.red[50],
                        initiallyExpanded: true,
                        title: Text(
                          language.text('itemDetails'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ItemReceiptTextWidget(
                            language.text('category'),
                            data.category,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('unit'),
                            data.unit,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('subDepot'),
                            data.subDepot,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('quantity'),
                            data.qty,
                            blueColor: true,
                          ),
                        /*  ItemReceiptTextWidget(
                            language.text('quantityInWords'),
                            data.qtyInWords,
                            blueColor: true,
                          ),*/
                          ItemReceiptTextWidget(
                            language.text('rate'),
                            data.rate,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('valueRs'),
                            data.value,
                            blueColor: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0, bottom: 20),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.red[100],
                        backgroundColor: Colors.red[50],
                        title: Text(
                          language.text('issueAndDemandDetails'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ItemReceiptTextWidget(
                            language.text('issueNoteNo'),
                            data.issueNoteNo,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(language.text('demandDate'),
                            data.demandDate,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('sign'),
                            data.sign,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('allocationPGR'),
                            data.allocationPGROrderNo,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('depotShopCodeConsignee'),
                            data.depotShopCodeConsignee,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('workOrderNo'),
                            data.workOrderNo,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('date'),
                            data.actualDateOfIssue,
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
                                      language.text('remarks'),
                                      style: TextStyle(
                                        color: Color(0XFF0073ff),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  ExpandableText(
                                    language.text('remarksTabs') + (data.remarks ?? '_'),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class IssueNoteData {
  IssueNoteData();
  IssueNoteData.fromMap(Map<String?, dynamic> input) {
    railway = input['railwayissuingzone'];
    cdCode = input['cardcord'];
    // ward = input[''];
    issuingDepot = input['consigneeissuename'];
    issueDate = input['receiptdate'];
    plNo = input['ledgerfolioplno'];
    description = input['itemdesc'];
    // category
    unit = (input['trunit1'] ?? '') + ' ' + (input['trunit'] ?? '');
    subDepot = input['consigneepostdesig'];
    qty = (input['trqty'] ?? '') + ' ' + (input['trunit'] ?? '');
    // qtyInWords
    rate = input['issuerate'];
    value = input['issuevalue'];
    issueNoteNo = input['vrno'];
    demandDate = input['dmddate'];
    sign = input['makebrand'];
    // allocationPGROrderNo = input[''];
    depotShopCodeConsignee = input['transdetails'];
    workOrderNo = input['workorder'];
    actualDateOfIssue = input['vrdate'];
    remarks = input['remarks'];
  }
  //First block
  String? railway;
  String? cdCode;
  String? ward;
  String? issuingDepot;
  String? issueDate;
  //Second block
  String? plNo;
  String? description;
  //Grouped in ExpansionTile (Item Details)
  String? category;
  String? unit;
  String? subDepot;
  String? qty;
  String? qtyInWords;
  String? rate;
  String? value;
  //Grouped in ExpansionTile (Issue and Demand Details)
  String? issueNoteNo;
  String? demandDate;
  String? demandLetterRefNo;
  String? sign;
  String? allocationPGROrderNo;
  String? depotShopCodeConsignee;
  String? workOrderNo;
  String? actualDateOfIssue;
  String? remarks;
}

Future<IssueNoteData> getApiData(String inputType, String input) async {
  Map<String, String> apiMap = {"input_type": inputType, "input": input};
  var apiBody = json.encode(apiMap);
  Uri uri = Uri.parse('https://ireps.gov.in/EPSApi/UDM/transaction');
  var response = await http.post(
    uri,
    body: apiBody,
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
  );
  Map<String, dynamic> apiData = jsonDecode(response.body)['data'];
  Map<String, dynamic> finalMap = {
    ...apiData['block1']['DATA'][0],
    ...apiData['block2']['DATA'][0],
  };
  return IssueNoteData.fromMap(finalMap);
}
