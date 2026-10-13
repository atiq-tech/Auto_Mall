import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProductItem {
  String code;
  String name;
  String category;
  double qty;
  double rate;
  double discount;
  double total;

  ProductItem({
    required this.code,
    required this.name,
    required this.category,
    required this.qty,
    required this.rate,
    this.discount = 0,
  }) : total = (qty * rate) - discount;
}

class SaleInvoiceScreen extends StatefulWidget {
  const SaleInvoiceScreen({super.key});

  @override
  State<SaleInvoiceScreen> createState() => _SaleInvoiceScreenState();
}

class _SaleInvoiceScreenState extends State<SaleInvoiceScreen> {
  // Header
  final TextEditingController invoiceNoCtrl = TextEditingController(text: '260100022');
  String? selectedEmployee;
  String saleFrom = 'Main Branch';
  DateTime selectedDate = DateTime(2026, 10, 12);

  // Customer
  String salesType = 'Retail';
  final TextEditingController customerCtrl = TextEditingController(text: 'Cash Customer');
  final TextEditingController nameCtrl = TextEditingController(text: 'Cash Customer');
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  // Product Entry
  String? selectedProduct;
  final TextEditingController saleRateCtrl = TextEditingController(text: '0');
  final TextEditingController qtyCtrl = TextEditingController(text: '0');
  final TextEditingController discountPercentCtrl = TextEditingController(text: '0.00');
  final TextEditingController amountCtrl = TextEditingController(text: '0');
  final TextEditingController warrantyCtrl = TextEditingController();

  // Amount Details
  final TextEditingController subTotalCtrl = TextEditingController(text: '300.00');
  final TextEditingController exchangeTotalCtrl = TextEditingController(text: '150.00');
  final TextEditingController discountCtrl = TextEditingController(text: '0.00');
  final TextEditingController discountPercent2Ctrl = TextEditingController(text: '0');
  final TextEditingController vatCtrl = TextEditingController(text: '0');
  final TextEditingController vatPercentCtrl = TextEditingController(text: '0.00');
  final TextEditingController transportCtrl = TextEditingController(text: '0');
  final TextEditingController totalCtrl = TextEditingController(text: '150.00');
  final TextEditingController cashPaidCtrl = TextEditingController(text: '150.00');
  final TextEditingController bankPaidCtrl = TextEditingController(text: '0');
  final TextEditingController dueCtrl = TextEditingController(text: '0');
  bool isCredit = false;

  // Note
  final TextEditingController noteCtrl = TextEditingController();

  // Replacement
  String? selectedReplacementProduct;
  final TextEditingController repPriceCtrl = TextEditingController(text: '0');
  final TextEditingController repQtyCtrl = TextEditingController(text: '0');
  final TextEditingController repAmountCtrl = TextEditingController(text: '0');

  List<ProductItem> cartItems = [
    ProductItem(code: 'P00003', name: 'Coolant', category: 'liquite', qty: 2, rate: 150.00),
  ];

  List<ProductItem> replacementItems = [
    ProductItem(code: 'P00003', name: 'Coolant', category: 'liquite', qty: 1, rate: 150.00),
  ];

  final List<String> employees = ['Select Employee', 'Employee 1', 'Employee 2', 'Employee 3'];
  final List<String> branches = ['Main Branch', 'Branch 2', 'Branch 3'];
  final List<String> products = ['Select Product', 'Coolant', 'Oil', 'Filter', 'Battery'];

  void _calculateTotals() {
    double subTotal = cartItems.fold(0, (sum, item) => sum + item.total);
    double exchange = replacementItems.fold(0, (sum, item) => sum + item.total);
    double discount = double.tryParse(discountCtrl.text) ?? 0;
    double vat = double.tryParse(vatCtrl.text) ?? 0;
    double transport = double.tryParse(transportCtrl.text) ?? 0;

    double total = subTotal - exchange - discount + vat + transport;

    setState(() {
      subTotalCtrl.text = subTotal.toStringAsFixed(2);
      exchangeTotalCtrl.text = exchange.toStringAsFixed(2);
      totalCtrl.text = total.toStringAsFixed(2);

      double cash = double.tryParse(cashPaidCtrl.text) ?? 0;
      double bank = double.tryParse(bankPaidCtrl.text) ?? 0;
      dueCtrl.text = (total - cash - bank).toStringAsFixed(2);
    });
  }

  void _addToCart() {
    if (selectedProduct == null || selectedProduct == 'Select Product') return;
    double rate = double.tryParse(saleRateCtrl.text) ?? 0;
    double qty = double.tryParse(qtyCtrl.text) ?? 0;
    double disc = double.tryParse(discountPercentCtrl.text) ?? 0;
    if (qty <= 0) return;

    setState(() {
      cartItems.add(ProductItem(
        code: 'P${(cartItems.length + 1).toString().padLeft(5, '0')}',
        name: selectedProduct!,
        category: 'General',
        qty: qty,
        rate: rate,
        discount: disc,
      ));
      _calculateTotals();
      selectedProduct = 'Select Product';
      saleRateCtrl.text = '0';
      qtyCtrl.text = '0';
      discountPercentCtrl.text = '0.00';
      amountCtrl.text = '0';
    });
  }

