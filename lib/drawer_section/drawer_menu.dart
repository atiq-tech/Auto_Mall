
import 'package:auto_mall/auth/global_logout.dart';
import 'package:auto_mall/home_screen.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:auto_mall/widgets/cod_pending_order_list_screen.dart';
import 'package:auto_mall/widgets/customer%20_list_screen.dart';
import 'package:auto_mall/widgets/customer_due_list_screen.dart';
import 'package:auto_mall/widgets/customer_entry_screen.dart';
import 'package:auto_mall/widgets/order_entry_screen.dart';
import 'package:auto_mall/widgets/pending_order_record_screen.dart';
import 'package:auto_mall/widgets/product_list_screen.dart';
import 'package:auto_mall/widgets/sales_entry_screen.dart';
import 'package:auto_mall/widgets/sales_invoice_list_screen.dart';
import 'package:auto_mall/widgets/sales_record_screen.dart';
import 'package:auto_mall/widgets/visit_entry_screen.dart';
import 'package:auto_mall/widgets/visits_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_list_tile.dart';

// ignore: must_be_immutable
class DrawerDemoPage extends StatefulWidget {
  const DrawerDemoPage({super.key});

  @override
  State<DrawerDemoPage> createState() => _DrawerDemoPageState();
}

class _DrawerDemoPageState extends State<DrawerDemoPage> {
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    userID = "${sharedPreferences?.getString('userId')}";
    setState(() {
    });

  }
  String? userName = "";
  String? userType = "";
  String? userID = "";

