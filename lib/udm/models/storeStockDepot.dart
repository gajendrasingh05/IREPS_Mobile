class StoreStkDepot{
  var orgZone,cat,storeDepot,ward,itemCode,itemDesc,rate,unit, stkqty;
  StoreStkDepot({this.orgZone,this.storeDepot,this.stkqty,this.cat,this.itemCode,this.itemDesc,this.rate,this.unit,this.ward});

  StoreStkDepot.fromJson(Map<String, dynamic> json) {
    orgZone = json['orgzone'];
    cat= json['cat'];
    storeDepot = json['storedepot'];
    ward = json['ward'].toString();
    itemCode = json['itemcode'].toString();
    itemDesc=json['itemdescription'];
    rate=json['rate'];
    stkqty=json['stockqty'].toString();
    unit=json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgzone'] = this.orgZone;
    data['cat'] = this.cat;
    data['storedepot'] = this.storeDepot;
    data['ward'] = this.ward;
    data['itemcode'] = this.itemCode;
    data['itemdescription']=this.itemDesc;
    data['rate']=this.rate;
    data['stockqty']=this.stkqty;
    data['unit']=this.unit;
    return data;
  }
}