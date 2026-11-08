import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500),vsync: this);
    _animation = Tween<double>(begin: 0.0,end: 1.0).animate(
      CurvedAnimation(parent: _controller,curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back, size: 22.0, color: Colors.white),
      ),
      elevation: 0.0,
      backgroundColor: AppColors.appColor,
      title: ScaleTransition(
        scale: _animation,
        child: Text(widget.title,
          style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500,color: Colors.white),
        ),
      ),
    );
  }
}