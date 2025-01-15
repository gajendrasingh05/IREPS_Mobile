class RecoveryRefundListData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RecRefData>? data;

  RecoveryRefundListData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RecoveryRefundListData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RecRefData>[];
      json['data'].forEach((v) {
        data!.add(new RecRefData.fromJson(v));
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

class RecRefData {
  String? refundValue;
  String? refundVrDate;
  String? refundVrNo;
  String? refundPdfPath;
  String? approverName;
  String? approverDesig;

  RecRefData(
      {this.refundValue,
        this.refundVrDate,
        this.refundVrNo,
        this.refundPdfPath,
        this.approverName,
        this.approverDesig});

  RecRefData.fromJson(Map<String, dynamic> json) {
    refundValue = json['refundValue'];
    refundVrDate = json['refundVrDate'];
    refundVrNo = json['refundVrNo'];
    refundPdfPath = json['refundPdfPath'];
    approverName = json['approverName'];
    approverDesig = json['approverDesig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refundValue'] = this.refundValue;
    data['refundVrDate'] = this.refundVrDate;
    data['refundVrNo'] = this.refundVrNo;
    data['refundPdfPath'] = this.refundPdfPath;
    data['approverName'] = this.approverName;
    data['approverDesig'] = this.approverDesig;
    return data;
  }
}