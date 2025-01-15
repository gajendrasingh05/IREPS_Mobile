class ConsSummary {
  String? _aac;
  String? _pacfirm;
  String? _stkunit;
  String? _depodetail;
  String? _issueccode;
  String? _rlyname;
  String? _issconsgdept;
  String? _ledgerno;
  String? _vs;
  String? _consumind;
  String? _ledgername;
  String? _ledgerfoliono;
  String? _ledgerfolioname;
  String? _ledgerfolioplno;
  String? _ledgerfolioshortdesc;
  String? _consumptionqty;
  String? _consumptionvalue;

  String? get aac => _aac;
  String? get pacfirm => _pacfirm;
  String? get stkunit => _stkunit;
  String? get depodetail => _depodetail;
  String? get issueccode => _issueccode;
  String? get rlyname => _rlyname;
  String? get issconsgdept => _issconsgdept;
  String? get ledgerno => _ledgerno;
  String? get vs => _vs;
  String? get consumind => _consumind;
  String? get ledgername => _ledgername;
  String? get ledgerfoliono => _ledgerfoliono;
  String? get ledgerfolioname => _ledgerfolioname;
  String? get ledgerfolioplno => _ledgerfolioplno;
  String? get ledgerfolioshortdesc => _ledgerfolioshortdesc;
  String? get consumptionqty => _consumptionqty;
  String? get consumptionvalue => _consumptionvalue;

  ConsSummary({
      String? aac, 
      String? pacfirm, 
      String? stkunit, 
      String? depodetail, 
      String? issueccode, 
      String? rlyname, 
      String? issconsgdept, 
      String? ledgerno, 
      String? vs, 
      String? consumind, 
      String? ledgername, 
      String? ledgerfoliono, 
      String? ledgerfolioname, 
      String? ledgerfolioplno, 
      String? ledgerfolioshortdesc, 
      String? consumptionqty, 
      String? consumptionvalue}){
    _aac = aac;
    _pacfirm = pacfirm;
    _stkunit = stkunit;
    _depodetail = depodetail;
    _issueccode = issueccode;
    _rlyname = rlyname;
    _issconsgdept = issconsgdept;
    _ledgerno = ledgerno;
    _vs = vs;
    _consumind = consumind;
    _ledgername = ledgername;
    _ledgerfoliono = ledgerfoliono;
    _ledgerfolioname = ledgerfolioname;
    _ledgerfolioplno = ledgerfolioplno;
    _ledgerfolioshortdesc = ledgerfolioshortdesc;
    _consumptionqty = consumptionqty;
    _consumptionvalue = consumptionvalue;
}

  ConsSummary.fromJson(dynamic json) {
    _aac = json['aac'];
    _pacfirm = json['pacfirm'];
    _stkunit = json['stkunit'];
    _depodetail = json['depodetail'];
    _issueccode = json['issueccode'];
    _rlyname = json['rlyname'];
    _issconsgdept = json['issconsgdept'];
    _ledgerno = json['ledgerno'];
    _vs = json['vs'];
    _consumind = json['consumind'];
    _ledgername = json['ledgername'];
    _ledgerfoliono = json['ledgerfoliono'];
    _ledgerfolioname = json['ledgerfolioname'];
    _ledgerfolioplno = json['ledgerfolioplno'];
    _ledgerfolioshortdesc = json['ledgerfolioshortdesc'];
    _consumptionqty = json['consumptionqty'];
    _consumptionvalue = json['consumptionvalue'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['aac'] = _aac;
    map['pacfirm'] = _pacfirm;
    map['stkunit'] = _stkunit;
    map['depodetail'] = _depodetail;
    map['issueccode'] = _issueccode;
    map['rlyname'] = _rlyname;
    map['issconsgdept'] = _issconsgdept;
    map['ledgerno'] = _ledgerno;
    map['vs'] = _vs;
    map['consumind'] = _consumind;
    map['ledgername'] = _ledgername;
    map['ledgerfoliono'] = _ledgerfoliono;
    map['ledgerfolioname'] = _ledgerfolioname;
    map['ledgerfolioplno'] = _ledgerfolioplno;
    map['ledgerfolioshortdesc'] = _ledgerfolioshortdesc;
    map['consumptionqty'] = _consumptionqty;
    map['consumptionvalue'] = _consumptionvalue;
    return map;
  }

}