import 'package:flutter/material.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/change_nsdscroll_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewDemandScreen extends StatefulWidget {
  final String? fileurl;
  ViewDemandScreen(this.fileurl);

  @override
  State<ViewDemandScreen> createState() => _ViewDemandScreenState();
}

class _ViewDemandScreenState extends State<ViewDemandScreen> {
  ScrollController listScrollController = ScrollController();

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;

  //'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'

  void _onDocumentLoad() {
    if (_pdfViewerController.pageCount > 0 && _isLoading) {
      Provider.of<ChangeNSDScrollVisibilityProvider>(context, listen: false).setNSDpdfView(false);
    }
  }

  void _pdfListener() {
    final int pageCount = _pdfViewerController.pageCount;
    final int currentPage = _pdfViewerController.pageNumber;
  }

  @override
  void initState() {
    super.initState();
    _pdfViewerController.addListener(_pdfListener);
  }

  @override
  void dispose() {
    _pdfViewerController.removeListener(_pdfListener); // Remove the listener
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.text('nsdemandtitle'), style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[300],
      ),
      body: Container(
        padding: EdgeInsets.all(6.0),
        height: size.height,
        width: size.width,
        child: Consumer<ChangeNSDScrollVisibilityProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                SfPdfViewer.network(
                  widget.fileurl!, // Replace with your PDF file path
                  controller: _pdfViewerController,
                  key: _pdfViewerKey,
                  initialZoomLevel: 0.20,
                  enableDoubleTapZooming: true,
                  scrollDirection: PdfScrollDirection.vertical,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    if(details.document.pages.count > 0) {
                      UdmUtilities.showSnackBar(context, language.text('pdls'));
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),

    );
  }
}
