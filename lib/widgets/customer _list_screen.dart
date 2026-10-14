import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/utils/all_textstyle.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Customer {
  final int sl;
  final String customerId;
  final String customerName;
  final String type; // Retail / Wholesale
  final String phone;
  final String address;

  Customer({
    required this.sl,
    required this.customerId,
    required this.customerName,
    required this.type,
    required this.phone,
    required this.address,
  });
}

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {

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
         isEmployeeListClicked = false;
      }
      if (selectValue == "Retail") {
        getPaymentType = "retail";
         isEmployeeListClicked = false;
      }
      if (selectValue == "Wholesale") {
        getPaymentType = "wholesale";
         isEmployeeListClicked = false;
      }
    });
    print("_paymentType======$getPaymentType");
  }


  // All sample customers
  final List<Customer> allCustomers = [
    Customer(sl: 1, customerId: 'C-1001', customerName: 'Karim Electronics', type: 'Wholesale', phone: '01711-123456', address: 'Motijheel, Dhaka'),
    Customer(sl: 2, customerId: 'C-1002', customerName: 'Rahim Store', type: 'Retail', phone: '01812-234567', address: 'Mirpur, Dhaka'),
    Customer(sl: 3, customerId: 'C-1003', customerName: 'Tech Hub BD', type: 'Wholesale', phone: '01913-345678', address: 'Gulshan, Dhaka'),
    Customer(sl: 4, customerId: 'C-1004', customerName: 'Mobile Point', type: 'Retail', phone: '01614-456789', address: 'Uttara, Dhaka'),
    Customer(sl: 5, customerId: 'C-1005', customerName: 'Digital World', type: 'Wholesale', phone: '01515-567890', address: 'Banani, Dhaka'),
    Customer(sl: 6, customerId: 'C-1006', customerName: 'Smart Gadgets', type: 'Retail', phone: '01316-678901', address: 'Dhanmondi, Dhaka'),
    Customer(sl: 7, customerId: 'C-1007', customerName: 'Computer Bazar', type: 'Wholesale', phone: '01717-789012', address: 'New Market, Dhaka'),
    Customer(sl: 8, customerId: 'C-1008', customerName: 'Phone Zone', type: 'Retail', phone: '01818-890123', address: 'Mohammadpur, Dhaka'),
    Customer(sl: 9, customerId: 'C-1009', customerName: 'Gadget Galaxy', type: 'Wholesale', phone: '01919-901234', address: 'Bashundhara, Dhaka'),
    Customer(sl: 10, customerId: 'C-1010', customerName: 'Local Mobile Shop', type: 'Retail', phone: '01620-012345', address: 'Farmgate, Dhaka'),
    Customer(sl: 11, customerId: 'C-1011', customerName: 'Wholesale King', type: 'Wholesale', phone: '01521-123450', address: 'Chittagong Road'),
    Customer(sl: 12, customerId: 'C-1012', customerName: 'Daily Needs Store', type: 'Retail', phone: '01322-234561', address: 'Khilgaon, Dhaka'),
  ];

  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getPTypeDropdownSize);
    super.initState();
    filteredCustomers = List.from(allCustomers); // Initially show all
  }

  void _searchCustomers() {
    setState(() {
      if (_paymentType == 'All') {
        filteredCustomers = List.from(allCustomers);
      } else {
        filteredCustomers = allCustomers
            .where((customer) => customer.type == _paymentType)
            .toList();
      }

      // Re-assign serial numbers after filtering
      for (int i = 0; i < filteredCustomers.length; i++) {
        filteredCustomers[i] = Customer(
          sl: i + 1,
          customerId: filteredCustomers[i].customerId,
          customerName: filteredCustomers[i].customerName,
          type: filteredCustomers[i].type,
          phone: filteredCustomers[i].phone,
          address: filteredCustomers[i].address,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // ========== Table Section ==========
            Expanded(
              child: filteredCustomers.isEmpty
                  ? Center(
                      child: Text(
                        'No customer found',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    )
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
                            DataColumn(label: Text('Type',style: AllTextStyle.tableHeadTextStyle)),
                            DataColumn(label: Text('Phone',style: AllTextStyle.tableHeadTextStyle)),
                            DataColumn(label: Text('Address',style: AllTextStyle.tableHeadTextStyle)),
                          ],
                          rows: filteredCustomers.map((customer) {
                            return DataRow(
                              cells: [
                                DataCell(Text(customer.sl.toString())),
                                DataCell(Text(customer.customerId,style: AllTextStyle.tableDataTextStyle)),
                                DataCell(Text(customer.customerName,style: AllTextStyle.tableDataTextStyle)),
                                DataCell(
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: customer.type == 'Wholesale'
                                          ? Colors.blue.shade50
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Text(
                                      customer.type,
                                      style: TextStyle(
                                        color: customer.type == 'Wholesale'
                                            ? Colors.blue.shade700
                                            : Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(customer.phone,style: AllTextStyle.tableDataTextStyle)),
                                DataCell(Text(customer.address,style: AllTextStyle.tableDataTextStyle)),
                              ],
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
}