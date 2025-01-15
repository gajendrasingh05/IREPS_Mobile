import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view_model/warranty_rejection_register_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WarrantyRejectionAdviceScreen extends StatefulWidget {
  final String? pdfpath;
  final String? trkey;
  WarrantyRejectionAdviceScreen(this.pdfpath, this.trkey);

  @override
  State<WarrantyRejectionAdviceScreen> createState() =>
      _WarrantyRejectionAdviceScreenState();
}

class _WarrantyRejectionAdviceScreenState
    extends State<WarrantyRejectionAdviceScreen> {
  String currentdate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getAllData();
    });
  }

  Future<void> getAllData() async {
    DateTime tdate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    currentdate = formatter.format(tdate);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getRejectionAdvicelistData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getWarrantyOfficerData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getWithdrawnData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getReinspData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getReplacementsData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getDepositedData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .getAmountRecoverdData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .fetchReturnRejData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .fetchRecoveryRefundData(widget.trkey, context);
    await Provider.of<WarrantyRejectionRegisterViewModel>(context,
            listen: false)
        .fetchAmountRefundData(widget.trkey, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text("${language.text('wrrtitle')}",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
                getAllData();
              },
              icon: Icon(Icons.refresh, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<WarrantyRejectionRegisterViewModel>(
            builder: ((context, value, child) {
          if (value.wodState == WarrantyOfficerDetailState.Busy) {
            return Container(
              height: size.height,
              width: size.width,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3.0),
                    SizedBox(height: 3.0),
                    Text(language.text('pw'),
                        style: TextStyle(color: Colors.black, fontSize: 16))
                  ],
                ),
              ),
            );
          } else if (value.wodState == WarrantyOfficerDetailState.Finished &&
              value.rejectionAdviceState == RejectionAdviceState.Finished) {
            return Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () async {
                      bool check = await UdmUtilities.checkconnection();
                      if (check == true) {
                        var fileUrl = widget.pdfpath;
                        print(fileUrl.toString().trim());
                        if (fileUrl.toString().trim() == "https://www.ireps.gov.in") {
                          UdmUtilities.showWarningFlushBar(context, "Sorry, no pdf found");
                        } else {
                          var fileName =
                              fileUrl!.substring(fileUrl.lastIndexOf("/"));
                          UdmUtilities.openPdfBottomSheet(context, fileUrl,
                              fileName, language.text('wrrtitle'));
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0, top: 4.0),
                      child: Container(
                          height: 45,
                          width: size.width * 0.50,
                          alignment: Alignment.center,
                          child: Text(
                              "View Digitally-signed Warranty Rejection Advice",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Image.asset('assets/indian_railway.png',
                        height: 90, width: 90)),
                value.rejectionadvicelistData.isNotEmpty
                    ? Text(value.rejectionadvicelistData[0].rlyname ?? "NA",
                        style: TextStyle(fontSize: 16, color: Colors.black))
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.grey, width: 0.5))),
                        child: Text(
                            value.rejectionadvicelistData[0].rejectionind == 'W'
                                ? "${language.text('wra')}"
                                : "${language.text('ratitle')}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold)))
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? value.rejectionadvicelistData[0].rejectionind
                                .toString() ==
                            "W"
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                            TextSpan(
                                text: "Depot Lodging Warranty Claim: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14)),
                            TextSpan(
                                text:
                                    "${replaceTags(value.rejectionadvicelistData[0].depotlodging)}",
                                style: TextStyle(
                                    color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
                          ]))
                        : Text(
                            "Inspecting Depot: ${value.rejectionadvicelistData[0].consigneeissuename} (Consignee Code: ${value.rejectionadvicelistData[0].conscode})",
                            textAlign: TextAlign.center)
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Table(
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        children: [
                          TableRow(children: [
                            Column(children: [
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? language.text('wran')
                                      : language.text('ran'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? value.rejectionadvicelistData[0]
                                              .warrantyno ??
                                          "NA"
                                      : value.rejectionadvicelistData[0].vrno ??
                                          "NA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('date'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].vrdate ??
                                      "NA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('pocn'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].pono ?? "NA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('pocd'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].podate ??
                                      "NA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('isrpoc'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].posr ?? "NA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('crr'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? "${replaceTags(value.rejectionadvicelistData[0].consigneereporting)}"
                                      : "${replaceTags(value.rejectionadvicelistData[0].consigneeissuename)} (Consignee Code: ${replaceTags(value.rejectionadvicelistData[0].conscode)})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('sdsc'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                          .warddetails ??
                                      "NA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? language.text('cn')
                                      : language.text('rarn'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? replaceTags(value
                                              .rejectionadvicelistData[0]
                                              .vrno) ??
                                          "NA"
                                      : replaceTags(value
                                              .rejectionadvicelistData[0]
                                              .vrno) ??
                                          "NA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? language.text('cd')
                                      : language.text('date'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].trdate ??
                                      "NA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('nas'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  "${value.rejectionadvicelistData[0].vendorname} (IREPS Code${value.rejectionadvicelistData[0].firmacctid})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('cnum'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].challanno ??
                                      "NA",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('cnumd'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                          .challandate ??
                                      "NA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? language.text('icnum')
                                      : value.rejectionadvicelistData[0]
                                                  .rejectionind !=
                                              'W'
                                          ? language.text('drrn')
                                          : language.text('islnum'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? value.rejectionadvicelistData[0].icno ??
                                          "NA"
                                      : value.rejectionadvicelistData[0]
                                                  .rejectionind !=
                                              'W'
                                          ? value.rejectionadvicelistData[0]
                                                  .vrrefno ??
                                              "NA"
                                          : value.rejectionadvicelistData[0]
                                                  .vrrefno ??
                                              "NA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? language.text('icd')
                                      : value.rejectionadvicelistData[0]
                                                  .rejectionind !=
                                              'W'
                                          ? language.text('drrd')
                                          : language.text('isld'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? value.rejectionadvicelistData[0]
                                              .icdate ??
                                          "NA"
                                      : value.rejectionadvicelistData[0]
                                                  .rejectionind !=
                                              'W'
                                          ? value.rejectionadvicelistData[0]
                                                  .vrrefdate ??
                                              "NA"
                                          : value.rejectionadvicelistData[0]
                                                  .vrrefdate ??
                                              "NA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('dds'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text('NA',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('pnic'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].plno ?? "NA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(language.text('iby'),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 3),
                                        Expanded(
                                            child: Text(
                                                value.rejectionadvicelistData[0]
                                                        .poagency ??
                                                    "NA",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Inspecting Official:",
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 3),
                                        Text(
                                            "${value.rejectionadvicelistData[0].inspectorname ?? "NA"} ${value.rejectionadvicelistData[0].inspectordesig ?? "NA"}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(language.text('icnum'),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 3),
                                        Expanded(
                                            child: Text(
                                                value.rejectionadvicelistData[0]
                                                        .icno ??
                                                    "NA",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(language.text('icd'),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 3),
                                        Text(
                                            value.rejectionadvicelistData[0]
                                                    .icdate ??
                                                "NA",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ],
                                    )
                                  ]),
                            ),
                            Column(children: [
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? language.text('vaa')
                                      : language.text('adpymt'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0]
                                              .rejectionind ==
                                          'W'
                                      ? value.rejectionadvicelistData[0]
                                              .approvingagency ??
                                          "NA"
                                      : value.rejectionadvicelistData[0]
                                                  .recovind ==
                                              'Y'
                                          ? "Yes"
                                          : "No",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        value.rejectionadvicelistData[0]
                                                .itemdesc ??
                                            "NA",
                                        maxLines: 5,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 3),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(language.text('mb'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            value.rejectionadvicelistData[0]
                                                    .makebrand ??
                                                "NA",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(language.text('bpsn'),
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Text(value.rejectionadvicelistData[0].productsrno ?? "NA",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(language.text('wp'),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 3),
                                        Expanded(
                                            child: Text(
                                                value.rejectionadvicelistData[0]
                                                        .warrantyperiod ??
                                                    "NA",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                      ],
                                    ),
                                  ]),
                            ),
                            Column(children: [
                              Text(language.text('qr'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  '${value.rejectionadvicelistData[0].qtyrejected ?? "NA"} ${value.rejectionadvicelistData[0].pounit}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('qrw'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  "Only ${convertToWords(double.parse(value.rejectionadvicelistData[0].qtyrejected!))} ${value.rejectionadvicelistData[0].pounit}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('ror'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].rejreason ??
                                      "NA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                          TableRow(children: [
                            Column(children: [
                              Text(language.text('ru'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  ' Rs. ${value.rejectionadvicelistData[0].pounitrate ?? "NA"} per ${value.rejectionadvicelistData[0].pounit ?? "NA"}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Text(language.text('ha'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 3),
                              Text(
                                  value.rejectionadvicelistData[0].alloc ??
                                      "NA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                          ]),
                        ],
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.grey, width: 0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${language.text('camt')}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                            Expanded(
                                child: Text(
                                    "Rs. ${value.rejectionadvicelistData[0].trrejvalue} (Rupees ${convertToWords(double.parse(value.rejectionadvicelistData[0].trrejvalue!))} only)",
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.grey, width: 0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${language.text('ra')}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline)),
                            Expanded(
                                child: Text(
                                    value.rejectionadvicelistData[0].remarks ??
                                        "NA",
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.black)))
                          ],
                        ),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.grey, width: 0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${language.text('note')}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline)),
                            Expanded(
                                child: Text(
                                    " Ground Rent, as applicable, will also have to be paid by the Vendor if rejected Stores are not removed from Railway premises within the allowed Free Period.",
                                    style: TextStyle(color: Colors.black)))
                          ],
                        ),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.grey, width: 0.5))),
                        child: value.rejectionadvicelistData[0].poagency ==
                                    'RITES' &&
                                value.rejectionadvicelistData[0].rejectionind ==
                                    'W'
                            ? RichText(
                                text: TextSpan(
                                  text: "${language.text('rfia')}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.underline),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            "${value.rejectionadvicelistData[0].inspvcode} may take necessary action against Inspecting Officials and ensure necessary corrective action as per Policy.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none)),
                                    //TextSpan(text: '${value.wrrlistData[index].balrejqty ?? "NA"}', style: TextStyle(color: Colors.blue, fontSize: 16,fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  text: "${language.text('rfia')}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.underline),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            "${value.rejectionadvicelistData[0].poagency} may take necessary action against Inspecting Officials and ensure necessary corrective action as per Policy.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none)),
                                    //TextSpan(text: '${value.wrrlistData[index].balrejqty ?? "NA"}', style: TextStyle(color: Colors.blue, fontSize: 16,fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? Table(
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        children: [
                            TableRow(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(language.text('cpa'),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 3),
                                      Text(
                                          value.rejectionadvicelistData[0].rejectionind == 'W'
                                              ? "All Paying Authorities across Indian Railways"
                                              : value.rejectionadvicelistData[0].billpayoff!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(language.text('sdo'),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 3),
                                    Text(
                                        "${value.rejectionadvicelistData[0].username ?? ""} ${value.rejectionadvicelistData[0].usertype ?? ""} ${value.rejectionadvicelistData[0].consigneepostdesig ?? ""} (Consignee Code: ${value.rejectionadvicelistData[0].conscode!})",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(language.text('co'),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 3),
                                    Text(
                                        value.officerData.length > 0
                                            ? replaceTags(
                                                value.officerData[0].userMail!)
                                            : "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              )
                            ]),
                          ])
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                //-- Adding for withdrawn  -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.withdrawData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Claim Withdrawals against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.withdrawData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Qty. for which Warranty Claim WithDrawn : ${value.totatqtywd.toString()} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.withdrawData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                value.withdrawData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.withdrawData.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('wr'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.withdrawData[index]
                                                          .voucherNo
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('qw'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.withdrawData[index].qtyAccepted.toString()} ${value.withdrawData[index].unit.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('duc'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.withdrawData[index]
                                                          .userDepotName
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  // SizedBox(height: 5.0),
                                                  // Text(language.text('dad'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                                                  // SizedBox(height: 2.0),
                                                  // Text("Test"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                SizedBox(height: 5.0),
                //---Added for Re-Inspection(S) against Warranty Claim No -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.reinsData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Re-Inspection(s) against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.reinsData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Qty. Re-Inspected: ${value.totqtyreins.toString()} ${value.rejectionadvicelistData[0].pounit} Total Qty.Accepted after Re-Inspection : ${value.totacqtyreins.toString()} ${value.rejectionadvicelistData[0].pounit} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.reinsData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.reinsData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.reinsData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('rivnum'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value
                                                          .reinsData[index].vrNo
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dpri'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.reinsData[index]
                                                          .vrDate
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dri'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.reinsData[index].qtyReceived.toString()} ${value.rejectionadvicelistData[0].pounit.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('qari'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(value.reinsData[index].qtyAccepted.toString() == 0 || value.reinsData[index].qtyAccepted == null ? "Under Inspection"
                                                          : "${value.reinsData[index].qtyAccepted.toString()} ${value.rejectionadvicelistData[0].pounit.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dari'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.reinsData[index]
                                                          .accountalTrDate
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dudc'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.reinsData[index].consCodeName.toString()} ${value.reinsData[index].userName.toString()} (${value.reinsData[index].postDesig.toString()}) - ${value.reinsData[index].rlyName.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dcsd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(value.reinsData[index].crnFlag.toString() == "3"
                                                          ? "Digital CRN not yet processed"
                                                          : value.reinsData[index].crnFlag.toString() == "1"
                                                              ? "Digital CRN under approval with ${value.reinsData[index].crnRemark} ${value.reinsData[index].rlyName} since ${value.reinsData[index].sentforAppDt}"
                                                              : "Approved by officer on ${value.reinsData[index].crnApprovalDate}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                value.reinsData.isNotEmpty ? SizedBox(height: 5.0) : SizedBox(),
                //----Added for Re-placement  -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.repData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Warranty Replacements through UDM against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.repData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Qty. of Warranty Replacement Received : ${value.totalreprec.toString()} ${value.repData[0].unit.toString()} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.repData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.repData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('ddars'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.repData[index].dmtrno.toString()} dt. ${value.repData[index].dateofaccountal.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('qtyr'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.repData[index].qtyreplaced.toString()} ${value.repData[index].unit.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('scnd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.repData[index].challanno ?? "NA"} dt. ${value.repData[index].challandate ?? "NA"}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('drrs'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.repData[index]
                                                          .receiptdate
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dudc'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.repData[index].conscodename.toString()} ${value.repData[index].userdepotname} (${value.repData[index].postdesig}) - ${value.repData[index].rlyname}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dcsd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.repData[index]
                                                                  .crnflag
                                                                  .toString() ==
                                                              "3"
                                                          ? "Digital CRN not yet processed"
                                                          : value.repData[index]
                                                                      .crnflag
                                                                      .toString() ==
                                                                  "1"
                                                              ? "Digital CRN under approval with ${value.repData[index].crnremark} ${value.repData[index].rlyname} since ${value.repData[index].sentforappdt}"
                                                              : "Approved by officer on ${value.repData[index].crnapprovaldate}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.repData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                //----Deposited Start -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.depositData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Claim Amount Deposited directly by Vendor against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.depositData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Claim Amount: Rs : ${value.totatqtywd.toString()} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.depositData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.depositData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('recdate'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.depositData[index].recoveryDate}"),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('amtrec'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.depositData[index].amountRecovered}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('co6num'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.depositData[index].co6Number}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('co6date'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.depositData[index].co6Date}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('ponum'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.depositData[index].poNo}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                value.depositData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                //----Addded for amount Recovered against Warranty claim no -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.amtrecvData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Amount With-held/Recovered against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.amtrecvData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Amount With-held/Recovered: Rs.: ${value.totamtrec} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.amtrecvData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.amtrecvData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('rwhd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.amtrecvData[index].recoverydate}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('arwh'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.amtrecvData[index].amountrecovered}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('rwhdet'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.amtrecvData[index].recoverydetails} ${value.amtrecvData[index].billdtls}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('derwhd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.amtrecvData[index].dateofrecoveringdetails}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  Text(language.text('uac'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.amtrecvData[index].username} (${value.amtrecvData[index].userdesig})",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                value.amtrecvData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                //-- Added for Return of Rejected Item to Vendor Through UDM Against Warranty Claim No. on 31-01-2023-->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.retrejData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Return of Rejected Item to vendor through UDM against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.retrejData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Rejected Qty. Returned to Vendor : ${value.totalqtyreturn.toString()} ${value.retrejData[0].unitDesc} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.retrejData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.retrejData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('innd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.retrejData[index].vrNo} dt. ${value.retrejData[index].vrDate}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('qtyret'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.retrejData[index].trQty} ${value.retrejData[index].unitDesc}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('srnd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.retrejData[index].dmdNo} dt. ${value.retrejData[index].dmdDate}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('gpd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      value.retrejData[index]
                                                              .gatePassDtl ??
                                                          "NA",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('dudc'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.retrejData[index].consCodeName} ${value.retrejData[index].userName} (${value.retrejData[index].postDesig})-${value.retrejData[index].rlyName}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  // SizedBox(height: 5.0),
                                                  // Text(
                                                  //     language.text('issuenote'),
                                                  //     style: TextStyle(
                                                  //         color: Colors.black,
                                                  //         fontSize: 16, fontWeight:
                                                  //     FontWeight.w600)),
                                                  // SizedBox(height: 2.0),
                                                  // Text("Test"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                value.retrejData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                //----Added for Amount Refund against Warranty Claim No. on 15-02-2023 -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.amountRefundData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Amount Refunded against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.amountRefundData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Amount Refunded: Rs: ${value.totalamtref.toString()} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.amountRefundData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.amountRefundData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('frbd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "Bill No.${value.amountRefundData[index].billNo.toString()} dt. ${value.amountRefundData[index].billDate.toString()}\n(${value.amountRefundData[index].billdesc.toString()})",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('rr'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.amountRefundData[index].refundingRly}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('amtrr'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text("${value.amountRefundData[index].amountRefunded}", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('refd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "CO6 No. ${value.amountRefundData[index].co6Number} dt.${value.amountRefundData[index].co6Date}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
                value.amountRefundData.isNotEmpty
                    ? SizedBox(height: 5.0)
                    : SizedBox(),
                //-- Added for recovery refund -->
                value.rejectionadvicelistData.isNotEmpty &&
                        value.recRefData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Recovery Refund Letter Issued against Warranty Claim No. ${value.rejectionadvicelistData[0].warrantyno} dt. ${value.rejectionadvicelistData[0].vrdate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.recRefData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            "Total Recovery Refund Letter Amount : Rs: ${value.totrecref.toString()} (as on $currentdate)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox(),
                value.rejectionadvicelistData.isNotEmpty &&
                        value.recRefData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListView.builder(
                            itemCount: value.recRefData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                      width: 1.0,
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(5)))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('rrvn'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.recRefData[index].refundVrNo}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('rrvd'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.recRefData[index].refundVrDate}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  SizedBox(height: 5.0),
                                                  Text(language.text('rrar'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 2.0),
                                                  Text(
                                                      "${value.recRefData[index].refundValue}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  // SizedBox(height: 5.0),
                                                  // Text(
                                                  //     language.text('rrvdoc'),
                                                  //     style: TextStyle(
                                                  //         color: Colors.black,
                                                  //         fontSize: 16, fontWeight:
                                                  //     FontWeight.w600)),
                                                  // SizedBox(height: 2.0),
                                                  // Text("Test"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                    : SizedBox(),
              ],
            );
          } else {
            return Container(
              height: size.height,
              width: size.width,
              child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Lottie.asset('assets/json/no_data.json',
                        height: 120, width: 120),
                    AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TyperAnimatedText(language.text('dnf'),
                              speed: Duration(milliseconds: 150),
                              textStyle: TextStyle(fontWeight: FontWeight.bold))
                        ])
                  ])),
            );
          }
        })),
      ),
    );
  }

  String convertToWords(double amount) {
    final units = [
      'Zero',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine'
    ];
    final tens = [
      '',
      'Ten',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];
    final scales = ['', 'Thousand', 'Lakh', 'Crore'];

    String getWord(int number) {
      if (number <= 0) {
        return '';
      } else if (number < 10) {
        return units[number];
      } else if (number < 20) {
        return [
          'Ten',
          'Eleven',
          'Twelve',
          'Thirteen',
          'Fourteen',
          'Fifteen',
          'Sixteen',
          'Seventeen',
          'Eighteen',
          'Nineteen'
        ][number - 10];
      } else if (number < 100) {
        return '${tens[number ~/ 10]} ${getWord(number % 10)}';
      } else {
        return '${units[number ~/ 100]} Hundred ${getWord(number % 100)}';
      }
    }

    String convert(int number, int scale) {
      if(number == 0) {
        return '';
      }
      final word = getWord(number).trim();
      final scaleWord = scales[scale].trim();
      return '$word $scaleWord ';
    }

    var wholePart = amount.toInt();
    final decimalPart = (amount * 100 % 100).toInt();

    String words = '';
    int scale = 0;

    while (wholePart > 0) {
      final part = wholePart % 1000;
      words = '${convert(part, scale)}$words';
      wholePart ~/= 1000;
      scale++;
    }
    if (decimalPart > 0) {
      words = '$words and ${getWord(decimalPart)} Paisa';
    }

    return '${words.trim()}';
  }

  String replaceTags(String? input) {
    // Replace </br> with newline character \n
    String replaced = input!.replaceAll("</br>", "\n");

    // Remove any remaining <br/> tags
    String withoutTags = replaced.replaceAll("<br/>", "\n");

    // Remove any extra leading and trailing whitespaces
    String trimmed = withoutTags.trim();

    return trimmed;
  }
}
