import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/loginProvider.dart';

import '../models/user.dart';

enum ButtonState { Idle, Busy, Completed }

class SignInButton extends StatefulWidget {
  @override
  final String? text;
  final Function? action;
  final LoginState? loginstate;
  // ButtonState state = ButtonState.Idle;

  SignInButton({this.text, this.action, this.loginstate});

  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> with TickerProviderStateMixin {
  late AnimationController _loginButtonController;
  late Animation<double> buttonSqueezeAnimation;
  Animation<double>? buttonBackToOriginal;
  User? user;

  void initState() {
    _loginButtonController = AnimationController(duration: Duration(seconds: 1), vsync: this);
    buttonSqueezeAnimation = Tween(
      begin: 320.0,
      end: 60.0,
    ).animate(CurvedAnimation(parent: _loginButtonController, curve: Interval(0.0, 0.250)));
    _loginButtonController.addListener(() {
      if(_loginButtonController.isAnimating){
          setState(() {});
      }
    });
    super.initState();
  }

  dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
         widget.action!();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("login provider ${widget.loginstate}");
     if(widget.loginstate == LoginState.Busy){
       _loginButtonController.forward();
     }
     return InkWell(
      onTap: widget.loginstate == LoginState.FinishedWithError ? _playAnimation : widget.loginstate == LoginState.Idle ? _playAnimation : null,
      child: Container(
        width: buttonSqueezeAnimation.value,
        height: 60,
        alignment: Alignment.center,
        child: buttonSqueezeAnimation.value > 65.0
            ? Text(widget.text!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))
            : widget.loginstate == LoginState.Busy ? CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ) : widget.loginstate == LoginState.Complete ? CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check_sharp,
                          color: Colors.white,
                          size: 50,
                        )) : CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.clear_sharp,
                          color: Colors.white,
                          size: 50,
                        ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonSqueezeAnimation.value > 65 ? 10 : buttonSqueezeAnimation.value),
          gradient: LinearGradient(
            colors: [Colors.red[300]!, Colors.orange[700]!],
          ),
        ),
      ),
    );
  }
}
