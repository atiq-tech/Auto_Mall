library;
import 'dart:convert';
import 'dart:io';
import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/all_textstyle.dart';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;

class CustomerEntryScreen extends StatefulWidget {
   const CustomerEntryScreen({super.key,});
  @override
  State<CustomerEntryScreen> createState() => _CustomerEntryScreenState();
}

class _CustomerEntryScreenState extends State<CustomerEntryScreen> {
  Color getColor(Set<WidgetState> states) {
    return Colors.blue.shade200;
  }

  Color getColors(Set<WidgetState> states) {
    return Colors.white;
  }
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _OwnerNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _officePhoneController = TextEditingController();
  final TextEditingController _previousDueController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _employeeCustomerController = TextEditingController();
  final TextEditingController _tradelicenseController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _LongitudeController = TextEditingController();

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
  }

  String? _Get_customerType="retail";
  String? employeeSlNo;
  String? areaSlNo;
  String? zoneSlNo;
  String? outletsSlNo;
  String? routeSlNo;
  String? employeeId = "";
  String? userEmployeeId = "";
  String userName = "";
  String userType = "";

  File? _image;
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 800.w,
        maxHeight: 800.h,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        if (mounted) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeData();
     WidgetsBinding.instance.addPostFrameCallback((_) {
     if(!mounted) return;
       CustomersProvider().on();
       Provider.of<CustomersProvider>(context,listen: false).getCustomers("");
    // Provider.of<EmployeeProvider>(context,listen: false).getEmployee();
    // Provider.of<AreaProvider>(context,listen: false).getArea();
    // Provider.of<ZoneProvider>(context,listen: false).getZone();
    // Provider.of<CustomerListProvider>(context, listen: false).customerList = [];
    // Provider.of<RouteProvider>(context, listen: false).getRoute();
     });
    userName = _employeeCustomerController.text;
    print("eeeeeeeeeeeeeeee======  ${_employeeCustomerController.text}");
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
        mainScrollController.animateTo(50,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
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

  var areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mainScrollController.addListener(mainScrollListener);
    // final allAreaData = Provider.of<AreaProvider>(context).allAreaList;
    // final allZoneData = Provider.of<ZoneProvider>(context).zoneList;
    // final allRouteData = Provider.of<RouteProvider>(context).allRouteList;
    // final allEmployeeData = Provider.of<EmployeeProvider>(context).allEmployeeList;
    final customersData = Provider.of<CustomersProvider>(context).customersList
    .where((customer) =>customer.customerName != "Cash Customer" && customer.customerName != "New Customer")
    .toList();
    return Scaffold(
      appBar: CustomAppBar(title: "Customer Entry"),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color.fromARGB(255, 7, 125, 180), width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2.r, blurRadius: 5.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Customer Name",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 25.h,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _customerNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Customer Name",
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
                       Expanded(flex: 6,child: Text("Owner Name",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 25.h,
                            child: TextField(
                              style:  AllTextStyle.dropDownlistStyle,
                              controller: _OwnerNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Owner Name",
                                hintStyle:  AllTextStyle.textValueStyle,
                                contentPadding: const EdgeInsets.only(left: 5),
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
                                hintText: "Enter Address Name",
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
                        Expanded(flex: 6,child: Text("Area",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 25.h,
                            decoration: ContDecoration.contDecoration,
                            // child: TypeAheadFormField(
                            //   textFieldConfiguration: TextFieldConfiguration(
                            //       onChanged: (value) {
                            //         if (value == '') {
                            //           areaSlNo = '';
                            //         }
                            //       },
                            //       style: AllTextStyle.dropDownlistStyle,
                            //       controller: areaController,
                            //       decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 10,left: 5.0),
                            //           hintText: 'Select Area',
                            //           hintStyle: AllTextStyle.textValueStyle,
                            //           suffixIcon: areaSlNo == "null" || areaSlNo == "" || areaController.text == "" || areaSlNo == null ? null
                            //               : GestureDetector(
                            //             onTap: () {
                            //               setState(() {
                            //                 areaController.text = '';
                            //               });
                            //             },
                            //             child: const Padding(padding: EdgeInsets.only(left: 6, right: 6), child: Icon(Icons.close, size: 16)),
                            //           ),
                            //           suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                            //           filled: true,
                            //           fillColor: Colors.white,
                            //           border: InputBorder.none,
                            //           focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                            //           enabledBorder:TextFieldInputBorder.focusEnabledBorder
                            //       )),
                            //   suggestionsCallback: (pattern) {
                            //     return allAreaData.where((element) => element.districtName.toString().toLowerCase().contains(pattern.toString().toLowerCase())).take(allAreaData.length).toList();
                            //   },
                            //   itemBuilder: (context, suggestion) {
                            //     return SizedBox(
                            //       child: Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            //         child: Text("${suggestion.districtName} - ${suggestion.districtSlNo}",
                            //             style: const TextStyle(fontSize: 12),
                            //             maxLines: 1, overflow: TextOverflow.ellipsis),
                            //       ),
                            //     );
                            //   },
                            //   transitionBuilder: (context, suggestionsBox, controller) {
                            //     return suggestionsBox;
                            //   },
                            //   onSuggestionSelected: (AreaModel suggestion) {
                            //     areaController.text = suggestion.districtName;
                            //     setState(() {
                            //       areaSlNo = suggestion.districtSlNo.toString();
                            //     });
                            //   },
                            //   onSaved: (value) {},
                            // ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    ///===new
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(flex: 6,child: Text("Mobile",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _mobileController,
                                        decoration: InputDecoration(
                                          hintText: "Enter Mobile No",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Expanded(flex: 6,child: Text("Office Phone",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _officePhoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "Enter Phone No",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder: TextFieldInputBorder.focusEnabledBorder,
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
                                  Expanded(flex: 6,child: Text("Previous Due",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _previousDueController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
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
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Expanded(flex: 6,child: Text("Credit Limit",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 25.h,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _creditLimitController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
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
                              ),
                            ],),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _image != null
                                  ? Container(
                                height: 85.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  image: DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ) : Container(
                                height: 85.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(color: Colors.white,width: 2.w)
                                ),
                                child: Center(child: Text("No Image Available",textAlign:TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 12.sp,fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(height: 5.h),
                              InkWell(
                                onTap: () async {
                                  await _pickImage();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade600,
                                    borderRadius: BorderRadius.circular(5.r),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 2.r,blurRadius: 5.r, offset: const Offset(0, 3)),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.r),
                                    child: Center(child: Text(
                                        "Select Image",style: TextStyle(fontSize: 12.sp,color: Colors.white,fontWeight: FontWeight.w500))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Cus Type : ",style: AllTextStyle.textFieldHeadStyle),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.80,
                                child: Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  fillColor: MaterialStateColor.resolveWith((states) => AppColors.appColor),
                                  value: "retail",
                                  groupValue: _Get_customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _Get_customerType = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox(child: Text("Retail",maxLines: 2,overflow: TextOverflow.ellipsis,style: AllTextStyle.textFieldHeadStyle))),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.80,
                                child: Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  fillColor: MaterialStateColor.resolveWith((states) => AppColors.appColor),
                                  value: "wholesale",
                                  groupValue: _Get_customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _Get_customerType = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox(child: Text("Wholesale",maxLines: 2,overflow: TextOverflow.ellipsis,style: AllTextStyle.textFieldHeadStyle))),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.80,
                                child: Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  fillColor: MaterialStateColor.resolveWith((states) => AppColors.appColor),
                                  value: "dealer",
                                  groupValue: _Get_customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _Get_customerType = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox(child: Text("Dipo/Dealers",maxLines: 2,overflow: TextOverflow.ellipsis,style: AllTextStyle.textFieldHeadStyle))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () async {
                          // final connectivityResult = await (Connectivity().checkConnectivity());
                          // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            Utils.closeKeyBoard(context);
                          if(_customerNameController.text==''){
                            Utils.errorSnackBar(context, "Customer name is required");
                          }
                          else if(areaController.text==''){
                            Utils.errorSnackBar(context, "Area field is required");
                          }
                          else if (userName == 'Admin') {
                            if (_employeeController.text == '') {
                              Utils.errorSnackBar(context, "Employee field is required");
                            }
                          }
                          else if(_zoneController.text==''){
                            Utils.errorSnackBar(context, "Zone field is required");
                          }
                          else if(_routeController.text==''){
                            Utils.errorSnackBar(context, "Route field is required");
                          }
                          else if(_mobileController.text==''){
                            Utils.errorSnackBar(context, "Mobile field is required");
                          }
                          else if(_tradelicenseController.text==''){
                            Utils.errorSnackBar(context, "Trade License field is required");
                          }
                          else if(_locationController.text==''){
                            Utils.errorSnackBar(context, "Location field is required");
                          }
                          else if(_latitudeController.text==''){
                            Utils.errorSnackBar(context, "Latitude field is required");
                          }
                          else if(_LongitudeController.text==''){
                            Utils.errorSnackBar(context, "Longitude field is required");
                          }
                          else{
                            setState(() {
                              customerEntryBtnClk = true;
                            });
                                customerEntry(context).then((value){
                                 //Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("","","");
                                 setState(() {
                                });
                            });
                           }
                          // }
                          // else{
                          //   Utils.errorSnackBar(context, "Please check your internet connection");
                          // }
                        },
                        child: Container(
                          height: 25.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                            color: AppColors.appColor,
                            borderRadius: BorderRadius.circular(5.r),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 2.r,blurRadius: 5.r, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: Center(child: customerEntryBtnClk ? SizedBox(height: 20.h,width:20.w,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                "SAVE",style: AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            CustomersProvider.isCustomersLoading ? const buildBeautifulLoading() 
              : Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
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
                      headingRowHeight: 16.h,
                      dataRowHeight: 16.h,
                      headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.cyan.shade200, width: 1.w),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Added Date',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Owner Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Area',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Contact Number',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Type',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Credit Limit',style: AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows: List.generate(
                        customersData.length > 100 ? 100 : customersData.length,
                            (int index) => DataRow(
                              color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
                          cells: <DataCell>[
                            DataCell(
                              Center(
                                child: Text(
                                  customersData[index].addTime == null ||
                                          customersData[index].addTime.toString().isEmpty
                                      ? ""
                                      : DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                            customersData[index].addTime.toString(),
                                          ),
                                        ),
                                  style: AllTextStyle.tableDataTextStyle,
                                ),
                              ),
                            ),
                            DataCell(Center(child: Text('${customersData[index].customerCode??""}',style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text('${customersData[index].customerName??""}',style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text('${customersData[index].ownerName??""}',style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text('${customersData[index].districtName??""}',style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text('${customersData[index].customerMobile??""}',style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text('${customersData[index].customerType??""}',style: AllTextStyle.tableDataTextStyle))),
                            DataCell(Center(child: Text('${customersData[index].customerCreditLimit??""}',style: AllTextStyle.tableDataTextStyle))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
  emptyMethod() {
    setState(() {
      _customerNameController.text = "";
      _mobileController.text = "";
      _officePhoneController.text = "";
      _addressController.text = "";
      _OwnerNameController.text = "";
       areaController.text = "";
       _employeeController.text="";
      _creditLimitController.text = "";
      _previousDueController.text = "";
     _zoneController.text = "";
      _routeController.text = "";
      _tradelicenseController.text = "";
      _locationController.text = "";
      _latitudeController.text = "";
      _LongitudeController.text = "";
      _image = null;
    });
  }

  Future<String> customerEntry(BuildContext context) async {
    String link = "${baseUrl}api/v1/addCustomer";
    var data = {
        "Customer_SlNo":"",
        "Customer_Code":"",
        "Customer_Name": _customerNameController.text.trim(),
        "Customer_Type":_Get_customerType.toString().trim(),
        "Customer_Mobile":_mobileController.text.trim(),
        "Trade_Licence":_tradelicenseController.text.trim(),
        "location":_locationController.text.trim(),
        "Customer_OfficePhone":_officePhoneController.text.trim(),
        "Customer_Address":_addressController.text.trim(),
        "owner_name": _OwnerNameController.text.trim(),
        "area_ID":areaSlNo.toString().trim(),
        "employee_id":userType == "m"||userType == "a" ? "$employeeSlNo" : userEmployeeId,
        "route_id":routeSlNo.toString().trim(),
        "latitude":_latitudeController.text.toString().trim(),
        "longitude":_LongitudeController.text.toString().trim(),
        "Customer_Credit_Limit":_creditLimitController.text.trim(),
        "previous_due":_previousDueController.text.trim(),
        "zone_id":zoneSlNo.toString().trim(),
    };

    FormData formData = FormData.fromMap({
      "data": jsonEncode(data),
      if (_image != null)
        "image": await MultipartFile.fromFile(_image!.path, filename: "customer_image.jpg"),
    });
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(link, data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
     var item = jsonDecode(response.data);
      if (item["success"] == true) {
        setState(() {
          customerEntryBtnClk = false;
        });
        emptyMethod();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 4, 108, 156),
            duration: const Duration(seconds: 2),
            content: Center(child: Text("${item["message"]}", style: const TextStyle(color: Colors.white))),
          ),
        );
        return "true";
      } else {
        setState(() {
          customerEntryBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
            content: Center(child: Text("${item["message"]}", style: const TextStyle(color: Colors.red)))),
        );
        return "false";
      }
    } catch (e) {
      print("Error: $e");
      return "false";
    }
  }
  bool customerEntryBtnClk = false;
  Future<void> getLocationFromCoordinates(double lat, double lng) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String location = data['display_name'] ?? "Unknown Location";
      setState(() {
        _locationController.text = location;
      });
    } else {
      setState(() {
        _locationController.text = "Error fetching location";
      });
    }
  }
}