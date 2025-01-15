class ReceiptModel {

  String? railway;
  String? ponumber;
  String? cname;
  String? conscode;
  String? poqty;
  String? pounitrate;
  String? podate;
  String? accountname;
  String? posr;
  String? pounitdesc;
  String? itemdescription;
  String? expirtydate;
  String? warrepflag;
  String? rnoteurl;
  String? reftranskey;
  String? transreinspectiondesc;
  String? rejtranskey;
  String? transkey;
  String? totalreinspqty;
  String? totalreturnedqty;
  String? reinspflag;
  String? unitname;
  String? trunit;
  String? transstatus;
  /*String? ponumber;
  String?  podate;
  String? accountname;
  String? posr;
  String? itemdescription;
  String? trqty;
  String? poqty;
  String? pounitrate;*/
  String? voucherno;
  String? transdate;
  String? qtydispatched;
  String? qtyreceived;
  String? qtyaccepted;
  String? qtyrejected;
  String? challandate;
  String? challanno;
  String? curmakebrand;
  String? curproductsrno;
  String? billno;
  String? billdate;
  String? cardcode;
  String? rejind;

  //String? expirtydate;
  String? issuemakebrand;
  String? issueproductsrno;
  String? issueexpirydate;
  String? expritydate;
  String? receiptexpritydate;
  String? sortaccountaldate;
  String? vouchernumber;
  String? accountaldat;
  String? makebrand;
  String? productsrno;
  String? trqty;
  //String? trunit;
  String? renspectionremark;
  String? issuevrno;
  String? issuevrdate;
  String? issueqty;
  String? issueunit;
  String? issuetransdetails;
  String? receiptbalqty;
  String? receiptmakebrand;
  String? receiptprductsrno;


  ReceiptModel({

    this.ponumber,
    this.cname,
    this.conscode,
    this.poqty,
    this.pounitrate,
    this.podate,
    this.accountname,
    this.posr,
    this.pounitdesc,
    this.itemdescription,


    this.expirtydate,
    this.warrepflag,
    this.rnoteurl,
    this.reftranskey,
    this.transreinspectiondesc,
    this.rejtranskey,
    this.transkey,
    this.totalreinspqty,
    this.totalreturnedqty,
    this.reinspflag,
    this.unitname,
    this.trunit,
    this.transstatus,
    /* this. ponumber,
    this.  podate,
    this. accountname,
    this. posr,
    this.itemdescription,
    this.trqty,
    this.poqty,
    this.pounitrate,*/
    this.voucherno,
    this.transdate,
    this.qtydispatched,
    this.qtyreceived,
    this.qtyaccepted,
    this.qtyrejected,
    this.challandate,
    this.challanno,
    this.curmakebrand,
    this.curproductsrno,
    this.billno,
    this.billdate,
    this.cardcode,
    this.rejind,

    //this.expirtydate,
    this.issuemakebrand,
    this.issueproductsrno,
    this.issueexpirydate,
    this.expritydate,
    this.receiptexpritydate,
    this.sortaccountaldate,
    this.vouchernumber,
    this.accountaldat,
    this. makebrand,
    this.productsrno,
    this.trqty,
    //this.trunit,
    this.renspectionremark,
    this.issuevrno,
    this.issuevrdate,
    this.issueqty,
    this.issueunit,
    this.issuetransdetails,
    this.receiptbalqty,
    this.receiptmakebrand,
    this.receiptprductsrno,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      ponumber: json['ponumber'].toString(),
      cname: json['cname'].toString(),
      conscode: json['conscode'].toString(),
      poqty: json['poqty'].toString(),
      pounitrate: json['pounitrate'].toString(),
      podate: json['podate'].toString(),
      accountname: json['accountname'].toString(),
      posr: json['posr'].toString(),
      pounitdesc: json['pounitdesc'].toString(),
      itemdescription: json['itemdescription'].toString(),


      expirtydate: json['expirtydate'].toString(),
      warrepflag: json['warrepflag'].toString(),
      rnoteurl: json['rnoteurl'].toString(),
      reftranskey: json['reftranskey'].toString(),
      transreinspectiondesc: json['transreinspectiondesc'].toString(),
      rejtranskey: json['rejtranskey'].toString(),
      transkey: json['transkey'].toString(),
      totalreinspqty: json['totalreinspqty'].toString(),
      totalreturnedqty: json['totalreturnedqty'].toString(),
      reinspflag: json['reinspflag'].toString(),
      unitname: json['unitname'].toString(),
      trunit: json['trunit'].toString(),
      transstatus: json['transstatus'].toString(),
      /* ponumber: json['ponumber'].toString(),
   podate: json['podate'].toString(),
   accountname: json['accountname'].toString(),
   posr: json['posr'].toString(),
   itemdescription: json['itemdescription'].toString(),
   trqty: json['trqty'].toString(),
   poqty: json['poqty'].toString(),
  pounitrate: json['pounitrate'].toString(),*/
      voucherno: json['voucherno'].toString(),
      transdate: json['transdate'].toString(),
      qtydispatched: json['qtydispatched'].toString(),
      qtyreceived: json['qtyreceived'].toString(),
      qtyaccepted: json['qtyaccepted'].toString(),
      qtyrejected: json['qtyrejected'].toString(),
      challandate: json['challandate'].toString(),
      challanno: json['challanno'].toString(),
      curmakebrand: json['curmakebrand'].toString(),
      curproductsrno: json['curproductsrno'].toString(),
      billno: json['billno'].toString(),
      billdate: json['billdate'].toString(),
      cardcode: json['cardcode'].toString(),
      rejind: json['rejind'].toString(),

      // expirtydate: json['expirtydate'].toString(),
      issuemakebrand: json['issuemakebrand'].toString(),
      issueproductsrno: json['issueproductsrno'].toString(),
      issueexpirydate: json['issueexpirydate'].toString(),
      expritydate: json['expritydate'].toString(),
      receiptexpritydate: json['receiptexpritydate'].toString(),
      sortaccountaldate: json['sortaccountaldate'].toString(),
      vouchernumber: json['vouchernumber'].toString(),
      accountaldat: json['accountaldat'].toString(),
      makebrand: json['makebrand'].toString(),
      productsrno: json['productsrno'].toString(),
      trqty: json['trqty'].toString(),
      // trunit: json['trunit'].toString(),
      renspectionremark: json['renspectionremark'].toString(),
      issuevrno: json['issuevrno'].toString(),
      issuevrdate: json['issuevrdate'].toString(),
      issueqty: json['issueqty'].toString(),
      issueunit: json['issueunit'].toString(),
      issuetransdetails: json['issuetransdetails'].toString(),
      receiptbalqty: json['receiptbalqty'].toString(),
      receiptmakebrand: json['receiptmakebrand'].toString(),
      receiptprductsrno: json['receiptprductsrno'].toString(),


    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ponumber'] = this. ponumber;
    data['cname'] = this. cname;
    data['conscode'] =  this. conscode;
    data['poqty'] =  this. poqty;
    data['pounitrate'] = this. pounitrate;
    data['podate'] = this. podate;
    data['accountname'] =  this. accountname;
    data['posr'] =  this. posr;
    data['pounitdesc'] =  this. pounitdesc;
    data['itemdescription'] =   this. itemdescription;


    data['expirtydate'] = this. expirtydate;
    data['warrepflag'] =  this. warrepflag;
    data['rnoteurl'] =  this. rnoteurl;
    data['reftranskey'] =  this. reftranskey;
    data['transreinspectiondesc'] =  this. transreinspectiondesc;
    data['rejtranskey'] =   this. rejtranskey;
    data['transkey'] =  this. transkey;
    data['totalreinspqty'] =  this. totalreinspqty;
    data['totalreturnedqty'] =   this. totalreturnedqty;
    data['reinspflag'] =  this. reinspflag;
    data['unitname'] =  this. unitname;
    data['trunit'] =  this. trunit;
    data['transstatus'] =  this. transstatus;
    /* data['ponumber'] =this. ponumber;
    data['podate'] =this.  podate;
   data['accountname'] = this. accountname;
    data['posr'] =this. posr;
   data['itemdescription'] = this.itemdescription;
    data['trqty'] =this.trqty;
   data['poqty'] = this.poqty;
   data['pounitrate'] = this.pounitrate;*/
    data['voucherno'] = this.voucherno;
    data['transdate'] = this.transdate;
    data['qtydispatched'] = this.qtydispatched;
    data['qtyreceived'] = this.qtyreceived;
    data['qtyaccepted'] =  this.qtyaccepted;
    data['qtyrejected'] = this.qtyrejected;
    data['challandate'] = this.challandate;
    data['challanno'] =  this.challanno;
    data['curmakebrand'] = this.curmakebrand;
    data['curproductsrno'] = this.curproductsrno;
    data['billno'] = this.billno;
    data['billdate'] = this.billdate;
    data['cardcode'] = this.cardcode;
    data['rejind'] =  this.rejind;

    //data['expirtydate'] =this.expirtydate;
    data['issuemakebrand'] = this.issuemakebrand;
    data['issueproductsrno'] = this.issueproductsrno;
    data['issueexpirydate'] =  this.issueexpirydate;
    data['expritydate'] =  this.expritydate;
    data['receiptexpritydate'] =this.receiptexpritydate;
    data['sortaccountaldate'] =this.sortaccountaldate;
    data['vouchernumber'] = this.vouchernumber;
    data['accountaldat'] = this.accountaldat;
    data['makebrand'] = this. makebrand;
    data['productsrno'] = this.productsrno;
    data['trqty'] = this.trqty;
    //data['trunit'] =this.trunit;
    data['renspectionremark'] = this.renspectionremark;
    data['issuevrno'] =  this.issuevrno;
    data['issuevrdate'] =  this.issuevrdate;
    data['issueqty'] = this.issueqty;
    data['issueunit'] = this.issueunit;
    data['issuetransdetails'] = this.issuetransdetails;
    data['receiptbalqty'] = this.receiptbalqty;
    data['receiptmakebrand'] = this.receiptmakebrand;
    data['receiptprductsrno'] =this.receiptprductsrno;


    return data;
  }
}