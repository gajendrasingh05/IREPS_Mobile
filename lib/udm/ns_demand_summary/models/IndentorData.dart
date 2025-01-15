class IndentorData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<IndentorNameData>? data;

  IndentorData({this.apiFor, this.count, this.status, this.message, this.data});

  IndentorData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <IndentorNameData>[];
      json['data'].forEach((v) {
        data!.add(new IndentorNameData.fromJson(v));
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

class IndentorNameData {
  String? postid;
  String? username;
  String? ccode;
  String? desig;

  IndentorNameData({this.postid, this.username, this.ccode, this.desig});

  IndentorNameData.fromJson(Map<String, dynamic> json) {
    postid = json['postid'];
    username = json['username'];
    ccode = json['ccode'];
    desig = json['desig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postid'] = this.postid;
    data['username'] = this.username;
    data['ccode'] = this.ccode;
    data['desig'] = this.desig;
    return data;
  }
}