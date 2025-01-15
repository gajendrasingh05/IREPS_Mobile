class ComplaintSourceData {
  String? apiFor;
  String? count;
  String? staus;
  String? message;
  List<ComplaintSource>? data;

  ComplaintSourceData({this.apiFor, this.count, this.staus, this.message, this.data});

  ComplaintSourceData.fromJson(Map<String, dynamic> json) {
    apiFor = json['apiFor'];
    count = json['count'];
    staus = json['staus'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ComplaintSource>[];
      json['data'].forEach((v) {
        data!.add(new ComplaintSource.fromJson(v));
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

class ComplaintSource {
  String? complaintsourcevalue;
  String? complaintsourcename;

  ComplaintSource({this.complaintsourcevalue, this.complaintsourcename});

  ComplaintSource.fromJson(Map<String, dynamic> json) {
    complaintsourcevalue = json['complaintsourcevalue'];
    complaintsourcename = json['complaintsourcename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaintsourcevalue'] = this.complaintsourcevalue;
    data['complaintsourcename'] = this.complaintsourcename;
    return data;
  }
}