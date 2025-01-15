class User {
   String? emailid;
   String? date;
   String? ans;
   String? log;
   String? loginFlag;
   String? stoken;
   String? ctoken;
   String? map_id;
 
  User({this.emailid, this.date, this.ans, this.log, this.loginFlag,this.ctoken,this.stoken,this.map_id});

  // User.initial()
  //     : id = 1,
  //       name = 'Test',
  //       username = 'test';

  User.fromJson(Map<String, dynamic> json) {
    emailid = json['emailid'];
    date = json['date'];
    ans = json['ans'];
    log = json['log'];
    loginFlag = json['loginFlag'];
    ctoken=json['ctoken'];
    stoken=json['stoken'];
    map_id=json['map_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailid'] = this.emailid;
    data['date'] = this.date;
    data['ans'] = this.ans;
    data['log'] = this.log;
    data['loginFlag'] = this.loginFlag;
    data['stoken']=this.stoken;
    data['ctoken']=this.ctoken;
    data['map_id']=this.map_id;
    return data;
  }
}
