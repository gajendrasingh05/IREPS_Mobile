
import 'package:flutter/material.dart';

import 'package:flutter_app/aapoorti/home/tender/customsearch/custom_search.dart';

void main() => runApp(new Info());

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("App Info"),),
    drawer :new Drawer(
    child : new ListView(
    children: <Widget>[
    new Container(
    constraints: new BoxConstraints.expand(height:180.0),
    alignment: Alignment.bottomLeft,
    padding: new EdgeInsets.only(left:16.0,bottom: 8.0),
    decoration: new BoxDecoration(
    image : new DecorationImage(

    image : new AssetImage('assets/welcome.jpg'),
    fit:BoxFit.cover ),
    ),
    child:  new Text('Welcome',
    style: new TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize:15.0),),
    ),
    new ListTile(
    onTap: (){
    Navigator.pushNamed(context, "/favourites");
    },


    leading: new Icon(Icons.favorite,textDirection: TextDirection.rtl,),
    title: new Text('Favourites'),

    ),

    new ListTile(


    leading: new Icon(Icons.stars),
    title: new Text('Rate Us'),

    ),

    new ListTile(
    onTap: (){
    Navigator.pushNamed(context, "/info");
    },

    leading: new Icon(Icons.touch_app),
    title: new Text('App info'),

    ),
    new ListTile(
    onTap: (){
    Navigator.pushNamed(context, "/about");

    },


    leading: new Icon(Icons.info),
    title: new Text('About Us'),

    ),
    new ListTile(
    onTap: (){
    Navigator.pushNamed(context, "/saved");
    },


    leading: new Icon(Icons.save),
    title: new Text('Saved Data'),

    )
    ],
    ),
    ),

    body:
    ListView(
    children: <Widget>[

      Card(
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
     IconButton(icon: Icon(Icons.home,    color:Colors.black,textDirection: TextDirection.rtl,), onPressed: () {  },),
                new Text("Home>>e-Tender",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,fontSize: 17),),
              ],
            ),


            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
                  children: <Widget>[
                    new Padding(padding: new  EdgeInsets.only(left:40.0)),
                    new Image.asset('assets/search.png',width: 20,height: 20,),
                    new Column(
                  children: <Widget>[
                    new InkWell(
                      child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                        decoration: TextDecoration.underline,)),
                      onTap: (){
    Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40,top:5)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),
            new Padding(padding: new EdgeInsets.only(left:40)),
            new Row(
              children: <Widget>[
                new Image.asset('assets/search.png',width: 20,height: 20,),
                new Column(
                  children: <Widget>[
                    new InkWell(
                        child: Text("Custom Search",style: TextStyle(color: Colors.black,fontSize: 15,
                          decoration: TextDecoration.underline,)),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CustomSearch()));}
                    ),
                  ],
                ),
              ],


            ),

          ],
        ),
      ),

     ]
    ),

      ),
    );
  }
}