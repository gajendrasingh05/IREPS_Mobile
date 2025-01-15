class OpenBalance{
  var rly;
  var iTEMNOOFBILL;
  var pONO;
  var pAYINGAUTHORITY ;
  var pODATE ;
  var pOSR;
  var iTEMDESC;
  var vENDORNAME ;
  var dOCTYPE ;
  var rAILNAME;
  var uNITTYPE;
  var uNITNAME;
  var cONSIGNEE ;
  var dEPARTMENT;
  var dOCNO ;
  var dOCDATE ;
  var bILLNO ;
  var bILLDATE ;
  var iREPSBILLNO ;
  var iREPSBILLDATE ;
  var qty;
  var uNIT ;
  var bILLAMOUNTFORITEM;



  OpenBalance({
    this.rly,
    this.iTEMNOOFBILL,
    this.pONO,
    this.pAYINGAUTHORITY,
    this.pODATE,
    this. pOSR ,
    this.iTEMDESC,
    this. vENDORNAME ,
    this. dOCTYPE,
    this. rAILNAME ,
    this. uNITTYPE ,
    this. uNITNAME,
    this. cONSIGNEE ,
    this. dEPARTMENT ,
    this. dOCNO ,
    this. dOCDATE ,
    this. bILLNO ,
    this. bILLDATE ,
    this. iREPSBILLNO ,
    this. iREPSBILLDATE ,
    this. qty ,
    this. uNIT ,
    this. bILLAMOUNTFORITEM ,

  });

  OpenBalance.fromJson(Map<String, dynamic> json) {
    rly = json['rly'];
    iTEMNOOFBILL = json['itemnoofbill'];
    pONO = json['pono'];
    pAYINGAUTHORITY =json['payingauthority'];
    pODATE =json['podate'];
    pOSR = json['posr'];
    iTEMDESC = json['itemdesc'];
    vENDORNAME = json['vendorname'];
    dOCTYPE = json['doctype'];
    rAILNAME = json['railname'];
    uNITTYPE = json['unittype'];
    uNITNAME = json['unitname'];
    cONSIGNEE = json['consignee'];
    dEPARTMENT = json['department'];
    dOCNO = json['docno'];
    dOCDATE = json['docdate'];
    bILLNO = json['billno'];
    bILLDATE = json['billdate'];
    iREPSBILLNO = json['irepsbillno'];
    qty = json['qty'];
    uNIT = json['unit'];
    bILLAMOUNTFORITEM = json['billamountforitem'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rly'] = this.rly;
    data['itemnoofbill'] = this.iTEMNOOFBILL;
    data['pono'] = this.pONO;
    data['podate'] = this.pODATE;
    data['posr'] = this. pOSR ;
    data['itemdesc'] = this.iTEMDESC;
    data['vendorname'] = this. vENDORNAME ;
    data['doctype'] = this. dOCTYPE;
    data['railname'] = this. rAILNAME ;
    data['unittype'] = this. uNITTYPE ;
    data['unitname'] = this. uNITNAME;
    data['consignee'] = this. cONSIGNEE ;
    data['department'] = this. dEPARTMENT ;
    data['dOCNO'] = this. dOCNO ;
    data['docdate'] = this. dOCDATE ;
    data['billno'] = this. bILLNO ;
    data['billdate'] = this. bILLDATE ;
    data['irepsbillno'] = this. iREPSBILLNO ;
    data['qty'] = this. qty ;
    data['unit'] = this. uNIT ;
    data['billamountforitem'] = this. bILLAMOUNTFORITEM ;

    return data;
  }


}