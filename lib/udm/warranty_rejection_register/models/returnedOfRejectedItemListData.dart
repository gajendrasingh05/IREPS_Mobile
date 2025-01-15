class ReturnedOfRejectedItemListData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RetrejData>? data;

  ReturnedOfRejectedItemListData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  ReturnedOfRejectedItemListData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RetrejData>[];
      json['data'].forEach((v) {
        data!.add(new RetrejData.fromJson(v));
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

class RetrejData {
  String? dmdNo;
  String? dmdDate;
  String? vrNo;
  String? vrDate;
  String? firTrkey;
  String? refTrKey;
  String? trKey;
  String? gpKey;
  String? trQty;
  String? rlyName;
  String? consCodeName;
  String? userName;
  String? postDesig;
  String? unitDesc;
  String? gatePassDtl;

  RetrejData(
      {this.dmdNo,
        this.dmdDate,
        this.vrNo,
        this.vrDate,
        this.firTrkey,
        this.refTrKey,
        this.trKey,
        this.gpKey,
        this.trQty,
        this.rlyName,
        this.consCodeName,
        this.userName,
        this.postDesig,
        this.unitDesc,
        this.gatePassDtl});

  RetrejData.fromJson(Map<String, dynamic> json) {
    dmdNo = json['dmdNo'];
    dmdDate = json['dmdDate'];
    vrNo = json['vrNo'];
    vrDate = json['vrDate'];
    firTrkey = json['fir_trkey'];
    refTrKey = json['refTrKey'];
    trKey = json['trKey'];
    gpKey = json['gp_key'];
    trQty = json['trQty'];
    rlyName = json['rlyName'];
    consCodeName = json['consCodeName'];
    userName = json['userName'];
    postDesig = json['postDesig'];
    unitDesc = json['unitDesc'];
    gatePassDtl = json['gatePassDtl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dmdNo'] = this.dmdNo;
    data['dmdDate'] = this.dmdDate;
    data['vrNo'] = this.vrNo;
    data['vrDate'] = this.vrDate;
    data['fir_trkey'] = this.firTrkey;
    data['refTrKey'] = this.refTrKey;
    data['trKey'] = this.trKey;
    data['gp_key'] = this.gpKey;
    data['trQty'] = this.trQty;
    data['rlyName'] = this.rlyName;
    data['consCodeName'] = this.consCodeName;
    data['userName'] = this.userName;
    data['postDesig'] = this.postDesig;
    data['unitDesc'] = this.unitDesc;
    data['gatePassDtl'] = this.gatePassDtl;
    return data;
  }
}