//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/type_ahead_searching_field.dart';
import 'package:auto_mall/models/areas_model.dart';
import 'package:auto_mall/models/categories_model.dart';
import 'package:auto_mall/models/customers_model.dart';
import 'package:auto_mall/models/employees_model.dart';
import 'package:auto_mall/models/products_model.dart';
import 'package:auto_mall/models/users_model.dart';
import 'package:auto_mall/providers/areas_provider.dart';
import 'package:auto_mall/providers/categories_provider.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/providers/employees_provider.dart';
import 'package:auto_mall/providers/products_provider.dart';
import 'package:auto_mall/providers/sale_details_provider.dart';
import 'package:auto_mall/providers/sale_records_provider.dart';
import 'package:auto_mall/providers/sales_provider.dart';
import 'package:auto_mall/providers/users_provider.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/widgets/sales_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/custom_appbar.dart';
import '../../utils/all_textstyle.dart';
import '../../utils/utils.dart';

class SalesRecordScreen extends StatefulWidget {
  const SalesRecordScreen({super.key});

  @override
  State<SalesRecordScreen> createState() => _SalesRecordScreenState();
}

class _SalesRecordScreenState extends State<SalesRecordScreen> {
  Color getPurple(Set<WidgetState> states) {return Colors.purple.shade50;}
  Color getBlue(Set<WidgetState> states) {return Colors.teal.shade50;}
  Color getWhite(Set<WidgetState> states) {return Colors.white;}

