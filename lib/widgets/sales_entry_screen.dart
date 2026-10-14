import 'dart:convert';
import 'package:auto_mall/models/sales_cart_model.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget/custom_appbar.dart';
import '../../utils/all_textstyle.dart';
import '../../utils/base_url.dart';
import '../../utils/utils.dart';

class SalesEntryScreen extends StatefulWidget {
  const SalesEntryScreen({super.key});
  @override
  State<SalesEntryScreen> createState() => _SalesEntryScreenState();
}

class _SalesEntryScreenState extends State<SalesEntryScreen> {
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _discountPercentController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salesRateController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final customerController = TextEditingController();
  final empluyeeNameController = TextEditingController();
  final categoryController = TextEditingController();
  final branchController = TextEditingController();
  final routeController = TextEditingController();
  final productController = TextEditingController();
  final _invoiceNoController = TextEditingController();
  final TextEditingController _vatPercentageController = TextEditingController();
  bool isCredit = false;
  final TextEditingController creditController = TextEditingController();

  var customerSlNo;
  String?  customerType = '';
  String? customerMobile;
  String? customerAddress;
  String? productId;
  String? categoryId;
  String? branchId;
  String? _selectedCustomer;
  String? _selectedRoute;
  String? employeeSlNo;
  String level = "retail";
  var availableStock = 0;
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
  double due = 0;
  double paidtotal = 0;

  void  removeFromCart(index){
    salesCartList.removeAt(index);
    calculateTotal();
    total = 0;
    due = 0;

    _vatController.text ='0';
    _vatPercentageController.text = "0";
    _discountController.text ='0';
    _discountPercentController.text ='0';
    _paidController.text ='0';
    _transportController.text = '0';
  }

  void  calculateTotal(){
    final allSalesCartData = salesCartList;
    double cartTotall = allSalesCartData.map((e) => e.total).fold(0.0, (p, element) => p+double.parse(element!));
    subtotal = double.parse("$cartTotall");
    double afterDisTotal = subtotal - discountAmount;
    total = afterDisTotal + vatAmount + transportCost;
    paidtotal = total;
  }
  ///
  List<SalesCartModel> salesCartList = [];

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
  late final Box box;
  bool isSellBtnClk = false;


  @override
  void initState() {
    super.initState();
    _initializeData();
    // Provider.of<EmployeeProvider>(context,listen: false).getEmployee();
    // Provider.of<ProductListProvider>(context,listen: false).getProduct("","");
    // Provider.of<RouteProvider>(context, listen: false).getRoute();
    // CustomerListProvider.isCustomerTypeChange = true;
    // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(level, "","");
     _quantityController.text = "1";
    _discountPercentController.text = "0";
    getOrderInvoice();

    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
  }

  //invoiceNo
  String? invoiceNo;
  getOrderInvoice() async {
    String link = "${baseUrl}api/v1/getSaleInvoice";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(link,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      setState(() {
        _invoiceNoController.text = jsonDecode(response.data);
      });
      print("invoiceNo Code===========> ${_invoiceNoController.text}");
    } catch (e) {
      print(e);
    }
  }

