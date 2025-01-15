import 'dart:async';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const List<String> assetNames = const <String>['assets/json/networkError.json',
];


class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LottieDemo(),
    );
  }
}

class LottieDemo extends StatefulWidget {
  const LottieDemo({Key? key}) : super(key: key);

  @override
  _LottieDemoState createState() => new _LottieDemoState();
}

class _LottieDemoState extends State<LottieDemo> with SingleTickerProviderStateMixin {
  late LottieComposition _composition;
  late String _assetName;
  late AnimationController _controller;
  late bool _repeat;

  @override
  void initState() {
    super.initState();

    _repeat = false;
    _loadButtonPressed(assetNames.last);
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _controller.addListener(() => setState(()
    {
      _controller.repeat(reverse: false);
    }));
  }

  void _loadButtonPressed(String assetName) {
    loadAsset(assetName).then((LottieComposition composition) {
      setState(() {
        _assetName = assetName;
        _composition = composition;
        _controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Lottie(
              composition: _composition,
              controller: _controller,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('                   OOPS!\nNO INTERNET CONNECTION',style: TextStyle(fontSize: 17)),
                ]),
            Padding(padding: EdgeInsets.only(bottom: 20),),
            Container(
                alignment: Alignment.bottomCenter,
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.cyan[400],
                  borderRadius: BorderRadius.circular(5),
                ),
                child:  MaterialButton(
                  onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    },//Navigator.pop(context);},
                  child: Text('Try Again',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400)),
                )
            )
          ],
        ),
      ),
    );
  }
}

Future<LottieComposition> loadAsset(String assetName) async {
  var assetData = await rootBundle.load(assetName);
  return await LottieComposition.fromByteData(assetData);
  // return await rootBundle
  //     .loadString(assetName)
  //     .then<Map<String, dynamic>>((String data) => json.decode(data))
  //     .then((Map<String, dynamic> map) => LottieComposition.);
}

