import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/common_widget/type_ahead_searching_field.dart';
import 'package:auto_mall/models/customers_model.dart';
import 'package:auto_mall/models/employees_model.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/providers/employees_provider.dart';
import 'package:auto_mall/providers/visites_provider.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/all_textstyle.dart';

class VisitsHistoryScreen extends StatefulWidget {
  const VisitsHistoryScreen({super.key});
  @override
  State<VisitsHistoryScreen> createState() => _VisitsHistoryScreenState();
}
class _VisitsHistoryScreenState extends State<VisitsHistoryScreen> {
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
  String? userEmployeeId = "";
  String? userEmployeeName = "";
  String? employeeCode = "";
  String? designationName = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userEmployeeName = "${sharedPreferences?.getString('employeeName')}";
    employeeCode = "${sharedPreferences?.getString('employeeCode')}";
    designationName = "${sharedPreferences?.getString('designationName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId====> $userEmployeeId");
  }
  
  //main dropdowns logic
  bool isAll = true;
  bool isCustomers = false;
  bool isEmployees = false;
  bool _isDropdownOpen = false;
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Customer',
    'By Employee',
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
                              child: Text(type, style: AllTextStyle.dropDownlistStyle),
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
      isCustomers = selectedValue == "By Customer";
      isEmployees = selectedValue == "By Employee";
      emtyMethod();
    });
  }

  String? customerId;
  String? employeeId;

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
  @override
  void initState() {
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _getDropdownSize(Duration.zero);
    if (!mounted) return;
    Provider.of<CustomersProvider>(context,listen: false).getCustomers("");
    Provider.of<VisitesProvider>(context, listen: false).visitesList = [];
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees();
  });
    super.initState();
  }

  var customerController = TextEditingController();
  var employeeController = TextEditingController();
  emtyMethod() {
    setState(() {
      customerController.text= "";
      employeeController.text="";
      customerId = "";
      employeeId = "";
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final customersData = Provider.of<CustomersProvider>(context).customersList
    .where((customer) =>customer.customerName != "Cash Customer" && customer.customerName != "New Customer")
    .toList();
    final employeesData = Provider.of<EmployeesProvider>(context).employeesList;
    ///get Visits
    final visitesData = Provider.of<VisitesProvider>(context).visitesList;
    print("visitsData length=====> ${visitesData.length} ");
    return Scaffold(
      appBar: CustomAppBar(title: "Visits History"),
      body: Container(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 6.0.h,bottom: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.0.r),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 156, 248, 202),
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
                  SizedBox(height: 3.h),
                  isEmployees == true? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Employee",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      userType == "a" || userType == "m" ? Expanded(
                      flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          child: CommonTypeAheadField<EmployeesModel>(
                          controller: employeeController,
                          suggestionList: employeesData,
                          hintText: 'Select Employee',
                          selectedValueId: userEmployeeId,
                          onValueIdChanged: (id) {
                            setState(() {
                              userEmployeeId = id;
                            });
                          },
                          displayText: (e) => e.employeeName??"",
                          valueId: (e) => e.employeeSlNo.toString(),
                         ),
                        )
                      ):Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.h,
                          padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 5.w),
                          margin: EdgeInsets.only(bottom: 4.h),
                          decoration: ContDecoration.contDecoration,
                          child: Text("$userEmployeeName - $employeeCode",style: AllTextStyle.searchTypeTxtStyle),
                        ))
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
                       )
                      )
                    ],
                  ): Container(),
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
                  SizedBox(height: 3.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(1.0.r),
                      child: InkWell(
                        onTap: () async {
                          VisitesProvider().on();
                          setState(() {
                            Provider.of<VisitesProvider>(context, listen: false).getVisites(
                              isCustomers == true ? customerId ?? "" : "",
                              userEmployeeId ?? "",
                              "$backEndFirstDate",
                              "$backEndSecondtDate",
                            );
                          });
                        },

                        child: Container(
                          height: 25.h,
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
            SizedBox(height: 10.h),
            VisitesProvider.isVisitesLoading ?
            const Center(child: buildBeautifulLoading())
           :visitesData.isNotEmpty? Expanded(child: Container(
           padding: EdgeInsets.only(bottom: 6.h),
             child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child: SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     DataTable(
                       headingRowHeight: 16.h,
                       // ignore: deprecated_member_use
                       dataRowHeight: 16.h,
                       headingRowColor: isEmployees == true ? WidgetStateColor.resolveWith((states) => AppColors.isEmployees):
                       isCustomers == true ? WidgetStateColor.resolveWith((states) => AppColors.isMechanics):
                       WidgetStateColor.resolveWith((states) => AppColors.appColor),
                       showCheckboxColumn: true,
                       border: TableBorder.all(color: Colors.cyan.shade100, width: 1.w),
                       columns: [
                         DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Address',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Phone',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Visit Date',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Note',style: AllTextStyle.tableHeadTextStyle)))),
                      ],
                      
                       rows: [
                        ...List.generate(
                          visitesData.length,
                          (int index) => DataRow(
                             color: isCustomers == true ? index % 2 == 0
                                     ? WidgetStateProperty.resolveWith(AppColors.getColors)
                                     : WidgetStateProperty.resolveWith(AppColors.getCustomer)
                                    : index % 2 == 0
                                            ? WidgetStateProperty.resolveWith(AppColors.getColors)
                                            : WidgetStateProperty.resolveWith(AppColors.getAll),
                            cells: <DataCell>[
                              DataCell(Center(child: Text(visitesData[index].customerCode??"",style: AllTextStyle.tableDataTextStyle))),
                              DataCell(Center(child: Text(visitesData[index].customerName??"",style: AllTextStyle.tableDataTextStyle))),
                              DataCell(Center(child: Text(visitesData[index].customerAddress??"",style: AllTextStyle.tableDataTextStyle))),
                              DataCell(Center(child: Text(visitesData[index].customerMobile??"",style: AllTextStyle.tableDataTextStyle))),
                              DataCell(
                                Center(
                                  child: Text(
                                    visitesData[index].date != null
                                        ? DateFormat('yyyy-MM-dd').format(visitesData[index].date!)
                                        : "",
                                    style: AllTextStyle.tableDataTextStyle,
                                  ),
                                ),
                              ),
                              DataCell(Center(child: Text(visitesData[index].note??"",style: AllTextStyle.tableDataTextStyle))),
                            ],
                          ),
                        ),
                      ],

                     ),
                     SizedBox(height: 100.h)
                   ],
                 ),
               ),
             ),
           ),
          ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))), 

          ],
        ),
      ),
    );
  }
}