  Response? response;
  void totalStack(
      String? productId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    response = await Dio().post("${baseUrl}api/v1/getProductStock",
        data: {
          "productId": "$productId",
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
    setState(() {
      availableStock = jsonDecode(response!.data);

    });
  }

  @override
  Widget build(BuildContext context) {

    // final allEmployee = Provider.of<EmployeeProvider>(context).allEmployeeList;
    // final allRouteData = Provider.of<RouteProvider>(context).allRouteList;
    // final allCustomer = Provider.of<CustomerListProvider>(context).customerList;
    // final productList = Provider.of<ProductListProvider>(context).allProductList;
    return Scaffold(
        appBar: CustomAppBar(title: "Sales Entry"),
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
                    padding: EdgeInsets.only(left: 4.r, right: 4.r, top: 4.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8D4E8),
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
                          children: [
                            Expanded(child: Text("Invoice no :",style: AllTextStyle.textFieldHeadStyle)),
                            Expanded(
                              flex:3,
                              child: Container(
                                height: 25.h,
                                decoration: ContDecoration.contDecoration,
                                child: TextField(
                                  style: AllTextStyle.dateFormatStyle,
                                  controller: _invoiceNoController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 14.h,left: 5.w),
                                      border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                                height: 25.h,
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                decoration: ContDecoration.contDecoration,
                                // child: TypeAheadFormField(
                                //   textFieldConfiguration:
                                //   TextFieldConfiguration(
                                //     onChanged: (value){
                                //       if (value == '') {
                                //         employeeSlNo = '';
                                //       }
                                //     },
                                //     style: AllTextStyle.dropDownlistStyle,
                                //     controller: empluyeeNameController,
                                //     decoration: InputDecoration(
                                //       border: InputBorder.none,
                                //       contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                                //       isDense: true,
                                //       hintText: 'Select Employee',
                                //       hintStyle: AllTextStyle.dropDownlistStyle,
                                //       suffixIcon: employeeSlNo == '' ? null : GestureDetector(
                                //         onTap: () {
                                //           setState(() {
                                //             empluyeeNameController.text = '';
                                //           });
                                //         },
                                //         child: Padding(
                                //         padding: EdgeInsets.only(left: 25.w),
                                //         child: Icon(Icons.close,size: 16.r,),
                                //       ),
                                //       ),
                                //     ),
                                //   ),
                                //   suggestionsCallback: (pattern) {
                                //     return allEmployee
                                //         .where((element) => element.employeeName
                                //         .toString()
                                //         .toLowerCase()
                                //         .contains(pattern
                                //         .toString()
                                //         .toLowerCase()))
                                //         .take(allEmployee.length)
                                //         .toList();
                                //   },
                                //   itemBuilder: (context, suggestion) {
                                //     return SizedBox(
                                //       child: Padding(
                                //         padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                //         child: Text(suggestion.employeeName,
                                //           style: AllTextStyle.dropDownlistStyle,
                                //           maxLines: 1,overflow: TextOverflow.ellipsis),
                                //       ),
                                //     );
                                //   },
                                //   transitionBuilder:(context, suggestionsBox, controller) {
                                //     return suggestionsBox;
                                //   },
                                //   onSuggestionSelected:(EmployeeModel suggestion) {
                                //     empluyeeNameController.text = suggestion.employeeName;
                                //     setState(() {
                                //       employeeSlNo = suggestion.employeeSlNo.toString();
                                //     });
                                //   },
                                //   onSaved: (value) {},
                                // ),
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
                     color: const Color(0xFFB8D4E8),
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
                                                // CustomerListProvider().on();
                                                // customerController.text = '';
                                                // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(level,"","");
                                              });
                                            }),
                                      ),
                                      const Text("Retail"),
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
                                              //   CustomerListProvider().on();
                                              //   customerController.text = '';
                                              //  Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(level,"","");
                                              });
                                            }),
                                      ),
                                      const Text("Wholesale"),
                                    ],
                                  ),
                                ],
                              ), // radio button
                              Row(
                                children: [
                                  SizedBox(width: 5.w),
                                  Text("Customer :",style: AllTextStyle.textFieldHeadStyle),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 3.w),
                                      decoration: ContDecoration.contDecoration,
                                      // child: TypeAheadFormField(
                                      //   textFieldConfiguration:
                                      //   TextFieldConfiguration(
                                      //       onChanged: (value){
                                      //         if (value == '') {
                                      //           _selectedCustomer = '';
                                      //         }
                                      //       },
                                      //       style: AllTextStyle.dropDownlistStyle,
                                      //       controller: customerController,
                                      //       decoration: InputDecoration(
                                      //         border: InputBorder.none,
                                      //         contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                                      //         hintText: 'Select Customer',
                                      //         isDense: true,
                                      //         hintStyle: AllTextStyle.dropDownlistStyle,
                                      //         suffixIcon: _selectedCustomer == '' ? null : GestureDetector(
                                      //           onTap: () {
                                      //             setState(() {
                                      //               customerController.text = '';
                                      //               _mobileNumberController.text = '';
                                      //               _addressController.text = '';
                                      //             });
                                      //           },
                                      //           child: Padding(
                                      //             padding: EdgeInsets.only(left: 25.w),
                                      //             child: Icon(Icons.close,size: 16.r),
                                      //           ),
                                      //         ),
                                      //       )
                                      //   ),
                                      //   suggestionsCallback: (pattern) {
                                      //     return allCustomer.where((element) => element.displayName!
                                      //         .toLowerCase().contains(pattern
                                      //         .toString().toLowerCase())).take(allCustomer.length).toList();
                                      //   },
                                      //   itemBuilder: (context, suggestion) {
                                      //     return SizedBox(
                                      //       width: double.infinity,
                                      //       child: Padding(
                                      //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                      //         child: Text(
                                      //           allCustomer[0].displayName=="Cash Customer" ?
                                      //           "${suggestion.displayName}":
                                      //           "${suggestion.customerCode ?? ''} - ${suggestion.customerName?? ''} - ${suggestion.customerAddress?? ''}",
                                      //           style: AllTextStyle.dropDownlistStyle,
                                      //           maxLines: 1,
                                      //           overflow: TextOverflow.ellipsis,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      //   transitionBuilder:(context, suggestionsBox, controller) {
                                      //     return suggestionsBox;
                                      //   },
                                      //   onSuggestionSelected: (CustomerListModel suggestion) {
                                      //     customerController.text = suggestion.customerName!;
                                      //     setState(() {
                                      //       _selectedCustomer = suggestion.customerSlNo.toString();
                                      //       customerSlNo = suggestion.customerSlNo.toString();
                                      //       customerType = suggestion.customerType.toString();
                                      //       previousDue = suggestion.previousDue.toString();
                                      //       print("customer selected ======> $_selectedCustomer");
                                      //       if (_selectedCustomer == 'null'|| _selectedCustomer =="") {
                                      //         isVisible = true;
                                      //         isEnabled = true;
                                      //         _nameController.text = '';
                                      //         _mobileNumberController.text = '';
                                      //         _addressController.text = '';
                                      //       } else {
                                      //         print("Yes has $_selectedCustomer");
                                      //         isEnabled = false;
                                      //         isVisible = false;
                                      //         customerMobile = suggestion.customerMobile;
                                      //         _mobileNumberController.text = suggestion.customerMobile.toString();
                                      //         customerAddress = suggestion.customerAddress;
                                      //         _addressController.text = suggestion.customerAddress.toString();  
                                      //       }
                                      //       print('isVisible $isVisible');
                                      //     });
                                      //   },
                                      //   onSaved: (value) {},
                                      // ),
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
                                          controller: _nameController,
                                          validator: (value) {
                                            if(value != null || value != ''){
                                              _nameController.text = value.toString();
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
                                        controller: _mobileNumberController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if(value != null || value != ''){
                                            _mobileNumberController.text = value.toString();
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: _selectedCustomer==""? EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w): EdgeInsets.symmetric(vertical: 11.5.h,horizontal: 5.w),
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
                                        controller: _addressController,
                                        validator: (value) {
                                          if(value != null || value != ''){
                                            _addressController.text = value.toString();
                                          }
                                          return null;
                                        },
                                        enabled: isEnabled,
                                        decoration: InputDecoration(
                                          contentPadding: _selectedCustomer==""? EdgeInsets.only(bottom: 5.h,left: 5.w): EdgeInsets.symmetric(vertical: 12.h,horizontal: 5.w),
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
                      color: const Color(0xFFB8D4E8),
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
                              Row(
                                children: [
                                  Expanded(flex: 4,child: Text("Product",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      decoration: ContDecoration.contDecoration,
                                      // child: TypeAheadFormField(
                                      //   textFieldConfiguration: TextFieldConfiguration(
                                      //       onChanged: (value){
                                      //         if (value == '') {
                                      //           _selectedProduct = '';
                                      //         }
                                      //       },
                                      //       style: AllTextStyle.dropDownlistStyle,
                                      //       controller: productController,
                                      //       decoration: InputDecoration(
                                      //         border: InputBorder.none,
                                      //         contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                                      //         isDense: true,
                                      //         hintText: 'Select Product',
                                      //         hintStyle: AllTextStyle.dropDownlistStyle,
                                      //         suffixIcon: _selectedProduct == '' ? null : GestureDetector(
                                      //           onTap: () {
                                      //             setState(() {
                                      //               productController.text = '';
                                      //             });
                                      //           },
                                      //           child: Padding(
                                      //             padding: EdgeInsets.only(left: 30.w),
                                      //             child: Icon(Icons.close,size: 16.r),
                                      //           ),
                                      //         ),
                                      //       )
                                      //   ),
                                      //   suggestionsCallback: (pattern) {
                                      //     return productList
                                      //         .where((element) => element.displayText
                                      //         .toString()
                                      //         .toLowerCase()
                                      //         .contains(pattern
                                      //         .toString()
                                      //         .toLowerCase()))
                                      //         .take(productList.length)
                                      //         .toList();
                                      //   },
                                      //   itemBuilder: (context, suggestion) {
                                      //     return SizedBox(
                                      //       width: double.infinity,
                                      //       child: Padding(
                                      //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                      //         child: Text("${suggestion.productName} - ${suggestion.productCategoryName} - ${suggestion.productCode}",
                                      //           style:  AllTextStyle.dropDownlistStyle,
                                      //           maxLines: 1,
                                      //           overflow: TextOverflow.ellipsis,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      //   transitionBuilder: (context, suggestionsBox, controller) {
                                      //     return suggestionsBox;
                                      //   },
                                      //   onSuggestionSelected: (ProductListModel suggestion) {
                                      //     productController.text = "${suggestion.productName} - ${suggestion.productCategoryName} - ${suggestion.productCode}";
                                      //     setState(() {
                                      //       _selectedProduct = suggestion.productSlNo;
                                      //       print("dfhsghdfkhgkh $_selectedProduct");
                                      //       cproductId = suggestion.productCode;
                                      //       productId = suggestion.productSlNo;
                                      //       isService = suggestion.isService;
                                      //       productStockId = suggestion.productSlNo;
                                      //       ccategoryName = suggestion.productCategoryName;
                                      //       cname = suggestion.productName;
                                      //       modelName = suggestion.brandName;
                                      //       productUnit = suggestion.unitName;
                                      //       cvat = suggestion.vat;
                                      //       cpurchaseRate = suggestion.productPurchaseRate;
                                      //       _vatController.text = suggestion.vat;
                                      //       _salesRateController.text = suggestion.productSellingPrice;
                                      //       setState(() {
                                      //         Total = (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                      //       });
                                      //       totalStack(productStockId);
                                      //     });
                                      //   },
                                      //   onSaved: (value) {},
                                      // )
                                    ),
                                  ),
                                ],
                              ), // product
                          
                              Row(
                                children: [
                                  Expanded(flex: 4,child: Text("Sales Rate",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _salesRateController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            Total = double.parse(_salesRateController.text);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 2,child: Center(child: Text("Qty",style: AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(left: 5.w, right: 0.w),
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _quantityController,
                                        onChanged: (value) {
                                          setState(() {
                                            Total = (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
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
                              ), // quantity
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Expanded(flex: 4,child: Text("Discount%",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _salesRateController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            Total = double.parse(_salesRateController.text);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 2,child: Center(child: Text("TK",style: AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(left: 5.w, right: 0.w),
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _quantityController,
                                        onChanged: (value) {
                                          setState(() {
                                            Total = (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
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
                              ), // quantity
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 4,child: Text("Amount",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 0.h, right: 5.w),
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h, bottom: 0.h),
                                      decoration: ContDecoration.contDecoration,
                                      child: Text("$Total",style: AllTextStyle.textValueStyle),
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
                                          availableStock != 0 ? Text("Stock,", style: TextStyle(color: Colors.green.shade700,fontSize: 12.sp)): Text("Stock,", style: TextStyle(color: Colors.red,fontSize: 12.sp)),
                                          Text("$availableStock ${productUnit ?? ""}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12.sp,color:availableStock != 0 ? Colors.green.shade700 : Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ), 
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 4,child: Text("Warranty",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 14,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _warrantyController,
                                        onChanged: (value) {
                                          
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
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
                              ),// product
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    if (productController.text != '' || productController.text.isNotEmpty) {
                                      if (_quantityController.text != '' || _quantityController.text.isNotEmpty){
                                        if (availableStock > 0) {
                                          setState(() {
                                            salesCartList.add(SalesCartModel(
                                              productId: "$productId",
                                              categoryId: "$categoryId",
                                              categoryName: "$ccategoryName",
                                              name: "$cname",
                                              salesRate: _salesRateController.text,
                                              vat: _vatController.text,
                                              quantity: _quantityController.text,
                                              total: "$Total",
                                              purchaseRate: "$cpurchaseRate",
                                              woodName: '$ccategoryName',
                                              modelName: '',
                                              productCode: '$cproductId',
                                              isService: '$isService'
                                             ));
                          
                                            cartTotal += Total;
                                            calculateTotal();
                                            categoryController.text = '';
                                            productController.text = '';
                                            _quantityController.text = '';
                                            _salesRateController.text = '';
                                            setState(() {
                                              Total = 0;
                                              calculateTotal();
                                              discountAmount=0;
                                              discountPer=0;
                                              vatAmount=0;
                                              vatPer=0;
                                              _discountController.text = "";
                                              _vatController.text = "";
                                              _discountPercentController.text="";
                                              _vatPercentageController.text="";
                                              _transportController.text="";
                                            });
                                            availableStock = 0;
                                          });
                                        } else {
                                          Utils.showTopSnackBar(context, "Stock Unavailable");
                                        }
                                      }
                                      else{
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
                                    child: const Center(child: Text("Add to cart",style: AllTextStyle.saveButtonTextStyle)))),
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
                                  DataCell(Center(child: Text("${index+1}"))),
                                  DataCell(Center(child: Text('${salesCartList[index].productCode}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].name}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].categoryName}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].quantity}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].salesRate}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].total}'))),
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
                  ///==new===
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 142, 207, 216),
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: const Color.fromARGB(255, 156, 150, 180),width: 1.w),
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
                                  color: Colors.cyan.shade900),
                              child: Center(
                                child: Text(
                                  'Replacement Product Information',
                                  style: AllTextStyle.saveButtonTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5.w,right: 3.w,top: 2.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(flex: 4,child: Text("Product",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      decoration: ContDecoration.contDecoration,
                                      // child: TypeAheadFormField(
                                      //   textFieldConfiguration: TextFieldConfiguration(
                                      //       onChanged: (value){
                                      //         if (value == '') {
                                      //           _selectedProduct = '';
                                      //         }
                                      //       },
                                      //       style: AllTextStyle.dropDownlistStyle,
                                      //       controller: productController,
                                      //       decoration: InputDecoration(
                                      //         border: InputBorder.none,
                                      //         contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                                      //         isDense: true,
                                      //         hintText: 'Select Product',
                                      //         hintStyle: AllTextStyle.dropDownlistStyle,
                                      //         suffixIcon: _selectedProduct == '' ? null : GestureDetector(
                                      //           onTap: () {
                                      //             setState(() {
                                      //               productController.text = '';
                                      //             });
                                      //           },
                                      //           child: Padding(
                                      //             padding: EdgeInsets.only(left: 30.w),
                                      //             child: Icon(Icons.close,size: 16.r),
                                      //           ),
                                      //         ),
                                      //       )
                                      //   ),
                                      //   suggestionsCallback: (pattern) {
                                      //     return productList
                                      //         .where((element) => element.displayText
                                      //         .toString()
                                      //         .toLowerCase()
                                      //         .contains(pattern
                                      //         .toString()
                                      //         .toLowerCase()))
                                      //         .take(productList.length)
                                      //         .toList();
                                      //   },
                                      //   itemBuilder: (context, suggestion) {
                                      //     return SizedBox(
                                      //       width: double.infinity,
                                      //       child: Padding(
                                      //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                      //         child: Text("${suggestion.productName} - ${suggestion.productCategoryName} - ${suggestion.productCode}",
                                      //           style:  AllTextStyle.dropDownlistStyle,
                                      //           maxLines: 1,
                                      //           overflow: TextOverflow.ellipsis,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      //   transitionBuilder: (context, suggestionsBox, controller) {
                                      //     return suggestionsBox;
                                      //   },
                                      //   onSuggestionSelected: (ProductListModel suggestion) {
                                      //     productController.text = "${suggestion.productName} - ${suggestion.productCategoryName} - ${suggestion.productCode}";
                                      //     setState(() {
                                      //       _selectedProduct = suggestion.productSlNo;
                                      //       print("dfhsghdfkhgkh $_selectedProduct");
                                      //       cproductId = suggestion.productCode;
                                      //       productId = suggestion.productSlNo;
                                      //       isService = suggestion.isService;
                                      //       productStockId = suggestion.productSlNo;
                                      //       ccategoryName = suggestion.productCategoryName;
                                      //       cname = suggestion.productName;
                                      //       modelName = suggestion.brandName;
                                      //       productUnit = suggestion.unitName;
                                      //       cvat = suggestion.vat;
                                      //       cpurchaseRate = suggestion.productPurchaseRate;
                                      //       _vatController.text = suggestion.vat;
                                      //       _salesRateController.text = suggestion.productSellingPrice;
                                      //       setState(() {
                                      //         Total = (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                      //       });
                                      //       totalStack(productStockId);
                                      //     });
                                      //   },
                                      //   onSaved: (value) {},
                                      // )
                                    ),
                                  ),
                                ],
                              ), // product
                          
                              Row(
                                children: [
                                  Expanded(flex: 4,child: Text("Price",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _salesRateController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            Total = double.parse(_salesRateController.text);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 2,child: Center(child: Text("Qty",style: AllTextStyle.textFieldHeadStyle))),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(left: 5.w, right: 0.w),
                                      child: TextField(
                                        style: AllTextStyle.textValueStyle,
                                        controller: _quantityController,
                                        onChanged: (value) {
                                          setState(() {
                                            Total = (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
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
                              ), // quantity
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 4,child: Text("Amount",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style: AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      height: 25.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                      decoration: ContDecoration.contDecoration,
                                      child: Text("$Total",style: AllTextStyle.textValueStyle),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: GestureDetector(
                                    onTap: () {
                                      if (productController.text != '' || productController.text.isNotEmpty) {
                                        if (_quantityController.text != '' || _quantityController.text.isNotEmpty){
                                          if (availableStock > 0) {
                                            setState(() {
                                              salesCartList.add(SalesCartModel(
                                                productId: "$productId",
                                                categoryId: "$categoryId",
                                                categoryName: "$ccategoryName",
                                                name: "$cname",
                                                salesRate: _salesRateController.text,
                                                vat: _vatController.text,
                                                quantity: _quantityController.text,
                                                total: "$Total",
                                                purchaseRate: "$cpurchaseRate",
                                                woodName: '$ccategoryName',
                                                modelName: '',
                                                productCode: '$cproductId',
                                                isService: '$isService'
                                              ));
                                                            
                                              cartTotal += Total;
                                              calculateTotal();
                                              categoryController.text = '';
                                              productController.text = '';
                                              _quantityController.text = '';
                                              _salesRateController.text = '';
                                              setState(() {
                                                Total = 0;
                                                calculateTotal();
                                                discountAmount=0;
                                                discountPer=0;
                                                vatAmount=0;
                                                vatPer=0;
                                                _discountController.text = "";
                                                _vatController.text = "";
                                                _discountPercentController.text="";
                                                _vatPercentageController.text="";
                                                _transportController.text="";
                                              });
                                              availableStock = 0;
                                            });
                                          } else {
                                            Utils.showTopSnackBar(context, "Stock Unavailable");
                                          }
                                        }
                                        else{
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
                                      decoration: BoxDecoration(
                                        color: Colors.cyan.shade900,
                                        borderRadius: BorderRadius.circular(5.r),
                                      ),
                                      child: const Center(child: Text("Add Replace",style: AllTextStyle.saveButtonTextStyle)))),
                                  ),
                                  ),
                                ],
                              ), // product
                              
                            ],
                          ),
                        ),
                        Container(
                          height: salesCartList.isEmpty ? 40.h:
                          salesCartList.length == 1 ? 70.h :
                          salesCartList.length == 2 ? 90.h :
                          salesCartList.length == 3 ? 110.h :
                          salesCartList.length == 4 ? 130.h :
                          MediaQuery.of(context).size.height /6,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 1.h,bottom: 2.h,left: 3.w,right: 3.w),
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
                                    DataColumn(label: Expanded(child: Center(child: Text('Product Code',style: AllTextStyle.tableHeadTextStyle)))),
                                    DataColumn(label: Expanded(child: Center(child: Text('Product Name',style: AllTextStyle.tableHeadTextStyle)))),
                                    DataColumn(label: Expanded(child: Center(child: Text('Category',style: AllTextStyle.tableHeadTextStyle)))),
                                    DataColumn(label: Expanded(child: Center(child: Text('Qty',style: AllTextStyle.tableHeadTextStyle)))),
                                    DataColumn(label: Expanded(child: Center(child: Text('Rate',style: AllTextStyle.tableHeadTextStyle)))),
                                    DataColumn(label: Expanded(child: Center(child: Text('Total',style: AllTextStyle.tableHeadTextStyle)))),
                                    DataColumn(label: Expanded(child: Center(child: Text('Action',style: AllTextStyle.tableHeadTextStyle)))),
                                  ],
                                  rows: List.generate(
                                    1,
                                    //salesCartList.length,
                                        (int index) => DataRow(
                                      color:index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor):WidgetStateProperty.resolveWith(getColors),
                                      cells: <DataCell>[
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        DataCell(Center(child: Text("${index+1}"))),
                                        // DataCell(Center(child: Text('${salesCartList[index].productCode}'))),
                                        // DataCell(Center(child: Text('${salesCartList[index].name}'))),
                                        // DataCell(Center(child: Text('${salesCartList[index].categoryName}'))),
                                        // DataCell(Center(child: Text('${salesCartList[index].quantity}'))),
                                        // DataCell(Center(child: Text('${salesCartList[index].salesRate}'))),
                                        // DataCell(Center(child: Text('${salesCartList[index].total}'))),
                                        // DataCell(Center(child: GestureDetector(
                                        //   onTap: () {
                                        //     removeFromCart(index);
                                        //     setState(() {
                                        //     });
                                        //   },
                                        //   child: Icon(Icons.delete,size: 16.r,color: Colors.red)
                                        // ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8D4E8),
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
                                    child: Text(double.parse("$subtotal").toStringAsFixed(2), style:AllTextStyle.textValueStyle),
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
                                        controller: _discountPercentController,
                                        onChanged: (value) {
                                          _transportController.text = '';
                                          _paidController.text = '';
                                          ///discount per
                                          setState(() {
                                            discountPer = double.parse(_discountPercentController.text);
                                            discountAmount = (subtotal * discountPer) / 100;
                                            _discountController.text = double.parse("$discountAmount").toStringAsFixed(2);
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
                                        controller: _discountController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          _transportController.text = '';
                                          _paidController.text = '';
                                          ///discount Amount
                                          setState(() {
                                            discountAmount = double.parse(_discountController.text);
                                            discountPer = (discountAmount * 100) / subtotal;
                                            _discountPercentController.text = double.parse("$discountPer").toStringAsFixed(2);
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
                                        controller: _vatPercentageController,
                                        onChanged: (value) {
                                          _transportController.text = '';
                                          _paidController.text = '';
                                          setState(() {
                                            ///vatPer
                                            double totalAmount = subtotal - discountAmount;
                                            vatPer = double.parse(_vatPercentageController.text);
                                            vatAmount = (totalAmount * vatPer) / 100;
                                            _vatController.text = double.parse("$vatAmount").toStringAsFixed(2);
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
                                        controller: _vatController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          _transportController.text = '';
                                          _paidController.text = '';
                                          ///vat amount
                                          setState(() {
                                            double totalAmount = subtotal - discountAmount;
                                            vatAmount = double.parse(_vatController.text);
                                            vatPer = (vatAmount * 100) / totalAmount;
                                            _vatPercentageController.text = double.parse("$vatPer").toStringAsFixed(2);
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
                                        controller: _transportController,
                                        onChanged: (value) {
                                          setState(() {
                                            transportCost = double.parse(_transportController.text);
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
                                  Expanded(flex: 5,child: Text("Bank Paid",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      child: TextField(
                                        style:AllTextStyle.textValueStyle,
                                        controller: _paidController,
                                        onChanged: (value) {
                                          setState(() {
                                            paidtotal = double.parse(_paidController.text);
                                            paid = paidtotal;
                                            due = total - paidtotal;
                                            calculateTotal();
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
                                            hintText: double.parse("$paidtotal").toStringAsFixed(2),
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
                                    flex: 14,
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
                                  ):Expanded(flex: 14, child: SizedBox()),
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
                                          color: Colors.cyan.shade700,
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        child: const Center(child: Text("New Sale",style:AllTextStyle.saveButtonTextStyle))
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
                                            : const Text("Sale", style:AllTextStyle.saveButtonTextStyle)),
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
    employeeSlNo="";
    _selectedRoute = '';
    _selectedCustomer='';
    _invoiceNoController.text="";
    empluyeeNameController.text="";
    routeController.text="";
    customerController.text="";
    _nameController.text = "";
    _paidController.text = "";
    _discountPercentController.text = "";
    _mobileNumberController.text = "";
    _addressController.text = "";
    _salesRateController.text = "";
    _discountController.text = "";
    _vatController.text = "";
    _vatPercentageController.text="";
    _quantityController.text = "";
    _transportController.text = "";
    _paidController.text="";
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
    String link = "${baseUrl}api/v1/addSales";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var studentsmap = salesCartList.map((e) {
        return {
        "productId": e.productId,
        "quantity":  e.quantity,
        "purchaseRate": e.purchaseRate,
        "salesRate": e.salesRate,
        "vat": "0",
        "total":  e.total,
        "is_service": e.isService
        };
      }).toList();
      print(studentsmap);
      Response response = await Dio().post(link,
        data: {
        "sales": {
        "invoiceNo": _invoiceNoController.text,
        "employeeId": "$employeeSlNo",
        "customerId": "$_selectedCustomer",
        "route_id": "$_selectedRoute",
        "salesDate": "$backEndFirstDate",
        "salesType": level,
        "total": total,
        "discount": "$discountAmount",
        "vat": "$vatAmount",
        "transportCost": "$transportCost",
        "subTotal": "$subtotal",
        "paid":  _paidController.text.toString().isNotEmpty ? _paidController.text : paidtotal,
        "due": "$due",
        "prevDue": "$previousDue" == 'null' || "$previousDue"=="" || "$previousDue"==0 ? '0' : "$previousDue",
        "note": ""
       },
          "customer": {
            "Customer_SlNo": _selectedCustomer,
            "Customer_Name": customerType == "N" || customerType == 'G' ? _nameController.text.trim() : customerController.text.trim(),
            "Customer_Mobile": _mobileNumberController.text.trim(),
            "Customer_Address": _addressController.text.trim(),
            "Customer_Type": "$customerType"
          },
          "cart": studentsmap
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );

      var item = jsonDecode(response.data);
      print("Product Cart============$studentsmap");
      print("Sales Entry Data============$item");
      if(item["success"] == true){
        setState(() {
          isSellBtnClk = false;
        });
        emptyData();
        // CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(salesId: "${item["salesId"]}")));
      }
      else{
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















// import 'package:auto_mall/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class ProductItem {
//   String code;
//   String name;
//   String category;
//   double qty;
//   double rate;
//   double discount;
//   double total;

//   ProductItem({
//     required this.code,
//     required this.name,
//     required this.category,
//     required this.qty,
//     required this.rate,
//     this.discount = 0,
//   }) : total = (qty * rate) - discount;
// }

// class SaleInvoiceScreen extends StatefulWidget {
//   const SaleInvoiceScreen({super.key});

//   @override
//   State<SaleInvoiceScreen> createState() => _SaleInvoiceScreenState();
// }

// class _SaleInvoiceScreenState extends State<SaleInvoiceScreen> {
//   // Header
//   final TextEditingController invoiceNoCtrl = TextEditingController(text: '260100022');
//   String? selectedEmployee;
//   String saleFrom = 'Main Branch';
//   DateTime selectedDate = DateTime(2026, 10, 12);

//   // Customer
//   String salesType = 'Retail';
//   final TextEditingController customerCtrl = TextEditingController(text: 'Cash Customer');
//   final TextEditingController nameCtrl = TextEditingController(text: 'Cash Customer');
//   final TextEditingController mobileCtrl = TextEditingController();
//   final TextEditingController addressCtrl = TextEditingController();

//   // Product Entry
//   String? selectedProduct;
//   final TextEditingController saleRateCtrl = TextEditingController(text: '0');
//   final TextEditingController qtyCtrl = TextEditingController(text: '0');
//   final TextEditingController discountPercentCtrl = TextEditingController(text: '0.00');
//   final TextEditingController amountCtrl = TextEditingController(text: '0');
//   final TextEditingController warrantyCtrl = TextEditingController();

//   // Amount Details
//   final TextEditingController subTotalCtrl = TextEditingController(text: '300.00');
//   final TextEditingController exchangeTotalCtrl = TextEditingController(text: '150.00');
//   final TextEditingController discountCtrl = TextEditingController(text: '0.00');
//   final TextEditingController discountPercent2Ctrl = TextEditingController(text: '0');
//   final TextEditingController vatCtrl = TextEditingController(text: '0');
//   final TextEditingController vatPercentCtrl = TextEditingController(text: '0.00');
//   final TextEditingController transportCtrl = TextEditingController(text: '0');
//   final TextEditingController totalCtrl = TextEditingController(text: '150.00');
//   final TextEditingController cashPaidCtrl = TextEditingController(text: '150.00');
//   final TextEditingController bankPaidCtrl = TextEditingController(text: '0');
//   final TextEditingController dueCtrl = TextEditingController(text: '0');
//   bool isCredit = false;

//   // Note
//   final TextEditingController noteCtrl = TextEditingController();

//   // Replacement
//   String? selectedReplacementProduct;
//   final TextEditingController repPriceCtrl = TextEditingController(text: '0');
//   final TextEditingController repQtyCtrl = TextEditingController(text: '0');
//   final TextEditingController repAmountCtrl = TextEditingController(text: '0');

//   List<ProductItem> cartItems = [
//     ProductItem(code: 'P00003', name: 'Coolant', category: 'liquite', qty: 2, rate: 150.00),
//   ];

//   List<ProductItem> replacementItems = [
//     ProductItem(code: 'P00003', name: 'Coolant', category: 'liquite', qty: 1, rate: 150.00),
//   ];

//   final List<String> employees = ['Select Employee', 'Employee 1', 'Employee 2', 'Employee 3'];
//   final List<String> branches = ['Main Branch', 'Branch 2', 'Branch 3'];
//   final List<String> products = ['Select Product', 'Coolant', 'Oil', 'Filter', 'Battery'];

//   void _calculateTotals() {
//     double subTotal = cartItems.fold(0, (sum, item) => sum + item.total);
//     double exchange = replacementItems.fold(0, (sum, item) => sum + item.total);
//     double discount = double.tryParse(discountCtrl.text) ?? 0;
//     double vat = double.tryParse(vatCtrl.text) ?? 0;
//     double transport = double.tryParse(transportCtrl.text) ?? 0;

//     double total = subTotal - exchange - discount + vat + transport;

//     setState(() {
//       subTotalCtrl.text = subTotal.toStringAsFixed(2);
//       exchangeTotalCtrl.text = exchange.toStringAsFixed(2);
//       totalCtrl.text = total.toStringAsFixed(2);

//       double cash = double.tryParse(cashPaidCtrl.text) ?? 0;
//       double bank = double.tryParse(bankPaidCtrl.text) ?? 0;
//       dueCtrl.text = (total - cash - bank).toStringAsFixed(2);
//     });
//   }

//   void _addToCart() {
//     if (selectedProduct == null || selectedProduct == 'Select Product') return;
//     double rate = double.tryParse(saleRateCtrl.text) ?? 0;
//     double qty = double.tryParse(qtyCtrl.text) ?? 0;
//     double disc = double.tryParse(discountPercentCtrl.text) ?? 0;
//     if (qty <= 0) return;

//     setState(() {
//       cartItems.add(ProductItem(
//         code: 'P${(cartItems.length + 1).toString().padLeft(5, '0')}',
//         name: selectedProduct!,
//         category: 'General',
//         qty: qty,
//         rate: rate,
//         discount: disc,
//       ));
//       _calculateTotals();
//       selectedProduct = 'Select Product';
//       saleRateCtrl.text = '0';
//       qtyCtrl.text = '0';
//       discountPercentCtrl.text = '0.00';
//       amountCtrl.text = '0';
//     });
//   }

//   void _addReplacement() {
//     if (selectedReplacementProduct == null || selectedReplacementProduct == 'Select Product') return;
//     double price = double.tryParse(repPriceCtrl.text) ?? 0;
//     double qty = double.tryParse(repQtyCtrl.text) ?? 0;
//     if (qty <= 0) return;

//     setState(() {
//       replacementItems.add(ProductItem(
//         code: 'P${(replacementItems.length + 1).toString().padLeft(5, '0')}',
//         name: selectedReplacementProduct!,
//         category: 'General',
//         qty: qty,
//         rate: price,
//       ));
//       _calculateTotals();
//       selectedReplacementProduct = null;
//       repPriceCtrl.text = '0';
//       repQtyCtrl.text = '0';
//       repAmountCtrl.text = '0';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE8F0F8),
//       appBar: AppBar(
//         title: const Text('Sale Invoice', style: TextStyle(fontSize: 18)),
//         backgroundColor: AppColors.appColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // ========== HEADER (Mobile Friendly) ==========
//               _buildHeaderCard(),
//               const SizedBox(height: 10),

//               // ========== Customer Information ==========
//               _buildSection(
//                 title: 'Customer Information',
//                 child: Column(
//                   children: [
//                     // Sales Type
//                     Row(
//                       children: [
//                         const Text('Sales Type', style: TextStyle(fontSize: 13)),
//                         const SizedBox(width: 8),
//                         Radio<String>(
//                           value: 'Retail',
//                           groupValue: salesType,
//                           onChanged: (v) => setState(() => salesType = v!),
//                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                           visualDensity: VisualDensity.compact,
//                         ),
//                         const Text('Retail', style: TextStyle(fontSize: 13)),
//                         Radio<String>(
//                           value: 'Wholesale',
//                           groupValue: salesType,
//                           onChanged: (v) => setState(() => salesType = v!),
//                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                           visualDensity: VisualDensity.compact,
//                         ),
//                         const Text('Wholesale', style: TextStyle(fontSize: 13)),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     _buildMobileField('Customer', customerCtrl, hasAdd: true),
//                     _buildMobileField('Name', nameCtrl),
//                     _buildMobileField('Mobile No', mobileCtrl, hint: 'Mobile No'),
//                     _buildMobileField('Address', addressCtrl, hint: 'Address'),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // ========== Product Information ==========
//               _buildSection(
//                 title: 'Product Information',
//                 child: Column(
//                   children: [
//                     _buildMobileDropdown('Product', selectedProduct ?? 'Select Product', products, (v) {
//                       setState(() => selectedProduct = v);
//                     }, hasAdd: true),
//                     Row(
//                       children: [
//                         Expanded(child: _buildMobileField('Sale Rate', saleRateCtrl, isNumber: true)),
//                         const SizedBox(width: 8),
//                         Expanded(child: _buildMobileField('Qty', qtyCtrl, isNumber: true)),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(child: _buildMobileField('Discount %', discountPercentCtrl, isNumber: true)),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Container(
//                             height: 40,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade400),
//                               borderRadius: BorderRadius.circular(4),
//                               color: Colors.grey.shade100,
//                             ),
//                             child: const Text('TK', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//                           ),
//                         ),
//                       ],
//                     ),
//                     _buildMobileField('Amount', amountCtrl, isNumber: true),
//                     _buildMobileField('Warranty day', warrantyCtrl, hint: 'Warranty'),
//                     const SizedBox(height: 8),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _addToCart,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFC45C26),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: const Text('Add to Cart', style: TextStyle(fontSize: 15)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // ========== Cart Table (Horizontal Scroll) ==========
//               _buildSection(
//                 title: 'Cart Items',
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: _buildCartTable(),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // ========== Note ==========
//               _buildSection(
//                 title: 'Note',
//                 child: TextField(
//                   controller: noteCtrl,
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     hintText: 'Write note here...',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // ========== Replacement Product ==========
//               _buildSection(
//                 title: 'Replacement Product Information',
//                 child: Column(
//                   children: [
//                     _buildMobileDropdown('Product', selectedReplacementProduct ?? 'Select Product', products, (v) {
//                       setState(() => selectedReplacementProduct = v);
//                     }),
//                     Row(
//                       children: [
//                         Expanded(child: _buildMobileField('Price', repPriceCtrl, isNumber: true)),
//                         const SizedBox(width: 8),
//                         Expanded(child: _buildMobileField('Qty', repQtyCtrl, isNumber: true)),
//                       ],
//                     ),
//                     _buildMobileField('Amount', repAmountCtrl, isNumber: true),
//                     const SizedBox(height: 8),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _addReplacement,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF5B9BD5),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: const Text('Add Replacement', style: TextStyle(fontSize: 15)),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: _buildReplacementTable(),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // ========== Amount Details ==========
//               _buildSection(
//                 title: 'Amount Details',
//                 child: Column(
//                   children: [
//                     _buildAmountRow('Sub Total', subTotalCtrl, readOnly: true),
//                     _buildAmountRow('Exchange Total', exchangeTotalCtrl, readOnly: true),
//                     Row(
//                       children: [
//                         const SizedBox(width: 100, child: Text('Discount', style: TextStyle(fontSize: 13))),
//                         Expanded(
//                           child: TextField(
//                             controller: discountCtrl,
//                             style: const TextStyle(fontSize: 13),
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               isDense: true,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             onChanged: (_) => _calculateTotals(),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 4),
//                           child: Text('%'),
//                         ),
//                         SizedBox(
//                           width: 55,
//                           child: TextField(
//                             controller: discountPercent2Ctrl,
//                             style: const TextStyle(fontSize: 13),
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               isDense: true,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         const SizedBox(width: 100, child: Text('Vat', style: TextStyle(fontSize: 13))),
//                         Expanded(
//                           child: TextField(
//                             controller: vatCtrl,
//                             style: const TextStyle(fontSize: 13),
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               isDense: true,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             onChanged: (_) => _calculateTotals(),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 4),
//                           child: Text('%'),
//                         ),
//                         SizedBox(
//                           width: 55,
//                           child: TextField(
//                             controller: vatPercentCtrl,
//                             style: const TextStyle(fontSize: 13),
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               isDense: true,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     _buildAmountRow('Transport Cost', transportCtrl, onChanged: (_) => _calculateTotals()),
//                     const Divider(height: 16),
//                     _buildAmountRow('Total', totalCtrl, readOnly: true, bold: true),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(child: _buildAmountRow('Cash Paid', cashPaidCtrl, onChanged: (_) => _calculateTotals())),
//                         const SizedBox(width: 8),
//                         Expanded(child: _buildAmountRow('Bank Paid', bankPaidCtrl, onChanged: (_) => _calculateTotals())),
//                       ],
//                     ),
//                     _buildAmountRow('Due', dueCtrl, readOnly: true, valueColor: Colors.red),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: isCredit,
//                           onChanged: (v) => setState(() => isCredit = v!),
//                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         const Text('Is Credit', style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     // Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Sale Completed Successfully!')),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF28A745),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                             ),
//                             child: const Text('Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 cartItems.clear();
//                                 replacementItems.clear();
//                                 noteCtrl.clear();
//                                 cashPaidCtrl.text = '0';
//                                 bankPaidCtrl.text = '0';
//                                 _calculateTotals();
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF5B2C6F),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                             ),
//                             child: const Text('New Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==================== HELPER WIDGETS ====================

//   Widget _buildHeaderCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF5B9BD5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           // Invoice No + Date
//           Row(
//             children: [
//               const Text('Invoice no', style: TextStyle(color: Colors.white, fontSize: 13)),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextField(
//                   controller: invoiceNoCtrl,
//                   style: const TextStyle(fontSize: 13),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               InkWell(
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate,
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2030),
//                   );
//                   if (date != null) setState(() => selectedDate = date);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                       const SizedBox(width: 4),
//                       const Icon(Icons.calendar_today, size: 16),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Sale By
//           Row(
//             children: [
//               const SizedBox(
//                 width: 70,
//                 child: Text('Sale By', style: TextStyle(color: Colors.white, fontSize: 13)),
//               ),
//               Expanded(
//                 child: Container(
//                   height: 40,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedEmployee ?? 'Select Employee',
//                       isExpanded: true,
//                       style: const TextStyle(fontSize: 13, color: Colors.black),
//                       items: employees.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//                       onChanged: (v) => setState(() => selectedEmployee = v),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Sale From
//           Row(
//             children: [
//               const SizedBox(
//                 width: 70,
//                 child: Text('Sale From', style: TextStyle(color: Colors.white, fontSize: 13)),
//               ),
//               Expanded(
//                 child: Container(
//                   height: 40,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: saleFrom,
//                       isExpanded: true,
//                       style: const TextStyle(fontSize: 13, color: Colors.black),
//                       items: branches.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//                       onChanged: (v) => setState(() => saleFrom = v!),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSection({required String title, required Widget child}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFB8D4E8),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFF5B9BD5)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: AppColors.appColor,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(7),
//                 topRight: Radius.circular(7),
//               ),
//             ),
//             child: Text(
//               title,
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: child,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileField(String label, TextEditingController controller, {String? hint, bool hasAdd = false, bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 90,
//             child: Text(label, style: const TextStyle(fontSize: 13)),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(fontSize: 13),
//               keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 border: const OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           if (hasAdd)
//             Container(
//               height: 40,
//               width: 36,
//               margin: const EdgeInsets.only(left: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFC45C26),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Icon(Icons.add, color: Colors.white, size: 20),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool hasAdd = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 90,
//             child: Text(label, style: const TextStyle(fontSize: 13)),
//           ),
//           Expanded(
//             child: Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: value,
//                   isExpanded: true,
//                   style: const TextStyle(fontSize: 13, color: Colors.black),
//                   items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//                   onChanged: onChanged,
//                 ),
//               ),
//             ),
//           ),
//           if (hasAdd)
//             Container(
//               height: 40,
//               width: 36,
//               margin: const EdgeInsets.only(left: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFC45C26),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Icon(Icons.add, color: Colors.white, size: 20),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAmountRow(String label, TextEditingController controller, {bool readOnly = false, bool bold = false, Color? valueColor, Function(String)? onChanged}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
//             ),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               readOnly: readOnly,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//                 color: valueColor,
//               ),
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 border: const OutlineInputBorder(),
//                 filled: true,
//                 fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
//               ),
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCartTable() {
//     return DataTable(
//       headingRowColor: MaterialStateProperty.all(const Color(0xFF2F5496)),
//       headingTextStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
//       dataTextStyle: const TextStyle(fontSize: 12),
//       columnSpacing: 16,
//       horizontalMargin: 8,
//       columns: const [
//         DataColumn(label: Text('SI')),
//         DataColumn(label: Text('Code')),
//         DataColumn(label: Text('Product Name')),
//         DataColumn(label: Text('Category')),
//         DataColumn(label: Text('Qty')),
//         DataColumn(label: Text('Rate')),
//         DataColumn(label: Text('Disc')),
//         DataColumn(label: Text('Total')),
//         DataColumn(label: Text('Action')),
//       ],
//       rows: cartItems.asMap().entries.map((e) {
//         final i = e.key;
//         final item = e.value;
//         return DataRow(
//           color: MaterialStateProperty.all(i % 2 == 0 ? Colors.white : const Color(0xFFE8F0F8)),
//           cells: [
//             DataCell(Text('${i + 1}')),
//             DataCell(Text(item.code)),
//             DataCell(Text(item.name)),
//             DataCell(Text(item.category)),
//             DataCell(
//               SizedBox(
//                 width: 50,
//                 child: TextField(
//                   controller: TextEditingController(text: item.qty.toStringAsFixed(0)),
//                   style: const TextStyle(fontSize: 12),
//                   textAlign: TextAlign.center,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (v) {
//                     item.qty = double.tryParse(v) ?? 0;
//                     item.total = (item.qty * item.rate) - item.discount;
//                     _calculateTotals();
//                   },
//                 ),
//               ),
//             ),
//             DataCell(
//               SizedBox(
//                 width: 60,
//                 child: TextField(
//                   controller: TextEditingController(text: item.rate.toStringAsFixed(2)),
//                   style: const TextStyle(fontSize: 12),
//                   textAlign: TextAlign.center,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (v) {
//                     item.rate = double.tryParse(v) ?? 0;
//                     item.total = (item.qty * item.rate) - item.discount;
//                     _calculateTotals();
//                   },
//                 ),
//               ),
//             ),
//             DataCell(Text(item.discount.toStringAsFixed(0))),
//             DataCell(Text(item.total.toStringAsFixed(2))),
//             DataCell(
//               IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red, size: 20),
//                 onPressed: () {
//                   setState(() {
//                     cartItems.removeAt(i);
//                     _calculateTotals();
//                   });
//                 },
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildReplacementTable() {
//     return DataTable(
//       headingRowColor: MaterialStateProperty.all(const Color(0xFF2F5496)),
//       headingTextStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
//       dataTextStyle: const TextStyle(fontSize: 12),
//       columnSpacing: 16,
//       horizontalMargin: 8,
//       columns: const [
//         DataColumn(label: Text('SI')),
//         DataColumn(label: Text('Code')),
//         DataColumn(label: Text('Product Name')),
//         DataColumn(label: Text('Category')),
//         DataColumn(label: Text('Qty')),
//         DataColumn(label: Text('Rate')),
//         DataColumn(label: Text('Total')),
//         DataColumn(label: Text('Action')),
//       ],
//       rows: replacementItems.asMap().entries.map((e) {
//         final i = e.key;
//         final item = e.value;
//         return DataRow(
//           color: MaterialStateProperty.all(i % 2 == 0 ? Colors.white : const Color(0xFFE8F0F8)),
//           cells: [
//             DataCell(Text('${i + 1}')),
//             DataCell(Text(item.code)),
//             DataCell(Text(item.name)),
//             DataCell(Text(item.category)),
//             DataCell(Text(item.qty.toStringAsFixed(0))),
//             DataCell(Text(item.rate.toStringAsFixed(2))),
//             DataCell(Text(item.total.toStringAsFixed(2))),
//             DataCell(
//               IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red, size: 20),
//                 onPressed: () {
//                   setState(() {
//                     replacementItems.removeAt(i);
//                     _calculateTotals();
//                   });
//                 },
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }
// }