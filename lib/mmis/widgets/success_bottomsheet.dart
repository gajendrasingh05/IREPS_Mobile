import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessBottomSheet extends StatefulWidget {
  const SuccessBottomSheet({Key? key}) : super(key: key);

  @override
  State<SuccessBottomSheet> createState() => _SuccessBottomSheetState();
}

class _SuccessBottomSheetState extends State<SuccessBottomSheet> with TickerProviderStateMixin,WidgetsBindingObserver{

  bool _isAnimated = false;

  void _toggleAnimation() {
    setState(() {
      _isAnimated = !_isAnimated;
    });
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.4, 1],
              colors: [
                Colors.red[300]!,
                Colors.orange[400]!,
              ]),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 55, width: 55, child: Icon(Icons.done_rounded,color: Colors.white, size: 30.0), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(27.5))),
          SizedBox(height: 16),
          Text('We have successfully changed your pin, please again login now', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0)),
          SizedBox(height: 16),
          Container(
            height: 45.0,
            width: Get.width * 0.70,
            child: OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith((color) => Colors.indigo.shade400),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(200.0))),
                  elevation: MaterialStateProperty.all(7.0),
                  side: MaterialStateProperty.all(BorderSide(
                      color: Colors.white, width: 1.5))),
              onPressed: () {
                _toggleAnimation();
                Get.back();
                // Close the bottom sheet
              },
              child: Text('Login Now',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}