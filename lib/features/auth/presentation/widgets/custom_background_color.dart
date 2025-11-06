import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBackgroundColor extends StatelessWidget {
  final Widget child;

  const CustomBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent),);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [Color(0xff056aa6), Color(0xff035c86), Color(0xff02304b)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   stops: [0.0, 0.5, 1.0], // Smooth blending
        // ),
        color: Colors.white
      ),
      child: child,
    );
  }
}
