class Status{
  var rlyCode;
  var cONSNAME;
  var cONSRLY;
  var pONUMBER;
  var pODATE ;
  var cONSIGNEE ;
  var aCCOUNTNAME;
  var pOSR ;
  var iTEMDESCRIPTION;

  Status({
    this.rlyCode,
    this.cONSNAME,
    this.cONSRLY,
    this.pONUMBER,
    this.pODATE,
    this.cONSIGNEE,
    this.aCCOUNTNAME,
    this.pOSR,
    this.iTEMDESCRIPTION,
  });

  Status.fromJson(Map<String, dynamic> json) {
    rlyCode=json['rlyCode'];
    cONSNAME=json['consname'];
    cONSRLY=json['consrly'];
    pONUMBER=json['ponumber'];
    pODATE=json['podate'];
    cONSIGNEE=json['consignee'];
    aCCOUNTNAME=json['accountname'];
    pOSR=json['posr'];
    iTEMDESCRIPTION=json['itemdescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rlyCode'] = this.rlyCode;
    data['consname'] = this.cONSNAME;
    data['consrly'] = this.cONSRLY;
    data['ponumber'] = this.pONUMBER;
    data['podate'] = this.pODATE;
    data['consignee']=this.cONSIGNEE;
    data['accountname'] = this.aCCOUNTNAME;
    data['posr'] = this.pOSR;
    data['itemdescription'] = this.iTEMDESCRIPTION;

    return data;
  }
}
