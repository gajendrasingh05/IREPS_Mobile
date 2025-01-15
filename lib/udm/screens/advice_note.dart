import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../widgets/item_receipt_text_widget.dart';

class AdviceNote extends StatelessWidget {
  AdviceNote({Key? key}) : super(key: key);
  static const routeName = '/advice-note';
  @override
  Widget build(BuildContext context) {
    String transCode = ModalRoute.of(context)!.settings.arguments as String;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.text('adviceNote')),
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder(
        future: getApiData(transCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
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
            print(snapshot.error);
          }
          var snapshotData = snapshot.data;
          AdviceNoteData data = ((snapshotData != null) ? snapshotData : AdviceNoteData.fromMap({}));
          return ListView(padding: EdgeInsets.all(4), children: [
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
                  ItemReceiptTextWidget(language.text('railway'), data.railway),
                  ItemReceiptTextWidget(
                    language.text('cdCode') + ' / ' + language.text('ward'),
                    (data.cdCode ?? '_') + ' / ' + (data.ward ?? '_'),
                  ),
                  ItemReceiptTextWidget(
                      language.text('receivingDepot'), data.depot),
                  ItemReceiptTextWidget(language.text('dpcd'), data.dpcd),
                  ItemReceiptTextWidget(
                      language.text('consignor'), data.consignor),
                  ItemReceiptTextWidget(
                    language.text('controllingOfficer'),
                    data.controllingOfficer,
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
                    null,
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
                          language.text('voucherNo') +
                              ' / \n' +
                              language.text('voucherDate'),
                          (data.voucherNo ?? '_') +
                              ' / \n' +
                              (data.voucherDate ?? '_'),
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('allocationNo'),
                          data.allocation,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('consigneeCode'),
                          data.consigneeCode,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('rmcCreditNote'),
                          data.rmcCreditNoteNo,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('rmcCreditDate'),
                          data.rmcCreditDate,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('rrNo'),
                          data.wagonRRNo,
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
                                  '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                                      (data.depotRemarks ?? '_'),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.red[100],
                      backgroundColor: Colors.red[50],
                      title: Text(
                        language.text('dispatchDetails'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      children: [
                        ItemReceiptTextWidget(
                          language.text('dispatchDetails'),
                          data.dispatchedDetails,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('wagonNo'),
                          data.wagonNo,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('wagonDate'),
                          data.wagonDate,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('depotRemarks'),
                          data.depotRemarks,
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
                        language.text('officialDetails'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      children: [
                        ItemReceiptTextWidget(
                          language.text('approvingAuthority'),
                          data.approvingAuthority,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('accountalDetails'),
                          data.accountalDetails,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('returningOfficial'),
                          data.returningOfficial,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('controllingOfficer'),
                          data.controllingOfficer,
                          blueColor: true,
                        ),
                        ItemReceiptTextWidget(
                          language.text('receivingDate'),
                          data.receivingDate,
                          blueColor: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}

Future<AdviceNoteData> getApiData(String input) async {
  Map apiMap = {
    "input_type": "TransactionViewAdviceNoteReport",
    //TODO Remove this dependency
    "input": input
  };
  var apiBody = json.encode(apiMap);
  Uri uri = Uri.parse('https://ireps.gov.in/EPSApi/UDM/transaction');
  var response = await http.post(uri, body: apiBody, headers: {
    "Accept": "application/json",
    "content-type": "application/json",
  });
  Map<String, dynamic> apiData = jsonDecode(response.body)['data'];
  Map<String, dynamic> combinedMap = {
    ...apiData['Block1']['DATA'][0],
    ...apiData['Block2']['DATA'][0],
  };
  return AdviceNoteData.fromMap(combinedMap);
}

class AdviceNoteData {
  AdviceNoteData.fromMap(Map<String, dynamic> map) {
    railway = map['railwayissuingzone'].toString();
    cdCode = map['cardcode'].toString();
    consignor = map['consignor'].toString();
    controllingOfficer = map['designation'].toString();
    depot = (map['partydetails'] ?? '_') + (map['partyorgzone'] ?? '_');
    dpcd = map['partycode'].toString();
    ward = map['ward'].toString();
    voucherNo = map['receiptvoucherno'].toString();
    //voucherDate
    allocation = map['allocation'].toString();
    consigneeCode = map['conscode'].toString();
    adviceNoteNo = map['vrno'].toString();
    adviceDate = map['vrdate'].toString();
    description = map['itemdesc'].toString();
    rmcCreditNoteNo = map['rmcno'].toString();
    rmcCreditDate = map['rmcdate'].toString();
    // depotRemarks = map['writebackremark'].toString(); //TODO uncertain
    wagonNo = map['lorryno'].toString(); //TODO uncertain
    // wagonRRNo = map[''];
    // wagonDate = map[''];
    depotRemarks = map['remarks'].toString();
    dispatchedDetails = map['dispatchdtls'].toString();
    approvingAuthority = map['signature'].toString();
    // accountalDetails = map[''];
  }
  String? railway;
  String? cdCode = '48';
  String? consignor;
  String? controllingOfficer;
  String? depot;
  String? dpcd;
  String? ward;
  String? voucherNo;
  String? voucherDate = 'dd-mm-yyyy';
  String? allocation;
  String? consigneeCode;
  String? adviceNoteNo = '33364-21-00376';
  String? adviceDate = '12-08-2021';
  String? description =
      'Cam shaft assly. (Left side) cat no. 21600116, 16B 71045 Alt-yd, line-2 sheet 1 of 1.';
  String? unit = '01 Number';
  String? qtyReceived = '5.000 Number (Only Five Number)';
  String? rateDemanded = 'At Book Rate';
  //TODO Remaining the table on the right side

  // String? plNo = '98090604';
  // String? cat = '60';

  String? rmcCreditNoteNo;
  String? rmcCreditDate;
  String? wagonNo;
  String? wagonRRNo;
  String? wagonDate;
  String? depotRemarks;
  String? cancellationRemarks;
  String? dispatchedDetails;
  String? approvingAuthority;
  String? accountalDetails;
  String? station;
  String? returningOfficial;
  String? receivingOfficer;
  String? receivingDate;
  String? copyNoBlock;
  String? depotStoresAccount;
  String? divisionalOfficer;
  String? ackByDepot;
  String? divOfficer;
}
