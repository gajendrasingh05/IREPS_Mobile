import 'package:flutter/material.dart';

enum PdfState{pagefirst, pagelast}
class PdfProvider with ChangeNotifier{

    int pageCount = 0;

    PdfState pdfState = PdfState.pagefirst;

    void setPdfState(PdfState state){
       pdfState = state;
       notifyListeners();
    }

    PdfState get pdfStateValue => pdfState;


    Future<void> pdfPageCount(int count) async{
       pageCount = count;
       notifyListeners();
    }

    Future<void> showDownloadOption(int currentpagevalue) async{
        if(currentpagevalue == 2){
          setPdfState(PdfState.pagelast);
        }
        else{
          setPdfState(PdfState.pagefirst);
        }
    }
 }