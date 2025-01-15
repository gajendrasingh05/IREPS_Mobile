class StockingProposallinkData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<StkprplinkData>? data;

  StockingProposallinkData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockingProposallinkData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StkprplinkData>[];
      json['data'].forEach((v) {
        data!.add(new StkprplinkData.fromJson(v));
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

class StkprplinkData {
  String? rly;
  String? plNo;
  String? rlyname;
  String? unitId;
  String? unitName;
  String? subunitId;
  String? subUnitName;
  String? storesDepot;
  String? uplRly;
  String? formNo;
  String? formDate;
  String? grpId;
  String? grpName;
  String? subGrpId;
  String? subGrpName;
  String? des;
  String? userId;
  String? username;
  String? postId;
  String? status;
  String? postName;
  String? forwardUserName;
  String? forwardPostName;
  String? authDate;

  StkprplinkData(
      {this.rly,
        this.plNo,
        this.rlyname,
        this.unitId,
        this.unitName,
        this.subunitId,
        this.subUnitName,
        this.storesDepot,
        this.uplRly,
        this.formNo,
        this.formDate,
        this.grpId,
        this.grpName,
        this.subGrpId,
        this.subGrpName,
        this.des,
        this.userId,
        this.username,
        this.postId,
        this.status,
        this.postName,
        this.forwardUserName,
        this.forwardPostName,
        this.authDate});

  StkprplinkData.fromJson(Map<String, dynamic> json) {
    rly = json['rly'];
    plNo = json['plNo'];
    rlyname = json['rlyname'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    subunitId = json['subunitId'];
    subUnitName = json['subUnitName'];
    storesDepot = json['storesDepot'];
    uplRly = json['uplRly'];
    formNo = json['formNo'];
    formDate = json['formDate'];
    grpId = json['grpId'];
    grpName = json['grpName'];
    subGrpId = json['subGrpId'];
    subGrpName = json['subGrpName'];
    des = json['des'];
    userId = json['userId'];
    username = json['username'];
    postId = json['postId'];
    status = json['status'];
    postName = json['postName'];
    forwardUserName = json['forwardUserName'];
    forwardPostName = json['forwardPostName'];
    authDate = json['authDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rly'] = this.rly;
    data['plNo'] = this.plNo;
    data['rlyname'] = this.rlyname;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['subunitId'] = this.subunitId;
    data['subUnitName'] = this.subUnitName;
    data['storesDepot'] = this.storesDepot;
    data['uplRly'] = this.uplRly;
    data['formNo'] = this.formNo;
    data['formDate'] = this.formDate;
    data['grpId'] = this.grpId;
    data['grpName'] = this.grpName;
    data['subGrpId'] = this.subGrpId;
    data['subGrpName'] = this.subGrpName;
    data['des'] = this.des;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['postId'] = this.postId;
    data['status'] = this.status;
    data['postName'] = this.postName;
    data['forwardUserName'] = this.forwardUserName;
    data['forwardPostName'] = this.forwardPostName;
    data['authDate'] = this.authDate;
    return data;
  }
}