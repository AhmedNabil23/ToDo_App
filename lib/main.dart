import 'package:flutter/material.dart';
import 'package:flutter_app/layout/home_layout.dart';
import 'package:flutter_app/modules/bmi/Bmi_screen.dart';
import 'package:flutter_app/modules/counter/Counter_screen.dart';
import 'package:flutter_app/modules/login/login_screen.dart';

void main() {
  runApp(MyApp());
}

// الويدجت ليه نوعين بستخدم منهم واحد وهم اللي بينوبوا عنه مش بعرف ويدجت
//StatelessWidget
//stateFulWidget

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
