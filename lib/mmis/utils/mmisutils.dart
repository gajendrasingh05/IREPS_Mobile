import 'package:flutter/material.dart';

class MmisUtils{

  void showAlertDialog(BuildContext ctx) {
    showGeneralDialog(
      context: ctx,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _dialog(BuildContext context){
    return Container();
  }
}