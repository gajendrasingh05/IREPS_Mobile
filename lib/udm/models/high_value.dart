class HighValue {
  String? _pacfirm;
  String? _itemcat;
  String? _depodetail;
  String? _issueccode;
  String? _rlyname;
  String? _stkitem;
  String? _issconsgdept;
  String? _ledgerno;
  String? _vs;
  String? _consumind;
  String? _ledgername;
  String? _ledgerfoliono;
  String? _ledgerfolioname;
  String? _ledgerfolioplno;
  String? _ledgerfolioshortdesc;
  String? _lmrdt;
  String? _lmidt;
  String? _stkqty;
  String? _bar;
  String? _stkvalue;
  String? _stkunit;
  String? _thresholdlimit;

  String? get pacfirm => _pacfirm;
  String? get itemcat => _itemcat;
  String? get depodetail => _depodetail;
  String? get issueccode => _issueccode;
  String? get rlyname => _rlyname;
  String? get stkitem => _stkitem;
  String? get issconsgdept => _issconsgdept;
  String? get ledgerno => _ledgerno;
  String? get vs => _vs;
  String? get consumind => _consumind;
  String? get ledgername => _ledgername;
  String? get ledgerfoliono => _ledgerfoliono;
  String? get ledgerfolioname => _ledgerfolioname;
  String? get ledgerfolioplno => _ledgerfolioplno;
  String? get ledgerfolioshortdesc => _ledgerfolioshortdesc;
  String? get lmrdt => _lmrdt;
  String? get lmidt => _lmidt;
  String? get stkqty => _stkqty;
  String? get bar => _bar;
  String? get stkvalue => _stkvalue;
  String? get stkunit => _stkunit;
  String? get thresholdlimit => _thresholdlimit;

  HighValue({
      String? pacfirm, 
      String? itemcat, 
      String? depodetail, 
      String? issueccode, 
      String? rlyname, 
      String? stkitem, 
      String? issconsgdept, 
      String? ledgerno, 
      String? vs, 
      String? consumind, 
      String? ledgername, 
      String? ledgerfoliono, 
      String? ledgerfolioname, 
      String? ledgerfolioplno, 
      String? ledgerfolioshortdesc, 
      String? lmrdt, 
      String? lmidt, 
      String? stkqty, 
      String? bar, 
      String? stkvalue, 
      String? stkunit, 
      String? thresholdlimit}){
    _pacfirm = pacfirm;
    _itemcat = itemcat;
    _depodetail = depodetail;
    _issueccode = issueccode;
    _rlyname = rlyname;
    _stkitem = stkitem;
    _issconsgdept = issconsgdept;
    _ledgerno = ledgerno;
    _vs = vs;
    _consumind = consumind;
    _ledgername = ledgername;
    _ledgerfoliono = ledgerfoliono;
    _ledgerfolioname = ledgerfolioname;
    _ledgerfolioplno = ledgerfolioplno;
    _ledgerfolioshortdesc = ledgerfolioshortdesc;
    _lmrdt = lmrdt;
    _lmidt = lmidt;
    _stkqty = stkqty;
    _bar = bar;
    _stkvalue = stkvalue;
    _stkunit = stkunit;
    _thresholdlimit = thresholdlimit;
}

  HighValue.fromJson(dynamic json) {
    _pacfirm = json['pacfirm'];
    _itemcat = json['itemcat'];
    _depodetail = json['depodetail'];
    _issueccode = json['issueccode'];
    _rlyname = json['rlyname'];
    _stkitem = json['stkitem'];
    _issconsgdept = json['issconsgdept'];
    _ledgerno = json['ledgerno'];
    _vs = json['vs'];
    _consumind = json['consumind'];
    _ledgername = json['ledgername'];
    _ledgerfoliono = json['ledgerfoliono'];
    _ledgerfolioname = json['ledgerfolioname'];
    _ledgerfolioplno = json['ledgerfolioplno'];
    _ledgerfolioshortdesc = json['ledgerfolioshortdesc'];
    _lmrdt = json['lmrdt'];
    _lmidt = json['lmidt'];
    _stkqty = json['stkqty'];
    _bar = json['bar'];
    _stkvalue = json['stkvalue'];
    _stkunit = json['stkunit'];
    _thresholdlimit = json['thresholdlimit'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['pacfirm'] = _pacfirm;
    map['itemcat'] = _itemcat;
    map['depodetail'] = _depodetail;
    map['issueccode'] = _issueccode;
    map['rlyname'] = _rlyname;
    map['stkitem'] = _stkitem;
    map['issconsgdept'] = _issconsgdept;
    map['ledgerno'] = _ledgerno;
    map['vs'] = _vs;
    map['consumind'] = _consumind;
    map['ledgername'] = _ledgername;
    map['ledgerfoliono'] = _ledgerfoliono;
    map['ledgerfolioname'] = _ledgerfolioname;
    map['ledgerfolioplno'] = _ledgerfolioplno;
    map['ledgerfolioshortdesc'] = _ledgerfolioshortdesc;
    map['lmrdt'] = _lmrdt;
    map['lmidt'] = _lmidt;
    map['stkqty'] = _stkqty;
    map['bar'] = _bar;
    map['stkvalue'] = _stkvalue;
    map['stkunit'] = _stkunit;
    map['thresholdlimit'] = _thresholdlimit;
    return map;
  }

}