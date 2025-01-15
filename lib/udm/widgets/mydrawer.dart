import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

import 'package:flutter_app/udm/helpers/shared_data.dart';


class MyDrawer extends StatelessWidget {
 
  var version = '1.0.1'; //IRUDMConstants.version;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:  Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                    margin: EdgeInsets.zero,
                     decoration: BoxDecoration(
          color: Colors.red[300],
        ),
                    child: UserAccountsDrawerHeader(
                     decoration: BoxDecoration(
          color: Colors.red[300],
        ), 
                      margin: EdgeInsets.zero,
                      accountEmail: Text('usermailid'),
                      accountName: Text('User name'),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.red[300],
                        backgroundImage: AssetImage('assets/name.png'),
                        radius: 150,
                      ),
                  )),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/about");
                      },
                      leading: Icon(Icons.info_outline),
                      title: Text('About Us',
                      ),
                    ),
                    ListTile(
                        leading: Icon(Icons.star_border),
                        title: Text('Rate Us'),
                        onTap: (){
                          AapoortiUtilities.openStore(context);
                        }
                    ),
              
                    
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                        Padding(
                          padding: const EdgeInsets.only(left:5.0),
                          child: Text("Version: $version",
                          style: TextStyle(color: Colors.grey,

                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:5.0),
                          child: Text("Developed by CRIS",
                          style: TextStyle(
                            color: Colors.grey,
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(height:15),
                 
          ],
        ),
      );
      
    
  }
  static Widget navigationdrawerbeforLOgin(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(height: 180.0),
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/welcome.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: Text('Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/about");
                    },
                    leading: Icon(Icons.info_outline),
                    title: Text('About Us'),
                  ),
                  ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text('Rate Us'),
                      onTap: () {
                        AapoortiUtilities.openStore(context);
                      }),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Version: 1.0.1",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  "Developed by CRIS",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

}