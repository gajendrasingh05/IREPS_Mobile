class SummaryStock {
    String? aNTIANNUALCONSUMP;
    String? bAR;
    String? cONSUMIND;
    String? dEPODETAIL;
    String? iSSCONSGDEPT;
    String? iSSUECCODE;
    String? iTEMCAT;
    String? lEDGERFOLIONAME;
    String? lEDGERFOLIONO;
    String? lEDGERFOLIOPLNO;
    String? lEDGERFOLIOSHORTDESC;
    String? lEDGERNAME;
    String? lEDGERNO;
    String? lMIDT;
    String? lMRDT;
    String? oRGZONE;
    String? pACFIRM;
    String? pLIMAGEPATH;
    String? rLYNAME;
    String? sTKITEM;
    String? sTKQTY;
    String? sTKUNIT;
    String? sTKVALUE;
    String? sUBCONSCODE;
    String? tHRESHOLDLIMIT;
    String? vS;

    SummaryStock({this.aNTIANNUALCONSUMP, this.bAR, this.cONSUMIND, this.dEPODETAIL, this.iSSCONSGDEPT, this.iSSUECCODE, this.iTEMCAT, this.lEDGERFOLIONAME, this.lEDGERFOLIONO, this.lEDGERFOLIOPLNO, this.lEDGERFOLIOSHORTDESC, this.lEDGERNAME, this.lEDGERNO, this.lMIDT, this.lMRDT, this.oRGZONE, this.pACFIRM, this.pLIMAGEPATH, this.rLYNAME, this.sTKITEM, this.sTKQTY, this.sTKUNIT, this.sTKVALUE, this.sUBCONSCODE, this.tHRESHOLDLIMIT, this.vS});

    factory SummaryStock.fromJson(Map<String, dynamic> json) {
        return SummaryStock(
            aNTIANNUALCONSUMP: json['antiannualconsump'],
            bAR: json['bar'],
            cONSUMIND: json['consumind'],
            dEPODETAIL: json['depodetail'],
            iSSCONSGDEPT: json['issconsgdept'],
            iSSUECCODE: json['issueccode'],
            iTEMCAT: json['itemcat'],
            lEDGERFOLIONAME: json['ledgerfolioname'],
            lEDGERFOLIONO: json['ledgerfoliono'],
            lEDGERFOLIOPLNO: json['ledgerfolioplno'],
            lEDGERFOLIOSHORTDESC: json['ledgerfolioshortdesc'],
            lEDGERNAME: json['ledgername'],
            lEDGERNO: json['ledgerno'],
            lMIDT: json['lmidt'],
            lMRDT: json['lmrdt'],
            oRGZONE: json['orgzone'],
            pACFIRM: json['pacfirm'],
            pLIMAGEPATH: json['plimagepath'],
            rLYNAME: json['rlyname'],
            sTKITEM: json['stkitem'],
            sTKQTY: json['stkqty'],
            sTKUNIT: json['stkunit'],
            sTKVALUE: json['stkvalue'],
            sUBCONSCODE: json['subconscode'],
            tHRESHOLDLIMIT: json['thresholdlimit'],
            vS: json['vs'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['antiannualconsump'] = this.aNTIANNUALCONSUMP;
        data['bar'] = this.bAR;
        data['consumind'] = this.cONSUMIND;
        data['depodetail'] = this.dEPODETAIL;
        data['issconsgdept'] = this.iSSCONSGDEPT;
        data['issueccode'] = this.iSSUECCODE;
        data['itemcat'] = this.iTEMCAT;
        data['ledgerfolioname'] = this.lEDGERFOLIONAME;
        data['ledgerfoliono'] = this.lEDGERFOLIONO;
        data['ledgerfolioplno'] = this.lEDGERFOLIOPLNO;
        data['ledgerfolioshortdesc'] = this.lEDGERFOLIOSHORTDESC;
        data['ledgername'] = this.lEDGERNAME;
        data['ledgerno'] = this.lEDGERNO;
        data['lmidt'] = this.lMIDT;
        data['lmrdt'] = this.lMRDT;
        data['orgzone'] = this.oRGZONE;
        data['pacfirm'] = this.pACFIRM;
        data['plimagepath'] = this.pLIMAGEPATH;
        data['rlyname'] = this.rLYNAME;
        data['stkitem'] = this.sTKITEM;
        data['stkqty'] = this.sTKQTY;
        data['stkunit'] = this.sTKUNIT;
        data['stkvalue'] = this.sTKVALUE;
        data['subconscode'] = this.sUBCONSCODE;
        data['thresholdlimit'] = this.tHRESHOLDLIMIT;
        data['vs'] = this.vS;
        return data;
    }
}