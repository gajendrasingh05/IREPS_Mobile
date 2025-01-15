class StockItemDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<ItemDetailData>? data;

  StockItemDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockItemDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ItemDetailData>[];
      json['data'].forEach((v) {
        data!.add(new ItemDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_for'] = this.apiFor;
    data['count'] = this.count;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetailData {
  String? uplRly;
  String? uplNo;
  String? des;
  String? drgNo;
  String? drgAlt;
  String? spec;
  String? purSec;
  String? fileSrNo;
  String? unit;
  String? abcCat;
  String? avgBar;
  String? source;
  String? tradeGroup;
  String? purAuth;
  String? purType;
  String? cpMm;
  String? srsMm;
  String? vs;
  String? shortname;
  String? dt1;
  String? remk;
  String? pam;
  String? mustchg;
  String? shelf;
  String? oldPlnos;
  String? uplno;
  String? oldplno;
  String? uniyn;
  String? weightKg;
  String? rlyname;
  int? rowId;

  ItemDetailData(
      {this.uplRly,
        this.uplNo,
        this.des,
        this.drgNo,
        this.drgAlt,
        this.spec,
        this.purSec,
        this.fileSrNo,
        this.unit,
        this.abcCat,
        this.avgBar,
        this.source,
        this.tradeGroup,
        this.purAuth,
        this.purType,
        this.cpMm,
        this.srsMm,
        this.vs,
        this.shortname,
        this.dt1,
        this.remk,
        this.pam,
        this.mustchg,
        this.shelf,
        this.oldPlnos,
        this.uplno,
        this.oldplno,
        this.uniyn,
        this.weightKg,
        this.rlyname,
        this.rowId});

  ItemDetailData.fromJson(Map<String, dynamic> json) {
    uplRly = json['upl_rly'];
    uplNo = json['upl_no'];
    des = json['des'];
    drgNo = json['drg_no'];
    drgAlt = json['drg_alt'];
    spec = json['spec'];
    purSec = json['pur_sec'];
    fileSrNo = json['file_sr_no'];
    unit = json['unit'];
    abcCat = json['abc_cat'];
    avgBar = json['avg_bar'];
    source = json['source'];
    tradeGroup = json['trade_group'];
    purAuth = json['pur_auth'];
    purType = json['pur_type'];
    cpMm = json['cp_mm'];
    srsMm = json['srs_mm'];
    vs = json['vs'];
    shortname = json['shortname'];
    dt1 = json['dt1'];
    remk = json['remk'];
    pam = json['pam'];
    mustchg = json['mustchg'];
    shelf = json['shelf'];
    oldPlnos = json['old_plnos'];
    uplno = json['uplno'];
    oldplno = json['oldplno'];
    uniyn = json['uniyn'];
    weightKg = json['weight_kg'];
    rlyname = json['rlyname'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upl_rly'] = this.uplRly;
    data['upl_no'] = this.uplNo;
    data['des'] = this.des;
    data['drg_no'] = this.drgNo;
    data['drg_alt'] = this.drgAlt;
    data['spec'] = this.spec;
    data['pur_sec'] = this.purSec;
    data['file_sr_no'] = this.fileSrNo;
    data['unit'] = this.unit;
    data['abc_cat'] = this.abcCat;
    data['avg_bar'] = this.avgBar;
    data['source'] = this.source;
    data['trade_group'] = this.tradeGroup;
    data['pur_auth'] = this.purAuth;
    data['pur_type'] = this.purType;
    data['cp_mm'] = this.cpMm;
    data['srs_mm'] = this.srsMm;
    data['vs'] = this.vs;
    data['shortname'] = this.shortname;
    data['dt1'] = this.dt1;
    data['remk'] = this.remk;
    data['pam'] = this.pam;
    data['mustchg'] = this.mustchg;
    data['shelf'] = this.shelf;
    data['old_plnos'] = this.oldPlnos;
    data['uplno'] = this.uplno;
    data['oldplno'] = this.oldplno;
    data['uniyn'] = this.uniyn;
    data['weight_kg'] = this.weightKg;
    data['rlyname'] = this.rlyname;
    data['row_id'] = this.rowId;
    return data;
  }
}