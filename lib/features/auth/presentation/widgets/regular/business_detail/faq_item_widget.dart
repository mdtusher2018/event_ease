import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQItem extends StatefulWidget {
  final String number;
  final String question;
  final String answer;
  final bool isExpanded;

  const FAQItem({
    super.key,
    required this.number,
    required this.question,
    required this.answer,
    required this.isExpanded,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded; // Initialize with the passed value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
        border: Border(left: BorderSide.none, bottom: BorderSide.none, top: BorderSide.none, right: BorderSide.none)
      ),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        tilePadding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        childrenPadding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        backgroundColor: AppColors.textFieldBg,
        collapsedBackgroundColor: AppColors.textFieldBg,

        shape: OutlineInputBorder( borderRadius: BorderRadius.circular(10.r)),


        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.number,
              style: styleForBoldText.copyWith(fontSize: 32.sp, color: AppColors.offWhite),
            ),
            SizedBox(height: 5.h,),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: styleForBoldText.copyWith(fontSize: 20.sp, color: AppColors.darkGrey)),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          _isExpanded ? Icons.cancel : Icons.add, // Plus when expanded, Cancel when not expanded
          color: Colors.black,
        ),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          if (widget.answer.isNotEmpty)
            Text(
              widget.answer,
              style: styleForNormalText.copyWith(fontSize: 18.sp, color: AppColors.grey,height: 1.40.h, fontWeight: FontWeight.w500,)),
        ],
      ),
    );
  }
}
