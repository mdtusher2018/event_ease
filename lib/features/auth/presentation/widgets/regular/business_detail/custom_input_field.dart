// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputField extends StatefulWidget {
  CustomInputField({super.key,required this.onSendCommentClick});
  Function(String)? onSendCommentClick;

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.8),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: TextField(
              controller: _controller,

              decoration: InputDecoration(
                hintText: AppString.typeYourCommentHere,
                hintStyle: styleForNormalText.copyWith(
                  fontSize: 16,
                  color: AppColors.grey,
                  height: 1.56,
                ),
                border: InputBorder.none,
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              widget.onSendCommentClick!(_controller.text);
              _controller.clear();
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
