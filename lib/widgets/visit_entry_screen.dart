import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/type_ahead_searching_field.dart';
import 'package:auto_mall/models/customers_model.dart';
import 'package:auto_mall/models/employees_model.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/providers/employees_provider.dart';
import 'package:auto_mall/providers/visites_provider.dart';
import 'package:auto_mall/utils/animation_snackbar.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget/custom_appbar.dart';
import '../../utils/all_textstyle.dart';
import '../../utils/base_url.dart';
import '../../utils/utils.dart';

class VisitEntryScreen extends StatefulWidget {
  const VisitEntryScreen({super.key});

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  Color getColor(Set<WidgetState> states) {return Colors.green.shade100;}
  Color getColors(Set<WidgetState> states) {return Colors.white;}
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _employeeCustomerController = TextEditingController();

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

  SharedPreferences? sharedPreferences;
  String? userName = "";
  String? userID = "";
  String? userEmployeeId = "";
  String? userType = "";
  String? employeeName = "";
  String? employeeSlNo;
  String? employeeId = "";
  String? employeeCode = "";
  String? customerId;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences!.getString('userName') ?? ''; 
    userType = "${sharedPreferences!.getString('userType')}";
    userEmployeeId = "${sharedPreferences!.getString('employeeId')}";
    employeeName = "${sharedPreferences!.getString('employeeName')}";
    employeeCode = "${sharedPreferences!.getString('employeeCode')}";
    userID = "${sharedPreferences!.getString('userId')}";
    print("userEmployeeId====> $userEmployeeId");
    setState(() {
      Provider.of<VisitesProvider>(context, listen: false).getVisites("",userEmployeeId,backEndFirstDate, backEndFirstDate);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    super.initState();
    _initializeData();
    Provider.of<EmployeesProvider>(context,listen: false).getEmployees();
    Provider.of<CustomersProvider>(context, listen: false).getCustomers("");
    userName = _employeeCustomerController.text;
    print("eeeeeeeeee======  ${_employeeCustomerController.text}");
  }

  ScrollController mainScrollController = ScrollController();
  late final ScrollController _listViewScrollController = ScrollController()
    ..addListener(listViewScrollListener);
  ScrollPhysics _physics = const ScrollPhysics();

  void listViewScrollListener() {
    if (_listViewScrollController.offset >=
        _listViewScrollController.position.maxScrollExtent &&
        !_listViewScrollController.position.outOfRange) {
      if (mainScrollController.offset == 0) {
        mainScrollController.animateTo(50, duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
      setState(() {
        _physics = const NeverScrollableScrollPhysics();
      });
      print("bottom");
    }
  }
  void mainScrollListener() {
    if (mainScrollController.offset <=
        mainScrollController.position.minScrollExtent &&
        !mainScrollController.position.outOfRange) {
      setState(() {
        if (_physics is NeverScrollableScrollPhysics) {
          _physics = const ScrollPhysics();
          _listViewScrollController.animateTo(
              _listViewScrollController.position.maxScrollExtent - 50,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        }
      });
      print("top");
    }
  }

  @override
  Widget build(BuildContext context) {
    mainScrollController.addListener(mainScrollListener);
    final employeesData = Provider.of<EmployeesProvider>(context).employeesList;
    ///get Customer
    final customersData = Provider.of<CustomersProvider>(context).customersList
    .where((customer) =>customer.customerName != "Cash Customer" && customer.customerName != "New Customer")
    .toList();
    ///get Visits
    final visitesData = Provider.of<VisitesProvider>(context).visitesList;
    print("visitsData length=====> ${visitesData.length} ");
    return Scaffold(
      appBar: CustomAppBar(title: "Visit Entry"),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(6.r),
              child: Card(
                color: Colors.green[200],
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Customer Name",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: Container(
                              height: 25.h,
                              decoration: ContDecoration.contDecoration,
                              child: TypeAheadField<CustomersModel>(
                                controller: _customerNameController,
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
                                      contentPadding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
                                      hintText: 'Select Customer',
                                      isDense: true,
                                      hintStyle: AllTextStyle.dropDownlistStyle,
                                      suffixIcon: customerId == ''
                                          ? null
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _customerNameController.clear();
                                                  fieldController.clear();
                                                  customerId = '';
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
                                  _customerNameController.text = "${suggestion.displayName=="null" || suggestion.displayName == null || suggestion.displayName!.isEmpty ? suggestion.customerName : suggestion.displayName}";
                                  setState(() {
                                    customerId = suggestion.customerSlNo.toString();
                                    _nameController.text = suggestion.customerName.toString();
                                    _phoneController.text = suggestion.customerMobile.toString();
                                    _addressController.text = suggestion.customerAddress.toString();
                                    //_employeeController.text = suggestion.employeeName.toString();
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Name",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              height: 25.h,
                              child: TextField(
                                style: AllTextStyle.dropDownlistStyle,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter name",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border:InputBorder.none,
                                  focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Phone",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              height: 25.h,
                              child: TextField(
                                style: AllTextStyle.dropDownlistStyle,
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  hintText: "Enter Phone",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border:InputBorder.none,
                                  focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Address",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              height: 25.h,
                              child: TextField(
                                style: AllTextStyle.dropDownlistStyle,
                                controller: _addressController,
                                decoration: InputDecoration(
                                    hintText: "Enter Address",
                                    hintStyle: AllTextStyle.textValueStyle,
                                    contentPadding: EdgeInsets.only(left: 5.w),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border:InputBorder.none,
                                    focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                    enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Visit Date",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: Container(
                              height: 25.h,
                              padding: EdgeInsets.only(top: 3.h, bottom: 5.h,right: 5.w),
                              decoration: ContDecoration.contDecoration,
                              child: GestureDetector(
                                onTap: (() {
                                  _firstSelectedDate();
                                }),
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r)),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: firstPickedDate ,
                                    hintStyle:  TextStyle(fontSize: 11.sp, color: Colors.grey.shade700, fontWeight: FontWeight.w400),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 6, child: Text("Employee", style: AllTextStyle.searchTypeTxtStyle)),
                          Expanded(flex: 1,child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                          userType == "a" || userType == "m" ? Expanded(
                            flex: 11,
                            child: Container(
                              height: 25.h,
                              margin: EdgeInsets.only(top: 4.h),
                              child: CommonTypeAheadField<EmployeesModel>(
                                controller: _employeeController,
                                suggestionList: employeesData,
                                hintText: 'Select Employee',
                                selectedValueId: userEmployeeId,
                                onValueIdChanged: (id) {
                                  setState(() {
                                    userEmployeeId = id;
                                  });
                                },
                                displayText: (e) => "${e.employeeName} - ${e.employeeId}",
                                valueId: (e) => e.employeeSlNo.toString(),
                              )
                            ),
                          ): Expanded(
                            flex: 11,
                            child: Container(
                              height: 25.h,
                              padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 5.w),
                              margin: EdgeInsets.only(top: 4.h,bottom: 4.h),
                              decoration: ContDecoration.contDecoration,
                              child: Text("$employeeName - $employeeCode",style: AllTextStyle.searchTypeTxtStyle),
                            ))
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Note",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              height: 45.h,
                              child: TextField(
                                style: AllTextStyle.dropDownlistStyle,
                                controller: _noteController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: "Note here",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () async {
                              Utils.closeKeyBoard(context);
                            if(_customerNameController.text==''){
                              Utils.showTopSnackBar(context, "Please Select Customer");
                            }
                            else if(_employeeController.text == '' && (userType == "a" || userType == "m")){ {
                              Utils.showTopSnackBar(context, "Employee field is required");
                            }}
                            else{
                              setState(() {
                                visitEntryBtnClk = true;
                              });
                              addVisites(context).then((value){
                                Provider.of<VisitesProvider>(context, listen: false).getVisites("",userEmployeeId,backEndFirstDate, backEndFirstDate);
                                setState(() {
                                });
                              });
                             }
                          },
                          child: Container(
                            height: 25.h,
                            width: MediaQuery.of(context).size.width/5.0,
                            decoration: BoxDecoration(
                              color: AppColors.appColor,
                              borderRadius: BorderRadius.circular(5.r),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 2.r,blurRadius: 5.r, offset: const Offset(0, 3)),
                              ],
                            ),
                            child: Center(child: visitEntryBtnClk ? SizedBox(height: 20.h,width:20.w,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                "SAVE",style: AllTextStyle.saveButtonTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ///
            SizedBox(height: 4.h),
            VisitesProvider.isVisitesLoading == true
              ? buildBeautifulLoading()
              : Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _listViewScrollController,
                  physics: _physics,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 25.w,
                      headingRowHeight: 16.h,
                      dataRowHeight: 16.h,
                      headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.isMechanics),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.blueGrey.shade100, width: 1),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Address',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Phone',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Visit Date',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Note',style: AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows: List.generate(
                       visitesData.length > 100 ? 100 : visitesData.length,
                            (int index) => DataRow(
                          color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
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
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
  emptyMethod() {
    setState(() {
      _nameController.text = "";
      _customerNameController.text = "";
      _phoneController.text = "";
      _addressController.text = "";
      _employeeController.text="";
      _noteController.text="";
    });
  }
  Future<String> addVisites(BuildContext context) async {
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(addVisit,
        data:  {
          "customerId": customerId,
          "address":_addressController.text.trim(),
          "employeeId": userEmployeeId ?? "",
          "date": backEndFirstDate,
          "note": _noteController.text.trim(),
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }),
      );

      var item = response.data;
      print("Visit Data: $item");
      if (item["success"] == true) {
        setState(() {
          visitEntryBtnClk = false;
        });
        emptyMethod();
        CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
        return "true";
      } else {
        setState(() {
          visitEntryBtnClk = false;
        });
        Utils.showTopSnackBar(context, "${item["message"]}");
        return "false";
      }
    } catch (e) {
      Utils.showTopSnackBar(context, "$e");
      print("Error: $e");
      return "false";
    }
  }
  bool visitEntryBtnClk = false;
}