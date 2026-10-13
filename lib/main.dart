
import 'package:auto_mall/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  // await Hive.initFlutter();
  // Hive.registerAdapter(ProductAdapter());
  // await Hive.openBox<Product>('product');
  // await Hive.openBox('profile');
  runApp(const AutoMallApp());
}

class AutoMallApp extends StatelessWidget {
  const AutoMallApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auto Mall',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
          useMaterial3: true,
        ),
        home:const AnimatedSplashScreen(),
      ));
  }
}



// import 'package:auto_mall/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// late final SharedPreferences sharedPreferences;
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   sharedPreferences = await SharedPreferences.getInstance();
//   // await Hive.initFlutter();
//   // Hive.registerAdapter(ProductAdapter());
//   // await Hive.openBox<Product>('product');
//   // await Hive.openBox('profile');
//   runApp(const AutoMallApp());
// }

// class AutoMallApp extends StatelessWidget {
//   const AutoMallApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       builder: (context, child) => MultiProvider(
//        providers: [
//         // ChangeNotifierProvider<AllCurrentStockProvider>(create: (_) => AllCurrentStockProvider()),
//         // ChangeNotifierProvider<OrderDetailsProvider>(create: (_) => OrderDetailsProvider()),
//         // ChangeNotifierProvider<CustomerListProvider>(create: (_) => CustomerListProvider()),
//         // ChangeNotifierProvider<CurrentStockProvider>(create: (_) => CurrentStockProvider()),
//         // ChangeNotifierProvider<AllCategoryProvider>(create: (_) => AllCategoryProvider()),
//         // ChangeNotifierProvider<ProductListProvider>(create: (_) => ProductListProvider()),
//         // ChangeNotifierProvider<CustomerDueProvider>(create: (_) => CustomerDueProvider()),
//         // ChangeNotifierProvider<SalesRecordProvider>(create: (_) => SalesRecordProvider()),
//         // ChangeNotifierProvider<SaleDetailsProvider>(create: (_) => SaleDetailsProvider()),
//         // ChangeNotifierProvider<OrderRecordProvider>(create: (_) => OrderRecordProvider()),
//         // ChangeNotifierProvider<GetOrderProvider>(create: (_) => GetOrderProvider()),
//         // ChangeNotifierProvider<GetSalesProvider>(create: (_) => GetSalesProvider()),
//         // ChangeNotifierProvider<EmployeeProvider>(create: (_) => EmployeeProvider()),
//         // ChangeNotifierProvider<AllUserProvider>(create: (_) => AllUserProvider()),
//         // ChangeNotifierProvider<AreaProvider>(create: (_) => AreaProvider()),
        
//         // ///ChangeNotifierProvider<UserDataProvider>(create: (_) => UserDataProvider()),
        
//         // ChangeNotifierProvider<ZoneProvider>(create: (_) => ZoneProvider()),
//         // ChangeNotifierProvider<RouteProvider>(create: (_) => RouteProvider()),
//         // ChangeNotifierProvider<VisitsProvider>(create: (_) => VisitsProvider()),
//         // ChangeNotifierProvider<OutletsProvider>(create: (_) => OutletsProvider()),
//         // ChangeNotifierProvider<SalesManProvider>(create: (_) => SalesManProvider()),
//         // ChangeNotifierProvider<AttendanceProvider>(create: (_) => AttendanceProvider()),
//         // ChangeNotifierProvider<AllProductsProvider>(create: (_) => AllProductsProvider()),
//         // ChangeNotifierProvider<SalesInvoiceProvider>(create: (_) => SalesInvoiceProvider()),
//         // ChangeNotifierProvider<AllCategoriesProvider>(create: (_) => AllCategoriesProvider()),
//         // ChangeNotifierProvider<OrdersInvoiceProvider>(create: (_) => OrdersInvoiceProvider()),
//         // ChangeNotifierProvider<OutletsCustomerProvider>(create: (_) => OutletsCustomerProvider()),
//         // ChangeNotifierProvider<OrderCateWiseProductProvider>(create: (_) => OrderCateWiseProductProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Alphabet Trade',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
//           useMaterial3: true,
//         ),
//         home:const AnimatedSplashScreen(),
//       ),
//     ));
//   }
// }