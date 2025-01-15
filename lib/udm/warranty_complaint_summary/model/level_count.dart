class LevelCount {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<LevelCountData>? data;

  LevelCount(
      {this.apiFor, this.count, this.status, this.message, this.data});

  LevelCount.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LevelCountData>[];
      json['data'].forEach((v) {
        data!.add(new LevelCountData.fromJson(v));
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

class LevelCountData {
  String? compsource;
  String? rlygencomplaint;
  String? rlygencomplaintcode;
  String? rlylodgecliam;
  String? rlylodgeclaimcode;
  String? total;
  String? claimlodgedvendor;
  String? claiminitiatedvendor;
  String? complaintreturned;
  String? advicenoteinitiated;
  String? advicenotefinalized;
  String? advicenotereturned;
  String? actionpending;

  LevelCountData(
      { this.compsource,
        this.rlygencomplaint,
        this.rlygencomplaintcode,
        this.rlylodgecliam,
        this.rlylodgeclaimcode,
        this.total,
        this.claimlodgedvendor,
        this.claiminitiatedvendor,
        this.complaintreturned,
        this.advicenoteinitiated,
        this.advicenotefinalized,
        this.advicenotereturned,
        this.actionpending});


  LevelCountData.fromJson(Map<String, dynamic> json) {
    compsource = json['compsource'];
    rlygencomplaint = json['rlygencomplaint'];
    rlygencomplaintcode = json['rlygencomplaintcode'];
    rlylodgecliam = json['rlylodgecliam'];
    rlylodgeclaimcode = json['rlylodgeclaimcode'];
    total = json['total'];
    claimlodgedvendor = json['claimlodgedvendor'];
    claiminitiatedvendor = json['claiminitiatedvendor'];
    complaintreturned = json['complaintreturned'];
    advicenoteinitiated = json['advicenoteinitiated'];
    advicenotefinalized = json['advicenotefinalized'];
    advicenotereturned = json['advicenotereturned'];
    actionpending = json['actionpending'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compsource'] = this.compsource;
    data['rlygencomplaint'] = this.rlygencomplaint;
    data['rlygencomplaintcode'] = this.rlygencomplaintcode;
    data['rlylodgecliam'] = this.rlylodgecliam;
    data['rlylodgeclaimcode'] = this.rlylodgeclaimcode;
    data['total'] = this.total;
    data['claimlodgedvendor'] = this.claimlodgedvendor;
    data['claiminitiatedvendor'] = this.claiminitiatedvendor;
    data['complaintreturned'] = this.complaintreturned;
    data['advicenoteinitiated'] = this.advicenoteinitiated;
    data['advicenotefinalized'] = this.advicenotefinalized;
    data['advicenotereturned'] = this.advicenotereturned;
    data['actionpending'] = this.actionpending;
    return data;
  }
}