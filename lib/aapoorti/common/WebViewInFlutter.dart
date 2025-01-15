import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewInFlutter extends StatefulWidget {
  final String? url1;

  WebViewInFlutter({
    this.url1,
  });

  @override
  WebViewInFlutterState createState() => WebViewInFlutterState(this.url1);
}

class WebViewInFlutterState extends State<WebViewInFlutter> {
  String? Corri_url;
  String? yyyy, mm, dd;
  WebViewInFlutterState(String? Corri_url) {
    this.Corri_url = Corri_url;
    print("====" + Corri_url!);
  }
  @override
  Widget build(BuildContext context) {
    return Container();/*WebviewScaffold(
        url: Corri_url,
        //hidden: true,
        appBar: AppBar(iconTheme: IconThemeData(color: Colors.white), title: Text("WebView")),
        withZoom: true,
        withLocalStorage: true);*/
  }
}
