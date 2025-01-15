class Stock{
   var itemCat;
   var aac;
   var depotDetail;
   var issueCode;
   var railway;
   var stkItem;
   var issueConsgDept;
   var ledgerNo;
   var vs;
   var consumInd;
   var ledgerType;
   var ledgerName;
   var ledgerFolioNo;
   var ledgerFolioName;
   var ledgerFolioPlNo;
   var ledgerFolioShortDesc;
   var stkqty;
   var bar;
   var stkValue;
   var stkUnit;
   var thresholdLimit;
   var lmrdt,lmidt;


  Stock({this.itemCat,this.aac,this.depotDetail,this.issueCode,this.railway,this.stkItem,this.issueConsgDept
    ,this.ledgerNo,this.vs,this.consumInd,this.ledgerType,this.ledgerName,this.ledgerFolioNo
    ,this.ledgerFolioName,this.ledgerFolioPlNo,this.ledgerFolioShortDesc,this.stkqty
    ,this.bar,this.stkValue,this.stkUnit,this.thresholdLimit,this.lmidt,this.lmrdt});

  Stock.fromJson(Map<String, dynamic> json) {
    itemCat = json['itemcat'];
    aac = json['aac'];
    depotDetail = json['depodetail'];
    issueCode = json['issueccode'].toString();
    railway = json['rlyname'].toString();
    stkItem=json['stkitem'];
    issueConsgDept=json['issconsgdept'];
    ledgerNo=json['ledgerno'];
    vs=json['vs'];
    consumInd=json['consumind'];
    ledgerName=json['ledgername'];
    ledgerFolioNo=json['ledgerfoliono'];
    ledgerFolioName=json['ledgerfolioname'];
    ledgerFolioPlNo=json['ledgerfolioplno'];
    ledgerFolioShortDesc=json['ledgerfolioshortdesc'];
    stkqty=json['stkqty'];
    bar=json['bar'];
    stkValue=json['stkvalue'];
    stkUnit=json['stkunit'];
    thresholdLimit=json['thresholdlimit'];
    lmrdt=json['lmrdt'];
    lmidt=json['lmidt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemcat'] = this.itemCat;
    data['aac'] = this.aac;
    data['depodetail'] = this.depotDetail;
    data['issueccode'] = this.issueCode;
    data['rlyname'] = this.railway;
    data['stkitem']=this.stkItem;
    data['issconsgdept']=this.issueConsgDept;
    data['ledgerno']=this.ledgerNo;
    data['ledgername']=this.ledgerName;
    data['ledgerfoliono']=this.ledgerFolioNo;
    data['ledgerfolioplno']=this.ledgerFolioPlNo;
    data['ledgerfolioname']=this.ledgerFolioName;
    data['ledgerfolioshortdesc']=this.ledgerFolioShortDesc;
    data['stkqty']=this.stkqty;
    data['stkvalue']=this.stkValue;
    data['stkunit']=this.stkUnit;
    data['thresholdlimit']=this.thresholdLimit;
    data['lmrdt']=this.lmrdt;
    data['lmidt']=this.lmidt;
    data['bar']=this.bar;
    return data;
  }
}