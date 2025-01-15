class AmountRecoveredData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<AmtRecData>? data;

  AmountRecoveredData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  AmountRecoveredData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AmtRecData>[];
      json['data'].forEach((v) {
        data!.add(new AmtRecData.fromJson(v));
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

class AmtRecData {
  String? vrno;
  String? vrdate;
  String? recoverydate;
  String? amountrecovered;
  String? recoverydetails;
  String? dateofrecoveringdetails;
  String? username;
  String? userdesig;
  String? pdfpath;
  String? billdtls;

  AmtRecData(
      {this.vrno,
        this.vrdate,
        this.recoverydate,
        this.amountrecovered,
        this.recoverydetails,
        this.dateofrecoveringdetails,
        this.username,
        this.userdesig,
        this.pdfpath,
        this.billdtls});

  AmtRecData.fromJson(Map<String, dynamic> json) {
    vrno = json['vrno'];
    vrdate = json['vrdate'];
    recoverydate = json['recoverydate'];
    amountrecovered = json['amountrecovered'];
    recoverydetails = json['recoverydetails'];
    dateofrecoveringdetails = json['dateofrecoveringdetails'];
    username = json['username'];
    userdesig = json['userdesig'];
    pdfpath = json['pdfpath'];
    billdtls = json['billdtls'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vrno'] = this.vrno;
    data['vrdate'] = this.vrdate;
    data['recoverydate'] = this.recoverydate;
    data['amountrecovered'] = this.amountrecovered;
    data['recoverydetails'] = this.recoverydetails;
    data['dateofrecoveringdetails'] = this.dateofrecoveringdetails;
    data['username'] = this.username;
    data['userdesig'] = this.userdesig;
    data['pdfpath'] = this.pdfpath;
    data['billdtls'] = this.billdtls;
    return data;
  }
}