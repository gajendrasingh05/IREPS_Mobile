import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogOutDialog extends StatelessWidget {
  final VoidCallback press;

  const LogOutDialog({
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: _buildDialogContent(context),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Text(
                'confirmtxt'.tr,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text(
                'logoutcfrm'.tr,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide(color: Colors.white, width: 1),
                        textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('nobtn'.tr, style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide(color: Colors.white, width: 1),
                        textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                      ),
                      onPressed: press,
                      child: Text('yesbtn'.tr, style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: -30,
          left: MediaQuery.of(context).padding.left,
          right: MediaQuery.of(context).padding.right,
          child: Image.asset(
            "assets/images/web.png",
            height: 60,
            width: 60,
          ),
        )
      ],
    );
  }
}
