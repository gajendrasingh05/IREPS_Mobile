class TransactionListDataModel{
  String? mACHINEDTLS;
  String? sTKVERIFIERUSERNAME;
  String? sTKVERIFIERPOST;
  String? tRANSUSERNAME;
  String? uSERTYPE;
  String? tRANSREMARKS;
  String? rEFTRANSKEY;
  String? tRANSKEY;
  String? rEJIND;
  String? tHRESHOLDLIMIT;
  String? cANCELLEDVOUCHERNO;
  String? cANCELLEDVOUCHERDATE;
  String? tRANSSTATUS;
  String? iSSEDEPOTTYPE;
  String? pONO;
  String? lOANBALQTY;
  String? lOANINDDESC;
  String? tRANSTYPEDESCRIPTION = "NA";
  String? tRANSCARDCODEDESC = "NA";
  String? rEMARKS;
  String? aCKNOWLEDGEFLAG;
  String? cARDCODE;
  String? oPENBALSTKQTY;
  String? cLOSINGBALSTKQTY;
  String? oPENBALVALUE;
  String? cLOSINGBALVALUE;
  String? sTKQTY;
  String? sTKVALUE;
  String? bAR;
  String? oRG_ZONE;
  String? rLYNAME;
  String? cONS_CODE;
  String? lEDGERNO;
  String? lEDGERNAME;
  String? lEDGERFOLIONO;
  String? lEDGERFOLIONAME;
  String? lEDGERFOLIOPLNO;
  String? tRANSUNIT;
  String? lEDGERFOLIOSHORTDESC;
  String? tRANSTYPE;
  String? pO_TYPE;
  String? vOUCHERNO;
  String? vOUCHERDATE;
  String? tRANSDATE;
  String? fIRMACCOUNTNAME;
  String? tRANSQTY;
  String? iSSUEQTY;
  String? bALANCEQTY;
  String? iSSUETOTALVALUE;
  String? iSSUETOTALQTY;
  String? rECEIPTTOTALQTY;
  String? rECEIPTTOTALVALUE;

  TransactionListDataModel({ this.mACHINEDTLS,this.sTKVERIFIERUSERNAME,this.sTKVERIFIERPOST,this.tRANSUSERNAME,this.uSERTYPE,this.tRANSREMARKS,this.rEFTRANSKEY,
    this.tRANSKEY,this.rEJIND,this.tHRESHOLDLIMIT,this.cANCELLEDVOUCHERNO,this.cANCELLEDVOUCHERDATE,this.tRANSSTATUS,this.iSSEDEPOTTYPE,this.pONO,this.lOANBALQTY,this.lOANINDDESC,this.tRANSTYPEDESCRIPTION,this.tRANSCARDCODEDESC,this.rEMARKS,this.aCKNOWLEDGEFLAG,this.cARDCODE,this.oPENBALSTKQTY,this.cLOSINGBALSTKQTY,this.oPENBALVALUE,this.cLOSINGBALVALUE,this.sTKQTY,this.sTKVALUE,this.bAR,this.oRG_ZONE,this.rLYNAME,this.cONS_CODE,this.lEDGERNO,this.lEDGERNAME,this.lEDGERFOLIONO,this.lEDGERFOLIONAME,this.lEDGERFOLIOPLNO,this.tRANSUNIT,this.lEDGERFOLIOSHORTDESC,this.tRANSTYPE,this.pO_TYPE,this.vOUCHERNO,this.vOUCHERDATE,this.tRANSDATE,this.fIRMACCOUNTNAME,this.tRANSQTY,this.iSSUEQTY,this.bALANCEQTY,this.iSSUETOTALVALUE,this.iSSUETOTALQTY,this.rECEIPTTOTALQTY,this.rECEIPTTOTALVALUE});

  factory TransactionListDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionListDataModel(
      mACHINEDTLS: json['machinedtls'],
      sTKVERIFIERUSERNAME: json['stkverifierusername'],
      sTKVERIFIERPOST: json['stkverifierpost'],
      tRANSUSERNAME: json['transusername'],
      uSERTYPE: json['usertype'],
      tRANSREMARKS: json['transremarks'],
      rEFTRANSKEY: json['reftranskey'],
      tRANSKEY: json['transkey'],
      rEJIND: json['rejind'],
      tHRESHOLDLIMIT: json['thresholdlimit'],
      cANCELLEDVOUCHERNO: json['cancelledvoucherno'],
      cANCELLEDVOUCHERDATE: json['cancelledvoucherdate'],
      tRANSSTATUS: json['transstatus'],
      iSSEDEPOTTYPE: json['issedepottype'],
      pONO: json['pono'],
      lOANBALQTY: json['loanbalqty'],
      lOANINDDESC: json['loaninddesc'],
      tRANSTYPEDESCRIPTION: json['transtypedescription'],
      tRANSCARDCODEDESC: json['transcardcodedesc'],
      rEMARKS: json['remarks'],
      aCKNOWLEDGEFLAG: json['acknowledgeflag'],
      cARDCODE: json['cardcode'],
      oPENBALSTKQTY: json['openbalstkqty'],
      cLOSINGBALSTKQTY: json['closingbalstkqty'],
      oPENBALVALUE: json['openbalvalue'],
      cLOSINGBALVALUE: json['closingbalvalue'],
      sTKQTY: json['stkqty'],
      sTKVALUE: json['stkvalue'],
      bAR: json['bar'],
      oRG_ZONE: json['org_zone'],
      rLYNAME: json['rlyname'],
      cONS_CODE: json['cons_code'],
      lEDGERNO: json['ledgerno'],
      lEDGERNAME: json['ledgername'],
      lEDGERFOLIONO: json['ledgerfoliono'],
      lEDGERFOLIONAME: json['ledgerfolioname'],
      lEDGERFOLIOPLNO: json['ledgerfolioplno'],
      tRANSUNIT: json['transunit'],
      lEDGERFOLIOSHORTDESC: json['ledgerfolioshortdesc'],
      tRANSTYPE: json['transtype'],
      pO_TYPE: json['po_type'],
      vOUCHERNO: json['voucherno'],
      vOUCHERDATE: json['voucherdate'],
      tRANSDATE: json['transdate'],
      fIRMACCOUNTNAME: json['firmaccountname'],
      tRANSQTY: json['transqty'],
      iSSUEQTY: json['issueqty'],
      bALANCEQTY: json['balanceqty'],
      iSSUETOTALVALUE: json['issuetotalvalue'],
      iSSUETOTALQTY: json['issuetotalqty'],
      rECEIPTTOTALQTY: json['receipttotalqty'],
      rECEIPTTOTALVALUE: json['receipttotalvalue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machinedtls'] = this.mACHINEDTLS;
    data['stkverifierusername'] = this.sTKVERIFIERUSERNAME;
    data['stkverifierpost'] = this.sTKVERIFIERPOST;
    data['transusername'] = this.tRANSUSERNAME;
    data['usertype'] = this.uSERTYPE;
    data['transremarks'] = this.tRANSREMARKS;
    data['reftranskey'] = this.rEFTRANSKEY;
    data['transkey'] = this.tRANSKEY;
    data['rejind'] = this.rEJIND;
    data['thresholdlimit'] = this.tHRESHOLDLIMIT;
    data['cancelledvoucherno'] = this.cANCELLEDVOUCHERNO;
    data['cancelledvoucherdate'] = this.cANCELLEDVOUCHERDATE;
    data['transstatus'] = this.tRANSSTATUS;
    data['issedepottype'] = this.iSSEDEPOTTYPE;
    data['pono'] = this.pONO;
    data['loanbalqty'] = this.lOANBALQTY;
    data['loaninddesc'] = this.lOANINDDESC;
    data['transtypedescription'] = this.tRANSTYPEDESCRIPTION;
    data['transcardcodedesc'] = this.tRANSCARDCODEDESC;
    data['remarks'] = this.rEMARKS;
    data['acknowledgeflag'] = this.aCKNOWLEDGEFLAG;
    data['cardcode'] = this.cARDCODE;
    data['openbalstkqty'] = this.oPENBALSTKQTY;
    data['closingbalstkqty'] = this.cLOSINGBALSTKQTY;
    data['openbalvalue'] = this.oPENBALVALUE;
    data['closingbalvalue'] = this.cLOSINGBALVALUE;
    data['stkqty'] = this.sTKQTY;
    data['stkvalue'] = this.sTKVALUE;
    data['bar'] = this.bAR;
    data['org_zone'] = this.oRG_ZONE;
    data['rlyname'] = this.rLYNAME;
    data['cons_code'] = this.cONS_CODE;
    data['ledgerno'] = this.lEDGERNO;
    data['ledgername'] = this.lEDGERNAME;
    data['ledgerfoliono'] = this.lEDGERFOLIONO;
    data['ledgerfolioname'] = this.lEDGERFOLIONAME;
    data['ledgerfolioplno'] = this.lEDGERFOLIOPLNO;
    data['transunit'] = this.tRANSUNIT;
    data['ledgerfolioshortdesc'] = this.lEDGERFOLIOSHORTDESC;
    data['transtype'] = this.tRANSTYPE;
    data['po_type'] = this.pO_TYPE;
    data['voucherno'] = this.vOUCHERNO;
    data['voucherdate'] = this.vOUCHERDATE;
    data['transdate'] = this.tRANSDATE;
    data['firmaccountname'] = this.fIRMACCOUNTNAME;
    data['transqty'] = this.tRANSQTY;
    data['issueqty'] = this.iSSUEQTY;
    data['balanceqty'] = this.bALANCEQTY;
    data['issuetotalvalue'] = this.iSSUETOTALVALUE;
    data['issuetotalqty'] = this.iSSUETOTALQTY;
    data['receipttotalqty'] = this.rECEIPTTOTALQTY;
    data['receipttotalvalue'] = this.rECEIPTTOTALVALUE;


    return data;
  }

}