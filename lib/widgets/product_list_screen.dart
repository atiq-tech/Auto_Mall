import 'package:auto_mall/common_widget/buildBeautifulLoading.dart';
import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/providers/products_provider.dart';
import 'package:auto_mall/utils/all_textstyle.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false).getProducts();
    ProductsProvider().on();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final productList = provider.productsList;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: CustomAppBar(title: "Product List"),
      body: ProductsProvider.isProductsLoading == true
      ? buildBeautifulLoading() 
      : Padding(
          padding: EdgeInsets.all(6.r),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  DataTable(
                    headingRowHeight: 17.h,
                    dataRowHeight: 17.h,
                    headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                    showCheckboxColumn: true,
                    border: TableBorder.all(color: Colors.blueGrey, width: 1.w),
                    columns: [
                      DataColumn(label: Text('Sl',style: AllTextStyle.tableHeadTextStyle)),
                      DataColumn(label: Text('Product Id',style: AllTextStyle.tableHeadTextStyle)),
                      DataColumn(label: Text('Product Name',style: AllTextStyle.tableHeadTextStyle)),
                      DataColumn(label: Text('Category',style: AllTextStyle.tableHeadTextStyle)),
                      DataColumn(label: Text('Sale Price',style: AllTextStyle.tableHeadTextStyle)),
                    ],
                    rows: productList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text("${index + 1}",style: AllTextStyle.tableDataTextStyle,)),
                          DataCell(Text(product.productCode,style: AllTextStyle.tableDataTextStyle)),
                          DataCell(Text(product.productName,style: AllTextStyle.tableDataTextStyle)),
                          DataCell(Text(product.productCategoryName,style: AllTextStyle.tableDataTextStyle)),
                          DataCell(Text(product.productSellingPrice.toString(),style: AllTextStyle.tableDataTextStyle)),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
    );
  }
}


