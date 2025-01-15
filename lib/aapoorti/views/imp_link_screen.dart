import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';

class ImplinkScreen extends StatefulWidget {
  @override
  State<ImplinkScreen> createState() => _ImplinkScreenState();
}

class _ImplinkScreenState extends State<ImplinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipPath(
            clipper: SlantedClipper(),
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              color: Colors.cyan[700],
              child: Text(
                "Important Links",
                style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    children: List.generate(choices.length, (index){
                      return Center(child: SelectCard(choice: choices[index]));
                    })
                ),
            ),
          )
        ],
      ),
    );;
  }
}

class Choice {
  const Choice({required this.title, required this.icon});
  final String title;
  final String icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'e-Documents', icon : 'assets/edoc_home.png'),
  const Choice(title: 'Banned Firms', icon: 'assets/banned_firms.png'),
  const Choice(title: 'AAC', icon: 'assets/aac_home.png'),
  const Choice(title: 'Approved Vendors', icon: 'assets/approved_home.png'),
];

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
         if(choice.title == "e-Documents"){
           bool check = await AapoortiUtilities.checkConnection();
           if(check == true)
             Navigator.pushNamed(context, "/edoc");
           else
             Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
         }
         else if(choice.title == "Banned Firms"){
           bool check = await AapoortiUtilities.checkConnection();
           if(check == true)
             Navigator.pushNamed(context, "/banned_Firms");
           else
             Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
         }
         else if(choice.title == "AAC"){
           bool check = await AapoortiUtilities.checkConnection();
           if(check == true)
             Navigator.pushNamed(context, "/aac");
           else
             Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
         }
         else{
           Navigator.pushNamed(context, "/approved_vendors");
         }
      },
      child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(width: 1.0, color: Colors.grey)
          ),
          child: Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Image.asset(choice.icon, height: 45, width: 45)),
                Padding(
                  padding: const EdgeInsets.only(bottom : 10.0),
                  child: Text(choice.title, style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ]
          ),
          )
      ),
    );
  }
}

class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at the top left corner
    path.lineTo(0, 0);

    // Draw line to the top-right corner with a slant
    path.lineTo(size.width, 0);

    // Create a slant effect on the right side
    path.lineTo(size.width, size.height);
    //path.lineTo(size.width - 40, size.height);  // Modify this value to control the slant angle

    // Draw line to the bottom-left corner
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
