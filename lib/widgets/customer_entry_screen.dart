library;
import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/common_widget/type_ahead_searching_field.dart';
import 'package:auto_mall/models/areas_model.dart';
import 'package:auto_mall/providers/areas_provider.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/utils/animation_snackbar.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/all_textstyle.dart';
import '../utils/utils.dart';

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
  var employeeController = TextEditingController();
  var customerNameController = TextEditingController();
  var ownerNameController = TextEditingController();
  var addressController = TextEditingController();
  var mobileController = TextEditingController();
  var officePhoneController = TextEditingController();
  var previousDueController = TextEditingController();
  var creditLimitController = TextEditingController();
  var areaController = TextEditingController();

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
  }

  String? _customerType = "retail";
  String? employeeSlNo;
  String? areaId;
  String? employeeId = "";
  String? userEmployeeId = "";
  String userName = "";
  String userType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeData();
     WidgetsBinding.instance.addPostFrameCallback((_) {
     if(!mounted) return;
       CustomersProvider().on();
       Provider.of<CustomersProvider>(context,listen: false).getCustomers("");
       Provider.of<AreasProvider>(context,listen: false).getAreas();
     });
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
    final areasData = Provider.of<AreasProvider>(context).areasList;
    final customersData = Provider.of<CustomersProvider>(context).customersList
    .where((customer) => customer.customerName != "Cash Customer" && customer.customerName != "New Customer").toList();
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
                              controller: customerNameController,
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
                              controller: ownerNameController,
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
                              controller: addressController,
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
                          child: Column(children: [
                            Row(
                              children: [
                                Expanded(flex: 6,child: Text("Mobile",style: AllTextStyle.textFieldHeadStyle)),
                                const Expanded(flex: 1, child: Text(":")),
                                Expanded(
                                  flex: 11,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.dropDownlistStyle,
                                      controller: mobileController,
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
                                  flex: 11,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.dropDownlistStyle,
                                      controller: officePhoneController,
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
                                  flex: 11,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.dropDownlistStyle,
                                      controller: previousDueController,
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
                                  flex: 11,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.dropDownlistStyle,
                                      controller: creditLimitController,
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
                                  groupValue: _customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _customerType = value;
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
                                  groupValue: _customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _customerType = value;
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
                                  groupValue: _customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _customerType = value;
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
                          Utils.closeKeyBoard(context);
                          if(customerNameController.text==''){
                            Utils.errorSnackBar(context, "Customer name is required");
                          }
                          else if(areaController.text==''){
                            Utils.errorSnackBar(context, "Area field is required");
                          }
                          else{
                          setState(() {
                            customerEntryBtnClk = true;
                          });
                            customerEntry(context).then((value){
                            Provider.of<CustomersProvider>(context, listen: false).getCustomers("");
                            setState(() {
                            });
                          });
                          }
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
                                  customersData[index].addTime == null || customersData[index].addTime.toString().isEmpty
                                      ? "" : DateFormat('dd-MM-yyyy').format(DateTime.parse(customersData[index].addTime.toString())),
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
      customerNameController.text = "";
      mobileController.text = "";
      officePhoneController.text = "";
      addressController.text = "";
      ownerNameController.text = "";
      areaController.text = "";
      employeeController.text="";
      creditLimitController.text = "";
      previousDueController.text = "";
    });
  }

  bool customerEntryBtnClk = false;
  Future<String> customerEntry(BuildContext context) async {
    var data = {
      "Customer_Name": customerNameController.text.trim(),
      "Customer_Type": _customerType.toString().trim(),
      "Customer_Mobile": mobileController.text.trim(),
      "Customer_OfficePhone": officePhoneController.text.trim(),
      "Customer_Address": addressController.text.trim(),
      "owner_name": ownerNameController.text.trim(),
      "area_ID": areaId.toString().trim(),
      "Customer_Credit_Limit": creditLimitController.text.trim(),
      "previous_due": previousDueController.text.trim(),
      "Customer_Email": "",
      "Customer_Phone": "",
    };
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(addCustomer,
        data: data, 
        options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "${sharedPreferences.getString("token")}",
          },
        ),
      );

      var item = response.data;
      if (item["success"] == true) {
        setState(() {
          customerEntryBtnClk = false;
        });
        emptyMethod();
        CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
        return "true";
      } else {
        setState(() {
          customerEntryBtnClk = false;
        });
        Utils.showTopSnackBar(context, "${item["message"]}");
        return "false";
      }
    } catch (e) {
      Utils.showTopSnackBar(context, "$e");
      print("Error: $e");
      setState(() {
        customerEntryBtnClk = false;
      });
      return "false";
    }
  }
}