
import 'package:auto_mall/providers/areas_provider.dart';
import 'package:auto_mall/providers/customer_due_provider.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/providers/products_provider.dart';
import 'package:auto_mall/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const AutoMallApp());
}

class AutoMallApp extends StatelessWidget {
  const AutoMallApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MultiProvider(
       providers: [
          ChangeNotifierProvider<AreasProvider>(create: (_) => AreasProvider()),
          ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
          ChangeNotifierProvider<CustomersProvider>(create: (_) => CustomersProvider()),
          ChangeNotifierProvider<CustomerDueProvider>(create: (_) => CustomerDueProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Auto Mall',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
            useMaterial3: true,
          ),
          home:const AnimatedSplashScreen(),
        ),
      ));
  }
}
