class StatusData {
  String? apiFor;
  String? count;
  String? staus;
  String? message;
  List<Status>? data;

  StatusData({this.apiFor, this.count, this.staus, this.message, this.data});

  StatusData.fromJson(Map<String, dynamic> json) {
    apiFor = json['apiFor'];
    count = json['count'];
    staus = json['staus'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Status>[];
      json['data'].forEach((v) {
        data!.add(new Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiFor'] = this.apiFor;
    data['count'] = this.count;
    data['staus'] = this.staus;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  String? statusvalue;
  String? statusname;

  Status({this.statusvalue, this.statusname});

  Status.fromJson(Map<String, dynamic> json) {
    statusvalue = json['statusvalue'];
    statusname = json['statusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusvalue'] = this.statusvalue;
    data['statusname'] = this.statusname;
    return data;
  }
}