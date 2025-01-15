import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/screens/menu/home_screen.dart';
import 'package:flutter/material.dart';

class NonStockDemandsScreen extends StatefulWidget {
  const NonStockDemandsScreen({super.key});

  @override
  State<NonStockDemandsScreen> createState() => _NonStockDemandsScreenState();
}

class _NonStockDemandsScreenState extends State<NonStockDemandsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Non-Stock Demands', style: TextStyle(color: Colors.white)),backgroundColor: MyColor.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),),
      body: Center(
        child: Image.asset('assets/comingsoon.jpg', height: 120, width: 120),
      ),
    );
  }
}



