import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './my_app.dart';

void main() => runApp(new MaterialApp(
    home: new SplashScreen(
      seconds: 4,
      backgroundColor: Colors.black,
      image: Image.asset('assets/splash_eclips.gif',
          alignment: Alignment.bottomCenter),
      loaderColor: Colors.transparent,
      loadingText: new Text("Mu Player",
          textScaleFactor: 3,
          style: TextStyle(color: Colors.purple)),
      photoSize: 200.0,
      navigateAfterSeconds: MyMaterialApp(),
    )));

class MyMaterialApp extends StatefulWidget {
  @override
  MyMaterialAppState createState() {
    return new MyMaterialAppState();
  }
}

class MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new MyApp());
  }
}
