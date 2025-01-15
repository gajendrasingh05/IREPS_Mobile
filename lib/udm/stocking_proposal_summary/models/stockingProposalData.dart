class StockingProposalData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<StkPrpData>? data;

  StockingProposalData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockingProposalData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StkPrpData>[];
      json['data'].forEach((v) {
        data!.add(new StkPrpData.fromJson(v));
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

class StkPrpData {
  String? rly;
  String? rlyname;
  String? subunitId;
  String? subUnitName;
  String? unitId;
  String? unitName;
  String? storesDepotId;
  String? storesDepot;
  String? uplRlyId;
  String? uplrly;
  String? status;
  String? cnt;
  String? totalCount;
  String? proposalInDraftStage;
  String? proposalWithDeptts;
  String? proposalWithStoreDepo;
  String? proposalWithPcmm;
  String? proposalWithUnifying;
  String? proposalRejectedUnifying;
  String? proposalReturnedToInitiator;
  String? stokingProposalDroped;
  String? stokingProposalApproved;

  StkPrpData(
      {this.rly,
        this.rlyname,
        this.subunitId,
        this.subUnitName,
        this.unitId,
        this.unitName,
        this.storesDepotId,
        this.storesDepot,
        this.uplRlyId,
        this.uplrly,
        this.status,
        this.cnt,
        this.totalCount,
        this.proposalInDraftStage,
        this.proposalWithDeptts,
        this.proposalWithStoreDepo,
        this.proposalWithPcmm,
        this.proposalWithUnifying,
        this.proposalRejectedUnifying,
        this.proposalReturnedToInitiator,
        this.stokingProposalDroped,
        this.stokingProposalApproved});

  StkPrpData.fromJson(Map<String, dynamic> json) {
    rly = json['rly'];
    rlyname = json['rlyname'];
    subunitId = json['subunitId'];
    subUnitName = json['subUnitName'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    storesDepotId = json['storesDepotId'];
    storesDepot = json['storesDepot'];
    uplRlyId = json['uplRlyId'];
    uplrly = json['uplrly'];
    status = json['status'];
    cnt = json['cnt'];
    totalCount = json['totalCount'];
    proposalInDraftStage = json['proposal_in_draft_stage'];
    proposalWithDeptts = json['proposal_with_deptts'];
    proposalWithStoreDepo = json['proposal_with_store_depo'];
    proposalWithPcmm = json['proposal_with_pcmm'];
    proposalWithUnifying = json['proposal_with_unifying'];
    proposalRejectedUnifying = json['proposal_rejected_unifying'];
    proposalReturnedToInitiator = json['proposal_returned_to_initiator'];
    stokingProposalDroped = json['stoking_proposal_droped'];
    stokingProposalApproved = json['stoking_proposal_approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rly'] = this.rly;
    data['rlyname'] = this.rlyname;
    data['subunitId'] = this.subunitId;
    data['subUnitName'] = this.subUnitName;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['storesDepotId'] = this.storesDepotId;
    data['storesDepot'] = this.storesDepot;
    data['uplRlyId'] = this.uplRlyId;
    data['uplrly'] = this.uplrly;
    data['status'] = this.status;
    data['cnt'] = this.cnt;
    data['totalCount'] = this.totalCount;
    data['proposal_in_draft_stage'] = this.proposalInDraftStage;
    data['proposal_with_deptts'] = this.proposalWithDeptts;
    data['proposal_with_store_depo'] = this.proposalWithStoreDepo;
    data['proposal_with_pcmm'] = this.proposalWithPcmm;
    data['proposal_with_unifying'] = this.proposalWithUnifying;
    data['proposal_rejected_unifying'] = this.proposalRejectedUnifying;
    data['proposal_returned_to_initiator'] = this.proposalReturnedToInitiator;
    data['stoking_proposal_droped'] = this.stokingProposalDroped;
    data['stoking_proposal_approved'] = this.stokingProposalApproved;
    return data;
  }
}