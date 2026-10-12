import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllTextStyle {
  static TextStyle searchTypeTxtStyle = TextStyle(fontSize: 12.sp,color: Color(0xFF424242),fontWeight: FontWeight.w400);
  static TextStyle tableHeadTextStyle = TextStyle(fontSize: 11.sp,color: Colors.white,fontWeight: FontWeight.w500);
  static TextStyle tableDataTextStyle = TextStyle(fontSize: 11.sp,color: Colors.black87,fontWeight: FontWeight.w500);
  static TextStyle productNameTextStyle =  TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.w500,fontSize: 11.sp);
  static TextStyle cashStatementHeadingTextStyle = TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: Color(0xff707488));
  static TextStyle nofoundTextStyle = TextStyle(color: Colors.red,fontSize: 14.sp,fontWeight: FontWeight.w500);
  static TextStyle subTotalTextStyle = TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold);
  static TextStyle dateFormatStyle = TextStyle(fontSize: 12.sp,color: Colors.grey.shade800,fontWeight: FontWeight.w400);
  static TextStyle menuHeadTextStyle =  TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12.sp);
  static const TextStyle saveButtonTextStyle = TextStyle(letterSpacing: 1.0,color: Colors.white,fontWeight: FontWeight.w500);
  static TextStyle textFieldHeadStyle = TextStyle(color: Colors.grey.shade800);
  static TextStyle dropDownlistStyle = TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.grey.shade700);
  static TextStyle textValueStyle = TextStyle(fontSize: 12.sp, color: Color.fromARGB(255, 126, 125, 125));
}
/// decoration
class ContDecoration{
  static  BoxDecoration contDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey, width: 1.w),
    borderRadius: BorderRadius.circular(5.r),
  );
}
/// textField inputborder
class TextFieldInputBorder{
  static OutlineInputBorder focusEnabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
    borderRadius: BorderRadius.circular(5.r),
  );
}
