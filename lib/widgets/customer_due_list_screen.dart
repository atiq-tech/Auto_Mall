import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/all_textstyle.dart';

class CustomerDueListScreen extends StatefulWidget {
  const CustomerDueListScreen({super.key});
  @override
  State<CustomerDueListScreen> createState() => _CustomerDueListScreenState();
}
class _CustomerDueListScreenState extends State<CustomerDueListScreen> {
   Color getColor(Set<MaterialState> states) {
    return Colors.blue.shade100;
  }
  Color getColors(Set<MaterialState> states) {
    return Colors.white;
  }
  Color getColorWithDetails(Set<MaterialState> states) {
    return Colors.purple.shade100;
  }
  Color getColorTotal(Set<MaterialState> states) {
    return Colors.blue.shade900;
  }
  String? userType = "";
  //String? userEmployeeId = "";
  String? userEmployeeName = "";
  String? employeeCode = "";
  String? designationName = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    employeeId = "${sharedPreferences?.getString('employeeId')}";
    userEmployeeName = "${sharedPreferences?.getString('employeeName')}";
    employeeCode = "${sharedPreferences?.getString('employeeCode')}";
    designationName = "${sharedPreferences?.getString('designationName')}";
    userType = "${sharedPreferences?.getString('userType')}";
  }
  
  //main dropdowns logic
  bool isAll = true;
  bool isEmployees = false;
  bool isAreas = false;
  bool isCustomers = false;
  bool _isDropdownOpen = false;
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Employee',
    'By Customer',
    'By Area',
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
                  color: Colors.blue.shade50,
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
                              child: Text(type, style: TextStyle(fontSize: 13.sp)),
                            ),
                            if (index != _searchTypes.length - 1)
                              Divider(height: 1.h, thickness: 0.8, color: Colors.indigo.shade400),
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
      isAll = selectedValue == "All";
      isEmployees = selectedValue == "By Employee";
      isCustomers = selectedValue == "By Customer";
      isAreas = selectedValue == "By Area";
      emtyMethod();
    });
  }

  String? customerId;
  String? employeeId;
  String? areaId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getDropdownSize);
    _initializeData();
    // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("","","","");
    // Provider.of<AreasProvider>(context, listen: false).getAreas();
    // Provider.of<CustomerDueProvider>(context, listen: false).customerDuelist = [];
    // Provider.of<EmployeeProvider>(context, listen: false).getEmployee();
    super.initState();
  }

  var customerController = TextEditingController();
  var employeeController = TextEditingController();
  var areaController = TextEditingController();
  emtyMethod() {
    setState(() {
      customerController.text= "";
      areaController.text= "";
      employeeController.text="";
      customerId = "";
      employeeId = "";
      areaId = "";
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // final allCustomersData = Provider.of<CustomerListProvider>(context)
    // .customerList
    // .where((element) => element.customerSlNo != 0)
    // .toList();

    // final allAreasData =Provider.of<AreasProvider>(context).areasList;
    // final providerCDueData = Provider.of<CustomerDueProvider>(context).customerDuelist;
    // List<CustomerDueModel> allCustomerDueData = [];
    // if (customerId == "") {
    //   allCustomerDueData = providerCDueData.where((item) {
    //     final due =
    //         double.tryParse(item.dueAmount ?? "0") ?? 0.0;

    //     return due != 0;
    //   }).toList();
    // } else {
    //   allCustomerDueData = providerCDueData;
    // }
   

    // final totalDue = allCustomerDueData.fold<double>(0.0, (sum, item) => sum + (double.tryParse(item.dueAmount ?? "0") ?? 0.0));
    // final allEmployeeData = Provider.of<EmployeeProvider>(context).allEmployeeList;
    return Scaffold(
      appBar: CustomAppBar(title: "Customer Due List"),
      body: Container(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 6.0.h,bottom: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.0.r),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10.0.r),
                border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.6), spreadRadius: 2, blurRadius: 5.r, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Search Type", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
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
                                  style: TextStyle(fontSize: 13.sp),
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
                  SizedBox(height: 3.h),
                  isEmployees == true ? Row(
                      children: [
                        Expanded(flex: 1,child: Text("Employee",style: AllTextStyle.textFieldHeadStyle)),
                        Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                        Expanded(
                          flex: 3,
                          child: userType == "a" || userType == "m" ? Container(
                            height: 25.0.h,
                            margin: EdgeInsets.only(bottom: 3.5.h),
                            decoration: ContDecoration.contDecoration,
                          //   child: TypeAheadField<EmployeeModel>(
                          //   controller: employeeController,
                          //   builder: (context, controller, focusNode) {
                          //     return TextField(
                          //       controller: controller,
                          //       focusNode: focusNode,
                          //       style: AllTextStyle.textValueStyle,
                          //       decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.only(left: 5.w, top: 2.5.h),
                          //         isDense: true,
                          //         hintText: 'Select Employee',
                          //         hintStyle: TextStyle(fontSize: 13.sp),
                          //         suffixIcon: employeeId == '' || employeeId == 'null' || employeeId == null || controller.text == ''
                          //             ? null
                          //             : GestureDetector(
                          //                 onTap: () {
                          //                   setState(() {
                          //                     employeeController.clear();
                          //                     controller.clear();
                          //                     employeeId = null;
                          //                   });
                          //                   // Clear করার পর নতুনভাবে customer লোড
                          //                   Provider.of<EmployeeProvider>(context, listen: false).getEmployee();
                          //                 },
                          //                 child: Padding(
                          //                   padding: EdgeInsets.all(5.r),
                          //                   child: Icon(Icons.close, size: 16.r),
                          //                 ),
                          //               ),
                          //         suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                          //         filled: false,
                          //         fillColor: Colors.white,
                          //         border: InputBorder.none,
                          //       ),
                          //       onTap: () {
                          //         // কার্সর রাখলেই নতুনভাবে লোড হবে
                          //         Provider.of<EmployeeProvider>(context, listen: false).getEmployee();
                    
                          //         // আগের সিলেকশন থাকলে clear হবে
                          //         if (employeeId != null &&
                          //             employeeId != '' &&
                          //             employeeId != 'null') {
                          //           setState(() {
                          //             employeeController.clear();
                          //             controller.clear();
                          //             employeeId = null;
                          //           });
                          //         }
                          //       },
                          //     );
                          //   },
                          //   suggestionsCallback: (pattern) async {
                          //     return Future.delayed(const Duration(seconds: 1), () {
                          //       return allEmployeeData
                          //           .where((element) => element.displayName
                          //               .toLowerCase()
                          //               .contains(pattern.toLowerCase()))
                          //           .toList()
                          //           .cast<EmployeeModel>();
                          //     });
                          //   },
                          //   itemBuilder: (context, EmployeeModel suggestion) {
                          //     return Padding(
                          //       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                          //       child: Text(
                          //         "${suggestion.displayName}",
                          //         style: TextStyle(fontSize: 12.sp),
                          //         maxLines: 1,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     );
                          //   },
                          //   onSelected: (EmployeeModel suggestion) {
                          //     employeeController.text = "${suggestion.displayName}";
                          //     setState(() {
                          //       employeeId = suggestion.employeeSlNo.toString();
                          //     });
                          //   },
                          // ),
                          ): Container(
                              height: 25.h,
                              margin: EdgeInsets.only(bottom: 3.5.h),
                              decoration: ContDecoration.contDecoration,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                child: Text("$userEmployeeName - $employeeCode - $designationName",style: AllTextStyle.dateFormatStyle),
                              )
                            ),
                        )
                      ],
                    ): SizedBox(height: 0.0.h),
                  isAreas == true? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Area",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        height: 25.0.h,
                        decoration: ContDecoration.contDecoration,
                          //   child: CommonTypeAheadField<AreasModel>(
                          //   controller: areaController,
                          //   suggestionList: allAreasData,
                          //   hintText: 'Select Area',
                          //   selectedValueId: areaId,
                          //   onValueIdChanged: (id) {
                          //     setState(() {
                          //       areaId = id;
                          //     });
                          //   },
                          //   displayText: (a) => a.districtName,
                          //   valueId: (a) => a.districtSlNo.toString(),
                          // ),
                      )
                    )
                    ],
                  ): Container(),
                  isCustomers == true ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        height: 25.0.h,
                        decoration: ContDecoration.contDecoration,
                          //   child: CommonTypeAheadField<CustomersModel>(
                          //   controller: customerController,
                          //   suggestionList: allCustomersData,
                          //   hintText: 'Select Customer',
                          //   selectedValueId: customerId,
                          //   onValueIdChanged: (id) {
                          //     setState(() {
                          //       customerId = id;
                          //     });
                          //   },
                          //   displayText: (c) => c.displayName,
                          //   valueId: (c) => c.customerSlNo.toString(),
                          // ),
                      )
                    )
                    ],
                  ): Container(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(1.0.r),
                      child: InkWell(
                        onTap: () async {
                          // if (isAll) {
                          //   CustomerDueProvider().on();
                          //   Provider.of<CustomerDueProvider>(context, listen: false).getCustomerDue("", "", "");
                          //   return;
                          // }
                          // if (isCustomers && (customerId == null || customerId!.isEmpty)) {
                          //   Utils.showTopSnackBar(context, "Please Select Customer");
                          //   return;
                          // }
                          // if (isAreas && (areaId == null || areaId!.isEmpty)) {
                          //   Utils.showTopSnackBar(context, "Please Select Area");
                          //   return;
                          // }
                          // if (isEmployees && (employeeId == null || employeeId!.isEmpty) && (userType=="m"||userType=="a")) {
                          //   Utils.showTopSnackBar(context, "Please Select Employee");
                          //   return;
                          // }
                          // CustomerDueProvider().on();
                          // Provider.of<CustomerDueProvider>(context, listen: false).getCustomerDue(customerId ?? "", areaId ?? "",employeeId ?? "");
                        },

                        child: Container(
                          height: 28.0.h,
                          width: 102.0.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5.0.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5.r,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(child: Text("Show Report", style:AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
          //   CustomerDueProvider.isCustomerDueLoading ?
          //   const Center(child: CircularProgressIndicator(),)
          //  :allCustomerDueData.isNotEmpty? Expanded(child: Container(
          //  padding: EdgeInsets.only(bottom: 10.h),
          //    child: SingleChildScrollView(
          //      scrollDirection: Axis.vertical,
          //      child: SingleChildScrollView(
          //        scrollDirection: Axis.horizontal,
          //        child: Column(
          //          crossAxisAlignment: CrossAxisAlignment.start,
          //          children: [
          //            DataTable(
          //              headingRowHeight: 20.h,
          //              // ignore: deprecated_member_use
          //              dataRowHeight: 20.h,
          //              headingRowColor: isAreas == true ? WidgetStateColor.resolveWith((states) => AppColors.isAreas):
          //              isCustomers == true ? WidgetStateColor.resolveWith((states) => AppColors.isCustomers):
          //              WidgetStateColor.resolveWith((states) => AppColors.appColor),
          //              showCheckboxColumn: true,
          //              border: TableBorder.all(color: Colors.black54, width: 1.w),
          //              columns: const [
          //                DataColumn(label: Expanded(child: Center(child: Text('Sl',style:AllTextStyle.tableHeadTextStyle)))),
          //                DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
          //                DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
          //                DataColumn(label: Expanded(child: Center(child: Text('Owner Name',style:AllTextStyle.tableHeadTextStyle)))),
          //                DataColumn(label: Expanded(child: Center(child: Text('Address',style:AllTextStyle.tableHeadTextStyle)))),
          //                DataColumn(label: Expanded(child: Center(child: Text('Customer Mobile',style:AllTextStyle.tableHeadTextStyle)))),
          //                DataColumn(label: Expanded(child: Center(child: Text('Due Amount',style:AllTextStyle.tableHeadTextStyle)))),
          //               ],
                      
          //              rows: [
          //               ...List.generate(
          //                 allCustomerDueData.length,
          //                 (int index) => DataRow(
          //                    color: 
          //                   isAreas == true ? index % 2 == 0
          //                           ? WidgetStateProperty.resolveWith(AppColors.getColors)
          //                           : WidgetStateProperty.resolveWith(AppColors.getArea)
          //                       : 
          //                       isCustomers == true ? index % 2 == 0
          //                               ? WidgetStateProperty.resolveWith(AppColors.getColors)
          //                               : WidgetStateProperty.resolveWith(AppColors.getCustomer)
          //                           : index % 2 == 0
          //                                   ? WidgetStateProperty.resolveWith(AppColors.getColors)
          //                                   : WidgetStateProperty.resolveWith(AppColors.getAll),
          //                   cells: <DataCell>[
          //                     DataCell(Center(child: Text("${index + 1}"))),
          //                     DataCell(Center(child: Text(allCustomerDueData[index].customerCode ?? ""))),
          //                     DataCell(Center(child: Text(allCustomerDueData[index].customerName ?? ""))),
          //                     DataCell(Center(child: Text(allCustomerDueData[index].ownerName ?? ""))),
          //                     DataCell(Center(child: Text(allCustomerDueData[index].customerAddress ?? ""))),
          //                     DataCell(Center(child: Text(allCustomerDueData[index].customerMobile ?? ""))),
          //                     DataCell(Center(child: Text(allCustomerDueData[index].dueAmount ?? ""))),
          //                   ],
          //                 ),
          //               ),
          //               DataRow(
          //                 cells: [
          //                   DataCell(SizedBox()),
          //                   DataCell(SizedBox()),
          //                   DataCell(SizedBox()),
          //                   DataCell(SizedBox()),
          //                   DataCell(SizedBox()),
          //                   DataCell(Center(child: Text("Total Due", style: TextStyle(fontWeight: FontWeight.bold)))),
          //                   DataCell(Center(child: Text(totalDue.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),
          //                   ))),
          //                 ],
          //               ),
          //             ],

          //            ),
          //            SizedBox(height: 100.h)
          //          ],
          //        ),
          //      ),
          //    ),
          //  ),
          // ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))), 
          
          ],
        ),
      ),
    );
  }
}