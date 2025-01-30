import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';

class ImplinkScreen extends StatefulWidget {
  @override
  State<ImplinkScreen> createState() => _ImplinkScreenState();
}

class _ImplinkScreenState extends State<ImplinkScreen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            color: Colors.cyan[700],
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Important Links',
              style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
            ),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  _buildAnimatedTile(Icons.description, 'E-Documents'),
                  SizedBox(height: 18),
                  _buildAnimatedTile(Icons.block, 'Banned Firms'),
                  SizedBox(height: 18),
                  _buildAnimatedTile(Icons.storage, 'AAC'),
                  SizedBox(height: 18),
                  _buildAnimatedTile(Icons.check_box, 'Approved Vendors'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       ClipPath(
    //         clipper: SlantedClipper(),
    //         child: Container(
    //           height: 50,
    //           alignment: Alignment.centerLeft,
    //           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    //           color: Colors.cyan[700],
    //           child: Text(
    //             "Important Links",
    //             style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child: Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    //             child: GridView.count(
    //                 crossAxisCount: 2,
    //                 crossAxisSpacing: 15.0,
    //                 mainAxisSpacing: 15.0,
    //                 children: List.generate(choices.length, (index){
    //                   return Center(child: SelectCard(choice: choices[index]));
    //                 })
    //             ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _buildAnimatedTile(IconData icon, String label) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-200 + (_animation.value * 200), 0),
          child: InkWell(
            onTap: () async{
              if(label == "E-Documents"){
                bool check = await AapoortiUtilities.checkConnection();
                if(check == true)
                  Navigator.pushNamed(context, "/edoc");
                else
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
              }
              else if(label == "Banned Firms"){
                bool check = await AapoortiUtilities.checkConnection();
                if(check == true)
                  Navigator.pushNamed(context, "/banned_Firms");
                else
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
              }
              else if(label == "AAC"){
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
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.teal,
                  ),
                  SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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