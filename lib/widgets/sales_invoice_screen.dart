
import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/models/invoice_model.dart';
import 'package:auto_mall/providers/invoice_provider.dart';
import 'package:auto_mall/utils/animation_snackbar.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:auto_mall/utils/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';

class SalesInvoiceScreen extends StatefulWidget {
  const SalesInvoiceScreen({super.key, required this.salesId});
  final String salesId;
  @override
  State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> {
  String userName = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
  }

  String companyName = "";
  String repotHeading = "";
  String dueStatus = "";
  String invoiceNote = "";
  String CompanyLogothum = "";
  String footerImg = "";

   void getCompanyProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get(companyProfile,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "${sharedPreferences.getString("token")}",
        }),
      );

      if (response.statusCode == 200) {
        var data = response.data is List ? response.data[0] : response.data;

        setState(() {
          companyName = data['Company_Name'] ?? "";
          CompanyLogothum = data['Company_Logo_thum'] ?? "";
          dueStatus = data['dueStatus'] ?? "";
          invoiceNote = data['InvoiceNote'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
  }

  @override
  void initState() {
    getCompanyProfile();
    _initializeData();
    super.initState();
  }

Future<Uint8List?> _fetchImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Image Load Failed: Status ${response.statusCode}');
      return null; 
    }
  } catch (e) {
    print('Error fetching image: $e');
    return null;
  }
}