// Check page access permission
bool hasPageAccess(String permission) {
  if (userType == "a" || userType == "m") {
    return true;
  }
  return sharedPreferences!.getBool(permission) ?? false;
}
void openPageWithAccess({required String permission,required Widget page}) {
  if (hasPageAccess(permission)) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => page));
  } else {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          icon: Icon(Icons.lock_outline,color: Colors.red,size: 40.r),
          title: const Text("Access Denied!",textAlign: TextAlign.center),
          content: const Text(
            "You don't have permission to access this page.",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:  AppColors.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35.r),
          bottomRight: Radius.circular(35.r),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 40, 10, 16),
              decoration: BoxDecoration(
                color: AppColors.appColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 2.5.w),
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColors.appColor,
                      radius: 32.r,
                      backgroundImage: AssetImage("images/automlogo.jpeg"),
                    ),
                  ),
                 SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName?.isNotEmpty == true ? userName! : "User",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        GestureDetector(
                          onTap: () {
                            launch("${baseUrl}Login");
                          },
                          child: Text(
                            "Auto Mall",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orderCardColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
              child: Custom_List_Tile(icon: Icons.home, icon_name: "Home Page")),
          Divider(height: 1.h,thickness: 1.0),

          InkWell(
            onTap: (){
              openPageWithAccess( permission: "order_entry",page: const OrderEntryScreen());
            },
            child: Custom_List_Tile(icon: Icons.border_all, icon_name: "Order Entry")),

          Divider(height: 1.h,thickness: 1.0),
          InkWell(
              onTap: (){
                openPageWithAccess(permission: "orderRecord",page: const PendingOrderRecordScreen());
              },
              child: Custom_List_Tile(icon: Icons.pending, icon_name: "Pending Order")),
   
          Divider(height: 1.h,thickness: 1.0),
          InkWell(
              onTap: (){
                openPageWithAccess(permission: "codPending",page: const CodPendingOrderListScreen());
              },
              child: Custom_List_Tile(icon: Icons.local_shipping, icon_name: "COD Pending List")),
   
          Divider(height: 1.h,thickness: 1.0),
          InkWell(
              onTap: (){
                openPageWithAccess(permission: "sales",page: const SalesEntryScreen());
              },
              child: Custom_List_Tile(icon: Icons.sim_card_alert_sharp, icon_name: "Sales Entry")),
          Divider(height: 1.h,thickness: 1.0),
          InkWell(
              onTap: (){
                openPageWithAccess(permission: "salesrecord",page: const SalesRecordScreen());
              },
              child: Custom_List_Tile(icon: Icons.library_books, icon_name: "Sales Record")),
          Divider(height: 1.h,thickness: 1.0),

          InkWell(
              onTap: (){
                openPageWithAccess(permission: "salesinvoice",page: const SalesInvoiceListScreen());
              },
              child: Custom_List_Tile(icon: Icons.insert_invitation_outlined, icon_name: "Sales Invoice")),
           Divider(height: 1.h,thickness: 1.0),
          InkWell(
              onTap: (){
                openPageWithAccess(permission: "productlist",page: const ProductListScreen());
              },
              child: Custom_List_Tile(icon: Icons.production_quantity_limits, icon_name: "Product List")),
          Divider(height: 1.h,thickness: 1.0),
         
        
          InkWell(
              onTap: (){
                openPageWithAccess(permission: "customer",page: CustomerEntryScreen());
                },
              child: Custom_List_Tile(icon: Icons.dashboard_customize_outlined, icon_name: "Customer Entry")),
          Divider(height: 1.h,thickness: 1.0),

        
        InkWell(
              onTap: (){
               openPageWithAccess(permission: "customerlist",page: CustomerListScreen());
              },
              child: Custom_List_Tile(icon: Icons.list_alt_outlined, icon_name: "Customer List")),
          Divider(height: 1.h,thickness: 1.0),

           InkWell(
              onTap: (){
                 openPageWithAccess(permission: "customerDue",page: const CustomerDueListScreen());
                },
              child: Custom_List_Tile(icon: Icons.category, icon_name: "Customer Due")),
          Divider(height: 1.h,thickness: 1.0),

          InkWell(
              onTap: (){
                openPageWithAccess(permission: "visitEntry",page: const VisitEntryScreen());
              },
              child: Custom_List_Tile(icon: Icons.visibility, icon_name: "Visit Entry")),
          Divider(height: 1.h,thickness: 1.0),

          InkWell(
              onTap: (){
                openPageWithAccess(permission: "visitEntryRecord",page: const VisitsHistoryScreen());
              },
              child: Custom_List_Tile(icon: Icons.visibility, icon_name: "Visit List")),
          Divider(height: 1.h,thickness: 1.0),
         
          InkWell(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 140.h,
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 5.w,bottom: 10.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r)
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Padding(
                                padding:
                                EdgeInsets.only(left: 8.w, top: 10.h),
                                child: Text(
                                  "Logout...!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp),
                                ),
                              ),
                               Padding(
                                padding:
                                EdgeInsets.only(left: 8.w, top: 10.h),
                                child: Text(
                                  "Are you sure want to Logout?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp),
                                ),
                              ),
                              SizedBox(height: 15.h),
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
                                        height: 28.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5.r)),
                                        child: Center(
                                            child: Text(
                                              "NO",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp),
                                            )),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    InkWell(
                                      onTap: () {
                                        LogoutService.fetchLogout(context);
                                      },
                                      child: Container(
                                        height: 28.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.r)),
                                        child: Center(
                                            child: Text("YES",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp),
                                            )),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
           child: Custom_List_Tile(icon: Icons.logout_outlined, icon_name: "Logout")),
           Divider(height: 1.h,thickness: 1.0),

        ],
      ),
    );
  }
}
// drawer list text
class TextStylee{
  TextStyle MyTextStyle = GoogleFonts.abhayaLibre(
    fontSize: 13.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 1,
    color: Colors.white,
  ) ;
}
class TextStyleeCard{
  TextStyle MyTextStyle = GoogleFonts.abhayaLibre(
    fontSize: 12.sp,
    fontWeight: FontWeight.w900,
    color: Colors.black,
  ) ;
}

// drawer list text
class ServiceTextStyle{
  TextStyle MyTextStyle = GoogleFonts.abhayaLibre(
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
    color: Colors.black,
  ) ;
}
void showCustomDialog(BuildContext context, String title, String message) {
  showDialog(context: context,
    builder: (context) {
      return AlertDialog(title: Text(title),
        content: Text(message, style: TextStyle(fontSize: 16.sp)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

