import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomLoadingBar extends StatefulWidget {
  final int total;
  final Duration duration;
  final String nextRouteName;

  const CustomLoadingBar({
    super.key,
    this.total = 18,
    this.duration = const Duration(seconds: 8),
    required this.nextRouteName,
  });

  @override
  _CustomLoadingBarState createState() => _CustomLoadingBarState();
}

class _CustomLoadingBarState extends State<CustomLoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final Color purpleLight = Color(0xFFEDE9FE); // purple-100

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(begin: 0, end: widget.total.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offNamed(widget.nextRouteName);
      }
    });



  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _animation.value;

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.w,
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                    top: BorderSide(color: AppColors.primary, width: 4),
                    bottom: BorderSide(color: AppColors.primary, width: 4),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    bottomLeft: Radius.circular(14.r),
                    topRight: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 32.w,
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.primary, width: 4),
                    top: BorderSide(color: AppColors.primary, width: 4),
                    bottom: BorderSide(color: AppColors.primary, width: 4),

                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14.r),
                    bottomRight: Radius.circular(14.r),
                    topLeft: Radius.circular(4.r),
                    bottomLeft: Radius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bars with partial horizontal fill
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.total, (index) {
            double fillFraction = (progress - index).clamp(0.0, 1.0);
            return Container(
              width: 14.w,
              height: 60.h,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: purpleLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 12 * fillFraction,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(4),
                          right: Radius.circular(fillFraction == 1 ? 4 : 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}