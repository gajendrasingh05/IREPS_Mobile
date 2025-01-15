class ReinspData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<ReinsData>? data;

  ReinspData({this.apiFor, this.count, this.status, this.message, this.data});

  ReinspData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReinsData>[];
      json['data'].forEach((v) {
        data!.add(new ReinsData.fromJson(v));
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

class ReinsData {
  String? crnFlag;
  String? rlyName;
  String? vrNo;
  String? vrDate;
  String? qtyReceived;
  String? qtyAccepted;
  String? accountalTrDate;
  String? consCodeName;
  String? userName;
  String? postDesig;
  String? crnRemark;
  String? pdfPath;
  String? crnApprovalDate;
  String? sentforAppDt;

  ReinsData(
      {this.crnFlag,
        this.rlyName,
        this.vrNo,
        this.vrDate,
        this.qtyReceived,
        this.qtyAccepted,
        this.accountalTrDate,
        this.consCodeName,
        this.userName,
        this.postDesig,
        this.crnRemark,
        this.pdfPath,
        this.crnApprovalDate,
        this.sentforAppDt});

  ReinsData.fromJson(Map<String, dynamic> json) {
    crnFlag = json['crnFlag'];
    rlyName = json['rlyName'];
    vrNo = json['vrNo'];
    vrDate = json['vrDate'];
    qtyReceived = json['qtyReceived'];
    qtyAccepted = json['qtyAccepted'];
    accountalTrDate = json['accountalTrDate'];
    consCodeName = json['consCodeName'];
    userName = json['userName'];
    postDesig = json['postDesig'];
    crnRemark = json['crnRemark'];
    pdfPath = json['pdfPath'];
    crnApprovalDate = json['crnApprovalDate'];
    sentforAppDt = json['sentforAppDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crnFlag'] = this.crnFlag;
    data['rlyName'] = this.rlyName;
    data['vrNo'] = this.vrNo;
    data['vrDate'] = this.vrDate;
    data['qtyReceived'] = this.qtyReceived;
    data['qtyAccepted'] = this.qtyAccepted;
    data['accountalTrDate'] = this.accountalTrDate;
    data['consCodeName'] = this.consCodeName;
    data['userName'] = this.userName;
    data['postDesig'] = this.postDesig;
    data['crnRemark'] = this.crnRemark;
    data['pdfPath'] = this.pdfPath;
    data['crnApprovalDate'] = this.crnApprovalDate;
    data['sentforAppDt'] = this.sentforAppDt;
    return data;
  }
}