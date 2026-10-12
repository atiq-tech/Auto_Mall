import 'package:auto_mall/auth/login_screen.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'login_screen.dart'; // আপনার LoginScreen এর path দিন

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Logout Function
  Future<void> _logout() async {
    // Confirmation Dialog
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // SharedPreferences clear করা
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // সব ডাটা মুছে ফেলবে

      // Login Screen-এ নিয়ে যাওয়া
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LogInPage()), 
          (route) => false,
        );
      }
    }
  }
  String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning!";
  } else if (hour >= 12 && hour < 17) {
    return "Good Afternoon!";
  } else if (hour >= 17 && hour < 21) {
    return "Good Evening!";
  } else {
    return "Good Night!";
  }
}
String? userImage;
String? userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Logout Button
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Logout",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
            padding: EdgeInsets.only(left: 5.w,right: 5.r,top: 5.h,bottom: 5.h),
            margin: EdgeInsets.only(left: 12.w,right: 12.r,top: 15),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(25.r),
          //     border: Border.all(color: AppColors.appColor.withOpacity(0.15)),
          //     gradient: LinearGradient(
          //     colors: [
          //       const Color.fromARGB(255, 183, 249, 255),
          //       const Color.fromARGB(255, 217, 251, 255),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          //  ),
           child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.appColor.withOpacity(0.2),
                    backgroundImage: userImage != null 
                        ? NetworkImage(userImage!) 
                        : null,
                    child: userImage == null
                        ? (userName != null && userName!.isNotEmpty
                            ? Text(
                                userName![0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.appColor,
                                ),
                              )
                            : Icon(
                                Icons.person_rounded,          // ← ইউজার না থাকলে আইকন
                                color: AppColors.buttonColor,
                                size: 50.r,
                              ))
                        : null,
                  ),
                  SizedBox(width: 10.w),
                 Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  Text(
                    "Hello, Admin",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orderCardTitle
                    ),
                  ),
                  Text(
                    getGreeting(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.isOrder
                    ),
                  ),
                ],
               ),
                ],
              ),
               Center(
                 child: Text(
                   DateFormat('E d MMMM, yyyy').format(DateTime.now()),
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 11.sp,
                     fontWeight: FontWeight.w600,
                     color: AppColors.isOrder,
                     height: 1.2,
                   ),
                 ),
               ),
             ],
           ),
          ),
          
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 90),
                itemCount: screenItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // if (index == 0) {
                      //   setState(() {
                      //     if (orderEntry == "true" || userType == "m" || userType == "a") {
                      //       if (userType == 'c') {
                      //         Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderListScreen()));
                      //       } else {
                      //         Navigator.push(context, MaterialPageRoute(builder: (context) => OutletList(totatOrderValue: totatOrdValue,routName: routName,
                      //          ))).then((value) {
                      //           setState(() {});
                      //         });
                      //       }
                      //     } else {
                      //       showCustomDialog(context);
                      //     }
                      //   });
                      // } 
                      // else if (index == 1) {
                      //   if (orderRecord == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderRecordScreen()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 2) {
                      //   if (salesInvoice == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context,MaterialPageRoute(builder: (context) => const AllOrderInvoicePage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 3) {
                      //   if (salesEntry == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryPage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 4) {
                      //   if (salesRecord == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 5) {
                      //   if (salesInvoice == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context,MaterialPageRoute(builder: (context) => const AllSalesInvoicePage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 6) {
                      //   if (productList == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 7) {
                      //   if (categoryList == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context,MaterialPageRoute(builder: (context) => const CategoryListScreen()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 8) {
                      //   if (customerEntry == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerEntryPage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 9) {
                      //   if (customerList == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerListPage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 10) {
                      //   if (visitEntry == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitEntryPage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 11) {
                      //   if (visitRecord == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitHistoryPage()));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else if (index == 12) {
                      //   if (attendanceEntry == "true" || userType == "m" || userType == "a") {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceEntry(latiduteValue: latitude,LongitudeValue: longitude)));
                      //   } else {
                      //     showCustomDialog(context);
                      //   }
                      // } 
                      // else {
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const OutletMapScreen()));
                      // }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.06),
                            blurRadius: 12.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.w,
                            padding: EdgeInsets.all(5.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.1),
                                    blurRadius: 6,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Icon(Icons.shopping_bag,color: const Color.fromARGB(255, 4, 87, 155),size: 40.r),
                                // child: Image.asset("${screenItems[index]["image"]}",fit: BoxFit.contain),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Text(
                              '${screenItems[index]["name"]}',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}