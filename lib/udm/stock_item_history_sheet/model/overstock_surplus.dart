class Overstock_Surplus {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<OverStockData>? data;

  Overstock_Surplus(
      {this.apiFor, this.count, this.status, this.message, this.data});

  Overstock_Surplus.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OverStockData>[];
      json['data'].forEach((v) {
        data!.add(new OverStockData.fromJson(v));
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

class OverStockData {
  String? dp;
  String? rly;
  String? shortname;
  String? dpName;
  String? phone;
  String? wd;
  String? cat;
  String? stock;
  String? udes;
  String? aac;
  String? cyr0;
  String? cyr1;
  String? lidt;
  String? rowId;

  OverStockData({
        this.dp,
        this.rly,
        this.shortname,
        this.dpName,
        this.phone,
        this.wd,
        this.cat,
        this.stock,
        this.udes,
        this.aac,
        this.cyr0,
        this.cyr1,
        this.lidt,
        this.rowId
  });

  OverStockData.fromJson(Map<String, dynamic> json)
  {
    dp = json['dp'];
    rly = json['rly'];
    shortname = json['shortname'];
    dpName = json['dp_name'];
    phone = json['phone'];
    wd = json['wd'];
    cat = json['cat'];
    stock = json['stock'];
    udes = json['udes'];
    aac = json['aac'];
    cyr0 = json['cyr0'];
    cyr1 = json['cyr1'];
    lidt = json['lidt'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp'] = this.dp;
    data['rly'] = this.rly;
    data['shortname'] = this.shortname;
    data['dp_name'] = this.dpName;
    data['phone'] = this.phone;
    data['wd'] = this.wd;
    data['cat'] = this.cat;
    data['stock'] = this.stock;
    data['udes'] = this.udes;
    data['aac'] = this.aac;
    data['cyr0'] = this.cyr0;
    data['cyr1'] = this.cyr1;
    data['lidt'] = this.lidt;
    data['row_id'] = this.rowId;
    return data;
  }
}