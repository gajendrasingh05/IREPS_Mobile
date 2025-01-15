import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/item_receipt_text_widget.dart';

class WarrantyClaimDetails extends StatelessWidget {
  const WarrantyClaimDetails({Key? key}) : super(key: key);
  static const routeName = '/warranty-claim-details';
  @override
  Widget build(BuildContext context) {
    String transCode = ModalRoute.of(context)!.settings.arguments as String;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.text('warrantyClaim')),
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
          WarrantyClaimData data = ((snapshotData != null)
              ? snapshotData
              : WarrantyClaimData.fromMap({})) as WarrantyClaimData;
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
                      language.text('depotLodgingWarranty'),
                      data.depotLodgingWarranty,
                    ),
                    ItemReceiptTextWidget(
                        language.text('poContractNo'), data.poContractNo),
                    ItemReceiptTextWidget(
                      language.text('poContractDate'),
                      data.poContractDate,
                    ),
                    ItemReceiptTextWidget(
                      language.text('depotOriginallyReceivingMaterial'),
                      data.depotOriginallyReceivingMaterial,
                    ),
                    ItemReceiptTextWidget(
                      language.text('subDepotSubConsignee'),
                      data.subDepotConsignee,
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
                      data.plNoItemCode,
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
                          language.text('warrantyDetails'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ItemReceiptTextWidget(
                            language.text('warrantyClaimNo'),
                            data.warrantyClaimNo,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('warrantyClaimDate'),
                            data.warrantyClaimDate,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('nameAndAddressOfSupplier'),
                            data.nameAddressOfSupplier,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('challanNoDate'),
                            (data.challanNo ?? '_') +
                                '\n' +
                                (data.challanDate ?? '_'),
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('billNoDate'),
                            (data.billNo ?? '_') +
                                '\n' +
                                (data.billDate ?? '_'),
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('ddrNoDate'),
                            (data.ddrNo ?? '_') + '\n' + (data.billDate ?? '_'),
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('islNoDate'),
                            (data.ddrNo ?? '_') + '\n' + (data.billDate ?? '_'),
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('inspectionBy'),
                            data.inspectionBy,
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
                          language.text('itemDetails'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ItemReceiptTextWidget(
                            language.text('qtyRejectedUnderWarranty'),
                            data.quantityRejectedUnderWarranty,
                            blueColor: true,
                          ),
                         /* ItemReceiptTextWidget(
                            language.text('qtyRejectedUnderWarrantyWords'),
                            data.quantityRejectedWarrantyWords,
                            blueColor: true,
                          ),*/
                          ItemReceiptTextWidget(
                            language.text('ratePerUnit'),
                            data.ratePerUnit,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('valueOfRejectedItem'),
                            data.valRejectedItem,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('headPerAllocation'),
                            data.headPerAllocation,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('warrantyClaimAmount'),
                            data.warrantyClaimAmount,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('recoveryAdvice'),
                            data.recoveryAdvice,
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('note'),
                            'Ground Rent, as applicable, will also have to be paid by the Vendor if rejected Stores are not removed from Railway premises within the allowed Free Period.',
                            blueColor: true,
                          ),
                          ItemReceiptTextWidget(
                            language.text('accountingUnit'),
                            data.accountingUnit,
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

Future<WarrantyClaimData> getApiData(String input) async {
  Map<String, String> apiMap = {
    "input_type": "TransactionsWarrentyClaim",
    "input": input
  };
  var apiBody = json.encode(apiMap);
  Uri uri = Uri.parse('https://ireps.gov.in/EPSApi/UDM/transaction');
  var response = await http.post(uri, body: apiBody, headers: {
    "Accept": "application/json",
    "content-type": "application/json",
  });
  // print(response.body);
  Map<String, dynamic> apiData = jsonDecode(response.body)['data'][0];
  print(apiData);
  return WarrantyClaimData.fromMap(apiData);
}

class WarrantyClaimData {
  WarrantyClaimData.fromMap(Map input) {
    depotLodgingWarranty = (input['rejconsigneeissuename'] ?? '') +
        (input['rejconscode'] ?? '') +
        '\n' +
        (input['conscode'] ?? '');
    warrantyClaimNo = input['vrno'];
    warrantyClaimDate = input['vrdate'];
    poContractNo = input['pono'];
    poContractDate = input['podate'];
    itemSlNo = input['productsrno'];
    depotOriginallyReceivingMaterial = input['rlyname'];
    subDepotConsignee = input['departmentname'];
    nameAddressOfSupplier = input['vendorname'];
    challanNo = input['challanno'];
    challanDate = input['challandate'];
    billNo = input['billno'];
    billDate = input['billdate'];
     ddrNo = input['vrrefno'];
    // ddrDate = input[''];
    // islNo = input[''];
    // islDate = input[''];
    description = input['itemdesc'];
    plNoItemCode = input['plno'];
    // inspectionBy = input[''];
    quantityRejectedUnderWarranty =
        (input['qtyrejected'] ?? '0') + (input['pounit'] ?? '');
    makeBrand = input['makebrand'];
    // productSlNo = input[''];
    // quantityRejectedWarrantyWords = input[''];
    reasonForRejection = input['rejreason'];
    ratePerUnit = input['pounitrate'];
    valRejectedItem = (input['orirecovery']) ?? '0' + (input['pounit'] ?? '');
    headPerAllocation = input['alloc'];
     warrantyClaimAmount = input['trvalue'];
    recoveryAdvice = input['remarks'];
    // note = input[''];
    accountingUnit = input['billpayoff'];
  }
  String? depotLodgingWarranty;
  String? warrantyClaimNo;
  String? warrantyClaimDate;
  String? poContractNo;
  String? poContractDate;
  String? itemSlNo;
  String? depotOriginallyReceivingMaterial;
  String? subDepotConsignee;
  String? nameAddressOfSupplier;
  String? challanNo;
  String? challanDate;
  String? billNo;
  String? billDate;
  String? ddrNo;
  String? ddrDate;
  String? islNo;
  String? islDate;
  String? description;
  String? plNoItemCode;
  String? inspectionBy;
  String? quantityRejectedUnderWarranty;
  String? makeBrand;
  String? productSlNo;
  String? quantityRejectedWarrantyWords;
  String? reasonForRejection;
  String? ratePerUnit;
  String? valRejectedItem;
  String? headPerAllocation;
  String? warrantyClaimAmount;
  String? recoveryAdvice;
  String? note;
  String? accountingUnit;
}