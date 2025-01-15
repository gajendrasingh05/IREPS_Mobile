import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';

class TransactionIssueAgainstReceipt extends StatelessWidget {
  const TransactionIssueAgainstReceipt({Key? key}) : super(key: key);

  static const routeName = '/transaction-issue-against-receipt';

  @override
  Widget build(BuildContext context) {
    String transCode = ModalRoute.of(context)!.settings.arguments as String;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Issue Against Receipt'),
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder(
        future: getApiData(
          'TransactionIssueAgainstReceipt',
          transCode,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
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
          TransactionIssueData data;
          if (snapshotData != null) {
            data = snapshotData as TransactionIssueData;
          } else {
            data = TransactionIssueData.fromMap({});
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
                      language.text('consigneeCode'),
                      data.consigneeCode,
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
                            '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
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
                              language.text('detailsOfReceiptVoucher'),
                              style: TextStyle(
                                color: Color(0XFF0073ff),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ExpandableText(
                            '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                                (data.detailsOfReceiptVoucher ?? '_'),
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
                    ItemReceiptTextWidget(
                      language.text('consigneeCode'),
                      data.consigneeCode,
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
                    ...data.issueDetailItems.map((item) {
                      return IssueDetailWidget(item);
                    }).toList(),
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

class IssueDetailWidget extends StatelessWidget {
  IssueDetailWidget(this.data, {Key? key}) : super(key: key);
  final IssueDetail data;
  @override
  Widget build(BuildContext context) {
    String transCode = ModalRoute.of(context)!.settings.arguments as String;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Padding(
      padding: EdgeInsets.all(4),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red[50],
        elevation: 5,
        child: Column(
          children: [
            ItemReceiptTextWidget(
              language.text('issueNoteNo'),
              data.issueNoteNo,
            ),
            ItemReceiptTextWidget(
              language.text('issueQuantity'),
              data.quantity,
            ),
            ItemReceiptTextWidget(
              language.text('date'),
              data.date,
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
                    '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
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
          ],
        ),
      ),
    );
  }
}

class TransactionIssueData {
  TransactionIssueData();
  TransactionIssueData.fromMap(Map<String, dynamic> input) {
    // railway = input[''];
    consignee = input['cname'];
    consigneeCode = input['conscode'];
    // detailsOfReceiptVoucher = input[''];
    balanceDate = input['transdate'];
    description = input['itemdescription'];
    // consigneeCode = input[''];
    voucherNo = input['voucherno'];
    quantity = (input['trqty'].toString()) + (input['trunit'] ?? '_');
    balanceQuantity = input['receiptbalqty'].toString();
    brand = input['makebrand'];
    make = input['curmakebrand'];
    description = input['transreinspectiondesc'];
    List inputIssueDetail = input['DATA'] ?? [];
    inputIssueDetail.forEach((i) {
      issueDetailItems.add(IssueDetail(
        issueNoteNo: i['issuevrno'],
        date: i['issuevrdate'],
        description: i['issuetransdetails'],
        quantity: i['receiptbalqty'].toString(),
      ));
    });
  }
  String? railway;
  String? consigneeCode;
  String? description;
  String? detailsOfReceiptVoucher;
  String? consignee;
  //Receipt Details
  String? voucherNo;
  String? accountalDate;
  String? quantity;
  String? make;
  String? brand;
  String? productNo;
  //Balance
  String? balanceDate;
  String? balanceQuantity;
  //List of IssueDetail
  List<IssueDetail> issueDetailItems = [];
}

class IssueDetail {
  IssueDetail({
    required this.issueNoteNo,
    this.date,
    this.quantity,
    this.description,
  });
  String? issueNoteNo;
  String? date;
  String? quantity;
  String? description;
}

Future<TransactionIssueData> getApiData(String inputType, String input) async {
  Map<String, String> apiMap = {"input_type": inputType, "input": input};
  var apiBody = json.encode(apiMap);
  Uri uri = Uri.parse('https://trial.ireps.gov.in/EPSApi/UDM/transaction');
  var response = await http.post(
    uri,
    body: apiBody,
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
  );
  print(response.body);
  Map<String, dynamic> apiData = jsonDecode(response.body);
  Map<String, dynamic> finalMap = {
    ...apiData['data']['IssueAgainstReceiptHeader'],
    ...apiData['data']['IssueAgainstReceiptList']
  };
  print(finalMap);
  return TransactionIssueData.fromMap(finalMap);
}

class ItemReceiptTextWidget extends StatelessWidget {
  ItemReceiptTextWidget(this.heading, this.value,
      {bool blueColor = false, Key? key})
      : super(key: key) {
    this.blueColor = blueColor;
  }
  final String? heading;
  final String? value;
  late final bool blueColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              heading ?? '_',
              style: TextStyle(
                color: blueColor ? Color(0XFF0073ff) : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value ?? '_',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
