class OtpVerRespData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<OtpRespData>? data;

  OtpVerRespData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  OtpVerRespData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OtpRespData>[];
      json['data'].forEach((v) {
        data!.add(new OtpRespData.fromJson(v));
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

class OtpRespData {
  String? email;
  String? logoutstatus;

  OtpRespData({this.email, this.logoutstatus});

  OtpRespData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    logoutstatus = json['logoutstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['logoutstatus'] = this.logoutstatus;
    return data;
  }
}
