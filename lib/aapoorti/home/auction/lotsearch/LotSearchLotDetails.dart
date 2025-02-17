import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../mmis/view/components/text/read_more_text.dart';

List<dynamic>? jsonResult;
bool? visibleYes;

class LotSearchLotDetails extends StatefulWidget {
  final int? lotId, lotType;
  LotSearchLotDetails({this.lotId, this.lotType});
  @override
  LotSearchLotDetailsState createState() =>
      LotSearchLotDetailsState(this.lotId!, this.lotType!);
}

class LotSearchLotDetailsState extends State<LotSearchLotDetails> {
  List<dynamic>? jsonResult;
  int? lotId;
  int? lotType;
  String? heading = "";
  LotSearchLotDetailsState(int lotId, int lotType) {
    this.lotId = lotId;
    this.lotType = lotType;
  }
  void initState() {
    super.initState();
    this.fetchPost();
  }

  List data = [];
  Future<void> fetchPost() async {
    var v =
        AapoortiConstants.webServiceUrl + 'Auction/LotDesc?LOTID=${this.lotId}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    setState(() {
      lotType == 0
          ? visibleYes = false
          : visibleYes = true; // setting visibility
      lotType == 0
          ? heading = "Lot Details(Published)"
          : heading = "Lot Details(Sold out)";
      data = jsonResult!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.lightBlue[800],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Lot Search(Sale)',
                        style: TextStyle(color: Colors.white))),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                    //Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 25,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  heading!,
                  style: new TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.lightBlue.shade800,
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color here
                    borderRadius: BorderRadius.circular(
                        10.0), // Optional: if you want rounded corners
                  ),
                  child: jsonResult == null
                      ? SpinKitWave(
                          color: Colors.lightBlue[800],
                          size: 30.0,
                        )
                      : _SoldLotDetailsListView(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isFullWidth = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If full width, no title is shown, just display value
          if (isFullWidth)
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center, // Center text
              ),
            )
          else
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          if (!isFullWidth)
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            )
          else
            Flexible(
              child: Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                softWrap: true,
              ),
            ),
        ],
      ),
    );
  }

  Widget _SoldLotDetailsListView(BuildContext context) {
    return Container(
      color: Color(0xFFE3F2FD),
      child: jsonResult!.isEmpty
          ? Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Lot Details not found!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: jsonResult != null ? jsonResult!.length : 0,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildAccountDepartmentRow(index),
                        Column(
                          children: [
                            Text(
                              "${jsonResult![index]['ACCNM'] ?? ""} / ${jsonResult![index]['DEPTNM'] ?? ""}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                            "Lot Number:", jsonResult![index]['LOTNO'] ?? ""),
                        _buildInfoRow(
                            "Custodian:", jsonResult![index]['CUST'] ?? ""),
                        _buildDivider(),
                        _buildInfoRow(
                          "PL No./Category ",
                          " ${jsonResult![index]['PLN'] ?? ""} / ${jsonResult![index]['CATNM'] ?? ""}",
                        ),
                        _buildDivider(),
                        _buildInfoRow("Qty/Sold Rate",
                            "${jsonResult![index]['LOTQTY']?.toString() ?? ""} / ${jsonResult![index]['SOLD_RATE']?.toString() ?? ""}"),
                        _buildDivider(),
                        _buildInfoRow(
                            "GST:", "${jsonResult![index]['GST'] ?? ""}%"),
                        _buildDivider(),
                        if (visibleYes!) ...[
                          _buildInfoRow("Bidder Name:",
                              jsonResult![index]['BIDDER_NAME'] ?? ""),
                        ],
                        _buildDivider(),
                        _buildInfoRow("Excluded Items:",
                            jsonResult![index]['EXCLDITMS'] ?? ""),
                        _buildDivider(),
                        _buildInfoRow(
                            "Location:", jsonResult![index]['LOC'] ?? ""),
                        _buildDivider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Special Condition:",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            ReadMoreText(
                              jsonResult![index]['SPCLCOND'] ?? "",
                              trimLines: 3,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              colorClickableText: Colors.grey[800],
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '..More',
                              trimExpandedText: '..Less',
                            )
                          ],
                        ),
                        _buildDivider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description:",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            ReadMoreText(
                              jsonResult![index]['LOTMATDESC'] ?? "",
                              trimLines: 3,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              colorClickableText: Colors.grey[800],
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '..More',
                              trimExpandedText: '..Less',
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 6),
            ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300], thickness: 1);
  }
}
