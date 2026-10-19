import 'package:auto_mall/auth/global_logout.dart';
import 'package:auto_mall/drawer_section/drawer_menu.dart';
import 'package:auto_mall/main.dart';
import 'package:auto_mall/utils/all_textstyle.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:auto_mall/widgets/customer_due_list_screen.dart';
import 'package:auto_mall/widgets/pending_order_record_screen.dart';
import 'package:auto_mall/widgets/customer%20_list_screen.dart';
import 'package:auto_mall/widgets/customer_entry_screen.dart';
import 'package:auto_mall/widgets/order_entry_screen.dart';
import 'package:auto_mall/widgets/product_list_screen.dart';
import 'package:auto_mall/widgets/sales_entry_screen.dart';
import 'package:auto_mall/widgets/sales_record_screen.dart';
import 'package:auto_mall/widgets/visit_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _initializeData() async {
    userName = sharedPreferences.getString('userName') ?? ''; 
    userType = "${sharedPreferences.getString('userType')}";
    salesEntry = '${sharedPreferences.getString("sales")}';
    salesInvoice = '${sharedPreferences.getString("salesinvoice")}';
    salesRecord = '${sharedPreferences.getString("salesrecord")}';
    customerList = '${sharedPreferences.getString("customerlist")}';
    orderEntry = '${sharedPreferences.getString("order_entry")}';
    orderRecord = '${sharedPreferences.getString("orderRecord")}';
    customerEntry = '${sharedPreferences.getString("customer")}';
    productList = '${sharedPreferences.getString("productlist")}';
    categoryList = '${sharedPreferences.getString("category")}';
    currentStock = '${sharedPreferences.getString("currentStock")}';
    attendanceEntry = '${sharedPreferences.getString("attendanceEntry")}';
    attendanceRecord = '${sharedPreferences.getString("attendanceRecord")}';
    visitEntry = '${sharedPreferences.getString("visitEntry")}';
    visitRecord = '${sharedPreferences.getString("visitEntryRecord")}';
    setState(() {
      
    });
    print("userName===========$userName");
  }

  String? userName = "";
  String? userImage;
  String? userType = "";
  String? salesEntry;
  String? salesRecord;
  String? salesInvoice;
  String? orderEntry;
  String? orderRecord;
  String? customerList;
  String? customerEntry;
  String? productList;
  String? categoryList;
  String? currentStock;
  String? attendanceEntry;
  String? attendanceRecord;
  String? visitEntry;
  String? visitRecord;

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

@override
  void initState() {
    _initializeData();
    // TODO: implement initState
    super.initState();
  }

var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              height: 55.h,
              width: 64.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                image: const DecorationImage(
                  image: AssetImage("images/splashlogo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Auto Mall",
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5.w,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Row(
              children: [
                PopupMenuButton(
                  child: Container(
                    height: 20.0.h,
                    width: 30.0.w,
                    alignment: Alignment.center,
                    child: Icon(Icons.arrow_drop_down, color: Colors.white, size: 25.0.sp),
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                    } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            height: 160.0.h,
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 5.0.w,bottom: 10.0.h),
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15.0.r)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
                                child: Text("Logout...!",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
                                ),
                              ),
                                Padding(
                                padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
                                child: Text("Are you sure want to Logout?",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0.sp)),
                              ),
                              SizedBox(height: 25.0.h),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 28.0.h,
                                        width: 60.0.w,
                                        decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0.r)),
                                        child: Center(child: Text("NO", style: AllTextStyle.saveButtonTextStyle)),
                                      ),
                                    ),
                                    SizedBox(width: 10.0.w),
                                    InkWell(
                                    onTap: () {
                                        LogoutService.fetchLogout(context);
                                      },
                                      child: Container(
                                        height: 28.0.h,
                                        width: 60.0.w,
                                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0.r)),
                                        child: Center(child: Text("YES", style: AllTextStyle.saveButtonTextStyle)),
                                      ),
                                    ),
                                    SizedBox(width: 10.0.w),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  }
                },
                itemBuilder: (BuildContext bc) {
                  return [
                    PopupMenuItem(
                      height: 25.0.h,
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.logout_outlined,size: 16.0.r,color: Colors.black),
                          Text("Logout", style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ];
                  },
                )
                ],
              ),
          ),
        ],
      ),
      drawer: DrawerDemoPage(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 5.w, right: 5.r, top: 5.h, bottom: 5.h),
              margin: EdgeInsets.only(left: 12.w, right: 12.r, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side
                  Flexible(                         
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
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
                                      Icons.person_rounded,
                                      color: AppColors.orderCardTitle,
                                      size: 50.r,
                                    ))
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Flexible(                     
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, ${userName ?? ''}",
                                maxLines: 2,                    
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.orderCardTitle,
                                ),
                              ),
                              Text(
                                getGreeting(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.isOrder,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    DateFormat('E d MMMM, yyyy').format(DateTime.now()),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.isOrder,
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
                      if (index == 0) {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderEntryScreen()));
                        
                        //   if (orderEntry == "true" || userType == "m" || userType == "a") {
                        //    Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderEntryScreen()));
                        //   } else {
                        //     showCustomDialog(context);
                        //   }
                      } 
                      else if (index == 1) {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const PendingOrderRecordScreen()));
                        // if (orderRecord == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderRecordScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 2) {
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => const PendingOrderRecordScreen()));
                        // if (salesInvoice == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) => const CODRecordScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 3) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryScreen()));
                        // if (salesEntry == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 4) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordScreen()));
                        // if (salesRecord == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 5) {
                        // if (salesInvoice == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) => const AllSalesInvoicePage()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 6) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen()));
                        // if (productList == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 7) {
                         Navigator.push(context,MaterialPageRoute(builder: (context) => CustomerEntryScreen()));
                        // if (categoryList == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) => const CategoryListScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 8) {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => CustomerListScreen()));
                        // if (customerEntry == "true" || userType == "m" || userType == "a") {
                        //    Navigator.push(context,MaterialPageRoute(builder: (context) => CustomerEntryScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 9) {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerDueListScreen()));
                        // if (customerList == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerListScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
                      else if (index == 10) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitEntryScreen()));
                        // if (visitEntry == "true" || userType == "m" || userType == "a") {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitEntryScreen()));
                        // } else {
                        //   showCustomDialog(context);
                        // }
                      } 
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
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsets.all(5.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.appColor.withOpacity(0.1),
                                    blurRadius: 6.r,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.asset("${screenItems[index]["image"]}",fit: BoxFit.contain),
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