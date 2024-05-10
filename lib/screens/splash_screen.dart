
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;
  late Animation<double> sizeFactor;
  late Animation<double> pendulumAnimation;
  late Animation<double> rotationAnimation;
  late Animation<Offset> slideAnimation;
  @override
  void initState() {
    Future.delayed(
        Duration(seconds: 4),(){
      Navigator.pushAndRemoveUntil(context as BuildContext, MaterialPageRoute(builder: (context)=>widget.child!), (route) => false);
    }

    );
    super.initState();
    controller=AnimationController(vsync: this,
    duration: Duration(milliseconds: 3200));
    pendulumAnimation=Tween<double>(begin:0,end:-100).animate(CurvedAnimation(parent: controller, curve: Curves.bounceIn));
    slideAnimation=Tween(begin: Offset(-1, -1),end: Offset.zero).animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    sizeFactor=Tween<double>(begin: 0,end: 1).animate(controller);
    rotationAnimation =
    Tween<double>(begin: -0.05, end: 0.05).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Image Viewer",
          style: TextStyle(
            color: Colors.white,
          ),),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_image2.jpg'), // Path to your background image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                RotationTransition(
                  turns: rotationAnimation,
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Center(
                        child: Image.asset("assets/images/familyPhoto.png")),
                  ),
                ),
                SizedBox(height: 10,),
                SizeTransition(
                  sizeFactor: sizeFactor,
                  axis: Axis.horizontal,
                  child: const Text(
                    "  Welcome to your Memories ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
