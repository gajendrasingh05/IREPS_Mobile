import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpDeskScreen extends StatefulWidget {

  final int data;

  HelpDeskScreen({required this.data});

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.red.shade300,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(language.text('helpdesktitle'), style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: widget.data == 0 ? SizedBox() : CustomBottomNav(currentIndex: 3),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color:Colors.red.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image(image: AssetImage("assets/images/railwayss.png"), height: 80, width: 80),
                    //SizedBox(height: 10),
                    Text(language.text('qss'),style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.underline)),
                    SizedBox(height: 10),
                    Text('${language.text('contactus')}::',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: TextDecoration.none)),
                    SizedBox(height: 10),
                    //Text("For Any Query/Suggestions/Supports"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: '${language.text('phone')} :: ',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: '011-23761525', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                makePhoneCall('011-23761525');
                              },
                              child: Icon(Icons.phone, size: 25),
                            ),
                            Text(language.text('cnow'), style: TextStyle(fontSize: 15, fontWeight:  FontWeight.w600))
                          ],
                        )
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     RichText(
                    //       textAlign: TextAlign.start,
                    //       text: TextSpan(
                    //         text: '${language.text('email')} :: ',
                    //         style: TextStyle(fontSize: 16, color: Colors.black),
                    //         children: <TextSpan>[
                    //           TextSpan(text: 'udm@cris.org.in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    //         ],
                    //       ),
                    //     ),
                    //     //Text("Email :: udm@cris.org.in"),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         InkWell(
                    //           onTap: (){
                    //             sendEmail('udm@cris.org.in');
                    //           },
                    //           child: Icon(Icons.email, size: 25),
                    //         ),
                    //         Text(language.text('enow'), style: TextStyle(fontSize: 15, fontWeight:  FontWeight.w600))
                    //       ],
                    //     )
                    //
                    //   ],
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Subject&body=message',
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }
}
