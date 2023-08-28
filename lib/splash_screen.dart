import 'package:flutter/material.dart';

import 'home.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context){
            return const Home();
          }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/medical-mask.png'),
          ),
          const Text('FACE MASK',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 35),),
          const Text('Detection',style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor,fontSize: 37),)
        ],
      ),
    );
  }
}
