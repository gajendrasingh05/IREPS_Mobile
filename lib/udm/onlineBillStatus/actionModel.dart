class ActionModel{
  var pONUMBER;
  var pOSR;
  var unit ;
  var fROMBILL;
  var vENDORNAME ;
  var iTEMDESC;
  var dOCNO ;
  var dOCDATE ;
  var pAYINGRLY;
  var pAYINGAUTHORITY ;
  var rLY ;
  var dOCTYPE ;
  var bILLNO ;
  var bILLDATE ;
  var iREPSBILLNO ;
  var iREPSBILLDATE ;
  var bILLTYPE ;
  var pAYMENTTYPE ;
  var pAYMENTPERCENTAGE ;
  var iTEMNOOFBILL ;
  var bILLAMOUNTFORITEM ;
  var cO6NO ;
  var cO6DATE ;
  var cO7NO ;
  var cO7DATE;
  var pASSEDAMOUNTFORITEM ;
  var  pAYMENTRETURNDATE ;
  var tOTALAMOUNTFORBILL ;
  var pASSEDAMOUNTFORBILL ;
  var dEDUCTEDAMOUNTFORBILL ;
  var pAIDAMOUNTFORBILL ;
  var rETURNREASON ;
  var rNOTENO ;
  var rNOTEDATE ;
  var qTYACCEPTED ;
  var qTYRECEIVED ;
  var cARDCODE;
 // var cONSNAME;
 // var cONSRLY;
  var pODATE ;
  //var cONSIGNEE ;
 // var aCCOUNTNAME;
 // var iTEMDESCRIPTION;
 // var item_code;
 // var ledger_name;
 // var description;
  var qty;
  var pAYAUTH;
 // var cO6STATUS;

  ActionModel({this.pONUMBER,this.pOSR,
    this. unit ,
    this.fROMBILL,
    this. vENDORNAME ,
    this. iTEMDESC,
    this. dOCNO ,
    this. dOCDATE ,
    this. pAYINGRLY,
    this. pAYINGAUTHORITY ,
    this. rLY ,
    this. dOCTYPE ,
    this. bILLNO ,
    this. bILLDATE ,
    this. iREPSBILLNO ,
    this. iREPSBILLDATE ,
    this. bILLTYPE ,
    this. pAYMENTTYPE ,
    this. pAYMENTPERCENTAGE ,
    this. iTEMNOOFBILL ,
    this. bILLAMOUNTFORITEM ,
    this. cO6NO ,
    this. cO6DATE ,
    this. cO7NO ,
    this. cO7DATE,
    this. pASSEDAMOUNTFORITEM ,
    this.  pAYMENTRETURNDATE ,
    this. tOTALAMOUNTFORBILL ,
    this. pASSEDAMOUNTFORBILL ,
    this. dEDUCTEDAMOUNTFORBILL ,
    this. pAIDAMOUNTFORBILL ,
    this. rETURNREASON ,
    this. rNOTENO ,
    this. rNOTEDATE ,
    this. qTYACCEPTED ,
    this. qTYRECEIVED ,
    this. cARDCODE,
   // this. cONSNAME,
   // this. cONSRLY,
    this. pODATE ,
   // this. cONSIGNEE ,
  //  this. aCCOUNTNAME,
  //  this. iTEMDESCRIPTION,
  //  this. item_code,
   // this. ledger_name,
    //String? iTEMDESCRIPTION = '';
   // this. description,
    this. qty,
    this. pAYAUTH,
  //  this. cO6STATUS,

  });

  ActionModel.fromJson(Map<String, dynamic> json) {
    pONUMBER =json['pono'];
    pOSR =json['posr'];
    fROMBILL = json['frombill'];
    vENDORNAME = json['vendorname'];
    iTEMDESC = json['itemdesc'];
    dOCNO = json['docno'];
    dOCDATE = json['docdate'];
    pAYINGRLY = json['payingrly'];
    pAYINGAUTHORITY = json['payingauthority'];
    rLY = json['rly'];
    dOCTYPE = json['doctype'];
    bILLNO = json['billno'];
    bILLDATE = json['billdate'];
    iREPSBILLNO = json['irepsbillno'];
    iREPSBILLDATE = json['irepsbilldate'];
    bILLTYPE = json['billtype'];
    pAYMENTTYPE = json['paymenttype'];
    pAYMENTPERCENTAGE = json['paymentpercentage'];
    iTEMNOOFBILL = json['itemnoofbill'];
    bILLAMOUNTFORITEM = json['billamountforitem'];
    cO6NO = json['co6no'];
    cO6DATE = json['co6date'];
    cO7NO = json['co7no'];
    cO7DATE = json['co7date'];
    pASSEDAMOUNTFORITEM = json['passedamountforitem'];
    pAYMENTRETURNDATE = json['paymentreturndate'];
    tOTALAMOUNTFORBILL = json['totalamountforbill'];
    pASSEDAMOUNTFORBILL = json['passedamountforbill'];
    dEDUCTEDAMOUNTFORBILL = json['deductedamountforbill'];
    pAIDAMOUNTFORBILL = json['paidamountforbill'];
    rETURNREASON = json['returnreason'];
    rNOTENO = json['rnoteno'];
    rNOTEDATE = json['rnotedate'];
    qTYACCEPTED = json['qtyaccepted'];
    // qTYRECEIVED = item_userDetails[0]['qtyreceived'];
    // cARDCODE = item_userDetails[0]['cardcode'];
    unit = json['unit'];
    pODATE = json['podate'];
    qty = json['qty'];
    pAYAUTH = json['payauth'];
   // cO6STATUS = json['co6status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //=======================================================
    data['pono'] = this.pONUMBER;
    data['posr'] = this.pOSR;

    data['unit'] = this. unit ;
    data['frombill'] = this.fROMBILL;
    data['vendorname'] = this. vENDORNAME ;
    data['itemdesc'] = this. iTEMDESC;
    data['docno'] = this. dOCNO ;
    data['docdate'] = this. dOCDATE ;
    data['payingrly'] = this. pAYINGRLY;
    data['payingauthority'] = this. pAYINGAUTHORITY ;
    data['rly'] = this. rLY ;
    data['doctype'] = this. dOCTYPE ;
    data['billno'] = this. bILLNO ;
    data['billdate'] = this. bILLDATE ;
    data['irepsbillno'] = this. iREPSBILLNO ;
    data['irepsbilldate'] = this. iREPSBILLDATE ;
    data['billtype'] = this. bILLTYPE ;
    data['paymenttype'] = this. pAYMENTTYPE ;
    data['paymentpercentage'] = this. pAYMENTPERCENTAGE ;
    data['itemnoofbill'] = this. iTEMNOOFBILL ;
    data['billamountforitem'] = this. bILLAMOUNTFORITEM ;
    data['co6no'] = this. cO6NO ;
    data['co6date'] = this. cO6DATE ;
    data['co7no'] = this. cO7NO ;
    data['co7date'] = this. cO7DATE;
    data['passedamountforitem'] = this. pASSEDAMOUNTFORITEM ;
    data['paymentreturndate'] = this.  pAYMENTRETURNDATE ;
    data['totalamountforbill'] = this. tOTALAMOUNTFORBILL ;
    data['passedamountforbill'] = this. pASSEDAMOUNTFORBILL ;
    data['deductedamountforbill'] = this. dEDUCTEDAMOUNTFORBILL ;
    data['paidamountforbill'] = this. pAIDAMOUNTFORBILL ;
    data['returnreason'] = this. rETURNREASON ;
    data['rnoteno'] = this. rNOTENO ;
    data['rnotedate'] = this. rNOTEDATE ;
    data['qtyaccepted'] = this. qTYACCEPTED ;
    data['qtyreceived'] = this. qTYRECEIVED ;
    data['cardcode'] = this. cARDCODE;
    //data['pono'] = this. cONSNAME;
    // data['pono'] = this. cONSRLY;
    data['podate'] = this. pODATE ;
   // data['consignee'] = this. cONSIGNEE ;
   // data['accountname'] = this. aCCOUNTNAME;
   // data['itemdescription'] = this. iTEMDESCRIPTION;
   // data['item_code'] = this. item_code;
   // data['ledger_name'] = this. ledger_name;
    //data['description'] = this. description;
    data['qty'] =  this. qty;
    data['payauth'] = this. pAYAUTH;
   // data['co6status'] = this. cO6STATUS;

    return data;
  }
}