class AmountRefundData {
  AmountRefundData({
    required this.apiFor,
    required this.count,
    required this.status,
    required this.message,
    required this.data,
  });

  late final String apiFor;
  late final String count;
  late final String status;
  late final String message;
  late final List<AmtRefData> data;

  AmountRefundData.fromJson(Map<String, dynamic> json){
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>AmtRefData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['api_for'] = apiFor;
    _data['count'] = count;
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AmtRefData {
  AmtRefData({
    required this.refundingRly,
    required this.trKey,
    required this.recvryKey,
    required this.recvryAdvNo,
    required this.recvryAdvDt,
    required this.vcode,
    required this.partyname,
    required this.refundRlyIpas,
    required this.co6Number,
    required this.co6Date,
    required this.billNo,
    required this.billDate,
    required this.billdesc,
    required this.amountRefunded,
    required this.recvryAMTREFUNDED,
  });
  late final String refundingRly;
  late final String trKey;
  late final String recvryKey;
  late final String recvryAdvNo;
  late final String recvryAdvDt;
  late final String vcode;
  late final String partyname;
  late final String refundRlyIpas;
  late final String co6Number;
  late final String co6Date;
  late final String billNo;
  late final String billDate;
  late final String billdesc;
  late final String amountRefunded;
  late final String recvryAMTREFUNDED;

  AmtRefData.fromJson(Map<String, dynamic> json){
    refundingRly = json['refundingRly'];
    trKey = json['tr_key'];
    recvryKey = json['recvry_key'];
    recvryAdvNo = json['recvry_adv_no'];
    recvryAdvDt = json['recvry_adv_dt'];
    vcode = json['vcode'];
    partyname = json['partyname'];
    refundRlyIpas = json['refund_rly_ipas'];
    co6Number = json['co6Number'];
    co6Date = json['co6Date'];
    billNo = json['billNo'];
    billDate = json['billDate'];
    billdesc = json['billdesc'];
    amountRefunded = json['amountRefunded'];
    recvryAMTREFUNDED = json['recvry_AMT_REFUNDED'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['refundingRly'] = refundingRly;
    _data['tr_key'] = trKey;
    _data['recvry_key'] = recvryKey;
    _data['recvry_adv_no'] = recvryAdvNo;
    _data['recvry_adv_dt'] = recvryAdvDt;
    _data['vcode'] = vcode;
    _data['partyname'] = partyname;
    _data['refund_rly_ipas'] = refundRlyIpas;
    _data['co6Number'] = co6Number;
    _data['co6Date'] = co6Date;
    _data['billNo'] = billNo;
    _data['billDate'] = billDate;
    _data['billdesc'] = billdesc;
    _data['amountRefunded'] = amountRefunded;
    _data['recvry_AMT_REFUNDED'] = recvryAMTREFUNDED;
    return _data;
  }
}