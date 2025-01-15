class Item{
   var item_code;
   var ledger_name;
   var description;
   var qty;
   var rate;
   var orgZone;
   var subConsCode;
   var plumber;
   var depoDetail;
   var issueDept;
   var issuediv;
   var itemcat;
   var cons_code;
   var issuecode;
   var issueconsg,rlyName,divName,isscongDept,ledgerName,ledgerNo,postName,folioName,plimagePath,stoqQty,unitCode,unit,booavgrat;

  Item({this.item_code, this.ledger_name, this.description, this.qty, this.rate,this.orgZone,this.subConsCode,this.booavgrat,this.depoDetail,this.cons_code,this.isscongDept,this.rlyName,this.unit,this.itemcat,this.folioName,this.plimagePath});

Item.fromJson(Map<String, dynamic> json) {
    item_code = json['plnumber'].toString().toLowerCase();
    ledger_name = json['ledgername'].toString();
    description = json['itemdescription'];
    qty = json['stockqty'].toString();
    rate = json['booavgrat'].toString();
    subConsCode=json['subconscode'];
    orgZone=json['orgzone'];
    depoDetail=json['depodetail'];
    cons_code=json['cons_code'];
    isscongDept=json['issconsgdept'];
    rlyName=json['rlyname'];
    itemcat=json['itemcat'];
    unit=json['unit'];
    folioName=json['folioname'];
    booavgrat=json['booavgrat'].toString();
    plimagePath=json['plimagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plnumber'] = this.item_code;
    data['ledgername'] = this.ledger_name;
    data['itemdescription'] = this.description;
    data['stockqty'] = this.qty;
    data['booavgrat'] = this.rate;
    data['subconscode']=this.subConsCode;
    data['orgzone']=this.orgZone;
    data['depodetail']=this.depoDetail;
    data['cons_code']=this.cons_code;
    data['issconsgdept']=this.isscongDept;
    data['rlyname']=this.rlyName;
    data['unit']=this.unit;
    data['itemcat']=this.itemcat;
    data['folioname']=this.folioName;
    data['plimagepath']=this.plimagePath;
    return data;
  }
}