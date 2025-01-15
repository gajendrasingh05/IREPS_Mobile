class CountryCode {
  List<CCODE>? cCODE;

  CountryCode({this.cCODE});

  CountryCode.fromJson(Map<String, dynamic> json) {
    if (json['CCODE'] != null) {
      cCODE = <CCODE>[];
      json['CCODE'].forEach((v) {
        cCODE!.add(new CCODE.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cCODE != null) {
      data['CCODE'] = this.cCODE!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CCODE {
  String? name;
  String? dialCode;
  String? code;

  CCODE({this.name, this.dialCode, this.code});

  CCODE.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    dialCode = json['dial_code'] as String?;
    code = json['code'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    return data;
  }

  // factory CCODE.fromJson(Map<String, dynamic> json) {
  //   return CCODE(
  //     name: json['name'] as String?,
  //     dialCode: json['dial_code'] as String?,
  //   );
  // }
}
