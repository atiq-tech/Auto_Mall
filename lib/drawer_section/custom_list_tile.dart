import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'drawer_menu.dart';

// ignore: must_be_immutable
class Custom_List_Tile extends StatelessWidget {
  Custom_List_Tile({super.key,required this.icon,required this.icon_name});
  final IconData? icon;
  String ? icon_name;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 0.0,left: 10.w,right: 10.w),
        height: 25.h,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.r,color: Colors.lightGreenAccent),
                SizedBox(width: 10.w),
                Text('$icon_name',style: TextStylee().MyTextStyle),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 11.r,color: Colors.lightGreenAccent),
          ],
        )
    );
  }
}
