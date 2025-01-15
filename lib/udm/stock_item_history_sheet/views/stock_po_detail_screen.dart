import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/providers/pdf_provider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class StockPoDetailScreen extends StatefulWidget {

  String filepath;
  StockPoDetailScreen({required this.filepath});

  @override
  State<StockPoDetailScreen> createState() => _StockPoDetailScreenState(filepath);
}

class _StockPoDetailScreenState extends State<StockPoDetailScreen> {

  String filepath;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  PdfViewerController? _controller;
  _StockPoDetailScreenState(this.filepath);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: SafeArea(
            child: Stack(
              children: [
                Consumer<PdfProvider>(builder: (context, value, child){
                   if(PdfState.pagelast == value.pdfState){
                     return Padding(
                       padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 45.0),
                       child: SfPdfViewer.network(
                         filepath,
                         controller: _controller,
                         initialZoomLevel: 1.0,
                         enableDoubleTapZooming: true,
                         key: _pdfViewerKey,
                         onPageChanged: (details){
                           if(details.isLastPage){
                             Provider.of<PdfProvider>(context, listen: false).showDownloadOption(2);
                           }
                           else{
                             //Provider.of<PdfProvider>(context, listen: false).showDownloadOption(1);
                           }
                         },
                         onDocumentLoaded: (details){
                           Provider.of<PdfProvider>(context, listen: false).pdfPageCount(details.document.pages.count);
                         },
                       ),
                     );
                   }
                   else{
                     return Padding(
                       padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 0.0),
                       child: SfPdfViewer.network(
                         filepath,
                         controller: _controller,
                         initialZoomLevel: 1.0,
                         enableDoubleTapZooming: true,
                         key: _pdfViewerKey,
                         onPageChanged: (details){
                           if(details.isLastPage){
                             Provider.of<PdfProvider>(context, listen: false).showDownloadOption(2);
                           }
                           else{
                             //Provider.of<PdfProvider>(context, listen: false).showDownloadOption(1);
                           }
                         },
                         onDocumentLoaded: (details){
                           Provider.of<PdfProvider>(context, listen: false).pdfPageCount(details.document.pages.count);
                         },
                       ),
                     );
                   }
                }),
                Consumer<PdfProvider>(builder: (context, value, child){
                   if(PdfState.pagelast == value.pdfState){
                     return Positioned(
                         bottom: 0.0,
                         left: 0.0,
                         right: 0.0,
                         child: Container(
                           height: 45,
                           decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0))),
                           padding: EdgeInsets.only(left: 5.0, right: 5.0),
                           width: double.infinity,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(language.text('savedpdf'), style: TextStyle(color: Colors.white, fontSize: 16)),
                               IconButton(onPressed: (){
                                 if(filepath != null){
                                   var fileName = filepath.substring(filepath.lastIndexOf("/"));
                                   UdmUtilities.showDownloadFlushBar(context, language.text('stdwnd'));
                                   UdmUtilities.download(filepath, fileName, context);
                                 }
                               }, icon: Icon(Icons.save_alt_outlined, size: 24, color: Colors.white))
                             ],
                           ),
                         ));
                   }
                   else{
                     return SizedBox();
                   }
                })
              ],
            ),
          ),
        )
    );
  }
}
