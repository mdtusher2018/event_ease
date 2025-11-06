import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xff6A0DAD);
  static const  Color purple = Color(0xFF6B21A8);
  static const Color secondary = Color(0xff8F59F9);

  static const Color textFieldBg =  Color(0xFFFAF4FF);
  static const Color lightPurple =   Color(0xFFC79FD8);

  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0x0ffddddd);
  static const Color grey = Color(0xff5D5D5D);
  static const Color lightGrey = Color(0xffA5ACB8);
  static const Color darkGrey = Color(0xff262621);
  static const Color greTab = Color(0xff717375);
  static const Color redPink = Color(0xffE57373);
  static const Color offWhite = Color(0xff9D96A8);

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LinearGradient color <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static const LinearGradient customColor = LinearGradient(
    colors: [Color(0xff8F59F9), Color(0xff6A0DAD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // stops: [0.0, 0.5, 1.0], // Smooth blending
  );
}
