
class Summary{
  var pONUMBER;
  var pOSR ;
  var pAYAUTHCODE ;
  var cONSECODE;
  var rAILNAME;
  var uNITTYPE;
  var uNITNAME;
  var dEPARTMENT;
  var cONSIGNEE;
  var  pAUAUTH;
  var oPENBAL;
  var bILLRECIVED;
  var bILLRETURENED;
  var bILLPASSED;
  var tOTALPENDING;
  var pENDSEVENDAYS;
  var pENDFIFTEENDAYS;
  var pENDTHIRTYDAYS;
  var pENDMORETHIRTY;
  var uNIT;
  var tODATE;
  var fROMDATE;
  var rAILCODE;


  Summary({
    this.pONUMBER,
    this.pOSR ,
    this.pAYAUTHCODE,
    this.cONSECODE,
    this.rAILNAME,
    this.uNITTYPE,
    this.uNITNAME,
    this.dEPARTMENT,
    this.cONSIGNEE,
    this.pAUAUTH,
    this.oPENBAL,
    this.bILLRECIVED,
    this.bILLRETURENED,
    this.bILLPASSED,
    this.tOTALPENDING,
    this.pENDSEVENDAYS,
    this.pENDFIFTEENDAYS,
    this.pENDTHIRTYDAYS,
    this.pENDMORETHIRTY,
    this.uNIT,
    this.tODATE,
    this.fROMDATE,
    this.rAILCODE,

  });

  Summary.fromJson(Map<String, dynamic> json) {
    pAYAUTHCODE = json['payauthcode'];
    cONSECODE = json['conscode'];
    rAILNAME = json['railname'];
    uNITTYPE = json['unittype'];
    uNITNAME = json['unitname'];
    dEPARTMENT = json['department'];
    cONSIGNEE = json['consignee'];
    pAUAUTH = json['payauth'];
    oPENBAL = json['openbal'];
    bILLRECIVED = json['billreceived'];
    bILLRETURENED = json['billreturned'];
    bILLPASSED = json['billpassed'];
    tOTALPENDING = json['totalpending'];
    pENDSEVENDAYS = json['pendsevendays'];
    pENDFIFTEENDAYS = json['pendfifteendays'];
    pENDTHIRTYDAYS = json['pendthirtydays'];
    pENDMORETHIRTY = json['pendmorethirty'];
    uNIT=json['unit'];
    tODATE=json['todate'];
    fROMDATE=json['fromdate'];
    rAILCODE=json['railcode'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payauthcode'] = this.pAYAUTHCODE;
    data['conscode'] = this.cONSECODE;
    data['railname'] = this.rAILNAME;
    data['unittype'] = this.uNITTYPE;
    data['unitname'] = this.uNITNAME;
    data['department']=this.dEPARTMENT;
    data['consignee']=this.cONSIGNEE;
    data['payauth']=this.pAUAUTH;
    data['openbal']=this.oPENBAL;
    data['billreceived']=this.bILLRECIVED;
    data['billreturned']=this.bILLRETURENED;
    data['billpassed']=this.bILLPASSED;
    data['totalpending']=this.tOTALPENDING;
    data['pendsevendays']=this.pENDSEVENDAYS;
    data['pendfifteendays']=this.pENDFIFTEENDAYS;
    data['pendthirtydays']=this.pENDTHIRTYDAYS;
    data['pendmorethirty']=this.pENDMORETHIRTY;
    data['unit']=this.uNIT;
    data['todate']=this.tODATE;
    data['fromdate']=this.fROMDATE;
    data['railcode']=this.rAILCODE;

    return data;
  }
}