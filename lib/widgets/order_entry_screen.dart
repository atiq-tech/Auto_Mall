import 'package:auto_mall/common_widget/type_ahead_searching_field.dart';
import 'package:auto_mall/models/bank_accounts_model.dart';
import 'package:auto_mall/models/couriers_model.dart';
import 'package:auto_mall/models/customers_model.dart';
import 'package:auto_mall/models/employees_model.dart';
import 'package:auto_mall/models/products_model.dart';
import 'package:auto_mall/models/sales_cart_model.dart';
import 'package:auto_mall/providers/bank_accounts_provider.dart';
import 'package:auto_mall/providers/couriers_provider.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/providers/employees_provider.dart';
import 'package:auto_mall/providers/products_provider.dart';
import 'package:auto_mall/utils/animation_snackbar.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/widgets/order_invoice_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget/custom_appbar.dart';
import '../../utils/all_textstyle.dart';
import '../../utils/base_url.dart';
import '../../utils/utils.dart';

class OrderEntryScreen extends StatefulWidget {
  const OrderEntryScreen({super.key});
  @override
  State<OrderEntryScreen> createState() => _OrderEntryScreenState();
}

class _OrderEntryScreenState extends State<OrderEntryScreen> {
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userType = "${sharedPreferences?.getString('usertype')}";
    print("userType======= $userType");
  }
  String? userType = '';

  Color getColor(Set<WidgetState> states) {
    return Colors.white;
  }
  Color getColors(Set<WidgetState> states) {
    return Colors.cyan.shade100;
  }
  final nameController = TextEditingController();
  final paidController = TextEditingController();
  final bankPaidController = TextEditingController();
  final discountPercentController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final addressController = TextEditingController();
  final salesRateController = TextEditingController();
  final discountController = TextEditingController();
  final vatController = TextEditingController();
  final quantityController = TextEditingController();
  final warrantyController = TextEditingController();
  final transportController = TextEditingController();
  final customerController = TextEditingController();
  final employeeController = TextEditingController();
  final categoryController = TextEditingController();
  final branchController = TextEditingController();
  final routeController = TextEditingController();
  final productController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final vatPercentageController = TextEditingController();
  final accountController = TextEditingController();
  bool isCredit = false;
  final creditController = TextEditingController();
  bool isCourier = false;
  final courierController = TextEditingController();
  final disPercentController = TextEditingController();
  final disAmountController = TextEditingController();

  var customerSlNo;
  String? customerType = '';
  String? customerMobile;
  String? customerAddress;
  String? productId;
  String? categoryId;
  String? customerId;
  String? employeeId;
  String? bankAccountId;
  String? courierId;
  String level = "retail";
  String? productUnit;
  double subtotal = 0;
  double cartTotal = 0;

