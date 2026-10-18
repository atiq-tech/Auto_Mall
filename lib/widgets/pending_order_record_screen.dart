//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget/custom_appbar.dart';
import '../../utils/all_textstyle.dart';
import '../../utils/utils.dart';

class PendingOrderRecordScreen extends StatefulWidget {
  const PendingOrderRecordScreen({super.key});

  @override
  State<PendingOrderRecordScreen> createState() => _PendingOrderRecordScreenState();
}

class _PendingOrderRecordScreenState extends State<PendingOrderRecordScreen> {
  Color getPurple(Set<WidgetState> states) {return Colors.teal.shade50;}
  Color getBlue(Set<WidgetState> states) {return Colors.blue.shade50;}
  Color getOrange(Set<WidgetState> states) {return Colors.orange.shade100;}
  Color getWhite(Set<WidgetState> states) {return Colors.white;}
  final TextEditingController customerController = TextEditingController();
  final TextEditingController employeeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController userController = TextEditingController();

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
    print("userEmployeeId==== $userEmployeeId");
    print("userName==== $userName");
    print("userID==== $userID");
    print("userType==== $userType");
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
                            Divider(height: 1.h, thickness: 0.8, color: Colors.teal.shade400),
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getRecordDropdownSize);
    _selectedRecordTypes = "Without Details";
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:"Pending Order Record"),
      body: Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h, bottom: 10.h),
        child: Column(
          children: [
            Card(
              elevation: 5,
              color: Colors.indigo.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
                side: BorderSide(color: Colors.indigo.shade400,width: 1.5.w), // ← your desired radius
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h, bottom: 4.h),
                child: Column(
                  children: [
                     Row(
                      children: [
                        Expanded(flex: 1, child: Text("Record Type", style: AllTextStyle.searchTypeTxtStyle)),
                        Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                        Expanded(
                        flex: 3,
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
                    Container(
                      height: 25.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 5.h),
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
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Color.fromARGB(221, 22, 51, 95),
                                        size: 16.r,
                                      ),
                                    ),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: firstPickedDate ,
                                    hintStyle:  TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Color.fromARGB(221, 22, 51, 95),
                                        size: 16.r,
                                      ),
                                    ),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: secondPickedDate,
                                    hintStyle: TextStyle(
                                      fontSize: 13,color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400,),
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
                    /// Date Picker
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(1.r),
                        child: InkWell(
                          onTap: () async {
                            
                          },
                          child: Container(
                            height: 28.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color:  Colors.indigo,
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
                            child: const Center(child: Text("Show Report", style: AllTextStyle.saveButtonTextStyle)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}