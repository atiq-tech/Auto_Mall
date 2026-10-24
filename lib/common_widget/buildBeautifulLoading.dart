import 'package:auto_mall/common_widget/circular_bouncing_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class buildBeautifulLoading extends StatelessWidget {
  const buildBeautifulLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularBouncingDots(size: 65,dotSize: 9),
          SizedBox(height: 15.h),
          Text(
            "Loading Data...",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Please wait a moment",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}