class Indentor {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<IndentorData>? data;

  Indentor({this.apiFor, this.count, this.status, this.message, this.data});

  Indentor.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <IndentorData>[];
      json['data'].forEach((v) {
        data!.add(new IndentorData.fromJson(v));
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

class IndentorData {
  String? postid;
  String? username;

  IndentorData({this.postid, this.username});

  IndentorData.fromJson(Map<String, dynamic> json) {
    postid = json['postid'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postid'] = this.postid;
    data['username'] = this.username;
    return data;
  }
}