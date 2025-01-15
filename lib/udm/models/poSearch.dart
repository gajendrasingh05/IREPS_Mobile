class POSearch {
    String? cANCELLATIONQTY;
    String? cONSG;
    String? cONSIGNEENAME;
    String? dELIVERYPERIOD;
    String? dES;
    String? iNSPECTIONACGENCY;
    String? iTEMCODE;
    String? pAIDVALUE;
    String? pODATE;
    String? pOKEY;
    String? pONO;
    String? pOQTY;
    String? pOSR;
    String? pOSTATUS;
    String? pOVALUE;
    String? rAINAME;
    String? rLY;
    String? rLYNAME;
    String? sTKNS;
    String? sUPPLYQTY;
    String? uNIT;
    String? vIEWPDF;
    String? vNAME;
    String? itemRate;

    POSearch({this.itemRate,this.cANCELLATIONQTY, this.cONSG,  this.cONSIGNEENAME, this.dELIVERYPERIOD, this.dES, this.iNSPECTIONACGENCY, this.iTEMCODE,  this.pAIDVALUE,
        this.pODATE, this.pOKEY, this.pONO, this.pOQTY, this.pOSR, this.pOSTATUS, this.pOVALUE, this.rAINAME, this.rLY, this.rLYNAME, this.sTKNS, this.sUPPLYQTY, this.uNIT,  this.vNAME,this.vIEWPDF});

    factory POSearch.fromJson(Map<String, dynamic> json) {
        return POSearch(
            cANCELLATIONQTY: json['cancellationqty'].toString(),
            cONSG: json['consg'],
           // cONSIGNEE: json['CONSIGNEE'],
            cONSIGNEENAME: json['consigneename'],
            dELIVERYPERIOD: json['deliveryperiod'],
            dES: json['des'],
           // iNDUSTRY_TYPE: json['industry_type'],
            iNSPECTIONACGENCY: json['inspectionacgency'],
            iTEMCODE: json['itemcode'],
         //   jSON: json['jSON'],
            //nVL: json['nVL(Z.DP,SUBSTR(Z.CONSIGNEE,3,2))'],
            pAIDVALUE: json['paidvalue'].toString(),
            pODATE: json['podate'],
            pOKEY: json['pokey'].toString(),
            pONO: json['pono'],
            pOQTY: json['poqty'].toString(),
            pOSR: json['posr'],
            pOSTATUS: json['postatus'],
            pOVALUE: json['povalue'].toString(),
          //  pO_SLOT: json['po_slot'],
            rAINAME: json['rainame'],
            rLY: json['rly'],
            rLYNAME: json['rlyname'],
            sTKNS: json['stkns'],
            sUPPLYQTY: json['supplyqty'].toString(),
            uNIT: json['unit'],
            vIEWPDF: json['viewpdf'],
            vNAME: json['vname'],
            itemRate: json['itemrate'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['cancellationqty'] = this.cANCELLATIONQTY;
        data['consg'] = this.cONSG;
    //    data['CONSIGNEE'] = this.cONSIGNEE;
        data['consigneename'] = this.cONSIGNEENAME;
        data['deliveryperiod'] = this.dELIVERYPERIOD;
        data['des'] = this.dES;
      //  data['industry_type'] = this.iNDUSTRY_TYPE;
        data['inspectionacgency'] = this.iNSPECTIONACGENCY;
        data['itemcode'] = this.iTEMCODE;
      //  data['jSON'] = this.jSON;
        //data['nVL(Z.DP,SUBSTR(Z.CONSIGNEE,3,2))'] = this.nVL;
        data['paidvalue'] = this.pAIDVALUE;
        data['podate'] = this.pODATE;
        data['pokey'] = this.pOKEY;
        data['pono'] = this.pONO;
        data['poqty'] = this.pOQTY;
        data['posr'] = this.pOSR;
        data['postatus'] = this.pOSTATUS;
        data['povalue'] = this.pOVALUE;
      //  data['po_slot'] = this.pO_SLOT;
        data['rainame'] = this.rAINAME;
        data['rly'] = this.rLY;
        data['rlyname'] = this.rLYNAME;
        data['stkns'] = this.sTKNS;
        data['supplyqty'] = this.sUPPLYQTY;
        data['unit'] = this.uNIT;
        data['viewpdf'] = this.vIEWPDF;
        data['vname'] = this.vNAME;
        data['itemrate']=this.itemRate;
        return data;
    }
}