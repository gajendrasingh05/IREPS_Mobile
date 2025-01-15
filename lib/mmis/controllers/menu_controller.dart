import 'dart:convert';


import 'package:flutter_app/mmis/services/repo/login_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class MenuController extends GetxController  {

  LoginRepo repo;
  bool isLoading = true;
  bool noInternet = false;

  bool balTransferEnable = true;
  bool langSwitchEnable = true;
  bool poolInvestEnable = true;
  bool scheduleInvestEnable = true;
  bool stackingInvestEnable = true;
  bool userRankEnable = true;

  MenuController({required this.repo});

  void loadData()async{
    isLoading = true;
    update();
    await configureMenuItem();
    isLoading = false;
    update();
  }

  configureMenuItem()async{

    // ResponseModel response = await repo.getGeneralSetting();
    //
    // if(response.statusCode==200){
    //   GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(response.responseJson));
    //   if(model.status?.toLowerCase() == Strings.success.toLowerCase()) {
    //     bool langStatus = model.data?.generalSetting?.languageSwitch == '0'?false:true;
    //     bool bTransferStatus  = model.data?.generalSetting?.bTransfer== '0'?false:true;
    //     poolInvestEnable  = model.data?.generalSetting?.poolOption == '0'?false:true;
    //     scheduleInvestEnable  = model.data?.generalSetting?.scheduleInvest == '0'?false:true;
    //     stackingInvestEnable  = model.data?.generalSetting?.stakingOption == '0'?false:true;
    //     userRankEnable  = model.data?.generalSetting?.userRanking == '0'?false:true;
    //     langSwitchEnable = langStatus;
    //     balTransferEnable = bTransferStatus;
    //     repo.apiClient.storeGeneralSetting(model);
    //     update();
    //   }
    //   else {
    //     List<String>message=[Strings.somethingWentWrong];
    //     CustomSnackBar.error(errorList:model.message?.error??message);
    //     return;
    //   }
    // }else{
    //   if(response.statusCode==503){
    //     noInternet=true;
    //     update();
    //   }
    //   CustomSnackBar.error(errorList:[response.message]);
    //   return;
    // }
  }


  TextEditingController passwordDeleteController = TextEditingController();
  bool isDeleteBtnLoading = false;
  Future<void>deleteAccount() async {
    // String password = passwordDeleteController.text;
    // if(password.isEmpty){
    //   CustomSnackBar.error(errorList: [Strings.passwordEmptyMsg]);
    //   return;
    // }
    //
    // isDeleteBtnLoading = true;
    // update();
    //
    // ResponseModel response = await repo.deleteAccount(password);
    //
    // if(response.statusCode==200){
    //   AuthorizationResponseModel model =
    //   AuthorizationResponseModel.fromJson(jsonDecode(response.responseJson));
    //   if (model.status?.toLowerCase()==MyStrings.success.toLowerCase()) {
    //    repo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
    //    repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, "");
    //
    //    Get.offAllNamed(RouteHelper.loginScreen);
    //    CustomSnackBar.error(errorList:model.message?.success??[MyStrings.accountDeletedSuccessfully]);
    //   }
    //   else {
    //     List<String>message=[MyStrings.somethingWentWrong];
    //     CustomSnackBar.error(errorList:model.message?.error??message);
    //   }
    // }else{
    //   if(response.statusCode==503){
    //     noInternet=true;
    //     update();
    //   }
    //   CustomSnackBar.error(errorList:[response.message]);
    // }
    //
    // isDeleteBtnLoading = false;
    // update();
  }

}