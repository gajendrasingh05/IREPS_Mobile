import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/choose_dept_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseDepartScreen extends StatefulWidget {
  const ChooseDepartScreen({super.key});

  @override
  State<ChooseDepartScreen> createState() => _ChooseDepartScreenState();
}

class _ChooseDepartScreenState extends State<ChooseDepartScreen> {

  List<String> departlist = ['CRIS-HQ-EPS', 'CRIS-HQ-ADMINISTRATION'];

  final choosedeptcontroller = Get.put<ChooseDeptController>(ChooseDeptController());

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRIS MMIS',style: TextStyle(color: Colors.white)),backgroundColor: MyColor.primaryColor,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
             children: [
                Container(
                  height: 45,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade700
                  ),
                  alignment: Alignment.center,
                  child: Text(" Choose your Department", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 15),
                Expanded(child: ListView.builder(
                    itemCount: departlist.length,
                    shrinkWrap: true,
                    //controller: listScrollController,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (BuildContext context, int index){
                      return InkWell(
                        onTap: () async{
                          setState(() {
                            selectedIndex = index;
                          });
                          fetchToken(context);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          choosedeptcontroller.setChooseDept(prefs.getString('userid')!);
                        },
                        child: Card(
                          margin: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          child: Container(
                            height: 150,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.cyanAccent,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Text(departlist[index], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(height: 5.0),
                                Obx((){
                                  if(choosedeptcontroller.choosedeptState == ChooseDeptState.loading){
                                    return selectedIndex == index ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Container(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.0)),
                                        ),
                                      ),
                                    ) : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  else if(choosedeptcontroller.choosedeptState == ChooseDeptState.success){
                                    return selectedIndex == index ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.check, color: Colors.white),
                                        ),
                                      ),
                                    ) : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  else if(choosedeptcontroller.choosedeptState == ChooseDeptState.idle){
                                    return Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  else if(choosedeptcontroller.choosedeptState == ChooseDeptState.failed){
                                    return selectedIndex == index ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                        ),
                                      ),
                                    ) : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  else if(choosedeptcontroller.choosedeptState == ChooseDeptState.failedWithError){
                                    return Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.5),
                                              color: Colors.indigo.shade300
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  return Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.5),
                                            color: Colors.indigo.shade300
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                      ),
                                    ),
                                  );
                                })
                                //TextButton(onPressed: (){}, child: Text("CLICK HERE", style: TextStyle(color: Colors.pinkAccent, fontSize: 16)))
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ))
             ],
          ),
        ),
      ),
    );
  }
}
