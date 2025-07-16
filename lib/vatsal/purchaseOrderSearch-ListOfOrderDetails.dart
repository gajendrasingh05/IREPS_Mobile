import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/helpdesk/requeststatus/view_helpdesk_details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'dart:convert';

// called in SearchPoList.dart

class PurchaseOrderSearch extends StatefulWidget {
  final int? pokey;
  PurchaseOrderSearch({this.pokey});
  @override
  _PurchaseOrderSearchState createState() => _PurchaseOrderSearchState();
}

class _PurchaseOrderSearchState extends State<PurchaseOrderSearch> {
 List<dynamic>? jsonResult;
 int? pokey;

 void initState() {
   super.initState();
   this.pokey = widget.pokey;
   fetchPO();
 }

 List data = [];

 Future<void> fetchPO() async {
   var url = AapoortiConstants.webServiceUrl + 'Tender/PODesc?param=${this.pokey}';
   final result = await http.post(Uri.parse(url));

   print("pokey: $pokey");
   print("API URL: $url");
   print("API response: ${result.body}");

   jsonResult = json.decode(result.body);

   setState(() {
     data = jsonResult!;
   });
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF1976D2),
        title: Text(
          'Purchase Order Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF1A7CE5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'List of Purchase Order Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // List Section
          Expanded(
            child: jsonResult == null ? SpinKitFadingCircle(color: Colors.cyan,size: 120,)
            : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _PurchaseOrderCard(
                  purchaseOrder: data[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PurchaseOrderCard extends StatefulWidget {
  final Map<String,dynamic> purchaseOrder;

  const _PurchaseOrderCard({
    Key? key,required this.purchaseOrder,
  }) : super(key: key);

  @override
  _PurchaseOrderCardState createState() => _PurchaseOrderCardState();
}

class _PurchaseOrderCardState extends State<_PurchaseOrderCard> {
  bool isExpanded = false;
  Map<String, String> extractSupplierData(String data) {
    int numStart = data.indexOf('NR');
    int dateStart = data.indexOf('dt.');
    int nameStart = data.indexOf('M/') ;

    String name = data.substring(nameStart).trim();
    String date = data.substring(dateStart + 4 , nameStart - 4).trim();
    String num = data.substring(numStart, dateStart).trim();

    return {
      'name': name,
      'date': date,
      'num': num,
    };
  } // supplier info breakdown

  @override
  Widget build(BuildContext context) {
    final supplierDetails = extractSupplierData(widget.purchaseOrder['SUPPNM'] ?? '');
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PO SI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.purchaseOrder['SR'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF6FD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE9ECEF), width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.business, color: Color(0xFF2196F3),
                              size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Supplier Information',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildSupplierRow('Name :', supplierDetails['name'] ?? '',),
                      SizedBox(height: 6),
                      _buildSupplierRow('Order Number :', supplierDetails['num'] ?? ''),
                      SizedBox(height: 6),
                      _buildSupplierRow('Order Date :', supplierDetails['date'] ?? ''),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildValueCard(
                        'Consignee',
                        widget.purchaseOrder['CNSIGNEE'],
                        Color(0xFFFF9800),
                        Icons.location_on,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildValueCard(
                        'PO Value',
                        '₹${widget.purchaseOrder['PO_VALUE'].toString()}',
                        Color(0xFF4CAF50),
                        Icons.currency_rupee,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildValueCard(
                        'Quantity',
                        widget.purchaseOrder['QTY'].toString(),
                        Color(0xFF2196F3),
                        Icons.inventory_2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildValueCard(
                        'T.U.R',
                        widget.purchaseOrder['TUR'],
                        Color(0xFF009688),
                        Icons.assessment,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FCFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description, color: Color(0xFF795548),
                              size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Item Description',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4C5359),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.purchaseOrder['DESC1'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'see less' : 'see more',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                // Delivery Date
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFBF8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFFAD0B2), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFFA76535),
                          size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Delivery Date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF40596D),
                        ),
                      ),
                      Spacer(),
                      Text(
                        widget.purchaseOrder['DELAYDT'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // supplier info card
  Widget _buildSupplierRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  // details cards
  Widget _buildValueCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2296F3),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}