  void _addReplacement() {
    if (selectedReplacementProduct == null || selectedReplacementProduct == 'Select Product') return;
    double price = double.tryParse(repPriceCtrl.text) ?? 0;
    double qty = double.tryParse(repQtyCtrl.text) ?? 0;
    if (qty <= 0) return;

    setState(() {
      replacementItems.add(ProductItem(
        code: 'P${(replacementItems.length + 1).toString().padLeft(5, '0')}',
        name: selectedReplacementProduct!,
        category: 'General',
        qty: qty,
        rate: price,
      ));
      _calculateTotals();
      selectedReplacementProduct = null;
      repPriceCtrl.text = '0';
      repQtyCtrl.text = '0';
      repAmountCtrl.text = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0F8),
      appBar: AppBar(
        title: const Text('Sale Invoice', style: TextStyle(fontSize: 18)),
        backgroundColor: AppColors.appColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== HEADER (Mobile Friendly) ==========
              _buildHeaderCard(),
              const SizedBox(height: 10),

              // ========== Customer Information ==========
              _buildSection(
                title: 'Customer Information',
                child: Column(
                  children: [
                    // Sales Type
                    Row(
                      children: [
                        const Text('Sales Type', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 8),
                        Radio<String>(
                          value: 'Retail',
                          groupValue: salesType,
                          onChanged: (v) => setState(() => salesType = v!),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const Text('Retail', style: TextStyle(fontSize: 13)),
                        Radio<String>(
                          value: 'Wholesale',
                          groupValue: salesType,
                          onChanged: (v) => setState(() => salesType = v!),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const Text('Wholesale', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _buildMobileField('Customer', customerCtrl, hasAdd: true),
                    _buildMobileField('Name', nameCtrl),
                    _buildMobileField('Mobile No', mobileCtrl, hint: 'Mobile No'),
                    _buildMobileField('Address', addressCtrl, hint: 'Address'),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ========== Product Information ==========
              _buildSection(
                title: 'Product Information',
                child: Column(
                  children: [
                    _buildMobileDropdown('Product', selectedProduct ?? 'Select Product', products, (v) {
                      setState(() => selectedProduct = v);
                    }, hasAdd: true),
                    Row(
                      children: [
                        Expanded(child: _buildMobileField('Sale Rate', saleRateCtrl, isNumber: true)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildMobileField('Qty', qtyCtrl, isNumber: true)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildMobileField('Discount %', discountPercentCtrl, isNumber: true)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade100,
                            ),
                            child: const Text('TK', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                    _buildMobileField('Amount', amountCtrl, isNumber: true),
                    _buildMobileField('Warranty day', warrantyCtrl, hint: 'Warranty'),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC45C26),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Add to Cart', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ========== Cart Table (Horizontal Scroll) ==========
              _buildSection(
                title: 'Cart Items',
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildCartTable(),
                ),
              ),
              const SizedBox(height: 10),

              // ========== Note ==========
              _buildSection(
                title: 'Note',
                child: TextField(
                  controller: noteCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write note here...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ========== Replacement Product ==========
              _buildSection(
                title: 'Replacement Product Information',
                child: Column(
                  children: [
                    _buildMobileDropdown('Product', selectedReplacementProduct ?? 'Select Product', products, (v) {
                      setState(() => selectedReplacementProduct = v);
                    }),
                    Row(
                      children: [
                        Expanded(child: _buildMobileField('Price', repPriceCtrl, isNumber: true)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildMobileField('Qty', repQtyCtrl, isNumber: true)),
                      ],
                    ),
                    _buildMobileField('Amount', repAmountCtrl, isNumber: true),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addReplacement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B9BD5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Add Replacement', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildReplacementTable(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ========== Amount Details ==========
              _buildSection(
                title: 'Amount Details',
                child: Column(
                  children: [
                    _buildAmountRow('Sub Total', subTotalCtrl, readOnly: true),
                    _buildAmountRow('Exchange Total', exchangeTotalCtrl, readOnly: true),
                    Row(
                      children: [
                        const SizedBox(width: 100, child: Text('Discount', style: TextStyle(fontSize: 13))),
                        Expanded(
                          child: TextField(
                            controller: discountCtrl,
                            style: const TextStyle(fontSize: 13),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (_) => _calculateTotals(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('%'),
                        ),
                        SizedBox(
                          width: 55,
                          child: TextField(
                            controller: discountPercent2Ctrl,
                            style: const TextStyle(fontSize: 13),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const SizedBox(width: 100, child: Text('Vat', style: TextStyle(fontSize: 13))),
                        Expanded(
                          child: TextField(
                            controller: vatCtrl,
                            style: const TextStyle(fontSize: 13),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (_) => _calculateTotals(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('%'),
                        ),
                        SizedBox(
                          width: 55,
                          child: TextField(
                            controller: vatPercentCtrl,
                            style: const TextStyle(fontSize: 13),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _buildAmountRow('Transport Cost', transportCtrl, onChanged: (_) => _calculateTotals()),
                    const Divider(height: 16),
                    _buildAmountRow('Total', totalCtrl, readOnly: true, bold: true),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildAmountRow('Cash Paid', cashPaidCtrl, onChanged: (_) => _calculateTotals())),
                        const SizedBox(width: 8),
                        Expanded(child: _buildAmountRow('Bank Paid', bankPaidCtrl, onChanged: (_) => _calculateTotals())),
                      ],
                    ),
                    _buildAmountRow('Due', dueCtrl, readOnly: true, valueColor: Colors.red),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Checkbox(
                          value: isCredit,
                          onChanged: (v) => setState(() => isCredit = v!),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const Text('Is Credit', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sale Completed Successfully!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF28A745),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                cartItems.clear();
                                replacementItems.clear();
                                noteCtrl.clear();
                                cashPaidCtrl.text = '0';
                                bankPaidCtrl.text = '0';
                                _calculateTotals();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5B2C6F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('New Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF5B9BD5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Invoice No + Date
          Row(
            children: [
              const Text('Invoice no', style: TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: invoiceNoCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.calendar_today, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Sale By
          Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text('Sale By', style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedEmployee ?? 'Select Employee',
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      items: employees.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => selectedEmployee = v),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Sale From
          Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text('Sale From', style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: saleFrom,
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      items: branches.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => saleFrom = v!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB8D4E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF5B9BD5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileField(String label, TextEditingController controller, {String? hint, bool hasAdd = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 13),
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          if (hasAdd)
            Container(
              height: 40,
              width: 36,
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFC45C26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool hasAdd = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          if (hasAdd)
            Container(
              height: 40,
              width: 36,
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFC45C26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, TextEditingController controller, {bool readOnly = false, bool bold = false, Color? valueColor, Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: valueColor,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(const Color(0xFF2F5496)),
      headingTextStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      dataTextStyle: const TextStyle(fontSize: 12),
      columnSpacing: 16,
      horizontalMargin: 8,
      columns: const [
        DataColumn(label: Text('SI')),
        DataColumn(label: Text('Code')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Rate')),
        DataColumn(label: Text('Disc')),
        DataColumn(label: Text('Total')),
        DataColumn(label: Text('Action')),
      ],
      rows: cartItems.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return DataRow(
          color: MaterialStateProperty.all(i % 2 == 0 ? Colors.white : const Color(0xFFE8F0F8)),
          cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(item.code)),
            DataCell(Text(item.name)),
            DataCell(Text(item.category)),
            DataCell(
              SizedBox(
                width: 50,
                child: TextField(
                  controller: TextEditingController(text: item.qty.toStringAsFixed(0)),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    item.qty = double.tryParse(v) ?? 0;
                    item.total = (item.qty * item.rate) - item.discount;
                    _calculateTotals();
                  },
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 60,
                child: TextField(
                  controller: TextEditingController(text: item.rate.toStringAsFixed(2)),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    item.rate = double.tryParse(v) ?? 0;
                    item.total = (item.qty * item.rate) - item.discount;
                    _calculateTotals();
                  },
                ),
              ),
            ),
            DataCell(Text(item.discount.toStringAsFixed(0))),
            DataCell(Text(item.total.toStringAsFixed(2))),
            DataCell(
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () {
                  setState(() {
                    cartItems.removeAt(i);
                    _calculateTotals();
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReplacementTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(const Color(0xFF2F5496)),
      headingTextStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      dataTextStyle: const TextStyle(fontSize: 12),
      columnSpacing: 16,
      horizontalMargin: 8,
      columns: const [
        DataColumn(label: Text('SI')),
        DataColumn(label: Text('Code')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Rate')),
        DataColumn(label: Text('Total')),
        DataColumn(label: Text('Action')),
      ],
      rows: replacementItems.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return DataRow(
          color: MaterialStateProperty.all(i % 2 == 0 ? Colors.white : const Color(0xFFE8F0F8)),
          cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(item.code)),
            DataCell(Text(item.name)),
            DataCell(Text(item.category)),
            DataCell(Text(item.qty.toStringAsFixed(0))),
            DataCell(Text(item.rate.toStringAsFixed(2))),
            DataCell(Text(item.total.toStringAsFixed(2))),
            DataCell(
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () {
                  setState(() {
                    replacementItems.removeAt(i);
                    _calculateTotals();
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}