import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/view_demand_screen.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'NoConnection.dart';
import 'downloadFile.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class UdmUtilities {
  static Future<void>? ackAlert(BuildContext context, String fileUrl, String fileName) {
    if(Platform.isAndroid) {
      return showDialog(context: context, builder: (_) => AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color:
                            Colors.blue, //new Color.fromRGBO(255, 0, 0, 0.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                minWidth: 50,
                                onPressed: () {
                                  //Navigator.of(context, rootNavigator: true).pop();
                                  UdmUtilities.openPdf(
                                      context, fileUrl, fileName);
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.open_in_new,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                    ),
                                    Text(
                                      "Open",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              Container(
                                width: 1,
                                color: Colors.black,
                              ),
                              MaterialButton(
                                minWidth: 50,
                                onPressed: () async {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  //Navigator.pop(context, false);
                                  //Navigator.pop(context);
                                  //Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Downloading started...",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green,
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                  UdmUtilities.download(
                                      fileUrl, fileName, context);
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.file_download,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                    ),
                                    Text(
                                      "Download",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ])),
              ));
    } else
      UdmUtilities.openPdf(context, fileUrl, fileName);
  }

  static Future<void>? openPdfBottomSheet(BuildContext context, String fileUrl, String fileName, String moduleName) {
    if (Platform.isAndroid) {
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
          //backgroundColor: Colors.white,
          isDismissible: false,
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                    colors: [Colors.red[300]!, Colors.orange[400]!],
                    stops: [0.4, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(moduleName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(onTap: (){
                              Navigator.of(context).pop();
                            }, child: Container(height: 30, width: 30, alignment: Alignment.center, child: Icon(Icons.clear, color: Colors.red.shade300), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.white))),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton.icon(
                                onPressed: (){
                                  //UdmUtilities.openPdf(context, fileUrl, fileName);
                                  if(moduleName == "NS Demand Summary" || moduleName == "एनएस डिमांड सारांश"){
                                    Navigator.of(context).pop();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDemandScreen(fileUrl)));
                                  }
                                  else {
                                    UdmUtilities.openPdf(context, fileUrl, fileName);
                                  }
                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red.shade300)))),
                                icon: Icon(Icons.open_in_new, color: Colors.red.shade300),
                                label: Text(" Open", style: TextStyle(color: Colors.red.shade300))
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton.icon(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Downloading started...", style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green,
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                  UdmUtilities.download(fileUrl, fileName, context);
                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red.shade300)))),
                                icon: Icon(Icons.file_download, color: Colors.red.shade300),
                                label: Text(" Download", style: TextStyle(color: Colors.red.shade300))),
                          ),
                        ],
                      ),
                    ),
                    // ListTile(
                    //     leading: const Icon(Icons.open_in_new),
                    //     title: const Text('Open'),
                    //     onTap: () {
                    //       //Navigator.of(context).pop();
                    //       UdmUtilities.openPdf(context, fileUrl, fileName);
                    //     }),
                    // ListTile(
                    //   leading: const Icon(Icons.file_download),
                    //   title: const Text('Download'),
                    //   onTap: () {
                    //     Navigator.of(context).pop();
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //       content: Text("Downloading started...", style: TextStyle(color: Colors.white)),
                    //       backgroundColor: Colors.green,
                    //       duration: Duration(milliseconds: 1500),
                    //     ));
                    //     UdmUtilities.download(fileUrl, fileName, context);
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          }
      );
    } else
      UdmUtilities.openPdf(context, fileUrl, fileName);
  }

  static Future<void>? openPdfSheet(BuildContext context, String fileUrl, String fileName){
    if(Platform.isAndroid){
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0), child: Text('Warranty Rejection Advice', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: (){
                              UdmUtilities.openPdf(context, fileUrl, fileName);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.grey)))),
                            icon: const Icon(Icons.open_in_new, color: Colors.black),
                            label: const Text("Open", style: TextStyle(color: Colors.black))),
                        const SizedBox(width: 40),
                        ElevatedButton.icon(
                            onPressed: (){
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Downloading started...", style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.green,
                                duration: Duration(milliseconds: 1500),
                              ));
                              UdmUtilities.download(fileUrl, fileName, context);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.grey)))),
                            icon: const Icon(Icons.file_download, color: Colors.black),
                            label: const Text("Download", style: TextStyle(color: Colors.black))),
                      ],
                    )
                  ])
          )
      );
    }
    else{
      UdmUtilities.openPdf(context, fileUrl, fileName);
    }
  }

  static Future<void>? openAlertBottomSheet(BuildContext context, String warningtitle, String warningdesc){
    return showModalBottomSheet(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
          //backgroundColor: Colors.white,
          isDismissible: false,
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    stops: [0.4, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(warningtitle, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16, decoration: TextDecoration.underline)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(onTap: (){
                              Navigator.of(context).pop();
                            }, child: Container(height: 30, width: 30, alignment: Alignment.center, child: Icon(Icons.clear, color: Colors.white), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.red.shade300))),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10.0), child: Container(
                      child: Text(warningdesc, textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 16)),
                    )),
                    Padding(padding: EdgeInsets.all(10.0), child: InkWell(
                      onTap: (){Navigator.of(context).pop();},
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.red.shade300),
                        child: Text("OK", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ))
                  ],
                ),
              ),
            );
          }
      );
    }

  static Future<void> openPdf(BuildContext context, String fileUrl, String fileName) async {
    if(fileName != "/null") {
      bool check = await checkconnection();
      if(check == false) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
      } else {
        try {
          Navigator.of(context, rootNavigator: true).pop();
          File file = await DefaultCacheManager().getSingleFile(fileUrl);
          OpenFilex.open(file.absolute.path);
        } on HttpExceptionWithStatus catch (_) {
          Navigator.of(context, rootNavigator: true).pop();
          showInSnackBar(context, "File Not Found");
        } catch (e) {
          Navigator.of(context, rootNavigator: true).pop();
          showInSnackBar(context, "Something unexpected occurred.");
        }
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showInSnackBar(context, "File Not Found");
    }
  }

  static void download(String fileurl, String filename, BuildContext context) async {
    if(filename != "/null") {
      downloadFile(fileurl).then((filepath) {
        Navigator.of(context).push(PageRouteBuilder(barrierColor: Colors.black54,
            opaque: false,
            pageBuilder: (context, _, __) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Text('File Saved'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('File saved at:'),
                        Text(filepath),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    // TextButton(
                    //   child: Text('OPEN'),
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //     print("${filepath.split("files/")[0]}files");
                    //     openGalleryFolder("${filepath.split("files/")[0]}files");
                    //   },
                    // ),
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //OpenFile.open(filepath);
                      },
                    ),
                  ],
                )));
      });
    } else {
      //Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
      showInSnackBar(context, "File Not Found");
    }
  }

  static void showSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
      duration: Duration(milliseconds: 1500),
    ));
  }

  static void showDownloadFlushBar(BuildContext context, String value) {
    Flushbar(
      message: value,
      messageColor: Colors.white,
      forwardAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      titleColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      reverseAnimationCurve: Curves.easeOut,
      flushbarPosition: FlushbarPosition.BOTTOM,
      positionOffset: 20,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  static void showFlushBar(BuildContext context, String value) {
    Flushbar(
      message: value,
      messageColor: Colors.white,
      forwardAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      titleColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      reverseAnimationCurve: Curves.easeOut,
      flushbarPosition: FlushbarPosition.BOTTOM,
      positionOffset: 20,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, size: 28, color: Colors.white),
    ).show(context);
  }

  static void showWarningFlushBar(BuildContext context, String value) {
    Flushbar(
      message: value,
      messageColor: Colors.white,
      forwardAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      titleColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      reverseAnimationCurve: Curves.easeOut,
      flushbarPosition: FlushbarPosition.BOTTOM,
      positionOffset: 20,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.error, size: 28, color: Colors.white),
    ).show(context);
  }

  static void showInSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(value),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.redAccent[100]),
    );
  }

  static Future<bool> checkconnection() async {
    var connectivityresult;
    try {
      connectivityresult = await InternetAddress.lookup('google.com');
      if (connectivityresult != null) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static void showAlertDialog(BuildContext ctx) {
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

  static Widget _dialog(BuildContext context) {
    return AlertDialog(
      title: Text(Provider.of<LanguageProvider>(context, listen: false).text('rwalert')),
      content: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
           TyperAnimatedText(
            Provider.of<LanguageProvider>(context, listen: false).text('rwmonthwrtitle'),
            speed: Duration(milliseconds: 15),
            textStyle: const TextStyle(color: Colors.black, fontSize: 16, backgroundColor: Colors.white)),
      ]),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
            textStyle: TextStyle(
                color: Colors.white, fontSize: 16, fontStyle: FontStyle.normal),
          ),
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }

  static void openGalleryFolder(String folderPath) async{
    final galleryUrl = 'file://$folderPath';
    if (await canLaunch(galleryUrl)) {
      await launch(galleryUrl);
    } else {
      throw 'Could not open gallery folder';
    }
  }
}
