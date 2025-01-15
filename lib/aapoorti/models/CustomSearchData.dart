class CustomSearchData {
  String? aCCNAME;
  String? wORKARA;
  String? tENDERDESCRIPTION;
  String? tENDEROPDATE;
  int? oID;
  String? tENDERNUMBER;
  String? pDFURL;
  String? aTTACHDOCS;
  String? cORRIDETAILS;
  String? tENDERSTATUS;
  String? tENDERTYPE;
  String? bIDDINGSYSTEM;

  CustomSearchData(
      {this.aCCNAME,
        this.wORKARA,
        this.tENDERDESCRIPTION,
        this.tENDEROPDATE,
        this.oID,
        this.tENDERNUMBER,
        this.pDFURL,
        this.aTTACHDOCS,
        this.cORRIDETAILS,
        this.tENDERSTATUS,
        this.tENDERTYPE,
        this.bIDDINGSYSTEM});

  CustomSearchData.fromJson(Map<String, dynamic> json) {
    aCCNAME = json['ACC_NAME'];
    wORKARA = json['WORK_ARA'];
    tENDERDESCRIPTION = json['TENDER_DESCRIPTION'];
    tENDEROPDATE = json['TENDER_OPDATE'];
    oID = json['OID'];
    tENDERNUMBER = json['TENDER_NUMBER'];
    pDFURL = json['PDFURL'];
    aTTACHDOCS = json['ATTACH_DOCS'];
    cORRIDETAILS = json['CORRI_DETAILS'];
    tENDERSTATUS = json['TENDER_STATUS'];
    tENDERTYPE = json['TENDER_TYPE'];
    bIDDINGSYSTEM = json['BIDDING_SYSTEM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ACC_NAME'] = this.aCCNAME;
    data['WORK_ARA'] = this.wORKARA;
    data['TENDER_DESCRIPTION'] = this.tENDERDESCRIPTION;
    data['TENDER_OPDATE'] = this.tENDEROPDATE;
    data['OID'] = this.oID;
    data['TENDER_NUMBER'] = this.tENDERNUMBER;
    data['PDFURL'] = this.pDFURL;
    data['ATTACH_DOCS'] = this.aTTACHDOCS;
    data['CORRI_DETAILS'] = this.cORRIDETAILS;
    data['TENDER_STATUS'] = this.tENDERSTATUS;
    data['TENDER_TYPE'] = this.tENDERTYPE;
    data['BIDDING_SYSTEM'] = this.bIDDINGSYSTEM;
    return data;
  }
}