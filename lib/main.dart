
import 'package:auto_mall/providers/areas_provider.dart';
import 'package:auto_mall/providers/bank_accounts_provider.dart';
import 'package:auto_mall/providers/categories_provider.dart';
import 'package:auto_mall/providers/customer_due_provider.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/providers/employees_provider.dart';
import 'package:auto_mall/providers/invoice_provider.dart';
import 'package:auto_mall/providers/pending_order_provider.dart';
import 'package:auto_mall/providers/pending_order_record_provider.dart';
import 'package:auto_mall/providers/products_provider.dart';
import 'package:auto_mall/providers/sale_details_provider.dart';
import 'package:auto_mall/providers/sale_records_provider.dart';
import 'package:auto_mall/providers/sales_provider.dart';
import 'package:auto_mall/providers/users_provider.dart';
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
          ChangeNotifierProvider<UsersProvider>(create: (_) => UsersProvider()),
          ChangeNotifierProvider<AreasProvider>(create: (_) => AreasProvider()),
          ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
          ChangeNotifierProvider<EmployeesProvider>(create: (_) => EmployeesProvider()),
          ChangeNotifierProvider<CategoriesProvider>(create: (_) => CategoriesProvider()),
          ChangeNotifierProvider<CustomerDueProvider>(create: (_) => CustomerDueProvider()),
          ChangeNotifierProvider<CustomerDueProvider>(create: (_) => CustomerDueProvider()),
          ChangeNotifierProvider<PendingOrderRecordProvider>(create: (_) => PendingOrderRecordProvider()),
          ChangeNotifierProvider<PendingOrderProvider>(create: (_) => PendingOrderProvider()),
          ChangeNotifierProvider<BankAccountsProvider>(create: (_) => BankAccountsProvider()),
          ChangeNotifierProvider<SaleDetailsProvider>(create: (_) => SaleDetailsProvider()),
          ChangeNotifierProvider<SaleRecordsProvider>(create: (_) => SaleRecordsProvider()),
          ChangeNotifierProvider<CustomersProvider>(create: (_) => CustomersProvider()),
          ChangeNotifierProvider<InvoiceProvider>(create: (_) => InvoiceProvider()),
          ChangeNotifierProvider<SalesProvider>(create: (_) => SalesProvider()),
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
