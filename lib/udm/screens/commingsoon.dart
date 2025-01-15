import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  ComingSoon({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "",
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          tooltip: "Back",
          icon: CircleAvatar(
            backgroundColor: Color(0xff9da9c7),
            radius: 20,
            child: Icon(Icons.arrow_back,color: Colors.white,),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            EmptyWidget(
              image: null,
              packageImage: PackageImage.Image_2,
              title: 'Coming Soon',
              //subTitle: 'No  notification available yet',
              titleTextStyle: TextStyle(
                fontSize: 22,
                color: Color(0xff9da9c7),
                fontWeight: FontWeight.w500,
              ),
              subtitleTextStyle: TextStyle(
                fontSize: 14,
                color: Color(0xffabb8d6),
              ),
            ),
          ],
        )
      ),
    );
  }
}