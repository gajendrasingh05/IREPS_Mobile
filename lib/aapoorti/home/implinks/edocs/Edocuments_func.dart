import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

import 'EdocsAucDetails.dart';
class Edocuments_func {



  //deepa
  static Widget OverlayList(BuildContext context, List<String> attachOverlayString,String namepdf) {

  //  String name=namepdf;

    List<String> General=["https://ireps.gov.in/ireps/upload/resources/SecurityAspectofeTokens.pdf",
      "https://ireps.gov.in/ireps/upload/resources/PublicKeyExportProcess.pdf",
      "https://ireps.gov.in/ireps/upload/resources/List-Of-Special-Characters.pdf",
      "https://ireps.gov.in//ireps/upload/resources/Getting_Your_System_Ready_for_IREPS_Application_Version_2.0.pdf",
      "https://ireps.gov.in/ireps/upload/resources/SecrityTipsIREPS.pdf",
      "https://ireps.gov.in//ireps/upload/resources/Guidelines_for_Procurement_and_Management_of_DEC_Versio_2.0.pdf",
      "https://ireps.gov.in/ireps/upload/resources/Procedure_for_Mapping_Party_Codes_&_Viewing_Bills.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors-Suppliers_for_Online_Bill_Tracking_Version_1.0.pdf",
      "https://www.ireps.gov.in/ireps/upload/resources/User_Manual_for_Registration_of_New_Vendors_&_Contractors_Version_1.0.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Creation-Change_of_Primary_User_(Vendors).pdf"
    ];
    List<String> GoodsandServices=[
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Vendors_(Goods&Services)_Version_1.0.pdf",
      "https://ireps.gov.in/ireps/upload/resources/Compatibility_View_Settings.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_manual_for_vendors_on_Post_Contract_Activities.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Vendors_%20for_Reverse_Auction_(Goods_&_Services_Module)_Version_2.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Supplementary_Bills_(Vendors).pdf",
    ];
    List<String> works=[
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_Railway_User_Version_1.0.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Department_Admins_Version_1.0.pdf",
      "https://ireps.gov.in//ireps/upload/resources/CM_SOR_NS_Item_DIR.pdf",
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors-For_Two_Stage_Reverse_Auction_(Works_Module)_Version_2.0.pdf",

    ];
    List<String> EarningLeasing=[
      "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors_(Earning-Leasing)_Version_1.0.pdf"];
    List<String> EAuction=[
      "https://ireps.gov.in/ireps/upload/resources/Bidder_manual.pdf",
      "https://ireps.gov.in/ireps/upload/resources/SBICorporateGuide.pdf",
      "https://ireps.gov.in/ireps/upload/resources/E-auction_bsvinvoice.pdf",
      "https://ireps.gov.in/ireps/upload/resources/BidderManual_LotPublishing.pdf"];
    List<String> iMMS=[
      "https://ireps.gov.in/ireps/upload/resources/iMMS_HQ_Manual.pdf",
          "https://ireps.gov.in/ireps/upload/resources/iMMS_Depot_Manual.pdf",
          "https://ireps.gov.in/ireps/upload/resources/iMMS_LP_Manual.pdf",
          "https://ireps.gov.in/ireps/upload/resources/iMMS_SYSADM_User_Manual.pdf",
          "https://ireps.gov.in/ireps/upload/resources/Procedure%20For%20Installation%20of%20Java%20And%20PkiServer.pdf",
          "https://ireps.gov.in/ireps/upload/resources/Procedure%20For%20Change%20Digital%20Certificate(DSC).pdf"];
    List<String> Faq=[
      "https://ireps.gov.in/ireps/upload/resources/FAQetenders06May10.pdf",
          "https://ireps.gov.in/ireps/upload/resources/BidderandPaymentFAQ.pdf",
          "https://ireps.gov.in/ireps/upload/resources/E-PaymentFAQ.pdf"];

   List<String> zonal_rly=["561","3482","6806","8937","31528","541","4702","401","4527","4494","562","5261","581","582","4495","601","483"];
   List<String> Production_unit=["6721","1222","831","641","501","20281","1233","43901"];
   List<String> other_units=["45221","321","55541","58281","46401","2261","31381","20504"];
    return ListView.separated(
        itemCount: attachOverlayString.length ,
//            != null ?  attachOverlayString.length : 0,
        itemBuilder: (context, index) {

          return GestureDetector(
            child:
            Container(
                margin: EdgeInsets.only(bottom: 20,top: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                                          child: Text((index+1).toString() + ". "+  attachOverlayString[index],
                        style: TextStyle(color: Colors.white, fontSize: 17),),
                    )

                  ],

                )
            ),
            onTap: ()
            {
              print("index");
              print( attachOverlayString.length);

              if(namepdf=="General"){
                print("In general = "+index.toString());

                var fileName = General[index].substring(General[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,General[index],fileName);

              }

             else
               if(namepdf=="Goods and services")
              {
                var fileName = GoodsandServices[index].substring(GoodsandServices[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,GoodsandServices[index],fileName);

              }

              else
                if(namepdf=="works")
              {
                var fileName = works[index].substring(works[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,works[index],fileName);

              }

              else
                if(namepdf=="EarningLeasing")
              {
                var fileName = EarningLeasing[index].substring(EarningLeasing[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,EarningLeasing[index],fileName);

              }

              else
                if(namepdf=="Auction")
              {
                var fileName = EAuction[index].substring(EAuction[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,EAuction[index],fileName);

              }

              else
                if(namepdf=="iMMS")
              {
                var fileName = iMMS[index].substring(iMMS[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,iMMS[index],fileName);

              }

              else
                if(namepdf=="Faq")
              {

                var fileName = Faq[index].substring(Faq[index].lastIndexOf("/"));
                AapoortiUtilities.ackAlert(context,Faq[index],fileName);


              }
                else
                  if(namepdf=="Zonal Railways")
                    {
                      print("Zonal rly");
                      Navigator.push(context,MaterialPageRoute(builder: (context) => EdocAucDetails(id:zonal_rly[index].toString())));

                    }
                  else
                    if(namepdf=="Production_unit")
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => EdocAucDetails(id:Production_unit[index].toString())));

                      }
                    else
                      if(namepdf=="RlyBoard_otherUnt")
                        {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => EdocAucDetails(id:other_units[index].toString())));

                        }

            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 5.0,color: Colors.white,);
        }
    );
  }



//deepa



}