Future<void> printInvoice(InvoiceModel? data) async {
  if (data == null || data.sales!.isEmpty) return;

  String currentDateTime = DateFormat('M/d/yy, h:mm a').format(DateTime.now());
  final Uint8List? netHeader = await _fetchImage("$baseUrl$CompanyLogothum");

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 15.h),

      // ========== BOTTOM FOOTER (Signature + Print info) ==========
      footer: (context) {
        return pw.Column(
          children: [
            pw.SizedBox(height: 20.h),

            // Signature Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                // Received by
                pw.Column(
                  children: [
                    pw.Container(
                      width: 100.w,
                      decoration: pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide(width: 0.9.w)),
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text("Received by", style: pw.TextStyle(fontSize: 9.sp)),
                  ],
                ),

                // QR Code
                pw.Column(
                  children: [
                    pw.Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.7.w),
                      ),
                      alignment: pw.Alignment.center,
                      padding: pw.EdgeInsets.all(2.r),
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: "https://demo.automallerp.com/sale_invoice_print/43",
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                  ],
                ),
                // Authorized Signature
                pw.Column(
                  children: [
                    pw.Container(
                      width: 100.w,
                      decoration: pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide(width: 0.9.w)),
                      ),
                    ),
                    pw.SizedBox(height: 3.h),
                    pw.Text("Authorized Signature",style: pw.TextStyle(fontSize: 9.sp)),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 18.h),
            // Print Date + Developed by
            pw.Divider(thickness: 0.6, color: PdfColors.grey500),
            pw.SizedBox(height: 4.h),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Print Date: ${DateFormat('dd-MM-yyyy h:mm a').format(DateTime.now())}, Printed by: ${data.sales![0].addedBy ?? "admin"}",
                  style: pw.TextStyle(fontSize: 7.5.sp),
                ),
                pw.Text(
                  "Developed by: Link-Up Technology, Contact no: 01911978897",
                  style: pw.TextStyle(fontSize: 7.5.sp),
                ),
              ],
            ),
          ],
        );
      },

      build: (context) => [
        // ========== TOP HEADER (Date + Invoice title + Barcode area) ==========
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              currentDateTime,
              style: pw.TextStyle(fontSize: 8.sp, fontStyle: pw.FontStyle.italic),
            ),
            pw.Text(
              "Invoice",
              style: pw.TextStyle(fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  width: 110.w,
                  height: 28.h,
                  alignment: pw.Alignment.center,
                  padding: pw.EdgeInsets.all(2.r),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.code128(),
                    data: data.sales![0].saleMasterInvoiceNo ?? "",
                    width: 104.w,
                    height: 23.h,
                    drawText: false,
                  ),
                ),
                pw.SizedBox(height: 2.h),
                pw.Text(
                  "inv${data.sales![0].saleMasterInvoiceNo ?? ""}",
                  style: pw.TextStyle(fontSize: 8.sp),
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 8.h),

        // ========== COMPANY HEADER ==========
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (netHeader != null)
            pw.Image(pw.MemoryImage(netHeader), height: 105.h, width: 100.w),
            pw.SizedBox(width: 12.w),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Sorif Trade",
                    style: pw.TextStyle(
                      fontSize: 16.sp,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    "Mirpur 10, Dhaka",
                    style: pw.TextStyle(fontSize: 9.sp),
                  ),
                  pw.Text(
                    "Phone: 01979556663",
                    style: pw.TextStyle(fontSize: 9.sp),
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 10.h),
        pw.Divider(thickness: 1.2, color: PdfColors.grey700),
        pw.SizedBox(height: 6.h),

        // ========== SALES INVOICE TITLE ==========
        pw.Center(
          child: pw.Text(
            "Sales Invoice",
            style: pw.TextStyle(
              fontSize: 13.sp,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 8.h),
        pw.Divider(thickness: 1.2, color: PdfColors.grey700),
        pw.SizedBox(height: 8.h),

        // ========== CUSTOMER + INVOICE INFO ==========
        pw.Container(
          padding: pw.EdgeInsets.all(8.r),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey700, width: 1.w),
            borderRadius: pw.BorderRadius.circular(6.r),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      "Customer ID",
                      data.sales![0].customerCode ?? "",
                    ),
                    _buildInfoRow(
                      "Name",
                      data.sales![0].customerName ?? "",
                    ),
                    _buildInfoRow(
                      "Address",
                      data.sales![0].customerAddress ?? "",
                    ),
                    _buildInfoRow(
                      "Mobile",
                      data.sales![0].customerMobile ?? "",
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 8.w),
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _buildInfoRow(
                      "Sales by",
                      data.sales![0].addedBy ?? "admin",
                      rightAlign: true,
                    ),
                    _buildInfoRow(
                      "Invoice No.",
                      data.sales![0].saleMasterInvoiceNo ?? "",
                      rightAlign: true,
                    ),
                    _buildInfoRow(
                      "Sales Date",
                      data.sales![0].saleMasterSaleDate ?? "",
                      rightAlign: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 14),

        // ========== PRODUCT TABLE ==========
        pw.Table(
          border: pw.TableBorder.all(width: 1.w, color: PdfColors.grey600),
          columnWidths: {
            0: const pw.FixedColumnWidth(28),
            1: const pw.FlexColumnWidth(4),
            2: const pw.FixedColumnWidth(50),
            3: const pw.FixedColumnWidth(40),
            4: const pw.FixedColumnWidth(55),
            5: const pw.FixedColumnWidth(55),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell("SI.", isHeader: true),
                _buildTableCell("Description", isHeader: true),
                _buildTableCell("Quantity", isHeader: true),
                _buildTableCell("Unit", isHeader: true),
                _buildTableCell("Unit Price", isHeader: true),
                _buildTableCell("Total", isHeader: true),
              ],
            ),
            ...data.saleDetails!.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return pw.TableRow(
                children: [
                  _buildTableCell("${i + 1}"),
                  _buildTableCell(
                    "${item.productCode ?? ""} - ${item.productName ?? ""}",
                    align: pw.TextAlign.left,
                  ),
                  _buildTableCell(item.saleDetailsTotalQuantity?.toString() ?? "0"),
                  _buildTableCell(item.unitName ?? "Pcs"),
                  _buildTableCell(item.saleDetailsRate?.toString() ?? "0.00"),
                  _buildTableCell(
                      item.saleDetailsTotalAmount?.toString() ?? "0.00"),
                ],
              );
            }).toList(),
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell(""),
                pw.Padding(
                  padding: pw.EdgeInsets.all(4.r),
                  child: pw.Text(
                    "Total",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
                _buildTableCell(
                  _calculateTotalQty(data.saleDetails!),
                  isHeader: true,
                ),
                _buildTableCell(""),
                _buildTableCell(""),
                _buildTableCell(
                  data.sales![0].saleMasterTotalSaleAmount?.toString() ?? "0.00",
                  isHeader: true,
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 12.h),

        // ========== IN WORD + NOTE  +  SUMMARY ==========
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "In Word: ${numberToWords(double.tryParse(data.sales![0].saleMasterTotalSaleAmount?.toString() ?? "0")?.toInt() ?? 0)} BDT only",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9.sp,
                    ),
                  ),
                  pw.SizedBox(height: 8.h),
                  pw.Text(
                    "Note: ${data.sales![0].saleMasterDescription==null||data.sales![0].saleMasterDescription==""?"Thank you for business...":data.sales![0].saleMasterDescription}",
                    style: pw.TextStyle(fontSize: 9.sp),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 16.w),
            pw.Expanded(
              flex: 2,
              child: pw.Table(
                border: pw.TableBorder.all(width: 1.w, color: PdfColors.grey600),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.2),
                  1: const pw.FlexColumnWidth(1.3),
                },
                children: [
                  _summaryTableRow("Sub Total:",data.sales![0].saleMasterSubTotalAmount ?? "0.00"),
                  _summaryTableRow("Discount: (-)",data.sales![0].saleMasterTotalDiscountAmount ?? "0.00"),
                  _summaryTableRow("Vat: (+)", data.sales![0].saleMasterTaxAmount ?? "0.00"),
                  _summaryTableRow("Transport Cost: (+)", "0.00"),
                  _summaryTableRow("Total:",data.sales![0].saleMasterTotalSaleAmount ?? "0.00",isBold: true),
                  _summaryTableRow("Paid:", data.sales![0].saleMasterPaidAmount ?? "0.00"),
                  _summaryTableRow("Due:",data.sales![0].saleMasterDueAmount ?? "0.00",isBold: true),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

// ==================== HELPER FUNCTIONS ====================

String _calculateTotalQty(List details) {
  double total = 0;
  for (var item in details) {
    total += double.tryParse(item.saleDetailsTotalQuantity?.toString() ?? "0") ?? 0;
  }
  return total.toStringAsFixed(0);
}

pw.Widget _buildInfoRow(String label, String value, {bool rightAlign = false}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 1.5.h),
    child: pw.Row(
      mainAxisAlignment:
          rightAlign ? pw.MainAxisAlignment.end : pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          "$label : ",
          style: pw.TextStyle(fontSize: 9.sp, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(value, style: pw.TextStyle(fontSize: 9.sp)),
      ],
    ),
  );
}

