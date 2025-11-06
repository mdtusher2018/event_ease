import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed});
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 20,
      child: IconButton(onPressed: onPressed, icon: Icon(Icons.arrow_back, size: 20, color: Colors.black,)),
    );
  }
}
