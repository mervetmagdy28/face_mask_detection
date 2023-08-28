import 'package:camera/camera.dart';
import 'package:face_mask_detection/splash_screen.dart';
import 'package:flutter/material.dart';

const primaryColor=Color(0xffD48E8E);
late List<CameraDescription> cameras;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras=await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
