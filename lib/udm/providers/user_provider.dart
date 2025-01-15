import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';


class UserProvider with ChangeNotifier{

    String name = '';
    String email = '';

    bool userState = false;

    bool get getVisibility{
      return userState;
    }

    void setVisibility(bool value){
      userState = value;
      notifyListeners();
    }

    Future<void> fetchUserData(context) async {
      try {
        DatabaseHelper dbHelper = DatabaseHelper.instance;
        var dbResult = await dbHelper.fetchSaveLoginUser();
        if(dbResult.isNotEmpty) {
          IRUDMConstants.showProgressIndicator(context);
          // userDetails(dbResult[0][DatabaseHelper.Tb3_col5_emailid].toString());
          // setState(() {
          //   username = dbResult[0][DatabaseHelper.Tb3_col8_userName];
          //   email = dbResult[0][DatabaseHelper.Tb3_col5_emailid];
          // });
        }
      } catch (err) {}
    }
}