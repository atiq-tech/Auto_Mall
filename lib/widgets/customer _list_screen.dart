import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/providers/customers_provider.dart';
import 'package:auto_mall/utils/all_textstyle.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
Color getBlue(Set<WidgetState> states) {return Colors.indigo.shade100;}
Color getWhite(Set<WidgetState> states) {return Colors.white;}

bool isEmployeeListClicked = false;
  bool _isDropdownOpen = false;
  String? getPaymentType = "";
  String? _paymentType = 'All';
  final List<String> _paymentTypeList = [
    'All',
    'Retail',
    'Wholesale' 
  ];
 
final LayerLink _pTypeLayerLink = LayerLink();
  OverlayEntry? _pTypeOverlayEntry;

  final GlobalKey _pkey = GlobalKey();
  Size _pTypeDropdownSize = Size.zero;
 
  void _getPTypeDropdownSize(Duration _) {
    final RenderBox renderBox = _pkey.currentContext?.findRenderObject() as RenderBox;
    _pTypeDropdownSize = renderBox.size;
  }
 
  void _togglePTypeDropdown() {
    if (_isDropdownOpen) {
      _removePTypeDropdown();
    } else {
      _showPTypeDropdown();
    }
  }
 
  void _showPTypeDropdown() {
    _pTypeOverlayEntry = _createPTypeOverlayEntry();
    Overlay.of(context).insert(_pTypeOverlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }
 
  void _removePTypeDropdown() {
    _pTypeOverlayEntry?.remove();
    _pTypeOverlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }
 
  OverlayEntry _createPTypeOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removePTypeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: _pTypeDropdownSize.width,
              child: CompositedTransformFollower(
                link: _pTypeLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, _pTypeDropdownSize.height + 2),
                child: Material(
                  elevation: 9.0,
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(5.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _paymentTypeList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final type = entry.value;
                      return InkWell(
                        onTap: () {
                          _onSelectedPType(type);
                          _removePTypeDropdown();
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Text(type, style: AllTextStyle.dropDownlistStyle),
                            ),
                            if (index != _paymentTypeList.length - 1)
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
 
  void _onSelectedPType(String selectValue) {
    setState(() {
      _paymentType = selectValue;
      if (selectValue == "All") {
        getPaymentType = "";
      }
      if (selectValue == "Retail") {
        getPaymentType = "retail";
      }
      if (selectValue == "Wholesale") {
        getPaymentType = "wholesale";
      }
    });
    print("_paymentType======$getPaymentType");
  }

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _getPTypeDropdownSize(Duration.zero);

    if (!mounted) return;

    Provider.of<CustomersProvider>(
      context,
      listen: false,
    ).getCustomers("");
  });
}


  void _searchCustomers() {
    setState(() {
      CustomersProvider().on();
      Provider.of<CustomersProvider>(context, listen: false).getCustomers("$getPaymentType");
    });
  }

  @override
  Widget build(BuildContext context) {
    final customersData = Provider.of<CustomersProvider>(context).customersList
    .where((customer) =>customer.customerName != "Cash Customer" && customer.customerName != "New Customer")
    .toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: CustomAppBar(title: "Customer List"),
      body: Padding(
        padding: EdgeInsets.all(5.r),
        child: Column(
          children: [
            // ========== Search Section ==========
            Card(
              elevation: 3,
              color: Colors.indigo.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
              child: Padding(
                padding: EdgeInsets.only(left: 6.w,right: 3.w,top: 2.h,bottom: 2.h),
                child: Row(
                  children: [
                    // Dropdown
                    Expanded(flex: 2,child: Text("Search Type : ",style: AllTextStyle.textFieldHeadStyle)),
                    Expanded(
                      flex: 3,
                      child: CompositedTransformTarget(
                      link: _pTypeLayerLink,
                      child: GestureDetector(
                      onTap: _togglePTypeDropdown,
                      child: Container(
                      key: _pkey,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      height: 25.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0.r),
                          border: Border.all(color: Colors.grey.shade400, width: 1.0.w),
                        ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text( _paymentType!,style: AllTextStyle.dropDownlistStyle),
                      GestureDetector(
                        onTap: _togglePTypeDropdown,
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
                    SizedBox(width: 3.w),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _searchCustomers,
                        child: Card(
                          elevation: 2,
                          color: AppColors.appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Container(
                            height: 25.h,
                            alignment: Alignment.center,
                            child: Text('Search',style: AllTextStyle.saveButtonTextStyle),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           SizedBox(height: 5.h),
            Expanded(
             child: CustomersProvider.isCustomersLoading ? const buildBeautifulLoading() : customersData.isEmpty ? Center(child: Text('No customer found',style: AllTextStyle.nofoundTextStyle),)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowHeight: 17.h,
                      dataRowHeight: 17.h,
                      headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.blueGrey, width: 1.w),
                      columns: [
                        DataColumn(label: Text('Sl',style: AllTextStyle.tableHeadTextStyle)),
                        DataColumn(label: Text('Customer Id',style: AllTextStyle.tableHeadTextStyle)),
                        DataColumn(label: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)),
                        DataColumn(label: Text('Address',style: AllTextStyle.tableHeadTextStyle)),
                        DataColumn(label: Text('Contact No.',style: AllTextStyle.tableHeadTextStyle)),
                      ],
                      rows:  customersData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final customer = entry.value;
                        return DataRow(
                          color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getBlue) : WidgetStateProperty.resolveWith(getWhite),
                          cells: [
                            DataCell(Text("${index+1}",style: AllTextStyle.tableDataTextStyle)),
                            DataCell(Text(customer.customerCode,style: AllTextStyle.tableDataTextStyle)),
                            DataCell(Text(customer.customerName, style: AllTextStyle.tableDataTextStyle)),
                            DataCell(Text(customer.customerAddress,style: AllTextStyle.tableDataTextStyle)),
                            DataCell(Text(customer.customerMobile,style: AllTextStyle.tableDataTextStyle)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}