import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PdfView extends StatefulWidget {
  String? pdfLink;
  PdfView(this.pdfLink);
  @override
  PdfViewState createState() => PdfViewState();
}

class PdfViewState extends State<PdfView> {

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if(request.url.toLowerCase().contains('pdf')) {
              IRUDMConstants.launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.pdfLink!));
    //if (Platform.isAndroid) WebViewWidget.platform = SurfaceAndroidWebView();
  }
  //final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebViewWidget(controller: _controller),
    );
  }
}