pw.Widget _buildTableCell(
  dynamic text, {
  bool isHeader = false,
  pw.TextAlign align = pw.TextAlign.center,
}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
    child: pw.Text(
      text?.toString() ?? "",
      textAlign: align,
      style: pw.TextStyle(
        fontSize: 8.5.sp,
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.TableRow _summaryTableRow(String label, String value, {bool isBold = false}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.5.h),
        child: pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9.sp,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.5.h),
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(
            fontSize: 9.sp,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    ],
  );
}


  String numberToWords(int number) {
    if (number == 0) return "Zero";
    final List<String> units = [
      "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
      "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
    ];

    final List<String> tens = [
      "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"
    ];

    String convertLessThanThousand(int num) {
      if (num == 0) return "";
      if (num < 20) return units[num];
      if (num < 100) return tens[num ~/ 10] + (num % 10 != 0 ? " ${units[num % 10]}" : "");
      return units[num ~/ 100] + " Hundred" + (num % 100 != 0 ? " " + convertLessThanThousand(num % 100) : "");
    }

    String words = "";
    if (number >= 1000000) {
      words += "${convertLessThanThousand(number ~/ 1000000)} Million ";
      number %= 1000000;
    }
    if (number >= 1000) {
      words += "${convertLessThanThousand(number ~/ 1000)} Thousand ";
      number %= 1000;
    }
    if (number > 0) {
      words += convertLessThanThousand(number);
    }
    return words.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Sales Invoice"),
      body:FutureBuilder(
          future: Provider.of<InvoiceProvider>(context).getInvoice(context, widget.salesId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: buildBeautifulLoading()),
              );
            } else if (snapshot.hasData) {
              int totalQty = snapshot.data!.saleDetails!.fold<int>(0,(sum, item) => sum + int.tryParse(item.saleDetailsTotalQuantity.toString())!);
              double totalAmount = snapshot.data!.saleDetails!.fold<double>(0.0,(sum, item) => sum + double.tryParse(item.saleDetailsTotalAmount.toString())!);

              return Padding(
                padding: EdgeInsets.all(8.r),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0.h),
                      GestureDetector(
                        onTap: () async {
                          CustomSnackBar.showTopSnackBar(context, "Please wait printing");
                          try {
                            await printInvoice(snapshot.data);
                          } catch (e) {
                            CustomSnackBar.showTopSnackBar(context, "Printing failed");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.print, size: 15.r, color: AppColors.appColor),
                            SizedBox(width: 3.0.w),
                            Text(
                              "Print",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.appColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 1.h),child: Divider(height: 2.h)),
                      Align(alignment: Alignment.center,
                      child: Text("Sales Invoice",style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black54))),
                      Padding(padding: EdgeInsets.symmetric(vertical: 1.h),child: Divider(height: 2.h)),
                      SizedBox(height: 5.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: Colors.black54,width: 1.6.w)
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Customer Id : ',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.w700
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: snapshot.data!.sales![0].customerCode,
                                                style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                            ),
                                          ],
                                        ),
                                      ),RichText(
                                        text: TextSpan(
                                          text: 'Name : ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: snapshot.data!.sales![0].customerName,
                                                style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                            ),
                                          ],
                                        ),
                                      ),RichText(
                                        text: TextSpan(
                                          text: 'Mobile : ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: snapshot.data!.sales![0].customerMobile,
                                                style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Sales By: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: snapshot.data!.sales![0].addedBy,
                                                style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Invoice No: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: snapshot.data!.sales![0].saleMasterInvoiceNo,
                                                style: TextStyle(fontSize: 9.sp,fontWeight: FontWeight.w400)
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Sales Date: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: DateFormat('dd-MM-yyyy hh:mm a').format(
                                                DateTime.parse(snapshot.data!.sales![0].addTime),
                                              ).toLowerCase(),   // "pm" ছোট হাতের অক্ষরে চাইলে
                                              style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Address : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:snapshot.data!.sales![0].customerAddress,
                                        style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 16.h,
                          dataRowHeight: 16.h,
                          showCheckboxColumn: true,
                          headingRowColor: WidgetStateColor.resolveWith((states) =>const Color.fromARGB(255, 183, 195, 201)),
                          border: TableBorder.all(color: Colors.black54, width: 1.6.w),
                          dataTextStyle: TextStyle(fontSize: 10.sp, color: Colors.black),
                          columns: [
                            DataColumn(label: Center(child: Text('Sl.', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Padding(
                              padding: EdgeInsets.only(left: 30.w),
                              child: Text('Description', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(label: Center(child: Text('Qty', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Unit', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Unit Price', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Total', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                          
                          ],
                          rows: [
                            // Table Data Rows
                            ...List.generate(snapshot.data!.saleDetails!.length, (index) {
                              return DataRow(cells: [
                                DataCell(Center(child: Text("${index + 1}"))),
                                DataCell(Text("${snapshot.data!.saleDetails![index].productName} - ${snapshot.data!.saleDetails![index].productCode}", style: TextStyle(fontSize: 10.sp))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails![index].saleDetailsTotalQuantity}"))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails![index].unitName}"))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails![index].saleDetailsRate}"))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails![index].saleDetailsTotalAmount}"))),
                              ]);
                            }),
                            // Total Row
                            DataRow(
                              cells: [
                                DataCell(SizedBox()),
                                DataCell(Text('Total:', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Center(child: Text("$totalQty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(SizedBox()),
                                DataCell(SizedBox()),
                                DataCell(Center(child: Text('$totalAmount', style: TextStyle(fontWeight: FontWeight.bold)))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                snapshot.data!.sales![0].bankName != null && snapshot.data!.sales![0].bankName != "null" 
                                ? Table(
                                border: TableBorder.all(color: Colors.grey.shade300),
                                columnWidths: const {
                                  0: FixedColumnWidth(35), 
                                  1: FlexColumnWidth(),    
                                  2: FixedColumnWidth(60), 
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle, 
                                children: [
                                  // Table Header
                                  TableRow(
                                    decoration: BoxDecoration(color: Colors.grey.shade200),
                                    children: [
                                      Center(child: Text("SL", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
                                      Center(child: Text("Bank", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
                                      Center(child: Text("Amount", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Center(child: Text("1", style: TextStyle(fontSize: 10.sp))),
                                      Padding(
                                        padding: EdgeInsets.all(2.w), 
                                        child: Text(
                                          "${snapshot.data!.sales![0].bankName??""}", 
                                          style: TextStyle(fontSize: 9.sp),
                                          softWrap: true,
                                          overflow: TextOverflow.visible, 
                                        )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.w), 
                                        child: Text(
                                          snapshot.data!.sales![0].bankPaid, 
                                          style: TextStyle(fontSize: 9.sp),
                                          softWrap: true,
                                          overflow: TextOverflow.visible, 
                                          textAlign: TextAlign.center, 
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ):SizedBox(),
                                SizedBox(height: 5.h),
                                dueStatus == "true" ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Previous Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales![0].saleMasterPreviousDue, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Current Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales![0].saleMasterDueAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Container(height: 1.h,color: Colors.black),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(double.parse("${double.parse('${snapshot.data!.sales![0].saleMasterPreviousDue}') + double.parse('${snapshot.data!.sales![0].saleMasterDueAmount}')}").toStringAsFixed(2),style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ):SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Expanded(
                          flex: 4,
                          child: Table(
                            border: TableBorder.all(color: Colors.black54, width: 1.6.w),
                            columnWidths: const {
                              0: FlexColumnWidth(5),
                              1: FlexColumnWidth(3),
                            },
                            children: [
                              // Sub Total
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "Sub Total:",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterSubTotalAmount,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                
                              // Discount
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "Discount:(-)",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterTotalDiscountAmount,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                
                              // Vat
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "Vat:(+)",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterTaxAmount,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                
                              // Transport Cost
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "TransportCost:(+)",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterFreight,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                
                              // Total
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "Total:",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterTotalSaleAmount,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                
                              // Paid
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "Paid:",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterPaidAmount,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                
                              // Due
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      "Due:",
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    child: Text(
                                      snapshot.data!.sales![0].saleMasterDueAmount,
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      SelectableText(
                        "In Word: ${numberToWords(double.parse(snapshot.data!.sales![0].saleMasterTotalSaleAmount).toInt())} BDT only",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text("Note: ${snapshot.data!.sales![0].saleMasterDescription==null||snapshot.data!.sales![0].saleMasterDescription==""?"Thank you for business...":snapshot.data!.sales![0].saleMasterDescription}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              );
            }else {
              return const SizedBox();
            }
          }
      )
    );
  }
}