///===new====
  double discountPer = 0;
  double discountAmount = 0;
  double vatPer = 0;
  double vatAmount = 0;
  double transportCost = 0;
  double paid = 0;
  double total = 0;
  double cashPaid = 0;
  double bankPaid = 0;
  double due = 0;
  double paidtotal = 0;

  void  removeFromCart(index){
    salesCartList.removeAt(index);
    calculateTotal();
    total = 0;
    due = 0;

    vatController.text ='0';
    vatPercentageController.text = "0";
    discountController.text ='0';
    discountPercentController.text ='0';
    paidController.text ='0';
    transportController.text = '0';
  }

  void  calculateTotal(){
    final allSalesCartData = salesCartList;
    double cartTotall = allSalesCartData.map((e) => e.total).fold(0.0, (p, element) => p+double.parse(element!));
    subtotal = double.parse("$cartTotall");
    double afterDisTotal = subtotal - discountAmount;
    total = afterDisTotal + vatAmount + transportCost;
    paidtotal = total;
    paid = (cashPaid + bankPaid);
    due = total - paid;
  }
  ///
  List<SalesCartModel> salesCartList = [];

  
   // Subtotal বের করার জন্য (Qty × Sales Rate)
  double _getSubTotal() {
    double qty = double.tryParse(quantityController.text) ?? 0;
    double rate = double.tryParse(salesRateController.text) ?? 0;
    return qty * rate;
  }

  // Final Amount হিসাব করার জন্য
  void calculateAmount() {
    double subTotal = _getSubTotal();
    double discountTk = double.tryParse(disAmountController.text) ?? 0;

    // Negative discount যাতে না হয়
    if (discountTk < 0) discountTk = 0;
    if (discountTk > subTotal) discountTk = subTotal;

    setState(() {
      Total = subTotal - discountTk;
    });
  }

  String? previousDue;
  String? cproductId;
  String? productCode;
  String? productStockId;
  String? ccategoryName;
  String? cname;
  String? modelName;
  String? isService;
  String? csalesRate;
  String? cvat;
  String? cquantity;
  String? ctotal;
  String? cpurchaseRate;
  double Total = 0.0;
  bool isVisible = false;
  bool isEnabled = false;
  bool isVisibleBankName = false;
  bool isAdded = false;
  bool isSellBtnClk = false;


  @override
  void initState() {
    super.initState();
    _initializeData();
    Provider.of<EmployeesProvider>(context,listen: false).getEmployees();
    CustomersProvider().on();
    Provider.of<CustomersProvider>(context, listen: false).getCustomers("");
    Provider.of<ProductsProvider>(context,listen: false).getProducts();
    Provider.of<BankAccountsProvider>(context,listen: false).getBankAccounts();
    Provider.of<CouriersProvider>(context,listen: false).getCouriers();
    quantityController.text = "1";
    discountPercentController.text = "0";
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
  }

  var availableStock = 0;
  Response? response;
  void totalStack(String? productId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    response = await Dio().post(productStock,
      data: {
        "productId": "$productId",
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "${sharedPreferences.getString("token")}",
      }),
    );
    setState(() {
      availableStock = int.tryParse(response!.data.toString()) ?? 0;
    });
    print("availableStock=========$availableStock");
  }

  @override
  Widget build(BuildContext context) {
    final employeesData = Provider.of<EmployeesProvider>(context).employeesList;
    final customersData = Provider.of<CustomersProvider>(context).customersList;
    print("customersData======${customersData.length}");
    final productsData = Provider.of<ProductsProvider>(context).productsList;
    final bankAccountsData = Provider.of<BankAccountsProvider>(context).bankAccounts;
    final couriersData = Provider.of<CouriersProvider>(context).couriersList;
    return Scaffold(
        appBar: CustomAppBar(title: "Order Entry"),
        body: ModalProgressHUD(
          blur: 2,
          inAsyncCall: false,
          //inAsyncCall: CustomerListProvider.isCustomerTypeChange,
          progressIndicator: Utils.showSpinKitLoad(),
          child: Container(
            padding: EdgeInsets.all(8.r),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.only(left: 4.r, right: 4.r),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 206, 232, 184),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2.r,
                          blurRadius: 5.r,
                          offset: const Offset(0, 3), 
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(child: Text("Date to      :",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5.h),
                                      height: 25.h,
                                      decoration: ContDecoration.contDecoration,
                                      child: GestureDetector(
                                        onTap: userType != "u" ? _selectedDate : null,
                                        child: AbsorbPointer(
                                          absorbing: userType == "u",
                                          child: TextFormField(
                                            enabled: userType != "u" ? false : true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 5.w),
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.only(left: 20.w),
                                                child: Icon(Icons.calendar_month, color: Colors.black87, size: 16.r),
                                              ),
                                              border: const OutlineInputBorder(borderSide: BorderSide.none),
                                              hintText: firstPickedDate,
                                              hintStyle: AllTextStyle.dateFormatStyle, // Use your custom text style here
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return null;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Invoice no drop down
                        Row(
                          children: [
                            Expanded(flex:1, child:Text("Sales By    :",style: AllTextStyle.textFieldHeadStyle)),
                            Expanded(
                              flex:3,
                              child: Container(
                                margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
                                height: 25.h,
                                child: CommonTypeAheadField<EmployeesModel>(
                                controller: employeeController,
                                suggestionList: employeesData,
                                hintText: 'Select Employee',
                                selectedValueId: employeeId,
                                onValueIdChanged: (id) {
                                  setState(() {
                                    employeeId = id;
                                  });
                                },
                                displayText: (e) => e.employeeName??"",
                                valueId: (e) => e.employeeSlNo.toString(),
                              )
                              ),
                            ),
                          ],
                        ), 
                      ],
                    ),
                  ),
                  ///my practice
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                     color: const Color.fromARGB(255, 206, 232, 184),
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2.r,
                          blurRadius: 5.r,
                          offset: const Offset(0, 3), 
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    topRight: Radius.circular(5.r),
                                  ),
                                  color: AppColors.appColor),
                              child: Center(
                                child: Text('Customer Information',style: AllTextStyle.saveButtonTextStyle),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4.w, right: 4.w,bottom: 4.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Sales Type :",style: AllTextStyle.textFieldHeadStyle),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.005,
                                        child: Radio(
                                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                            fillColor: WidgetStateColor.resolveWith((states) =>
                                              const Color.fromARGB(255, 5, 114, 165),
                                            ),
                                            value: "retail",
                                            groupValue: level,
                                            onChanged: (value) {
                                              setState(() {
                                                level = value.toString();
                                                print(level);
                                                CustomersProvider().on();
                                                customerController.text = '';
                                                Provider.of<CustomersProvider>(context, listen: false).getCustomers(level);
                                              });
                                            }),
                                      ),
                                     Text("Retail",style: AllTextStyle.textFieldHeadStyle),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.005,
                                        child: Radio(
                                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                            fillColor: WidgetStateColor.resolveWith((states) =>
                                              const Color.fromARGB(255, 5, 114, 165),
                                            ),
                                            value: "wholesale",
                                            groupValue: level,
                                            onChanged: (value) {
                                              setState(() {
                                                level = value.toString();
                                                print(level);
                                                CustomersProvider().on();
                                                customerController.text = '';
                                                Provider.of<CustomersProvider>(context, listen: false).getCustomers(level);
                                              });
                                            }),
                                      ),
                                      Text("Wholesale",style: AllTextStyle.textFieldHeadStyle),
                                    ],
                                  ),
                                ],
                              ), // radio button
                              Row(
                                children: [
                                  SizedBox(width: 9.w),
                                  Text("Customer :",style: AllTextStyle.textFieldHeadStyle),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 3.w),
                                      decoration: ContDecoration.contDecoration,
                                      child: TypeAheadField<CustomersModel>(
                                        controller: customerController,
                                        hideOnEmpty: false,          
                                        hideOnLoading: false,
                                        debounceDuration: const Duration(milliseconds: 200),
                                        builder: (context, fieldController, focusNode) {
                                          return TextField(
                                            controller: fieldController,
                                            focusNode: focusNode,
                                            style: AllTextStyle.dropDownlistStyle,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                                              hintText: 'Select Customer',
                                              isDense: true,
                                              hintStyle: AllTextStyle.dropDownlistStyle,
                                              suffixIcon: customerId == ''
                                                  ? null
                                                  : GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          customerController.clear();
                                                          fieldController.clear();
                                                          customerId = '';
                                                          mobileNumberController.clear();
                                                          addressController.clear();
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 25.w),
                                                        child: Icon(Icons.close, size: 16.r),
                                                      ),
                                                    ),
                                            ),
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                setState(() {
                                                  customerId = '';
                                                });
                                              }
                                            },
                                          );
                                        },
                                        suggestionsCallback: (pattern) async {
                                          // ছোট delay দিলে suggestions ভালো কাজ করে
                                          await Future.delayed(const Duration(milliseconds: 100));

                                          if (customersData.isEmpty) return [];

                                          final query = pattern.toLowerCase().trim();

                                          if (query.isEmpty) {
                                            // কিছু না লিখলে পুরো লিস্ট দেখাবে
                                            return customersData;
                                          }

                                          return customersData
                                              .where((element) {
                                                final name = (element.displayName ?? '').toLowerCase();
                                                final code = (element.customerCode ?? '').toLowerCase();
                                                final customerName = (element.customerName ?? '').toLowerCase();
                                                return name.contains(query) ||
                                                    code.contains(query) ||
                                                    customerName.contains(query);
                                              })
                                              .toList();
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
                                            child: Text(
                                              suggestion.displayName ?? suggestion.customerName ?? '',
                                              style: AllTextStyle.dropDownlistStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        },
                                        onSelected: (CustomersModel suggestion) {
                                          customerController.text = suggestion.customerName ?? suggestion.displayName ?? '';
                                          setState(() {
                                            customerId = suggestion.customerSlNo?.toString() ?? '';
                                            customerSlNo = suggestion.customerSlNo?.toString() ?? '';
                                            customerType = suggestion.customerType?.toString() ?? '';
                                            previousDue = suggestion.previousDue?.toString() ?? '';

                                            print("customer selected ======> $customerId");

                                            if (customerId == "0" || customerId == 'null') {
                                              isVisible = true;
                                              isEnabled = true;
                                              nameController.clear();
                                              mobileNumberController.clear();
                                              addressController.clear();
                                            } else {
                                              print("Yes has $customerId");
                                              isEnabled = false;
                                              isVisible = false;
                                              customerMobile = suggestion.customerMobile;
                                              mobileNumberController.text = suggestion.customerMobile?.toString() ?? '';
                                              customerAddress = suggestion.customerAddress;
                                              addressController.text = suggestion.customerAddress?.toString() ?? '';
                                            }
                                            print('isVisible $isVisible');
                                          });
                                        },
                                      ),
                                    ),
                                                                      ),
                                ],
                              ), // drop down
                              Visibility(
                                visible: isVisible,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 28.w),
                                      child: Text("Name : ",style: AllTextStyle.textFieldHeadStyle),
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 25.h,
                                        margin: EdgeInsets.only(bottom: 4.h),
                                        child: TextFormField(
                                          style: AllTextStyle.dropDownlistStyle,
                                          controller: nameController,
                                          validator: (value) {
                                            if(value != null || value != ''){
                                              nameController.text = value.toString();
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                           focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                           enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 22.w),
                                    child: Text("Mobile : ",style: AllTextStyle.textFieldHeadStyle),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: Colors.grey[200]),
                                      child: TextFormField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        enabled: isEnabled,
                                        controller: mobileNumberController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if(value != null || value != ''){
                                            mobileNumberController.text = value.toString();
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: customerId==""? EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w): EdgeInsets.symmetric(vertical: 11.5.h,horizontal: 5.w),
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // mobile
                          
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.w),
                                    child: Text("Address : ",style: AllTextStyle.textFieldHeadStyle),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 25.h,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: Colors.grey[200],),
                                      child: TextFormField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: addressController,
                                        validator: (value) {
                                          if(value != null || value != ''){
                                            addressController.text = value.toString();
                                          }
                                          return null;
                                        },
                                        enabled: isEnabled,
                                        decoration: InputDecoration(
                                          contentPadding: customerId==""? EdgeInsets.only(bottom: 5.h,left: 5.w): EdgeInsets.symmetric(vertical: 12.h,horizontal: 5.w),
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          
                              //address
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                   Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10.h),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 206, 232, 184),
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2.r,
                          blurRadius: 5.r,
                          offset: const Offset(0, 3), 
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    topRight: Radius.circular(5.r),
                                  ),
                                  color: AppColors.appColor),
                              child: Center(
                                child: Text(
                                  'Product Information',
                                  style: AllTextStyle.saveButtonTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        padding: EdgeInsets.all(4.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // ===================== Product =====================
                            Row(
                              children: [
                                Expanded(flex: 4, child: Text("Product", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1, child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 14,
                                  child: Container(
                                    height: 25.h,
                                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    decoration: ContDecoration.contDecoration,
                                    child: TypeAheadField<ProductsModel>(
                                      controller: productController,
                                      hideOnEmpty: false,
                                      hideOnLoading: false,
                                      debounceDuration: const Duration(milliseconds: 200),
                                      builder: (context, fieldController, focusNode) {
                                        return TextField(
                                          controller: fieldController,
                                          focusNode: focusNode,
                                          style: AllTextStyle.dropDownlistStyle,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                                            isDense: true,
                                            hintText: 'Select Product',
                                            hintStyle: AllTextStyle.dropDownlistStyle,
                                            suffixIcon: productId == ''
                                                ? null
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        productController.clear();
                                                        fieldController.clear();
                                                        productId = '';
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 30.w),
                                                      child: Icon(Icons.close, size: 16.r),
                                                    ),
                                                  ),
                                          ),
                                          onChanged: (value) {
                                            if (value == '') {
                                              setState(() {
                                                productId = '';
                                              });
                                            }
                                          },
                                        );
                                      },
                                      suggestionsCallback: (pattern) async {
                                        await Future.delayed(const Duration(milliseconds: 100));

                                        if (productsData.isEmpty) return [];

                                        final query = pattern.toLowerCase().trim();

                                        if (query.isEmpty) {
                                          return productsData;
                                        }

                                        return productsData
                                            .where((element) => element.productName
                                                .toString()
                                                .toLowerCase()
                                                .contains(query))
                                            .toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                            child: Text(
                                              "${suggestion.productName} - ${suggestion.productCategoryName} - ${suggestion.productCode}",
                                              style: AllTextStyle.dropDownlistStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      },
                                      onSelected: (ProductsModel suggestion) {
                                        productController.text =
                                            "${suggestion.productName} - ${suggestion.productCategoryName} - ${suggestion.productCode}";

                                        setState(() {
                                          productId = suggestion.productSlNo;
                                          print("dfhsghdfkhgkh $productId");
                                          cproductId = suggestion.productCode;
                                          productId = suggestion.productSlNo;
                                          isService = suggestion.isService;
                                          productStockId = suggestion.productSlNo;
                                          ccategoryName = suggestion.productCategoryName;
                                          cname = suggestion.productName;
                                          modelName = suggestion.brandName;
                                          productUnit = suggestion.unitName;
                                          cvat = suggestion.vat;
                                          cpurchaseRate = suggestion.productPurchaseRate;
                                          vatController.text = suggestion.vat;
                                          salesRateController.text = suggestion.productSellingPrice;

                                          // Clear previous discount when new product selected
                                          disPercentController.clear();
                                          disAmountController.clear();

                                          calculateAmount(); // <-- new calculation
                                          totalStack(productStockId);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ), // product

                            // ===================== Sales Rate + Qty =====================
                            Row(
                              children: [
                                Expanded(flex: 4, child: Text("Sales Rate", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1, child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 6,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: salesRateController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                        hintText: "0",
                                        hintStyle: AllTextStyle.textValueStyle,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                      onChanged: (value) {
                                        calculateAmount(); // <-- updated
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Center(child: Text("Qty", style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(left: 5.w, right: 0.w),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: quantityController,
                                      onChanged: (value) {
                                        calculateAmount(); // <-- updated
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ), // quantity

                            SizedBox(height: 4.h),

                            // ===================== Discount % + Discount TK =====================
                            Row(
                              children: [
                                Expanded(flex: 4, child: Text("Discount%", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1, child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 6,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: disPercentController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                        hintText: "0",
                                        hintStyle: AllTextStyle.textValueStyle,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                      onChanged: (value) {
                                        // When % is changed → calculate Discount Amount
                                        double subTotal = _getSubTotal();
                                        double percent = double.tryParse(value) ?? 0;

                                        double discountTk = (subTotal * percent) / 100;
                                        disAmountController.text = discountTk.toStringAsFixed(2);

                                        calculateAmount();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Center(child: Text("TK", style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(left: 5.w, right: 0.w),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: disAmountController,
                                      onChanged: (value) {
                                        // When TK is changed → calculate Discount %
                                        double subTotal = _getSubTotal();
                                        double discountTk = double.tryParse(value) ?? 0;

                                        if (subTotal > 0) {
                                          double percent = (discountTk / subTotal) * 100;
                                          disPercentController.text = percent.toStringAsFixed(2);
                                        } else {
                                          disPercentController.text = "0";
                                        }

                                        calculateAmount();
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ), // discount

                            SizedBox(height: 4.h),

                            // ===================== Amount + Stock =====================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 4, child: Text("Amount", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1, child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 0.h, right: 5.w),
                                    height: 25.h,
                                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h, bottom: 0.h),
                                    decoration: ContDecoration.contDecoration,
                                    child: Text("$Total", style: AllTextStyle.textValueStyle),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    height: 25.h,
                                    decoration: ContDecoration.contDecoration,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        availableStock != 0
                                            ? Text("Stock,", style: TextStyle(color: Colors.green.shade700, fontSize: 11.sp))
                                            : Text("Stock,", style: TextStyle(color: Colors.red, fontSize: 11.sp)),
                                        Text(
                                          "$availableStock ${productUnit ?? ""}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: availableStock != 0 ? Colors.green.shade700 : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 4.h),

                            // ===================== Warranty =====================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 4, child: Text("Warranty", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1, child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 14,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: warrantyController,
                                      onChanged: (value) {},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ), // product

                            // ===================== Add to cart Button =====================
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  if (productController.text != '' || productController.text.isNotEmpty) {
                                    if (quantityController.text != '' || quantityController.text.isNotEmpty) {
                                      if (availableStock > 0) {
                                        setState(() {
                                          salesCartList.add(SalesCartModel(
                                            productId: "$productId",
                                            categoryId: "$categoryId",
                                            categoryName: "$ccategoryName",
                                            name: "$cname",
                                            salesRate: salesRateController.text,
                                            vat: vatController.text,
                                            quantity: quantityController.text,
                                            total: "$Total",
                                            purchaseRate: "$cpurchaseRate",
                                            productCode: '$cproductId',
                                            isService: '$isService',
                                            discount: disPercentController.text,
                                            warranty: warrantyController.text,
                                          ));

                                          cartTotal += Total;
                                          calculateTotal();
                                          categoryController.text = '';
                                          productController.text = '';
                                          quantityController.text = '';
                                          salesRateController.text = '';
                                          disPercentController.clear();
                                          disAmountController.clear();

                                          setState(() {
                                            Total = 0;
                                            calculateTotal();
                                            discountAmount = 0;
                                            discountPer = 0;
                                            vatAmount = 0;
                                            vatPer = 0;
                                            discountController.text = "";
                                            vatController.text = "";
                                            discountPercentController.text = "";
                                            vatPercentageController.text = "";
                                            transportController.text = "";
                                          });
                                          availableStock = 0;
                                        });
                                      } else {
                                        Utils.showTopSnackBar(context, "Stock Unavailable");
                                      }
                                    } else {
                                      Utils.showTopSnackBar(context, "Please Select Quantity");
                                    }
                                  } else {
                                    Utils.showTopSnackBar(context, "Please Select Product");
                                  }
                                },
                                child: Card(
                                  elevation: 5.0,
                                  child: Container(
                                    height: 25.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.appColor,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: const Center(
                                      child: Text("Add to cart", style: AllTextStyle.saveButtonTextStyle),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                  Container(
                    height: salesCartList.isEmpty ? 60.h:
                    salesCartList.length==1 ? 70.h :
                    salesCartList.length==2 ? 90.h :
                    salesCartList.length==3 ? 110.h :
                    salesCartList.length==4 ? 130.h :
                    MediaQuery.of(context).size.height /6,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15.h,bottom: 10.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 17.h,
                            dataRowHeight: 17.h,
                            headingRowColor: WidgetStateColor.resolveWith((states) => Colors.indigo.shade900),
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.blueGrey, width: 1.w),
                            columns: [
                              DataColumn(label: Expanded(child: Center(child: Text('SL.',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Code',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Product/Service Name',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Category',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Qty',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Rate',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Total',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Action',style: AllTextStyle.tableHeadTextStyle)))),
                            ],
                            rows: List.generate(
                              salesCartList.length,
                                  (int index) => DataRow(
                                color:index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor):WidgetStateProperty.resolveWith(getColors),
                                cells: <DataCell>[
                                  DataCell(Center(child: Text("${index+1}",style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text('${salesCartList[index].productCode}',style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text('${salesCartList[index].name}',style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text('${salesCartList[index].categoryName}',style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text('${salesCartList[index].quantity}',style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text('${salesCartList[index].salesRate}',style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text('${salesCartList[index].total}',style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: GestureDetector(
                                    onTap: () {
                                      removeFromCart(index);
                                      setState(() {
                                      });
                                    },
                                    child: Icon(Icons.delete,size: 16.r,color: Colors.red)
                                  ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 4.h),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 206, 232, 184),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2.r,
                          blurRadius: 5.r,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Container(
                              decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.r),
                                      topRight: Radius.circular(5.r)),
                                  color: AppColors.appColor),
                              child: const Center(
                                child: Text(
                                  '💸 Amount Details',
                                  style: AllTextStyle.saveButtonTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: Text("Sub Total", style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                  flex: 14,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    height: 25.h,
                                    padding: EdgeInsets.all(5.r),
                                    decoration:ContDecoration.contDecoration,
                                    child: Text(double.parse("$subtotal").toStringAsFixed(2), style:AllTextStyle.textValueStyle),
                                  )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: Text("Exchange", style:AllTextStyle.textFieldHeadStyle),),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                  flex: 14,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    height: 25.h,
                                    padding: EdgeInsets.all(5.r),
                                    decoration:ContDecoration.contDecoration,
                                    child: Text("0", style:AllTextStyle.textValueStyle),
                                  )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: Text("Discount", style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: discountPercentController,
                                        onChanged: (value) {
                                          transportController.text = '';
                                          paidController.text = '';
                                          ///discount per
                                          setState(() {
                                            discountPer = double.parse(discountPercentController.text);
                                            discountAmount = (subtotal * discountPer) / 100;
                                            discountController.text = double.parse("$discountAmount").toStringAsFixed(2);
                                            calculateTotal();
                                          });
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 6.w),
                                            hintText: "0",
                                            hintStyle: AllTextStyle.textValueStyle,
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 2,child: Center(child: Text("%", style:AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(style:AllTextStyle.textValueStyle,
                                        controller: discountController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          transportController.text = '';
                                          paidController.text = '';
                                          ///discount Amount
                                          setState(() {
                                            discountAmount = double.parse(discountController.text);
                                            discountPer = (discountAmount * 100) / subtotal;
                                            discountPercentController.text = double.parse("$discountPer").toStringAsFixed(2);
                                            calculateTotal();
                                          });
                                        },
                                        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 6.w),
                                            hintText: "0",
                                            hintStyle: AllTextStyle.textValueStyle,
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: Text("Vat", style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(top: 4.h),
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: vatPercentageController,
                                        onChanged: (value) {
                                          transportController.text = '';
                                          paidController.text = '';
                                          setState(() {
                                            ///vatPer
                                            double totalAmount = subtotal - discountAmount;
                                            vatPer = double.parse(vatPercentageController.text);
                                            vatAmount = (totalAmount * vatPer) / 100;
                                            vatController.text = double.parse("$vatAmount").toStringAsFixed(2);
                                            calculateTotal();
                                          });
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            hintText: "0",
                                            hintStyle: AllTextStyle.textValueStyle,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 2,child: Center(child: Text("%", style:AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(top: 4.h),
                                      child: TextField(style: AllTextStyle.textValueStyle,
                                        controller: vatController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          transportController.text = '';
                                          paidController.text = '';
                                          ///vat amount
                                          setState(() {
                                            double totalAmount = subtotal - discountAmount;
                                            vatAmount = double.parse(vatController.text);
                                            vatPer = (vatAmount * 100) / totalAmount;
                                            vatPercentageController.text = double.parse("$vatPer").toStringAsFixed(2);
                                            calculateTotal();
                                          });
                                        },
                                        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 6.w),
                                            hintText: "0",
                                            filled: true,
                                            hintStyle: AllTextStyle.textValueStyle,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(flex: 5,child: Text("Tr. Cost", style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: transportController,
                                        onChanged: (value) {
                                          setState(() {
                                            transportCost = double.parse(transportController.text);
                                            calculateTotal();
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(contentPadding: EdgeInsets.only(top: 5.h, left: 5.w),
                                            hintText: "0",
                                            hintStyle: AllTextStyle.textValueStyle,
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5,child: Text("Total",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                      flex: 14,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 4.h),
                                        height: 25.h,
                                        padding: EdgeInsets.all(5.r),
                                        decoration: ContDecoration.contDecoration,
                                        child: Text(total.toStringAsFixed(2), style:AllTextStyle.textValueStyle),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(flex: 5,child: Text("Cash Paid",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 25.h,
                                      margin: const EdgeInsets.only(bottom: 4),
                                      child: TextField(style: AllTextStyle.textValueStyle,
                                        controller: paidController,
                                        onChanged: (value) {
                                        setState(() {
                                          if (value.trim().isEmpty) {
                                            cashPaid = 0;
                                          } else {
                                            cashPaid = double.tryParse(value) ?? 0;
                                          }
                                          isAdded = false;
                                          calculateTotal();
                                        });
                                      },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                                          hintText: "0",
                                          hintStyle: TextStyle(fontSize: 13.5,fontWeight: FontWeight.w400,color: Colors.grey.shade600),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 4,child: Center(child: Text("Bank Paid",style:AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 25.h,
                                      margin: const EdgeInsets.only(bottom: 4),
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: bankPaidController,
                                        onChanged: (value) {
                                          setState(() {
                                            if (bankPaidController.text == "" || bankPaidController.text == '0') {
                                              isVisibleBankName = false;
                                              accountController.text = "";
                                            } else {
                                              isVisibleBankName = true;
                                            }
                                          });
                                          
                                          setState(() {
                                            if (value.trim().isEmpty) {
                                              bankPaid = 0;
                                            } else {
                                              bankPaid = double.tryParse(value) ?? 0;
                                            }
                                            isAdded = false;
                                            calculateTotal();
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                                          hintText: "0",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: isVisibleBankName,
                                child: Row(
                                  children: [
                                  Expanded(flex: 5,child: Text("Bank Acc.",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                  flex: 14,
                                  child: Container(
                                  height: 25.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: const EdgeInsets.only(bottom: 4.0),
                                  child: CommonTypeAheadField<BankAccountsModel>(
                                    controller: accountController,
                                    suggestionList: bankAccountsData,
                                    hintText: 'Select Bank',
                                    selectedValueId: bankAccountId,
                                    onValueIdChanged: (id) {
                                        setState(() {
                                          bankAccountId = id;
                                        });
                                      },
                                      displayText: (a) => "${a.accountName} - ${a.accountNumber} - (${a.bankName})",
                                      valueId: (a) => a.accountId.toString(),
                                     )
                                     ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: Text('Due',style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1, child: Text(':',style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                  flex: 6,
                                  child: Container(
                                    height: 25.h,
                                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                    decoration: ContDecoration.contDecoration,
                                    child: Text(due.toStringAsFixed(2),style: AllTextStyle.textValueStyle),
                                  )),
                                  Expanded(flex: 2, child: Center(child: Text("P.Due",style: AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                      decoration:ContDecoration.contDecoration,
                                      child: SizedBox(
                                        child: Text("$previousDue" == 'null' || "$previousDue"=="" || "$previousDue"==0 ? '0' : "$previousDue", style:const TextStyle(color: Colors.red),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.75,
                                    child: Checkbox(
                                      value: isCredit,
                                      activeColor: AppColors.appColor,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                      onChanged: (value) {
                                        setState(() {
                                          isCredit = value ?? false;               
                                          if (!isCredit) {
                                            creditController.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text('Is Credit',style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1, child: Text(':',style: AllTextStyle.textFieldHeadStyle)),
                                  isCredit == true ? Expanded(
                                    flex: 15,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                      controller: creditController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
                                        hintText: "0",
                                        hintStyle: AllTextStyle.textValueStyle,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                     ),
                                    ),
                                  ):Expanded(flex: 15, child: SizedBox()),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.75,
                                    child: Checkbox(
                                      value: isCourier,
                                      activeColor: AppColors.appColor,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                      onChanged: (value) {
                                        setState(() {
                                          isCourier = value ?? false;               
                                          if (!isCourier) {
                                            courierController.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text('Is Courier',style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1, child: Text(':',style: AllTextStyle.textFieldHeadStyle)),
                                  isCourier == true ? Expanded(
                                    flex: 15,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: CommonTypeAheadField<CouriersModel>(
                                        controller: courierController,
                                        suggestionList: couriersData,
                                        hintText: 'Select Courier',
                                        selectedValueId: courierId,
                                        onValueIdChanged: (id) {
                                          setState(() {
                                            courierId = id;
                                          });
                                        },
                                        displayText: (c) => c.name??"",
                                        valueId: (c) => c.id.toString(),
                                      )
                                    ),
                                  ):Expanded(flex: 15, child: SizedBox()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                    },
                                    child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                        height: 25.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 94, 136, 57),
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        child: const Center(child: Text("New Order",style:AllTextStyle.saveButtonTextStyle))
                                    )),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () async {
                                        if (customerController.text == '') {
                                        Utils.showTopSnackBar(context, "Customer Field is required");
                                      }else{
                                        setState(() {
                                          isSellBtnClk = true;
                                        });
                                        if (subtotal == 0) {
                                          setState(() {
                                            isSellBtnClk = false;
                                          });
                                          Utils.showTopSnackBar(context, "Please Add to Cart");
                                        } else {
                                          addSales();
                                        }
                                      }
                                    },
                                    child: Card(
                                      elevation: 5.0,
                                      child: Container(
                                        height: 25.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          color: Colors.indigo.shade900,
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        child: Center(child: isSellBtnClk ? SizedBox(height: 20.h, width: 20.w, child: CircularProgressIndicator(color: Colors.white))
                                            : const Text("Order", style:AllTextStyle.saveButtonTextStyle)),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        )
    );
  }

  String? firstPickedDate;
  var backEndFirstDate;
  void _selectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
        print("Firstdateee $firstPickedDate");
      });
    }
  }
  
   void emptyData() {
    subtotal=0;
    due=0;
    employeeId="";
    customerId='';
    invoiceNoController.text="";
    employeeController.text="";
    routeController.text="";
    customerController.text="";
    nameController.text = "";
    paidController.text = "";
    discountPercentController.text = "";
    mobileNumberController.text = "";
    addressController.text = "";
    salesRateController.text = "";
    discountController.text = "";
    vatController.text = "";
    vatPercentageController.text="";
    quantityController.text = "";
    transportController.text = "";
    paidController.text="";
    courierController.text = "";
    creditController.text = "";
    paidtotal=0;
    previousDue = "";
    cartTotal = 0;
    discountAmount=0;
    vatAmount=0;
    vatPer=0;
    total=0;
    salesCartList.clear();
  }

  addSales() async {
  SharedPreferences? sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  try {
    var cartItems = salesCartList.map((e) {
      return {
        "productId": e.productId,
        "productCode": e.productCode ?? "",
        "name": e.name ?? "",
        "quantity": e.quantity,
        "purchaseRate": e.purchaseRate,
        "salesRate": e.salesRate,
        "vat": e.vat ?? "0",
        "total": e.total,
        "discount": e.discount ?? "0",
        "is_service": e.isService ?? "false",
        "warranty": e.warranty ?? "0",
      };
    }).toList();

    Response response = await Dio().post(
      addSale,
      data: {
        "sales": {
          "isOrder": "1",
          "isCourier": isCourier ? "1" : "0",
          "employeeId": employeeId ?? "0",
          "courierId": isCourier ? (courierId ?? "0") : "0",
          "customerId": customerId ?? "0",
          "salesDate": "$backEndFirstDate",
          "salesType": level,
          "total": total.toStringAsFixed(2),
          "discount": discountAmount.toStringAsFixed(2),
          "vat": vatAmount.toStringAsFixed(2),
          "transportCost": transportCost.toStringAsFixed(2),
          "subTotal": subtotal.toStringAsFixed(2),
          "accountId": bankAccountId ?? "",
          "cashPaid": cashPaid.toStringAsFixed(2),
          "bankPaid": bankPaid.toStringAsFixed(2),
          "paid": paid.toStringAsFixed(2),
          "due": due.toStringAsFixed(2),
          "previousDue": (previousDue == null || previousDue == 'null' || previousDue == "" || previousDue == "0")
              ? "0"
              : previousDue,
          "note": "",
          "exchangeTotal": "0", // change this if you have exchange logic
        },
        "customer": {
          "Customer_SlNo": customerId ?? "0",
          "Customer_Code": "",
          "Customer_Name": (customerType == "N" || customerType == "G")
              ? nameController.text.trim()
              : customerController.text.trim(),
          "display_name": (customerType == "N" || customerType == "G")
              ? nameController.text.trim()
              : customerController.text.trim(),
          "Customer_Mobile": mobileNumberController.text.trim(),
          "Customer_Address": addressController.text.trim(),
          "Customer_Type": customerType ?? level,
        },
        "cart": cartItems,
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "${sharedPreferences.getString("token")}",
      }),
    );

    var item = response.data;
    print("Product Cart============$cartItems");
    print("Sales Entry Data============$item");

    if (item["success"] == true) {
      setState(() {
        isSellBtnClk = false;
      });
      emptyData();
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderInvoiceScreen(salesId: "${item["salesId"]}"),
        ),
      );
    } else {
      setState(() {
        isSellBtnClk = false;
      });
      Utils.showTopSnackBar(context, "${item["message"] ?? "Failed"}");
    }
  } catch (e) {
    print(e);
    setState(() {
      isSellBtnClk = false;
    });
    Utils.showTopSnackBar(context, "An error occurred: ${e.toString()}");
  }
}
}
