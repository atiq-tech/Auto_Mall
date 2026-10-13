import 'dart:convert';
import 'package:auto_mall/home_screen.dart';
import 'package:auto_mall/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/base_url.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences? sharedPreferences;

  bool _isObscure = true;
  bool isLogInBtnClk = false;
  bool isError = false;
  final _formkey = GlobalKey<FormState>();

  fetchLogin() async {
    String link = "${baseUrl}api/v1/login";
    try {
      final formData = FormData.fromMap({
        "username": _usernameController.text,
        "password": _passwordController.text
      });
      final response = await Dio().post(link, data: formData);
      var item = jsonDecode(response.data);
      print('Log In Response Data=== $item');
      print("Message Response=== ${item["message"]}");

      if (item["status"] == true) {
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences?.setString('token', "${item["token"]}");
        sharedPreferences?.setString('sessionId', "${item["session_id"]}");
        sharedPreferences?.setString("userName", "${item["data"]["name"]}");
        sharedPreferences?.setString("userId", "${item["data"]["id"]}");
        sharedPreferences?.setString("userType", "${item["data"]["usertype"]}");
        sharedPreferences?.setString('employeeId', "${item["data"]["employeeId"]}");
        sharedPreferences?.setString('employeePhone', "${item["data"]["employee_phone"]}");
        sharedPreferences?.setString('customerId', "${item["data"]["customerId"]}");
        sharedPreferences?.setString("branch", "${item["data"]["branch"]}");
        sharedPreferences?.setString("branchName", "${item["data"]["branch_name"]}");

        GetStorage().write("token", "${item["token"]}");
        GetStorage().write("id", "${item["data"]["id"]}");
        GetStorage().write("name", "${item["data"]["name"]}");
        GetStorage().write("usertype", "${item["data"]["usertype"]}");
        GetStorage().write("customerId", "${item["data"]["customerId"]}");
        GetStorage().write("image_name", "${item["data"]["image_name"]}");
        GetStorage().write("branch", "${item["data"]["branch"]}");
        GetStorage().write("branch_name", "${item["data"]["branch_name"]}");

        // access for sales module
        if (item["access"] == "null" || item["access"] == null) {
          item["access"] = [];
        } else {
          sharedPreferences?.setString("sales", "${item["access"].contains("sales")}");
          sharedPreferences?.setString("salesinvoice", "${item["access"].contains("salesinvoice")}");
          sharedPreferences?.setString("salesrecord", "${item["access"].contains("salesrecord")}");
          sharedPreferences?.setString("customerlist", "${item["access"].contains("customerlist")}");
          sharedPreferences?.setString("order_entry", "${item["access"].contains("order_entry")}");
          sharedPreferences?.setString("orderRecord", "${item["access"].contains("orderRecord")}");
          sharedPreferences?.setString("customer", "${item["access"].contains("customer")}");
          sharedPreferences?.setString("productlist", "${item["access"].contains("productlist")}");
          sharedPreferences?.setString("category", "${item["access"].contains("category")}");
          sharedPreferences?.setString("currentStock", "${item["access"].contains("currentStock")}");
          sharedPreferences?.setString("attendanceEntry", "${item["access"].contains("attendance_entry")}");
          sharedPreferences?.setString("attendanceRecord", "${item["access"].contains("attendance_record")}");
          sharedPreferences?.setString("visitEntry", "${item["access"].contains("visit_entry")}");
          sharedPreferences?.setString("visitEntryRecord", "${item["access"].contains("visit_entry_record")}");
        }

        setState(() {
          isLogInBtnClk = false;
        });
        _usernameController.clear();
        _passwordController.clear();
        
        Utils.showMotionToast(context,
        title: "${item["message"]}!",
        description: "Welcome to Auto Mall Sales Management App",
        icon: Icons.check_circle,
        duration: const Duration(seconds: 3),
      );
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        setState(() {
          isLogInBtnClk = false;
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLogInBtnClk = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/splash.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.55),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Sales Management Apps",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                        color: Colors.white,
                        letterSpacing: 0.5.w,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Container(
                            height: 130.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              // color: const Color.fromARGB(255, 2, 29, 70).withOpacity(0.25),
                              // borderRadius: BorderRadius.circular(16.r),
                              // //border: Border.all(color: Colors.cyan.shade200, width: 2.w),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.4),
                              //     blurRadius: 12.r,
                              //     offset: const Offset(0, 6),
                              //   ),
                              // ],
                              image: const DecorationImage(
                                image: AssetImage("images/splashlogo.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              color: Colors.white,
                              letterSpacing: 0.8.w,
                            ),
                            ),
                          ),
                          Center(
                            child: Text(
                            "Sign in to your account",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: const Color.fromARGB(255, 6, 224, 253),
                            ),
                            ),
                          ),
                          // SizedBox(height: 15.h),
                          // Center(
                          //   child: SizedBox(
                          //     height: 30.0.h,
                          //     width: 300.0.w,
                          //     child: Marquee(
                          //       text: 'Welcome to Auto Mall Sales Management App',
                          //       style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w600, color: Colors.cyan.shade200),
                          //       scrollAxis: Axis.horizontal,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       blankSpace: 50.0,
                          //       velocity: 50.0,
                          //       pauseAfterRound: Duration(seconds: 1),
                          //       startPadding: 10.0,
                          //       accelerationDuration: Duration(seconds: 1),
                          //       accelerationCurve: Curves.linear,
                          //       decelerationDuration: Duration(milliseconds: 500),
                          //       decelerationCurve: Curves.easeOut,
                          //     ),
                          //   ),
                          // ),
                          // Title
                          SizedBox(height: 15.h),
                          // Login Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(22, 8, 22, 24),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 12, 23, 83).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: const Color.fromARGB(255, 27, 34, 73).withOpacity(0.5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 20.r,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  Center(
                                //    child: Text(
                                //     "Sign In Form",
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.w700,
                                //       fontSize: 18.sp,
                                //       color: Colors.teal.shade900,
                                //       letterSpacing: 0.8.w,
                                //     ),
                                //    ),
                                //  ),
                                 SizedBox(height: 10.h),
                                // Username
                                TextFormField(
                                  controller: _usernameController,
                                  style: TextStyle(fontSize: 15.sp,color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter your username",
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.sp,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline_rounded,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.indigo.withOpacity(0.2), // হালকা background
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                      borderSide: BorderSide(color: Colors.grey.shade300.withOpacity(0.7)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                      borderSide: BorderSide(color: Colors.grey.shade300.withOpacity(0.7)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                      borderSide: BorderSide(color: Colors.grey.shade300.withOpacity(0.9)),
                                    ),
                                    errorStyle: TextStyle(height: 0.h),
                                  ),
                                ),
                                SizedBox(height: 18.h),
                                // Password
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isObscure,
                                  style: TextStyle(fontSize: 15.sp,color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
                                    prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.indigo.withOpacity(0.2),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                      borderSide: BorderSide(color: Colors.grey.shade300.withOpacity(0.7)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                      borderSide: BorderSide(color: Colors.grey.shade300.withOpacity(0.7)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                      borderSide: BorderSide(color: Colors.grey.shade300.withOpacity(0.9)),
                                    ),
                                    errorStyle: TextStyle(height: 0.h),
                                  ),
                                ),

                                // Error Message
                                if (isError) ...[
                                  SizedBox(height: 14.h),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(100.r),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 20.r),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            "Invalid Username or Password",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(height: 26.h),
                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 40.h,
                                  child: ElevatedButton(
                                    onPressed: isLogInBtnClk
                                        ? null
                                        : () {
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              isLogInBtnClk = true;
                                              isError = false;
                                            });
                                            if (_formkey.currentState!.validate()) {
                                              fetchLogin();
                                            } else {
                                              setState(() {
                                                isLogInBtnClk = false;
                                              });
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade900,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: Colors.black,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100.r),
                                      ),
                                    ),
                                    child: isLogInBtnClk
                                        ? SizedBox(
                                            height: 22.h,
                                            width: 22.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "LOG IN",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.1.w,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Bar
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8.r,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 11.sp),
                        children: [
                          const TextSpan(text: "Developed by  "),
                          TextSpan(
                            text: "Link-Up Technology Ltd.",
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse("https://linktechbd.com/#"));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
















// import 'dart:convert';
// //import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:alphabet_trade/utils/all_textstyle.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../home_page.dart';
// import '../utils/const_model.dart';

// class LogInPage extends StatefulWidget {
//   const LogInPage({super.key});
//   @override
//   State<LogInPage> createState() => _LogInPageState();
// }

// class _LogInPageState extends State<LogInPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   SharedPreferences? sharedPreferences;
//   fetchLogin() async {
//     String link = "${baseUrl}api/v1/login";
//     try {
//       final formData = FormData.fromMap({
//         "username": _usernameController.text,
//         "password": _passwordController.text
//       });
//       final response = await Dio().post(link, data: formData);
//       var item = jsonDecode(response.data);
//       print('Log In Response Data=== $item');
//       print("Message Response=== ${item["message"]}");
//       if (item["status"] == true) {
//         sharedPreferences = await SharedPreferences.getInstance();
//         sharedPreferences?.setString('token', "${item["token"]}");
//         sharedPreferences?.setString('sessionId', "${item["session_id"]}");
//         sharedPreferences?.setString("userName", "${item["data"]["name"]}");
//         sharedPreferences?.setString("userId", "${item["data"]["id"]}");
//         sharedPreferences?.setString("userType", "${item["data"]["usertype"]}");
//         sharedPreferences?.setString('employeeId', "${item["data"]["employeeId"]}");
//         sharedPreferences?.setString('employeePhone', "${item["data"]["employee_phone"]}");
//         sharedPreferences?.setString('customerId', "${item["data"]["customerId"]}");
//         sharedPreferences?.setString("branch", "${item["data"]["branch"]}");
//         sharedPreferences?.setString("branchName", "${item["data"]["branch_name"]}");
//         var box = Hive.box('profile');
//         box.put('name', "${item["data"]["name"]}");
//         box.put('token', "${item["token"]}");

//         print('tokeeeen=====${sharedPreferences?.getString('token')}');
//         print('employeeId=====${sharedPreferences?.getString('employeeId')}');
//         print('sessionId===== ${sharedPreferences?.getString('sessionId')}');
//         print('userName===== ${sharedPreferences?.getString('userName')}');

//         GetStorage().write("token", "${item["token"]}");
//         GetStorage().write("id", "${item["data"]["id"]}");
//         GetStorage().write("name", "${item["data"]["name"]}");
//         GetStorage().write("usertype", "${item["data"]["usertype"]}");
//         GetStorage().write("customerId", "${item["data"]["customerId"]}");
//         GetStorage().write("image_name", "${item["data"]["image_name"]}");
//         GetStorage().write("branch", "${item["data"]["branch"]}");
//         GetStorage().write("branch_name", "${item["data"]["branch_name"]}");

//         ///access for sales module
//         if(item["access"]=="null"||item["access"]==null){
//            item["access"]=[];
//         }else{
//           sharedPreferences?.setString("sales", "${item["access"].contains("sales")}");
//           sharedPreferences?.setString("salesinvoice", "${item["access"].contains("salesinvoice")}");
//           sharedPreferences?.setString("salesrecord", "${item["access"].contains("salesrecord")}");
//           sharedPreferences?.setString("customerlist", "${item["access"].contains("customerlist")}");
//           sharedPreferences?.setString("order_entry", "${item["access"].contains("order_entry")}");
//           sharedPreferences?.setString("orderRecord", "${item["access"].contains("orderRecord")}");
//           sharedPreferences?.setString("customer", "${item["access"].contains("customer")}");
//           sharedPreferences?.setString("productlist", "${item["access"].contains("productlist")}");
//           sharedPreferences?.setString("category", "${item["access"].contains("category")}");
//           sharedPreferences?.setString("currentStock", "${item["access"].contains("currentStock")}");
//           sharedPreferences?.setString("attendanceEntry", "${item["access"].contains("attendance_entry")}");
//           sharedPreferences?.setString("attendanceRecord", "${item["access"].contains("attendance_record")}");
//           sharedPreferences?.setString("visitEntry", "${item["access"].contains("visit_entry")}");
//           sharedPreferences?.setString("visitEntryRecord", "${item["access"].contains("visit_entry_record")}");
//         }
//         setState(() {
//           isLogInBtnClk = false;
//         });
//         _usernameController.text = "";
//         _passwordController.text = "";

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green.shade900,
//             content: Center(child: Text("${item["message"]}",style: const TextStyle(color: Colors.white),))));
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
//       }else{
//         setState(() {
//           isLogInBtnClk = false;
//           isError=true;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLogInBtnClk = false;
//         isError=true;
//       });
//     }
//   }

//   String? user_name;
//    bool _isObscure = true;
//    final _formkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: InkWell(onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
//           child: Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("images/bg.jpg"),fit: BoxFit.fill)),
//             child: Container(
//               color: Colors.black.withOpacity(0.6),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formkey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 50.0,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(color: Colors.teal.shade900),
//                         child: const Center(
//                           child: Text("Sales Management Apps",
//                             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0, color: Colors.white),
//                        ))),
//                       SizedBox(height: MediaQuery.of(context).size.height / 30),
//                       Container(
//                         height: 140,
//                         width: 200,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15.0),
//                             border: Border.all(color: Colors.cyan.shade300, width: 2.0),
//                             image: const DecorationImage(image: AssetImage("images/mainlogo.jpg"),fit: BoxFit.fill,)
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Center(
//                         child: Text(
//                           "Sign In Form",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 25.0,
//                               color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                           height: isError == true ? MediaQuery.of(context).size.height/2.9 : MediaQuery.of(context).size.height/3.3,
//                           width: MediaQuery.of(context).size.width,
//                           margin: const EdgeInsets.only(left: 10.0, right: 10.0),
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
//                           decoration: BoxDecoration(color: Colors.white.withOpacity(0.5),
//                             border: Border.all(color: Colors.cyanAccent, width: 2.0),
//                             borderRadius: BorderRadius.circular(20.0),
//                            ),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 50.0,
//                                   child: TextFormField(
//                                     controller: _usernameController,
//                                     decoration:   InputDecoration(
//                                       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//                                       fillColor: Colors.white.withOpacity(0.9),
//                                       filled: true,
//                                       hintText: "User Name",
//                                       errorStyle: const TextStyle(fontSize: 0.0),
//                                       hintStyle: const TextStyle(fontSize: 14.0),
//                                       enabledBorder:  OutlineInputBorder(
//                                         borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 155, 152, 152)),
//                                         borderRadius: BorderRadius.circular(100.0),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 185, 185, 185)),
//                                         borderRadius: BorderRadius.circular(100.0)
//                                       ),
//                                     ),
//                                     onTap: () async {},
//                                   ),
//                                 ),
//                                 const SizedBox(height: 15.0),
//                                 SizedBox(
//                                   height: 50.0,
//                                   child: TextFormField(
//                                     obscureText: _isObscure,
//                                     controller: _passwordController,
//                                     decoration: InputDecoration(
//                                       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//                                       fillColor: Colors.white.withOpacity(0.9),
//                                       filled: true,
//                                       suffixIcon: IconButton(
//                                         icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
//                                         onPressed: () {
//                                           setState(() {
//                                             _isObscure = !_isObscure;
//                                           });
//                                         },
//                                       ),
//                                       suffixIconColor: Colors.grey,
//                                       errorStyle: const TextStyle(fontSize: 0.0),
//                                       hintText: "Password",
//                                       hintStyle: const TextStyle(fontSize: 14.0),
//                                       enabledBorder:  OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             width: 1, color: Color.fromARGB(255, 155, 152, 152)),
//                                           borderRadius: BorderRadius.circular(100.0)
//                                       ),
//                                       focusedBorder:  OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             width: 1, color: Color.fromARGB(255, 185, 185, 185)),
//                                           borderRadius: BorderRadius.circular(100.0)
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10.0),
//                                 Visibility(
//                                   visible: isError,
//                                   child: const Align(
//                                     alignment: Alignment.topLeft,
//                                     child: Column(
//                                       children: [
//                                         Text("Invalid User name or Password",style: TextStyle(color: Colors.red,fontSize: 16),),
//                                         SizedBox(height: 10.0),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: GestureDetector(
//                                     onTap: () async {
//                                       // final connectivityResult = await (Connectivity().checkConnectivity());
//                                       // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
//                                       FocusScope.of(context).requestFocus(FocusNode());
//                                       setState(() {
//                                         isLogInBtnClk = true;
//                                       });
//                                       if (_formkey.currentState!.validate()) {
//                                         fetchLogin();
//                                       } else {
//                                         setState(() {
//                                           isError=false;
//                                           isLogInBtnClk = false;
//                                         });
//                                       }
//                                     //  }
//                                     //   else{
//                                     //      Utils.errorSnackBar(context, "Please check your internet connection");
//                                     //   }
//                                     },
//                                     child: Card(
//                                     elevation: 9.0,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
//                                       child: Container(
//                                         height: 45.0,
//                                         width: MediaQuery.of(context).size.width,
//                                         decoration: BoxDecoration(color: Colors.teal.shade900,borderRadius: BorderRadius.circular(50)),
//                                         child: Center(child: isLogInBtnClk ?  const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white)) : const Text(
//                                          "LOG IN", style: AllTextStyle.saveButtonTextStyle)),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10.0),
//                               ],
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         bottomSheet: Container(
//           height: 26.0,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(color:  Colors.teal.shade900),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 70),
//               child: Row(
//                 children: [
//                   const Text("Developed by", style: TextStyle(color: Colors.white, fontSize: 14.0)),
//                   const SizedBox(width: 5),
//                   RichText(
//                    text: TextSpan(text: "Link-Up Technology Ltd.", style: const TextStyle(color: Colors.white, fontSize: 14.0),
//                     recognizer: TapGestureRecognizer()
//                      ..onTap = () {
//                       launch("https://linktechbd.com/#");
//                    })),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   bool isLogInBtnClk = false;
//   bool isError=false;
// }
