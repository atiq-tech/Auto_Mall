//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
    // Provider.of<EmployeeProvider>(context,listen: false).getEmployee();
    // CustomerListProvider.isCustomerTypeChange = true;
    // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("","","");
    // Provider.of<AllCategoriesProvider>(context, listen: false).getCategories();
    // Provider.of<ProductListProvider>(context,listen: false).getProduct("","");
    // Provider.of<AllUserProvider>(context,listen: false).getUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo!="").toList();
    // final allEmployeeData = Provider.of<EmployeeProvider>(context).allEmployeeList;
    // final allCategoryData = Provider.of<AllCategoriesProvider>(context).allCategoriesList;
    // final allProductData = Provider.of<ProductListProvider>(context).allProductList;
    // final allUserData = Provider.of<AllUserProvider>(context).allUserlist;
    // //get Sales
    // final allGetSalesData = Provider.of<GetSalesProvider>(context).getSaleslist;
    // print("Get Sales length=====> ${allGetSalesData.length} ");
    // ///Sub total
    // subTotal=allGetSalesData.map((e) => e.saleMasterSubTotalAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // vatTotal=allGetSalesData.map((e) => e.saleMasterTaxAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // discountTotal=allGetSalesData.map((e) => e.saleMasterTotalDiscountAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // transferCost=allGetSalesData.map((e) => e.saleMasterFreight).fold(0.0, (p, element) => p!+double.parse(element));
    // totalAmount=allGetSalesData.map((e) => e.saleMasterTotalSaleAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // paidTotal=allGetSalesData.map((e) => e.saleMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // dueTotal=allGetSalesData.map((e) => e.saleMasterDueAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // //get Sales Record
    // final allGetSalesRecordData = Provider.of<SalesRecordProvider>(context).getSalesRecordlist;
    // print("Get Sales record length=====> ${allGetSalesRecordData.length} ");
    // //get Sale_details
    // final allGetSaleDetailsData = Provider.of<SaleDetailsProvider>(context).getSaleDetailsList;
    // print("Get Sale_Details length=====> ${allGetSaleDetailsData.length} ");
    // ///soldQuantity total
    // soldQuantity=allGetSaleDetailsData.map((e) => e.saleDetailsTotalQuantity).fold(0.0, (p, element) => p!+double.parse(element));

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
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(left: 5.w),
                          margin: EdgeInsets.only(top: 4.h),
                          decoration: ContDecoration.contDecoration,
                          // child: TypeAheadFormField(
                          //   textFieldConfiguration: TextFieldConfiguration(
                          //     onChanged: (value){
                          //       if (value == '') {
                          //         _selectedCustomer = '';
                          //       }
                          //     },
                          //     style: AllTextStyle.dropDownlistStyle,
                          //     controller: customerController,
                          //     decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       contentPadding: EdgeInsets.only(bottom: 10.h),
                          //       hintText: 'Select Customer',
                          //       hintStyle: AllTextStyle.dropDownlistStyle,
                          //       suffixIcon: _selectedCustomer == "null"
                          //           || _selectedCustomer == ""
                          //           || customerController.text == ""
                          //           || _selectedCustomer == null ? null: GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             customerController.text = '';
                          //           });
                          //         },
                          //         child: Padding(
                          //           padding: EdgeInsets.only(left: 20.w),
                          //           child: Icon(Icons.close,size: 16.sp),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          //   suggestionsCallback: (pattern) {
                          //     return allCustomerData.where((element) {
                          //       String? nameToCheck = (element.displayName == "null" || element.displayName == null || element.displayName!.isEmpty)
                          //           ? element.customerName : element.displayName;
                          //       return nameToCheck!.toLowerCase().contains(pattern.toString().toLowerCase());
                          //     }).toList();
                          //   },
                          //   itemBuilder: (context, suggestion) {
                          //     return SizedBox(
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          //         child: Text(
                          //           "${suggestion.displayName=="null" || suggestion.displayName == null || suggestion.displayName!.isEmpty ? suggestion.customerName : suggestion.displayName}",
                          //           style: AllTextStyle.dropDownlistStyle,
                          //           maxLines: 1,overflow: TextOverflow.ellipsis,),
                          //       ),
                          //     );
                          //   },
                          //   transitionBuilder: (context, suggestionsBox, controller) {
                          //     return suggestionsBox;
                          //   },
                          //   onSuggestionSelected: (CustomerListModel suggestion) {
                          //     customerController.text = "${suggestion.displayName=="null" || suggestion.displayName == null || suggestion.displayName!.isEmpty ? suggestion.customerName : suggestion.displayName}";
                          //     setState(() {
                          //       _selectedCustomer = suggestion.customerSlNo.toString();
                          //     });
                          //   },
                          //   onSaved: (value) {},
                          // ),
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
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(left: 5.w),
                          margin: EdgeInsets.only(top: 4.h),
                          decoration: ContDecoration.contDecoration,
                          // child: TypeAheadFormField(
                          //   textFieldConfiguration: TextFieldConfiguration(
                          //     onChanged: (value){
                          //       if (value == '') {
                          //         _selectedCustomer = '';
                          //       }
                          //     },
                          //     style: AllTextStyle.dropDownlistStyle,
                          //     controller: customerController,
                          //     decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       contentPadding: EdgeInsets.only(bottom: 10.h),
                          //       hintText: 'Select Customer',
                          //       hintStyle: AllTextStyle.dropDownlistStyle,
                          //       suffixIcon: _selectedCustomer == "null"
                          //           || _selectedCustomer == ""
                          //           || customerController.text == ""
                          //           || _selectedCustomer == null ? null: GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             customerController.text = '';
                          //           });
                          //         },
                          //         child: Padding(
                          //           padding: EdgeInsets.only(left: 20.w),
                          //           child: Icon(Icons.close,size: 16.sp),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          //   suggestionsCallback: (pattern) {
                          //     return allCustomerData.where((element) {
                          //       String? nameToCheck = (element.displayName == "null" || element.displayName == null || element.displayName!.isEmpty)
                          //           ? element.customerName : element.displayName;
                          //       return nameToCheck!.toLowerCase().contains(pattern.toString().toLowerCase());
                          //     }).toList();
                          //   },
                          //   itemBuilder: (context, suggestion) {
                          //     return SizedBox(
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          //         child: Text(
                          //           "${suggestion.displayName=="null" || suggestion.displayName == null || suggestion.displayName!.isEmpty ? suggestion.customerName : suggestion.displayName}",
                          //           style: AllTextStyle.dropDownlistStyle,
                          //           maxLines: 1,overflow: TextOverflow.ellipsis,),
                          //       ),
                          //     );
                          //   },
                          //   transitionBuilder: (context, suggestionsBox, controller) {
                          //     return suggestionsBox;
                          //   },
                          //   onSuggestionSelected: (CustomerListModel suggestion) {
                          //     customerController.text = "${suggestion.displayName=="null" || suggestion.displayName == null || suggestion.displayName!.isEmpty ? suggestion.customerName : suggestion.displayName}";
                          //     setState(() {
                          //       _selectedCustomer = suggestion.customerSlNo.toString();
                          //     });
                          //   },
                          //   onSaved: (value) {},
                          // ),
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
                              padding: EdgeInsets.only(left: 5.w),
                              margin: EdgeInsets.only(top: 4.h),
                              decoration: ContDecoration.contDecoration,
                              // child: TypeAheadFormField(
                              //   textFieldConfiguration:
                              //   TextFieldConfiguration(
                              //     onChanged: (value){
                              //       if (value == '') {
                              //         _selectedEmployee = '';
                              //       }
                              //     },
                              //     style:  AllTextStyle.dropDownlistStyle,
                              //     controller: employeeController,
                              //     decoration: InputDecoration(
                              //       border: InputBorder.none,
                              //       contentPadding: EdgeInsets.only(bottom: 10.h),
                              //       hintText: 'Select Employee',
                              //       hintStyle: AllTextStyle.dropDownlistStyle,
                              //       suffixIcon: _selectedEmployee == "null"
                              //           || _selectedEmployee == ""
                              //           || employeeController.text == ""
                              //           || _selectedEmployee == null
                              //           ? null
                              //           : GestureDetector(
                              //         onTap: () {
                              //           setState(() {
                              //             employeeController.text = '';
                              //             _selectedEmployee = '';
                              //           });
                              //         },
                              //         child: Padding(
                              //           padding: EdgeInsets.only(left: 20.w),
                              //           child: Icon(Icons.close, size: 16.r),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              //   suggestionsCallback: (pattern) {
                              //     return allEmployeeData
                              //         .where((element) => element.displayName
                              //         .toLowerCase()
                              //         .contains(pattern
                              //         .toString()
                              //         .toLowerCase()))
                              //         .take(allEmployeeData.length)
                              //         .toList();
                              //    },
                              //   itemBuilder: (context, suggestion) {
                              //     return SizedBox(
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                              //         child: Text(suggestion.displayName,
                              //           style: AllTextStyle.dropDownlistStyle,
                              //           maxLines: 1,overflow: TextOverflow.ellipsis),
                              //       ),
                              //     );
                              //   },
                              //   transitionBuilder: (context, suggestionsBox, controller) {
                              //     return suggestionsBox;
                              //   },
                              //   onSuggestionSelected: (EmployeeModel suggestion) {
                              //     employeeController.text = suggestion.displayName;
                              //     setState(() {
                              //       _selectedEmployee = suggestion.employeeSlNo.toString();
                              //     });
                              //   },
                              //   onSaved: (value) {},
                              // ),
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
                            padding: EdgeInsets.only(left: 5.w),
                            margin: EdgeInsets.only(top: 4.h,bottom: 4.h),
                            decoration: ContDecoration.contDecoration,
                            // child: TypeAheadFormField(
                            //   textFieldConfiguration:
                            //   TextFieldConfiguration(
                            //     onChanged: (value){
                            //       if (value == '') {
                            //         _selectedCategory = '';
                            //       }
                            //     },
                            //     style: AllTextStyle.dropDownlistStyle,
                            //     controller: categoryController,
                            //     decoration: InputDecoration(
                            //       border: InputBorder.none,
                            //       contentPadding: EdgeInsets.only(bottom: 10.h),
                            //       hintText: 'Select Category',
                            //       hintStyle: AllTextStyle.dropDownlistStyle,
                            //       suffixIcon: _selectedCategory == "null"
                            //           || _selectedCategory == ""
                            //           || categoryController.text == ""
                            //           || _selectedCategory == null ? null: GestureDetector(
                            //         onTap: () {
                            //           setState(() {
                            //             categoryController.text = '';
                            //           });
                            //         },
                            //         child: Padding(
                            //           padding: EdgeInsets.only(left: 20.w),
                            //           child: Icon(Icons.close,size: 16.r),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            //   suggestionsCallback: (pattern) {
                            //     return allCategoryData
                            //       .where((element) => element.productCategoryName
                            //       .toLowerCase()
                            //       .contains(pattern
                            //       .toString()
                            //       .toLowerCase()))
                            //       .take(allCategoryData.length)
                            //       .toList();
                            //     },
                            //   itemBuilder: (context, suggestion) {
                            //     return SizedBox(
                            //       child: Padding(
                            //         padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                            //         child: Text(suggestion.productCategoryName,
                            //           style: AllTextStyle.dropDownlistStyle,
                            //           maxLines: 1,overflow: TextOverflow.ellipsis,),
                            //       ),
                            //     );
                            //   },
                            //   transitionBuilder: (context, suggestionsBox, controller) {
                            //     return suggestionsBox;
                            //   },
                            //   onSuggestionSelected: (AllCategoriesModel suggestion) {
                            //     categoryController.text = suggestion.productCategoryName;
                            //     setState(() {
                            //       _selectedCategory = suggestion.productCategorySlNo.toString();
                            //     });
                            //   },
                            //   onSaved: (value) {},
                            // ),
                          ),
                        )
                      ],
                    ): Container(),
                  isProductWiseClicked == true
                      ? Column(
                        children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                          Expanded(flex: 4, child: Text("Product", style: AllTextStyle.searchTypeTxtStyle)),
                          Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                          Expanded(
                            flex: 10,
                            child: Container(
                                height: 25.h,
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
                                decoration: ContDecoration.contDecoration,
                                // child: TypeAheadFormField(
                                //   textFieldConfiguration:
                                //   TextFieldConfiguration(
                                //       onChanged: (value){
                                //         if (value == '') {
                                //           _selectedProduct = '';
                                //         }
                                //       },
                                //       style: AllTextStyle.dropDownlistStyle,
                                //       controller: productController,
                                //       decoration: InputDecoration(
                                //         border: InputBorder.none,
                                //         contentPadding: EdgeInsets.only(bottom: 3.h,top: 5.h),
                                //         isDense: true,
                                //         hintText: 'Select Product',
                                //         hintStyle: AllTextStyle.dropDownlistStyle,
                                //         suffixIcon: _selectedProduct == "null"
                                //             || _selectedProduct == ""
                                //             || productController.text == ""
                                //             || _selectedProduct == null ? null: GestureDetector(
                                //           onTap: () {
                                //             setState(() {
                                //               productController.text = '';
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
                                //     return allProductData
                                //         .where((element) => element.displayText
                                //         .toLowerCase()
                                //         .contains(pattern
                                //         .toString()
                                //         .toLowerCase()))
                                //         .take(allProductData.length)
                                //         .toList();
                                //    },
                                //   itemBuilder: (context, suggestion) {
                                //     return SizedBox(
                                //       width: double.infinity,
                                //       child: Padding(
                                //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                //         child: Text(suggestion.displayText,
                                //           style: AllTextStyle.dropDownlistStyle,
                                //           maxLines: 1, overflow: TextOverflow.ellipsis,
                                //         ),
                                //       ),
                                //     );
                                //   },
                                //   transitionBuilder: (context, suggestionsBox, controller) {
                                //     return suggestionsBox;
                                //   },
                                //   onSuggestionSelected: (ProductListModel suggestion) {
                                //     productController.text = suggestion.displayText;
                                //     setState(() {
                                //       _selectedProduct = suggestion.productSlNo;
                                //     });
                                //   },
                                //   onSaved: (value) {},
                                // )
                               ),
                              )
                             ],
                           ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 4, child: Text("Employee", style: AllTextStyle.searchTypeTxtStyle)),
                              Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                              Expanded(
                                flex: 10,
                                child: Container(
                                  height: 25.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                  margin: EdgeInsets.only(bottom: 5.h),
                                  decoration: ContDecoration.contDecoration,
                                  // child: TypeAheadFormField(
                                  //   textFieldConfiguration:
                                  //   TextFieldConfiguration(
                                  //     onChanged: (value){
                                  //       if (value == '') {
                                  //         _selectedEmployee = '';
                                  //       }
                                  //     },
                                  //     style: AllTextStyle.dropDownlistStyle,
                                  //     controller: employeeController,
                                  //     decoration: InputDecoration(
                                  //       border: InputBorder.none,
                                  //       contentPadding: EdgeInsets.only(bottom: 10.h),
                                  //       hintText: 'Select Employee',
                                  //       hintStyle: AllTextStyle.dropDownlistStyle,
                                  //       suffixIcon: _selectedEmployee == "null"
                                  //           || _selectedEmployee == ""
                                  //           || employeeController.text == ""
                                  //           || _selectedEmployee == null ? null: GestureDetector(
                                  //         onTap: () {
                                  //           setState(() {
                                  //             employeeController.text = '';
                                  //             _selectedEmployee = '';
                                  //           });
                                  //         },
                                  //         child: Padding(
                                  //           padding: EdgeInsets.only(left: 25.w),
                                  //           child: Icon(Icons.close,size: 16.r),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   suggestionsCallback: (pattern) {
                                  //     return allEmployeeData
                                  //       .where((element) => element.displayName
                                  //       .toLowerCase()
                                  //       .contains(pattern
                                  //       .toString()
                                  //       .toLowerCase()))
                                  //       .take(allEmployeeData.length)
                                  //       .toList();
                                  //    },
                                  //   itemBuilder: (context, suggestion) {
                                  //     return SizedBox(
                                  //       child: Padding(
                                  //         padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                  //         child: Text(suggestion.displayName,
                                  //           style: AllTextStyle.dropDownlistStyle,
                                  //           maxLines: 1,overflow: TextOverflow.ellipsis),
                                  //       ),
                                  //     );
                                  //   },
                                  //   transitionBuilder: (context, suggestionsBox, controller) {
                                  //     return suggestionsBox;
                                  //   },
                                  //   onSuggestionSelected: (EmployeeModel suggestion) {
                                  //     employeeController.text = suggestion.displayName;
                                  //     setState(() {
                                  //       _selectedEmployee = suggestion.employeeSlNo.toString();
                                  //     });
                                  //   },
                                  //   onSaved: (value) {},
                                  // ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                      : Container(),
                  isUserWiseClicked == true
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 4, child: Text("User", style: AllTextStyle.searchTypeTxtStyle)),
                          Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                          userName=="Admin"?Expanded(
                            flex: 10,
                            child: Container(
                              height: 25.h,
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              margin: EdgeInsets.only(bottom: 5.h),
                              decoration: ContDecoration.contDecoration,
                              // child: TypeAheadFormField(
                              //   textFieldConfiguration:
                              //   TextFieldConfiguration(
                              //     onChanged: (value){
                              //       if (value == '') {
                              //         _selectedUser = '';
                              //       }
                              //     },
                              //     style: AllTextStyle.dropDownlistStyle,
                              //     controller: userController,
                              //     decoration: InputDecoration(
                              //       border: InputBorder.none,
                              //       contentPadding: EdgeInsets.only(bottom: 10.h),
                              //       hintText: 'Select User',
                              //       hintStyle: AllTextStyle.dropDownlistStyle,
                              //       suffixIcon: _selectedUser == "null"
                              //           || _selectedUser == ""
                              //           || userController.text == ""
                              //           || _selectedUser == null ? null: GestureDetector(
                              //         onTap: () {
                              //           setState(() {
                              //             userController.text = '';
                              //           });
                              //         },
                              //         child: Padding(
                              //           padding: EdgeInsets.only(left: 25.w),
                              //           child: Icon(Icons.close,size: 16.r,),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              //   suggestionsCallback: (pattern) {
                              //     return allUserData
                              //         .where((element) => element.fullName
                              //         .toLowerCase()
                              //         .contains(pattern
                              //         .toString()
                              //         .toLowerCase()))
                              //         .take(allUserData.length)
                              //         .toList();
                              //    },
                              //   itemBuilder: (context, suggestion) {
                              //     return SizedBox(
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                              //         child: Text(
                              //           suggestion.fullName,
                              //           style: AllTextStyle.dropDownlistStyle,
                              //           maxLines: 1,overflow: TextOverflow.ellipsis,),
                              //       ),
                              //     );
                              //   },
                              //   transitionBuilder: (context, suggestionsBox, controller) {
                              //     return suggestionsBox;
                              //   },
                              //   onSuggestionSelected: (AllUserModel suggestion) {
                              //     userController.text = suggestion.fullName;
                              //     userfullName = suggestion.fullName;
                              //     setState(() {
                              //       _selectedUser = suggestion.userSlNo.toString();
                              //     });
                              //   },
                              //   onSaved: (value) {},
                              // ),
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
                          // GetSalesProvider().on();
                          // SalesRecordProvider().on();
                          // SaleDetailsProvider().on();
                          // setState(() {
                          //   if (isAllTypeClicked && isWithoutDetailsClicked) {
                          //     data = 'showAllWithoutDetails';
                          //     Provider.of<GetSalesProvider>(context, listen: false).getGatSales(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       ""
                          //     );
                          //   }
                          //   else if (isAllTypeClicked && isWithDetailsClicked) {
                          //     data = 'showAllWithDetails';
                          //     Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       ""
                          //     );
                          //   }
                          //   else if (isCustomerWiseClicked && isWithoutDetailsClicked) {
                          //     data = 'showByCustomerWithoutDetails';
                          //     Provider.of<GetSalesProvider>(context, listen: false).getGatSales(
                          //       "$_selectedCustomer",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       ""
                          //     );
                          //   }
                          //   else if (isCustomerWiseClicked && isWithDetailsClicked) {
                          //     data = 'showByCustomerWithDetails';
                          //     Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(
                          //       "$_selectedCustomer",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       ""
                          //     );
                          //   }
                          //   else if (isEmployeeWiseClicked && isWithoutDetailsClicked) {
                          //     data = 'showByEmployeeWithoutDetails';
                          //     Provider.of<GetSalesProvider>(context, listen: false).getGatSales(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "$_selectedEmployee",
                          //       "",
                          //     );
                          //   }
                          //   else if (isEmployeeWiseClicked && isWithDetailsClicked) {
                          //     data = 'showByEmployeeWithDetails';
                          //     Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "$_selectedEmployee",
                          //       "",
                          //     );
                          //   }
                          //   else if (isCategoryWiseClicked) {
                          //     data = 'showByCategoryDetails';
                          //     Provider.of<SaleDetailsProvider>(context, listen: false).getSaleDetails(
                          //       "$_selectedCategory",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       "",
                          //     );
                          //   }
                          //   else if (isProductWiseClicked) {
                          //     data = 'showByProductDetails';
                          //     Provider.of<SaleDetailsProvider>(context, listen: false).getSaleDetails(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       _selectedEmployee ??"",
                          //       "$_selectedProduct",
                          //     );
                          //   }
                          //   else if (isUserWiseClicked && isWithoutDetailsClicked) {
                          //     data = 'showByUserWithoutDetails';
                          //     Provider.of<GetSalesProvider>(context, listen: false).getGatSales(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       userName=="Admin"?"$_selectedUser":userID,
                          //     );
                          //   }
                          //   else if (isUserWiseClicked && isWithDetailsClicked) {
                          //     data = 'showByUserWithDetails';
                          //     Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(
                          //       "",
                          //       "$backEndFirstDate",
                          //       "$backEndSecondtDate",
                          //       "",
                          //       userName=="Admin"?"$_selectedUser":userID,
                          //     );
                          //   }
                          //  });
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
            // data == 'showAllWithoutDetails' || data == 'showByCustomerWithoutDetails' || data == 'showByEmployeeWithoutDetails' || data == 'showByUserWithoutDetails'
            // ? Expanded(
            //   child: GetSalesProvider.isSearchTypeChange
            //       ? const buildBeautifulLoading()
            //       : allGetSalesData.isNotEmpty?
            //   SizedBox(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.vertical,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             DataTable(
            //               columnSpacing: 25.w,
            //               headingRowHeight: 18.h,
            //               dataRowHeight: 16.h,
            //               showCheckboxColumn: true,
            //               headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
            //               border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
            //               columns: [
            //                 DataColumn(label: Expanded(child: Center(child: Text('Invoice No', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Date', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Customer Name', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Employee Name', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Saved By', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Sub Total', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Vat', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Discount', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Transport Cost', style: AllTextStyle.tableHeadTextStyle))),),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Total', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Paid', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Due', style: AllTextStyle.tableHeadTextStyle)))),
            //                 DataColumn(label: Expanded(child: Center(child: Text('Invoice', style: AllTextStyle.tableHeadTextStyle)))),
            //               ],
            //               rows: [
            //                 ...List.generate(
            //                   allGetSalesData.length,
            //                       (int index) => DataRow(
            //                         color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getBlue) : WidgetStateProperty.resolveWith(getWhite),
            //                         cells: <DataCell>[
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterInvoiceNo, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterSaleDate, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].customerName== "null" ? '' : allGetSalesData[index].customerName, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].employeeName== "null" ? '' : allGetSalesData[index].employeeName, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].addedBy, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterSubTotalAmount, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterTaxAmount, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterTotalDiscountAmount, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterFreight, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterTotalSaleAmount, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterPaidAmount, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(Center(child: Text(allGetSalesData[index].saleMasterDueAmount, style: AllTextStyle.tableDataTextStyle))),
            //                          DataCell(
            //                           Center(
            //                            child:GestureDetector(
            //                             child: Icon(Icons.collections_bookmark,size: 16.r),
            //                              onTap: () {
            //                               Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
            //                              salesId: allGetSalesData[index].saleMasterSlNo)));
            //                           },
            //                           ),
            //                          ),
            //                         ),
            //                        ],
            //                       ),
            //                 ),
            //                 DataRow(
            //                   cells: <DataCell>[
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(subTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(vatTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(discountTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(transferCost!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(totalAmount!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(paidTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Align(alignment: Alignment.centerRight,
            //                       child: Text(dueTotal!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle),
            //                     )),
            //                     const DataCell(SizedBox()),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //            SizedBox(height: 20.h),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ) : Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            // )
            //     : data == 'showAllWithDetails' || data == 'showByCustomerWithDetails' || data == 'showByEmployeeWithDetails' || data == 'showByUserWithDetails'
            //     ? Expanded(
            //   child: SalesRecordProvider.isSearchTypeChange
            //       ? const buildBeautifulLoading()
            //       : allGetSalesRecordData.isNotEmpty?
            //   SizedBox(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.vertical,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: DataTable(
            //           columnSpacing: 10.w,
            //           headingRowHeight: 18.h,
            //           dataRowMinHeight: 16.h,
            //           dataRowMaxHeight: double.infinity,
            //           showCheckboxColumn: true,
            //           headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
            //           border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
            //           columns: [
            //             DataColumn(label: Expanded(child: Center(child: Text('Invoice No', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Date', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Customer Name', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Employee Name', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Saved By', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Price', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Quantity', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Discount', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Total', style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Invoice', style: AllTextStyle.tableHeadTextStyle)))),
            //           ],
            //           rows: List.generate(
            //             allGetSalesRecordData.length,
            //                 (int index) => DataRow(
            //                   color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getPurple) : WidgetStateProperty.resolveWith(getWhite),
            //                   cells: <DataCell>[
            //                 DataCell(Center(child: Text(allGetSalesRecordData[index].saleMasterInvoiceNo, style: AllTextStyle.tableDataTextStyle))),
            //                 DataCell(Center(child: Text(allGetSalesRecordData[index].saleMasterSaleDate, style: AllTextStyle.tableDataTextStyle))),
            //                 DataCell(Center(child: Text(allGetSalesRecordData[index].customerName=="null"?"":allGetSalesRecordData[index].customerName, style: AllTextStyle.tableDataTextStyle))),
            //                 DataCell(Center(child: Text(allGetSalesRecordData[index].employeeName=="null"?"":allGetSalesRecordData[index].employeeName, style: AllTextStyle.tableDataTextStyle))),
            //                 DataCell(Center(child: Text(allGetSalesRecordData[index].addedBy, style: AllTextStyle.tableDataTextStyle))),
            //                 DataCell(
            //                   Center(child: Column(
            //                         children: List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
            //                           return Center(child: Text(allGetSalesRecordData[index].saleDetails[j].productName, style: AllTextStyle.tableDataTextStyle)
            //                           );
            //                         })
            //                     ),
            //                   ),
            //                 ),
            //                 DataCell(
            //                   Center(child: Column(
            //                         children: List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
            //                           return Center(child: Text(double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsRate).toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
            //                           );
            //                         })
            //                     ),
            //                   ),
            //                 ),
            //                 DataCell(
            //                   Center(child: Column(
            //                         children: List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
            //                           return Center(child: Text(double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalQuantity).toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
            //                           );
            //                         })
            //                     ),
            //                   ),
            //                 ),
            //                 DataCell(
            //                   Center(child: Column(
            //                         children: List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
            //                           return Center(child: Text(double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsDiscount).toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
            //                           );
            //                         })
            //                     ),
            //                   ),
            //                 ),
            //                 DataCell(
            //                   Center(child: Column(
            //                         children: List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
            //                           return Center(child: Text(double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalAmount).toStringAsFixed(2), style: AllTextStyle.tableDataTextStyle)
            //                           );
            //                         })
            //                     ),
            //                   ),
            //                 ),
            //                 DataCell(
            //                   Center(
            //                     child:GestureDetector(
            //                       child: Icon(Icons.collections_bookmark,size: 16.r),
            //                       onTap: () {
            //                         Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
            //                           salesId: allGetSalesRecordData[index].saleMasterSlNo)));
            //                       },
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            // )
            //     : data == 'showByCategoryDetails'
            //     ? Expanded(
            //   child: SaleDetailsProvider.isSearchTypeChange
            //       ? const buildBeautifulLoading()
            //       : allGetSaleDetailsData.isNotEmpty?
            //   SizedBox(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.vertical,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             DataTable(
            //               columnSpacing: 25.w,
            //                 headingRowHeight: 18.h,
            //                 dataRowHeight: 16.h,
            //                 showCheckboxColumn: true,
            //               headingRowColor: WidgetStateColor.resolveWith((states) => Colors.purple.shade900),
            //               border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
            //                 columns: [
            //                   DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child: Center(child: Text('Category', style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child:  Center(child: Text('Sold Quantity', style: AllTextStyle.tableHeadTextStyle)))),
            //                 ],
            //               rows: [
            //                 ...List.generate(
            //                   allGetSaleDetailsData.length,
            //                       (int index) =>DataRow(
            //                         color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getPurple) : WidgetStateProperty.resolveWith(getWhite),
            //                             cells: <DataCell>[
            //                               DataCell(Center(child: Text(allGetSaleDetailsData[index].productCode, style: AllTextStyle.tableDataTextStyle))),
            //                               DataCell(Center(child: Text(allGetSaleDetailsData[index].productCategoryName, style: AllTextStyle.tableDataTextStyle))),
            //                               DataCell(Center(child: Text(allGetSaleDetailsData[index].productName.toString().trim(), style: AllTextStyle.tableDataTextStyle))),
            //                               DataCell(Center(child: Text(allGetSaleDetailsData[index].saleDetailsTotalQuantity, style: AllTextStyle.tableDataTextStyle))),
            //                             ],
            //                           ),
            //                 ),
            //                 DataRow(
            //                   cells: <DataCell>[
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(soldQuantity!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle),)),
            // )
            //     : data == 'showByProductDetails'
            //     ? Expanded(
            //   child: SaleDetailsProvider.isSearchTypeChange
            //       ? const buildBeautifulLoading()
            //       : allGetSaleDetailsData.isNotEmpty?
            //   SizedBox(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.vertical,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             DataTable(
            //               columnSpacing: 25.w,
            //                 headingRowHeight: 18.h,
            //                 dataRowHeight: 16.h,
            //                 showCheckboxColumn: true,
            //                 border: TableBorder.all(color: Colors.grey.shade400,width: 1.w),
            //                 headingRowColor: WidgetStateColor.resolveWith((states) => Colors.purple.shade900),
            //                 columns: [
            //                   DataColumn(label: Expanded(child: Center(child: Text('Invoice No.',style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child: Center(child: Text('Date',style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child: Center(child: Text('Product Name',style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child:  Center(child: Text('Sales Rate',style: AllTextStyle.tableHeadTextStyle)))),
            //                   DataColumn(label: Expanded(child: Center(child: Text('Quantity',style: AllTextStyle.tableHeadTextStyle)))),
            //                 ],
            //               rows: [
            //                 ...List.generate(
            //                   allGetSaleDetailsData.length,
            //                       (int index) =>DataRow(
            //                       color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getBlue) : WidgetStateProperty.resolveWith(getWhite),
            //                       cells: <DataCell>[
            //                       DataCell(Center(child: Text(allGetSaleDetailsData[index].saleMasterInvoiceNo, style: AllTextStyle.tableDataTextStyle))),
            //                       DataCell(Center(child: Text(allGetSaleDetailsData[index].saleMasterSaleDate, style: AllTextStyle.tableDataTextStyle))),
            //                       DataCell(Center(child: Text(allGetSaleDetailsData[index].customerName.toString().trim(), style: AllTextStyle.tableDataTextStyle))),
            //                       DataCell(Center(child: Text(allGetSaleDetailsData[index].productName.toString().trim(), style: AllTextStyle.tableDataTextStyle))),
            //                       DataCell(Center(child: Text(allGetSaleDetailsData[index].saleDetailsRate, style: AllTextStyle.tableDataTextStyle))),
            //                       DataCell(Center(child: Text(allGetSaleDetailsData[index].saleDetailsTotalQuantity, style: AllTextStyle.tableDataTextStyle))),
            //                      ],
            //                    ),
            //                 ),
            //                 DataRow(
            //                   cells: <DataCell>[
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     const DataCell(SizedBox()),
            //                     DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: AllTextStyle.subTotalTextStyle))),
            //                     DataCell(Center(child: Text(soldQuantity!.toStringAsFixed(2),style: AllTextStyle.subTotalTextStyle))),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            // ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
          
          ],
        ),
      ),
    );
  }
}