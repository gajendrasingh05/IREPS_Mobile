import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';

import '../widgets/item_receipt_text_widget.dart';

class ConsigneeReceiptNote extends StatelessWidget {
  const ConsigneeReceiptNote({Key? key}) : super(key: key);
  static const String routeName = '/consignee-receipt-note';

  @override
  Widget build(BuildContext context) {
    LanguageProvider language =
    Provider.of<LanguageProvider>(context, listen: false);
    String transCode = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Consignee Receipt Note'),
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder(
        future: getApiData('TransactionsConsignmentReceipt', transCode),
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
          }
          var snapshotData = snapshot.data;
          ConsigneeReceiptNoteData data = ((snapshotData != null) ? snapshotData : ConsigneeReceiptNoteData) as ConsigneeReceiptNoteData;
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
                        language.text('railway'), data.railway),
                    ItemReceiptTextWidget(
                        language.text('crnNo') + '\n' + language.text('date'),
                        (data.crnNo ?? '_') + ' / \n' + (data.crnDate ?? '_')),
                    ItemReceiptTextWidget(
                      language.text('poContractNo') +
                          '\n' +
                          language.text('date'),
                      (data.poContractNo ?? '_') +
                          '\n' +
                          (data.poContractDate ?? '_'),
                    ),
                    ItemReceiptTextWidget(
                        language.text('firmDetails'), data.firmDetails ?? '_'),
                    ItemReceiptTextWidget(
                        language.text('dmtrNo'), data.dmtrNo ?? '_'),
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
                                // fontWeight: FontWeight.bold,
                                color: Color(0XFF0073ff),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ExpandableText(
                            language.text('descriptionTabs') +
                                (data.itemDetails ?? '_'),
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
                            language.text('packagesReceived'),
                            data.packagesReceived,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('poContractUnitRate'),
                            data.pOContractUnitRate,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('itemQtyInPO'),
                            data.itemQuantityInPO,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('deliveryPeriod'),
                            data.deliveryPeriod,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('qtyDisp'),
                            data.qtyDispatchedInPO,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('qtyAcceptPO'),
                            data.qtyAcceptedInPO,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('qtyAcceptTU'),
                            data.qtyAcceptedInPO,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('qtyRecPO'),
                            data.qtyReceivedInPO,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('qtyRejPO'),
                            data.qtyRejectedInPO,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('acceptedQtyVal'),
                            data.valueOfAcceptedQty,
                            blueColor: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.red[100],
                        backgroundColor: Colors.red[50],
                        title: Text(
                          language.text('demandAndIssue'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ItemReceiptTextWidget(
                            language.text('demandWorkSanction'),
                            (data.demandWorkSanctionNo ?? '_') +
                                '\n' +
                                (data.demandWorkSanctionDate ?? '_'),
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('challanDate'),
                            data.challanNoDate,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('icDate'),
                            (data.iCNo ?? '_') + '\n' + (data.iCDate ?? '_'),
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('productSLDate'),
                            data.productSLNo,
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
                                        // fontWeight: FontWeight.bold,
                                        color: Color(0XFF0073ff),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  ExpandableText(
                                    language.text('remarksTabs') +
                                        (data.remarks ?? '_'),
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
                          ItemReceiptTextWidget(
                            language.text('signatureOfStockHolder'),
                            data.signatureOfStockHolder,
                            blueColor: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0, bottom: 20),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.red[100],
                        backgroundColor: Colors.red[50],
                        title: Text(
                          language.text('billingDetails'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ItemReceiptTextWidget(
                            language.text('billPassing'),
                            data.billPassing,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('allocation'),
                            data.allocationValue,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('locationOfMatDuringRec'),
                            data.locationOfMaterialDuringReceipt,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('makeBrand'),
                            data.makeBrand,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('accountedInLedger'),
                            data.accountedInLedger,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('payingAuthority'),
                            data.payingAuthority,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('poContractAgency'),
                            data.pOContractAgency,
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
                                    language.text('paymentTerms'),
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: Color(0XFF0073ff),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                ExpandableText(
                                  '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                                      (data.paymentTerms ?? '_'),
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
                            language.text('dateOfAccountal'),
                            data.dateOfAccountal,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('matStockLoc'),
                            data.materialStockingLocation,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('ledgerFolio'),
                            data.ledgerFolio,
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
        },
      ),
    );
  }
}

class ConsigneeReceiptNoteData {
  ConsigneeReceiptNoteData();
  ConsigneeReceiptNoteData.fromMap(Map input) {
    railway = input['rlyname'];
    crnNo = input['vrno'];
    crnDate = input['vrdate'];
    poContractNo = input['pono'];
    poContractDate = input['podate'];
    firmDetails = input['consigneepostdesig'];
    dmtrNo = input['vrno'];
    // finalCustodian = input[''];
    plNo = input['plno'];
    itemQuantityInPO = input['poqty'];
    // deliveryPeriod = input[''];
    qtyDispatchedInPO = input['qtydispatched'];
    qtyAcceptedInPO = input['qtyaccepted'];
    // qtyAcceptedInTU = input[''];
    pOContractUnitRate = input['pounitrate'];
    packagesReceived = input['packagereceived'];
    qtyReceivedInPO = input['qtyreceived'];
    qtyRejectedInPO = input['qtyrejected'];
    valueOfAcceptedQty = input['valueofmatrecived'];
    demandWorkSanctionNo = input['dmdno'];
    demandWorkSanctionDate = input['dmddate'];
    iCNo = input['icno'];
    iCDate = input['icdate'];
    remarks = input['remarks'];
    productSLNo = input['productsrno'];
    challanNoDate = (input['challanno'] ?? '') + (input['challandate'] ?? '');
    ledgerFolio = input['ledgerfolioname'];
    materialStockingLocation = input['stockinglocation'];
     dateOfAccountal = input['vrdate'];
    paymentTerms = input['paymentterms'];
    pOContractAgency = input['poinspagency'];
    accountedInLedger = input['ledgername'];
    makeBrand = input['makebrand'];
    locationOfMaterialDuringReceipt = input['receiptlocation'];
    billPassing = input['billdate'];
    payingAuthority = input['billpayoff'];
    signatureOfStockHolder =
        (input['username'] ?? '') + (input['consigneepostdesig'] ?? '');
    itemDetails = input['itemdesc'];
    allocationValue = input['allocation'];
    // workOrderNo = input[''];
  }
  String? railway;
  String? crnNo;
  String? crnDate;
  String? poContractNo;
  String? poContractDate;
  String? firmDetails;
  String? dmtrNo;
  String? finalCustodian;
  String? plNo;
  String? itemQuantityInPO;
  String? deliveryPeriod;
  String? qtyDispatchedInPO;
  String? qtyAcceptedInPO;
  String? qtyAcceptedInTU;
  String? pOContractUnitRate;
  String? packagesReceived;
  String? qtyReceivedInPO;
  String? qtyRejectedInPO;
  String? valueOfAcceptedQty;
  String? demandWorkSanctionNo;
  String? demandWorkSanctionDate;
  String? iCNo;
  String? iCDate;
  String? remarks;
  String? productSLNo;
  String? challanNoDate;
  String? ledgerFolio;
  String? materialStockingLocation;
  String? dateOfAccountal;
  String? paymentTerms;
  String? pOContractAgency;
  String? accountedInLedger;
  String? makeBrand;
  String? locationOfMaterialDuringReceipt;
  String? billPassing;
  String? payingAuthority;
  String? signatureOfStockHolder;
  String? itemDetails;
  String? allocationValue;
  String? workOrderNo;
}

Future<ConsigneeReceiptNoteData> getApiData(
    String inputType, String input) async {
  Map<String, String> apiMap = {"input_type": inputType, "input": input};
  var apiBody = json.encode(apiMap);
  Uri uri = Uri.parse('https://ireps.gov.in/EPSApi/UDM/transaction');
  var response = await http.post(uri, body: apiBody, headers: {
    "Accept": "application/json",
    "content-type": "application/json",
  });
  Map<String, dynamic> apiData = jsonDecode(response.body)['data'][0];
  return ConsigneeReceiptNoteData.fromMap(apiData);
}