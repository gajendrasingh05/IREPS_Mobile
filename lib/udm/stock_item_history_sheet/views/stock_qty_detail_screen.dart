import 'package:flutter/material.dart';

class StockQtyDetailScreen extends StatefulWidget {
  const StockQtyDetailScreen({Key? key}) : super(key: key);

  @override
  State<StockQtyDetailScreen> createState() => _StockQtyDetailScreenState();
}

class _StockQtyDetailScreenState extends State<StockQtyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("Stock Quantity Detail"),
      ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Text('Consignee Stock for PL: 10062026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Modified Lube oil Pump (Herrignbone type gear)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Container(
                             height : 40,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(4.0),
                               color: Colors.blue
                             ),
                             child: Text("Stock Detail", style: TextStyle(color: Colors.white))
                         ),
                         SizedBox(height: 5.0),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               children: [
                                 Text("Cat", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                 SizedBox(height: 4.0),
                                 Text("10")
                               ],
                             ),
                             Column(
                               children: [
                                 Text("Stock", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                 SizedBox(height: 4.0),
                                 Text("1.000 Nos.")
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 5.0),
                         Column(
                           children: [
                              Text("Value (Rs.)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                              SizedBox(height: 5.0),
                              Text("150021.90", style: TextStyle(color : Colors.black, fontSize: 16))
                           ],
                         ),
                         SizedBox(height: 5.0),
                         Column(
                          children: [
                            Text("Consignee", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                            SizedBox(height: 5.0),
                            Text("090268 : DIESEL LOCO SHOP /PR [Address:Central Railway Loco Workshop Parel, Mumbai 400012, Station: PR]", style: TextStyle(color : Colors.black, fontSize: 16))
                          ],
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
    );
  }
}