  final customerController = TextEditingController();
  final areaController = TextEditingController();
  final employeeController = TextEditingController();
  final categoryController = TextEditingController();
  final productController = TextEditingController();
  final userController = TextEditingController();
  SharedPreferences? sharedPreferences;
  String userName = "";
  String userID = "";
  String userEmployeeId = "";
  String userType = "";
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userID = "${sharedPreferences?.getString('userId')}";
    userType = "${sharedPreferences?.getString('userType')}";
  }

  String? firstPickedDate;
  var backEndFirstDate;
  var backEndSecondtDate;

  var toDay = DateTime.now();
  void _firstSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $firstPickedDate");
      });
    }
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $firstPickedDate");
      });
    }
  }

  String? secondPickedDate;
  void _secondSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndSecondtDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $secondPickedDate");
      });
    }else{
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondtDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $secondPickedDate");
      });
    }
  }

  String? customerId;
  String? areaId;
  String? employeeId;
  String? categoryId;
  String? productId;
  String? userId;

   //main dropdowns logic
  bool isAllTypeClicked = true;
  bool isCustomerWiseClicked = false;
  bool isAreaWiseClicked = false;
  bool isEmployeeWiseClicked = false;
  bool isCategoryWiseClicked = false;
  bool isProductWiseClicked = false;
  bool isUserWiseClicked = false;
  bool _isDropdownOpen = false;
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Customer',
    'By Area',
    'By Employee',
    'By Category',
    'By Quantity',
    'By User',
  ];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final GlobalKey _key = GlobalKey();
  Size _dropdownSize = Size.zero;

  void _getDropdownSize(Duration _) {
    final RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    _dropdownSize = renderBox.size;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: _dropdownSize.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, _dropdownSize.height + 0),
                child: Material(
                  elevation: 9.0,
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(5.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _searchTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final type = entry.value;
                      return InkWell(
                        onTap: () {
                          _onSelectedType(type);
                          _removeDropdown();
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Text(type, style: AllTextStyle.dropDownlistStyle),
                            ),
                            if (index != _searchTypes.length - 1)
                              Divider(height: 1.h, thickness: 0.8, color: Colors.blue.shade400),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectedType(String selectedValue) {
    setState(() {
      _selectedSearchTypes = selectedValue;
      isAllTypeClicked = selectedValue == "All";
      isCustomerWiseClicked = selectedValue == "By Customer";
      isAreaWiseClicked = selectedValue == "By Area";
      isEmployeeWiseClicked = selectedValue == "By Employee";
      isCategoryWiseClicked = selectedValue == "By Category";
      isProductWiseClicked = selectedValue == "By Quantity";
      isUserWiseClicked = selectedValue == "By User";
       emtyMethod();
    });
  }

  emtyMethod() {
    setState(() {
      customerController.text = "";
      areaController.text = "";
      employeeController.text = "";
      categoryController.text = "";
      productController.text = "";
      userController.text = "";
      customerId = "";
      areaId = "";
      employeeId = "";
      categoryId = "";
      productId = "";
      userId = "";
    });
  }

  //=====reordType new code
bool isWithoutDetailsClicked = true;
bool isWithDetailsClicked = false;
String? _selectedRecordTypes = "Without Details";
final List<String> _recordType = ['Without Details', 'With Details'];

bool _isRecordDropdownOpen = false;
final LayerLink _recordLayerLink = LayerLink();
OverlayEntry? _recordOverlayEntry;

final GlobalKey _recordKey = GlobalKey();
Size _recordDropdownSize = Size.zero;

void _getRecordDropdownSize(Duration _) {
  final RenderBox renderBox = _recordKey.currentContext?.findRenderObject() as RenderBox;
  _recordDropdownSize = renderBox.size;
}

void _toggleRecordDropdown() {
  if (_isRecordDropdownOpen) {
    _removeRecordDropdown();
  } else {
    _showRecordDropdown();
  }
}

void _showRecordDropdown() {
  _recordOverlayEntry = _createRecordOverlayEntry();
  Overlay.of(context).insert(_recordOverlayEntry!);
  setState(() {
    _isRecordDropdownOpen = true;
  });
}

void _removeRecordDropdown() {
  _recordOverlayEntry?.remove();
  _recordOverlayEntry = null;
  setState(() {
    _isRecordDropdownOpen = false;
  });
}

OverlayEntry _createRecordOverlayEntry() {
  return OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: _removeRecordDropdown,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Positioned(
            width: _recordDropdownSize.width,
            child: CompositedTransformFollower(
              link: _recordLayerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, _recordDropdownSize.height + 0),
              child: Material(
                elevation: 9.0,
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(5.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _recordType.asMap().entries.map((entry) {
                    final index = entry.key;
                    final type = entry.value;
                    return InkWell(
                      onTap: () {
                        _onSelectedRecordType(type);
                        _removeRecordDropdown();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            child: Text(type, style: AllTextStyle.dropDownlistStyle),
                          ),
                          if (index != _recordType.length - 1)
                            Divider(height: 1.h, thickness: 0.8, color: Colors.blue.shade400),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _onSelectedRecordType(String selectedValue) {
     setState(() {
      _selectedRecordTypes = selectedValue;
      if (isWithoutDetailsClicked = selectedValue == "Without Details") {
      }
      if (isWithDetailsClicked = selectedValue == "With Details") {
      }
    });
}
  
  String data = '';
  ///Sub total
  double? subTotal;
  double? vatTotal;
  double? discountTotal;
  double? transferCost;
  double? totalAmount;
  double? paidTotal;
  double? dueTotal;
  double? soldQuantity;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getDropdownSize);
    WidgetsBinding.instance.addPostFrameCallback(_getRecordDropdownSize);
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<EmployeesProvider>(context,listen: false).getEmployees();
    Provider.of<CustomersProvider>(context, listen: false).getCustomers("");
    Provider.of<CategoriesProvider>(context, listen: false).getCategories();
    Provider.of<ProductsProvider>(context,listen: false).getProducts();
    Provider.of<AreasProvider>(context, listen: false).getAreas();
    Provider.of<UsersProvider>(context,listen: false).getUsers();
    Provider.of<SalesProvider>(context,listen: false).getSales("", "", "", "", "", "", "a");
    Provider.of<SaleRecordsProvider>(context,listen: false).getSaleRecords("", "", "", "", "", "", "a");
    Provider.of<SaleDetailsProvider>(context,listen: false).getSaleDetails("", "", "",  "","a");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customersData = Provider.of<CustomersProvider>(context).customersList.where((customer) =>customer.customerName != "Cash Customer" && customer.customerName != "New Customer")
    .toList();
    final areasData = Provider.of<AreasProvider>(context).areasList;
    final employeesData = Provider.of<EmployeesProvider>(context).employeesList;
    final categoriesData = Provider.of<CategoriesProvider>(context).categoriesList;
    final productsData = Provider.of<ProductsProvider>(context).productsList;
    final usersData = Provider.of<UsersProvider>(context).usersList;
    //get Sales
    final salesData = Provider.of<SalesProvider>(context).salesList;
    print("Sales length=====> ${salesData.length} ");
    ///Sub total
    subTotal = salesData.map((e) => e.saleMasterSubTotalAmount).fold(0.0, (p, element) => p!+double.parse(element));
    vatTotal = salesData.map((e) => e.saleMasterTaxAmount).fold(0.0, (p, element) => p!+double.parse(element));
    discountTotal = salesData.map((e) => e.saleMasterTotalDiscountAmount).fold(0.0, (p, element) => p!+double.parse(element));
    transferCost = salesData.map((e) => e.saleMasterFreight).fold(0.0, (p, element) => p!+double.parse(element));
    totalAmount = salesData.map((e) => e.saleMasterTotalSaleAmount).fold(0.0, (p, element) => p!+double.parse(element));
    paidTotal = salesData.map((e) => e.saleMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));
    dueTotal = salesData.map((e) => e.saleMasterDueAmount).fold(0.0, (p, element) => p!+double.parse(element));
    //get Sales Record
    final saleRecordsData = Provider.of<SaleRecordsProvider>(context).saleRecordsList;
    print("Sale records length=====> ${saleRecordsData.length} ");
    //get Sale_details
    final saleDetailsData = Provider.of<SaleDetailsProvider>(context).saleDetailsList;
    print("Sale_Details length=====> ${saleDetailsData.length} ");
    ///soldQuantity total
    soldQuantity = saleDetailsData.map((e) => e.saleDetailsTotalQuantity).fold(0.0, (p, element) => p!+double.parse(element));

    return Scaffold(
      appBar: CustomAppBar(title:"Sales Record"),
      body: Container(
        padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h,bottom: 20.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.appColor, width: 1.w),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 4, child: Text("Search Type", style: AllTextStyle.searchTypeTxtStyle)),
                      Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                      Expanded(
                        flex: 10,
                        child: CompositedTransformTarget(
                          link: _layerLink,
                          child: GestureDetector(
                            onTap: _toggleDropdown,
                            child: Container(
                              key: _key,
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              height: 25.h,
                              decoration: ContDecoration.contDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedSearchTypes ?? 'Please select a type',
                                    style: AllTextStyle.dropDownlistStyle,
                                  ),
                                  GestureDetector(
                                    onTap: _toggleDropdown,
                                    child: Icon(
                                      color: Colors.grey.shade700,
                                      _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isCustomerWiseClicked == true
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 4, child: Text("Customer", style: AllTextStyle.searchTypeTxtStyle)),
                      Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                      Expanded(
                        flex: 10,
                        child: Container(
                          height: 25.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: CommonTypeAheadField<CustomersModel>(
                            controller: customerController,
                            suggestionList: customersData,
                            hintText: 'Select Customer',
                            selectedValueId: customerId,
                            onValueIdChanged: (id) {
                              setState(() {
                                customerId = id;
                              });
                            },
                            displayText: (c) => c.displayName??"",
                            valueId: (c) => c.customerSlNo.toString(),
                          ),
                        ),
                      )
                    ],
                  ): Container(),
                  isAreaWiseClicked == true
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 4, child: Text("Area", style: AllTextStyle.searchTypeTxtStyle)),
                      Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                      Expanded(
                        flex: 10,
                        child: Container(
                          height: 25.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: CommonTypeAheadField<AreasModel>(
                            controller: areaController,
                            suggestionList: areasData,
                            hintText: 'Select Area',
                            selectedValueId: areaId,
                            onValueIdChanged: (id) {
                              setState(() {
                                areaId = id;
                              });
                            },
                            displayText: (a) => a.districtName??"",
                            valueId: (a) => a.districtSlNo.toString(),
                          )
                        ),
                      )
                    ],
                  ): Container(),
                  isEmployeeWiseClicked == true
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 4, child: Text("Employee", style: AllTextStyle.searchTypeTxtStyle)),
                          Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                          Expanded(
                            flex: 10,
                            child: Container(
                              height: 25.h,
                              margin: EdgeInsets.only(top: 4.h),
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
                          )
                        ],
                      ): Container(),
                  isCategoryWiseClicked == true
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: Text("Category", style: AllTextStyle.searchTypeTxtStyle)),
                        Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                        Expanded(
                          flex: 10,
                          child: Container(
                            height: 25.h,
                            margin: EdgeInsets.only(top: 4.h,bottom: 4.h),
                            child: CommonTypeAheadField<CategoriesModel>(
                                controller: categoryController,
                                suggestionList: categoriesData,
                                hintText: 'Select Category',
                                selectedValueId: categoryId,
                                onValueIdChanged: (id) {
                                  setState(() {
                                    categoryId = id;
                                  });
                                },
                                displayText: (cate) => cate.productCategoryName??"",
                                valueId: (cate) => cate.productCategorySlNo.toString(),
                              )
                          ),
                        )
                      ],
                    ): Container(),
                  isProductWiseClicked == true
                      ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                      Expanded(flex: 4, child: Text("Product", style: AllTextStyle.searchTypeTxtStyle)),
                      Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                      Expanded(
                        flex: 10,
                        child: Container(
                            height: 25.h,
                            margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
                            child: CommonTypeAheadField<ProductsModel>(
                              controller: productController,
                              suggestionList: productsData,
                              hintText: 'Select Product',
                              selectedValueId: productId,
                              onValueIdChanged: (id) {
                                setState(() {
                                  productId = id;
                                });
                              },
                              displayText: (p) => p.productName??"",
                              valueId: (p) => p.productSlNo.toString(),
                            )
                           ),
                          )
                         ],
                       )
                      : Container(),
                  isUserWiseClicked == true
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 4, child: Text("User", style: AllTextStyle.searchTypeTxtStyle)),
                          Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                          userName=="Admin" ? Expanded(
                            flex: 10,
                            child: Container(
                              height: 25.h,
                              margin: EdgeInsets.only(top: 4.h),
                              child: CommonTypeAheadField<UsersModel>(
                              controller: userController,
                              suggestionList: usersData,
                              hintText: 'Select User',
                              selectedValueId: userId,
                              onValueIdChanged: (id) {
                                setState(() {
                                  userId = id;
                                });
                              },
                              displayText: (u) => u.userName??"",
                              valueId: (u) => u.userSlNo.toString(),
                            )
                            ),
                          ):Expanded(
                            flex: 10,
                            child: Container(
                              height: 25.h,
                              padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 5.w),
                              margin: EdgeInsets.only(top: 4.h),
                              decoration: ContDecoration.contDecoration,
                              child: Text(userName,style: AllTextStyle.searchTypeTxtStyle),
                            ))
                        ],
                      ): Container(),
                  isCategoryWiseClicked == true || isProductWiseClicked == true ? Container() : Row(
                    children: [
                      Expanded(flex: 4, child: Text("Record Type", style: AllTextStyle.searchTypeTxtStyle)),
                      Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                      Expanded(
                      flex: 10,
                      child: CompositedTransformTarget(
                      link: _recordLayerLink,
                      child: GestureDetector(
                        key: _recordKey,
                        onTap: _toggleRecordDropdown,
                        child: Container(
                          height: 25.h,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
                          decoration: ContDecoration.contDecoration,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedRecordTypes ?? 'Select Type',
                                style: AllTextStyle.dropDownlistStyle,
                              ),
                              Icon(
                                _isRecordDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 25.h,
                            padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 5.w, right: 5.w),
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                  filled: true,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(left: 25.w),
                                    child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r)),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: firstPickedDate ,
                                  hintStyle: AllTextStyle.dateFormatStyle,
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
                        Text(" To ",style: AllTextStyle.searchTypeTxtStyle),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 25.h,
                            padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 5.w, right: 5.w),
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                _secondSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                  filled: true,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(left: 25.w),
                                    child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r)),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: secondPickedDate,
                                  hintStyle: AllTextStyle.dateFormatStyle,
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
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                     margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.all(1.h),
                      child: InkWell(
                        onTap: () async {
                          SalesProvider().on();
                          SaleRecordsProvider().on();
                          SaleDetailsProvider().on();
                          setState(() {
                            if (isAllTypeClicked && isWithoutDetailsClicked) {
                              data = 'showAllWithoutDetails';
                              Provider.of<SalesProvider>(context, listen: false).getSales(
                                "",
                                "",
                                "",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isAllTypeClicked && isWithDetailsClicked) {
                              data = 'showAllWithDetails';
                              Provider.of<SaleRecordsProvider>(context, listen: false).getSaleRecords(
                                "",
                                "",
                                "",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isCustomerWiseClicked && isWithoutDetailsClicked) {
                              data = 'showByCustomerWithoutDetails';
                              Provider.of<SalesProvider>(context, listen: false).getSales(
                                "",
                                "",
                                customerId??"",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isCustomerWiseClicked && isWithDetailsClicked) {
                              data = 'showByCustomerWithDetails';
                              Provider.of<SaleRecordsProvider>(context, listen: false).getSaleRecords(
                                "",
                                "",
                                customerId??"",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isAreaWiseClicked && isWithoutDetailsClicked) {
                              data = 'showByAreaWithoutDetails';
                              Provider.of<SalesProvider>(context, listen: false).getSales(
                                "",
                                areaId??"",
                                "",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isAreaWiseClicked && isWithDetailsClicked) {
                              data = 'showByAreaWithDetails';
                              Provider.of<SaleRecordsProvider>(context, listen: false).getSaleRecords(
                                "",
                                areaId??"",
                                "",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isEmployeeWiseClicked && isWithoutDetailsClicked) {
                              data = 'showByEmployeeWithoutDetails';
                              Provider.of<SalesProvider>(context, listen: false).getSales(
                                "",
                                "",
                                "",
                                employeeId??"",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isEmployeeWiseClicked && isWithDetailsClicked) {
                              data = 'showByEmployeeWithDetails';
                              Provider.of<SaleRecordsProvider>(context, listen: false).getSaleRecords(
                                "",
                                "",
                                "",
                                employeeId??"",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isCategoryWiseClicked) {
                              data = 'showByCategoryDetails';
                              Provider.of<SaleDetailsProvider>(context, listen: false).getSaleDetails(
                                categoryId??"",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a"
                              );
                            }
                            else if (isProductWiseClicked) {
                              data = 'showByProductDetails';
                              Provider.of<SaleDetailsProvider>(context, listen: false).getSaleDetails(
                                "",
                                productId??"",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a"
                              );
                            }

                            else if (isUserWiseClicked && isWithoutDetailsClicked) {
                              data = 'showByUserWithoutDetails';
                              Provider.of<SalesProvider>(context, listen: false).getSales(
                                userId??"",
                                "",
                                "",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                            }
                            else if (isUserWiseClicked && isWithDetailsClicked) {
                              data = 'showByUserWithDetails';
                              Provider.of<SaleRecordsProvider>(context, listen: false).getSaleRecords(
                                userId??"",
                                "",
                                "",
                                "",
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                                "a",
                              );
                              print("UserId=====$userId");
                              print("backEndFirstDate=====$backEndFirstDate");
                              print("backEndSecondtDate=====$backEndSecondtDate");
                            }
                           });
                        },
                        child: Container(
                          height: 25.h,
                          width: 110.w,
                          decoration: BoxDecoration(
                            color: AppColors.appColor,
                            borderRadius: BorderRadius.circular(5.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2.r,
                                blurRadius: 5.r,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(child: Text("Show Report", style: AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            data == 'showAllWithoutDetails' || data == 'showByCustomerWithoutDetails' || data == 'showByAreaWithoutDetails' || data == 'showByEmployeeWithoutDetails' || data == 'showByUserWithoutDetails'
            ? Expanded(
              child: SalesProvider.isSalesLoading
                  ? const buildBeautifulLoading()
                  : salesData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          columnSpacing: 25.w,
                          headingRowHeight: 18.h,
                          dataRowHeight: 16.h,
                          showCheckboxColumn: true,
                          headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                          border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
                          columns: [
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice No', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Date', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Customer Name', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Employee Name', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Saved By', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Sub Total', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Vat', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Discount', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Transport Cost', style: AllTextStyle.tableHeadTextStyle))),),
                            DataColumn(label: Expanded(child: Center(child: Text('Total', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Paid', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Due', style: AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice', style: AllTextStyle.tableHeadTextStyle)))),
                          ],
                          rows: [
                            ...List.generate(
                              salesData.length,
                                  (int index) => DataRow(
                                    color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getBlue) : WidgetStateProperty.resolveWith(getWhite),
                                    cells: <DataCell>[
                                     DataCell(Center(child: Text(salesData[index].saleMasterInvoiceNo??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterSaleDate??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].customerName??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].employeeName??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].addedBy??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterSubTotalAmount??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterTaxAmount??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterTotalDiscountAmount??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterFreight??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterTotalSaleAmount??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterPaidAmount??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(Center(child: Text(salesData[index].saleMasterDueAmount??"", style: AllTextStyle.tableDataTextStyle))),
                                     DataCell(
                                      Center(
                                       child:GestureDetector(
                                        child: Icon(Icons.collections_bookmark,size: 16.r),
                                         onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(
                                         salesId: salesData[index].saleMasterSlNo)));
                                      },
                                      ),
                                     ),
                                    ),
                                   ],
                                  ),
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(subTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(vatTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(discountTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(transferCost!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(totalAmount!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(paidTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Align(alignment: Alignment.centerRight,
                                  child: Text(dueTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle),
                                )),
                                const DataCell(SizedBox()),
                              ],
                            ),
                          ],
                        ),
                       SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ) : Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            )
                : data == 'showAllWithDetails' || data == 'showByCustomerWithDetails'|| data == 'showByAreaWithDetails' || data == 'showByEmployeeWithDetails' || data == 'showByUserWithDetails'
                ? Expanded(
              child: SaleRecordsProvider.isSaleRecordsLoading
                  ? const buildBeautifulLoading()
                  : saleRecordsData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 10.w,
                      headingRowHeight: 18.h,
                      dataRowMinHeight: 16.h,
                      dataRowMaxHeight: double.infinity,
                      showCheckboxColumn: true,
                      headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                      border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice No', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Date', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Employee Name', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Saved By', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Price', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Quantity', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Discount', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Total', style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice', style: AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows: List.generate(
                        saleRecordsData.length,
                            (int index) => DataRow(
                              color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getPurple) : WidgetStateProperty.resolveWith(getWhite),
                              cells: <DataCell>[
                            DataCell(Center(child: Text(saleRecordsData[index].saleMasterInvoiceNo, style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text(saleRecordsData[index].saleMasterSaleDate, style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text(saleRecordsData[index].customerName??"", style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text(saleRecordsData[index].employeeName??"", style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text(saleRecordsData[index].addedBy, style: AllTextStyle.tableDataTextStyle))),
                            DataCell(
                              Center(child: Column(
                                    children: List.generate( saleRecordsData[index].saleDetails!.length, (j) {
                                      return Center(child: Text(saleRecordsData[index].saleDetails![j].productName??"", style: AllTextStyle.tableDataTextStyle)
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(child: Column(
                                    children: List.generate( saleRecordsData[index].saleDetails!.length, (j) {
                                      return Center(child: Text(double.parse(saleRecordsData[index].saleDetails![j].saleDetailsRate??"").toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(child: Column(
                                    children: List.generate( saleRecordsData[index].saleDetails!.length, (j) {
                                      return Center(child: Text(double.parse(saleRecordsData[index].saleDetails![j].saleDetailsTotalQuantity??"").toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(child: Column(
                                    children: List.generate( saleRecordsData[index].saleDetails!.length, (j) {
                                      return Center(child: Text(double.parse(saleRecordsData[index].saleDetails![j].saleDetailsDiscount??"").toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(child: Column(
                                    children: List.generate( saleRecordsData[index].saleDetails!.length, (j) {
                                      return Center(child: Text(double.parse(saleRecordsData[index].saleDetails![j].saleDetailsTotalAmount??"").toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child:GestureDetector(
                                  child: Icon(Icons.collections_bookmark,size: 16.r),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(
                                      salesId: saleRecordsData[index].saleMasterSlNo)));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            )
                : data == 'showByCategoryDetails'
                ? Expanded(
              child: SaleDetailsProvider.isSaleDetailsLoading
                  ? const buildBeautifulLoading()
                  : saleDetailsData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          columnSpacing: 25.w,
                            headingRowHeight: 18.h,
                            dataRowHeight: 16.h,
                            showCheckboxColumn: true,
                          headingRowColor: WidgetStateColor.resolveWith((states) => Colors.purple.shade900),
                          border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
                            columns: [
                              DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Category', style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child:  Center(child: Text('Sold Quantity', style: AllTextStyle.tableHeadTextStyle)))),
                            ],
                          rows: [
                            ...List.generate(
                              saleDetailsData.length,
                                  (int index) =>DataRow(
                                    color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getPurple) : WidgetStateProperty.resolveWith(getWhite),
                                        cells: <DataCell>[
                                          DataCell(Center(child: Text(saleDetailsData[index].productCode, style: AllTextStyle.tableDataTextStyle))),
                                          DataCell(Center(child: Text(saleDetailsData[index].productCategoryName, style: AllTextStyle.tableDataTextStyle))),
                                          DataCell(Center(child: Text(saleDetailsData[index].productName.toString().trim(), style: AllTextStyle.tableDataTextStyle))),
                                          DataCell(Center(child: Text(saleDetailsData[index].saleDetailsTotalQuantity, style: AllTextStyle.tableDataTextStyle))),
                                        ],
                                      ),
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(soldQuantity!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle),)),
            )
                : data == 'showByProductDetails'
                ? Expanded(
              child: SaleDetailsProvider.isSaleDetailsLoading
                  ? const buildBeautifulLoading()
                  : saleDetailsData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          columnSpacing: 25.w,
                            headingRowHeight: 18.h,
                            dataRowHeight: 16.h,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
                            headingRowColor: WidgetStateColor.resolveWith((states) => Colors.purple.shade900),
                            columns: [
                              DataColumn(label: Expanded(child: Center(child: Text('Invoice No.',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Date',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Product Name',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child:  Center(child: Text('Sales Rate',style: AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label: Expanded(child: Center(child: Text('Quantity',style: AllTextStyle.tableHeadTextStyle)))),
                            ],
                          rows: [
                            ...List.generate(
                              saleDetailsData.length,
                                  (int index) =>DataRow(
                                  color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getBlue) : WidgetStateProperty.resolveWith(getWhite),
                                  cells: <DataCell>[
                                  DataCell(Center(child: Text(saleDetailsData[index].saleMasterInvoiceNo, style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text(saleDetailsData[index].saleMasterSaleDate, style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text(saleDetailsData[index].customerName.toString().trim(), style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text(saleDetailsData[index].productName.toString().trim(), style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text(saleDetailsData[index].saleDetailsRate, style: AllTextStyle.tableDataTextStyle))),
                                  DataCell(Center(child: Text(saleDetailsData[index].saleDetailsTotalQuantity, style: AllTextStyle.tableDataTextStyle))),
                                 ],
                               ),
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: AllTextStyle.subTotalTextStyle))),
                                DataCell(Center(child: Text(soldQuantity!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
          ],
        ),
      ),
    );
  }
}