class Checkverification {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<VerificationData>? data;

  Checkverification(
      {this.apiFor, this.count, this.status, this.message, this.data});

  Checkverification.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VerificationData>[];
      json['data'].forEach((v) {
        data!.add(new VerificationData.fromJson(v));
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

class VerificationData {
  String? pendingAt;

  VerificationData({this.pendingAt});

  VerificationData.fromJson(Map<String, dynamic> json) {
    pendingAt = json['pending_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_at'] = this.pendingAt;
    return data;
  }
}
