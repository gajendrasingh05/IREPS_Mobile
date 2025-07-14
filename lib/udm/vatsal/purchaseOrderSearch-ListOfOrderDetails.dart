import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purchase Order Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: PurchaseOrderSearch(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PurchaseOrderSearch extends StatefulWidget {
  @override
  _PurchaseOrderSearchState createState() => _PurchaseOrderSearchState();
}

class _PurchaseOrderSearchState extends State<PurchaseOrderSearch> {
  List<PurchaseOrder> purchaseOrders = [
    PurchaseOrder(
      poSl: "1.0",
      poNumber: "NR/01160018102351",
      poDate: "12 May 2017",
      supplierName: "M/S. SHARD DHAAN SALES PVT. LTD.",
      supplierLocation: "KOLKATA",
      itemDescription: "31356679: 1/2 INCH SAFETY VALVE TYPE T-2 SET AT 110 PSI TO W.S.F PART NO. J70929/18 OR ESCORT PART NO. 3EP 5551/1. FIRM'S OFFER: 1/2 INCH SAFETY VALVE TYPE 12 SET 8 Kg/cm2TO WSF PART NO: J70929/18.",
      consignee: "EMU/GZB",
      poValue: "206386.95",
      poQtyUnit: "107",
      tur: "107",
      delyDate: "30 Nov 2017",
    ),
  ];

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
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: purchaseOrders.length,
              itemBuilder: (context, index) {
                return PurchaseOrderCard(
                  purchaseOrder: purchaseOrders[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseOrderCard extends StatefulWidget {
  final PurchaseOrder purchaseOrder;
  final int index;

  const PurchaseOrderCard({
    Key? key,
    required this.purchaseOrder,
    required this.index,
  }) : super(key: key);

  @override
  _PurchaseOrderCardState createState() => _PurchaseOrderCardState();
}

class _PurchaseOrderCardState extends State<PurchaseOrderCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                  'PO Sl',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.purchaseOrder.poSl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Content
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
                          Icon(Icons.business, color: Color(0xFF2196F3), size: 18),
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
                      _buildSupplierRow('Name :', widget.purchaseOrder.supplierName),
                      SizedBox(height: 6),
                      _buildSupplierRow('Order Number :', widget.purchaseOrder.poNumber),
                      SizedBox(height: 6),
                      _buildSupplierRow('Order Date :', widget.purchaseOrder.poDate),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildValueCard(
                        'Consignee',
                        widget.purchaseOrder.consignee,
                        Color(0xFFFF9800),
                        Icons.location_on,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildValueCard(
                        'PO Value',
                        '₹${widget.purchaseOrder.poValue}',
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
                        widget.purchaseOrder.poQtyUnit,
                        Color(0xFF2196F3),
                        Icons.inventory_2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildValueCard(
                        'T.U.R',
                        widget.purchaseOrder.tur,
                        Color(0xFF009688),
                        Icons.assessment,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Item Description with expandable functionality
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
                          Icon(Icons.description, color: Color(0xFF795548), size: 16),
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
                        widget.purchaseOrder.itemDescription,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
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
                      Icon(Icons.calendar_today, color: Color(0xFFA76535), size: 16),
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
                        widget.purchaseOrder.delyDate,
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

class PurchaseOrder {
  final String poSl;
  final String poNumber;
  final String poDate;
  final String supplierName;
  final String supplierLocation;
  final String itemDescription;
  final String consignee;
  final String poValue;
  final String poQtyUnit;
  final String tur;
  final String delyDate;

  PurchaseOrder({
    required this.poSl,
    required this.poNumber,
    required this.poDate,
    required this.supplierName,
    required this.supplierLocation,
    required this.itemDescription,
    required this.consignee,
    required this.poValue,
    required this.poQtyUnit,
    required this.tur,
    required this.delyDate,
  });
}