import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './my_app.dart';
import './utils/themes.dart';

void main() => runApp(new MaterialApp(
    home: new SplashScreen(
      seconds: 5,
      backgroundColor: Colors.black,
      image: Image.asset('assets/splash_eclips.gif',
          alignment: Alignment.bottomCenter),
      loaderColor: Colors.transparent,
      loadingText: new Text("Mu Player",
          textScaleFactor: 3,
          style: TextStyle(fontFamily: "Ubuntu", color: Colors.purple)),
      photoSize: 300.0,
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
