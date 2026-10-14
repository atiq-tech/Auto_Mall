import 'package:auto_mall/common_widget/custom_appbar.dart';
import 'package:auto_mall/utils/all_textstyle.dart';
import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Product {
  final int sl;
  final String productId;
  final String productName;
  final String category;
  final String salePrice;

  Product({
    required this.sl,
    required this.productId,
    required this.productName,
    required this.category,
    required this.salePrice,
  });
}

class ProductListScreen extends StatelessWidget {
   ProductListScreen({super.key});

final List<Product> products = [
  Product(sl: 1, productId: 'P-1001', productName: 'Samsung Galaxy A54', category: 'Mobile', salePrice: '৳ 42,999'),
  Product(sl: 2, productId: 'P-1002', productName: 'Xiaomi Redmi Note 13', category: 'Mobile', salePrice: '৳ 24,999'),
  Product(sl: 3, productId: 'P-1003', productName: 'Apple AirPods Pro 2', category: 'Accessories', salePrice: '৳ 28,500'),
  Product(sl: 4, productId: 'P-1004', productName: 'Sony WH-1000XM5', category: 'Accessories', salePrice: '৳ 39,990'),
  Product(sl: 5, productId: 'P-1005', productName: 'HP Pavilion 15', category: 'Laptop', salePrice: '৳ 78,500'),
  Product(sl: 6, productId: 'P-1006', productName: 'Logitech MX Master 3S', category: 'Accessories', salePrice: '৳ 12,999'),
  Product(sl: 7, productId: 'P-1007', productName: 'Canon EOS R50', category: 'Camera', salePrice: '৳ 89,990'),
  Product(sl: 8, productId: 'P-1008', productName: 'Samsung 55" QLED TV', category: 'Television', salePrice: '৳ 1,15,000'),
  Product(sl: 9, productId: 'P-1009', productName: 'iPhone 15 Pro', category: 'Mobile', salePrice: '৳ 1,49,999'),
  Product(sl: 10, productId: 'P-1010', productName: 'OnePlus 12', category: 'Mobile', salePrice: '৳ 79,999'),
  Product(sl: 11, productId: 'P-1011', productName: 'JBL Flip 6', category: 'Accessories', salePrice: '৳ 11,500'),
  Product(sl: 12, productId: 'P-1012', productName: 'Dell XPS 13', category: 'Laptop', salePrice: '৳ 1,25,000'),
  Product(sl: 13, productId: 'P-1013', productName: 'Nikon Z30', category: 'Camera', salePrice: '৳ 72,500'),
  Product(sl: 14, productId: 'P-1014', productName: 'LG 43" Smart TV', category: 'Television', salePrice: '৳ 48,990'),
  Product(sl: 15, productId: 'P-1015', productName: 'Realme GT Neo 5', category: 'Mobile', salePrice: '৳ 35,999'),
  Product(sl: 16, productId: 'P-1016', productName: 'Bose QuietComfort Ultra', category: 'Accessories', salePrice: '৳ 42,000'),
  Product(sl: 17, productId: 'P-1017', productName: 'Lenovo IdeaPad Slim 5', category: 'Laptop', salePrice: '৳ 68,500'),
  Product(sl: 18, productId: 'P-1018', productName: 'GoPro Hero 12', category: 'Camera', salePrice: '৳ 54,990'),
  Product(sl: 19, productId: 'P-1019', productName: 'Sony Bravia 65"', category: 'Television', salePrice: '৳ 1,89,000'),
  Product(sl: 20, productId: 'P-1020', productName: 'Google Pixel 8', category: 'Mobile', salePrice: '৳ 89,999'),
  Product(sl: 21, productId: 'P-1021', productName: 'Anker PowerCore 20000', category: 'Accessories', salePrice: '৳ 4,999'),
  Product(sl: 22, productId: 'P-1022', productName: 'Asus ROG Zephyrus G14', category: 'Laptop', salePrice: '৳ 1,65,000'),
  Product(sl: 23, productId: 'P-1023', productName: 'Fujifilm X-T5', category: 'Camera', salePrice: '৳ 1,45,000'),
  Product(sl: 24, productId: 'P-1024', productName: 'TCL 50" 4K TV', category: 'Television', salePrice: '৳ 39,990'),
  Product(sl: 25, productId: 'P-1025', productName: 'Vivo V30 Pro', category: 'Mobile', salePrice: '৳ 52,999'),
  Product(sl: 26, productId: 'P-1026', productName: 'Razer DeathAdder V3', category: 'Accessories', salePrice: '৳ 8,500'),
  Product(sl: 27, productId: 'P-1027', productName: 'MacBook Air M3', category: 'Laptop', salePrice: '৳ 1,35,000'),
  Product(sl: 28, productId: 'P-1028', productName: 'DJI Mini 4 Pro', category: 'Camera', salePrice: '৳ 95,000'),
  Product(sl: 29, productId: 'P-1029', productName: 'Xiaomi 55" A Pro TV', category: 'Television', salePrice: '৳ 42,500'),
  Product(sl: 30, productId: 'P-1030', productName: 'Nothing Phone 2a', category: 'Mobile', salePrice: '৳ 34,999'),
  Product(sl: 31, productId: 'P-1031', productName: 'Samsung Galaxy Buds 2 Pro', category: 'Accessories', salePrice: '৳ 18,990'),
  Product(sl: 32, productId: 'P-1032', productName: 'Acer Aspire 7', category: 'Laptop', salePrice: '৳ 72,000'),
  Product(sl: 33, productId: 'P-1033', productName: 'Panasonic Lumix G9', category: 'Camera', salePrice: '৳ 1,12,000'),
  Product(sl: 34, productId: 'P-1034', productName: 'Hisense 43" UHD TV', category: 'Television', salePrice: '৳ 36,500'),
  Product(sl: 35, productId: 'P-1035', productName: 'Oppo Reno 11', category: 'Mobile', salePrice: '৳ 45,999'),
  Product(sl: 36, productId: 'P-1036', productName: 'Keychron K2 Mechanical', category: 'Accessories', salePrice: '৳ 9,800'),
  Product(sl: 37, productId: 'P-1037', productName: 'MSI Cyborg 15', category: 'Laptop', salePrice: '৳ 95,500'),
  Product(sl: 38, productId: 'P-1038', productName: 'Insta360 X4', category: 'Camera', salePrice: '৳ 58,000'),
  Product(sl: 39, productId: 'P-1039', productName: 'Walton 32" Smart TV', category: 'Television', salePrice: '৳ 22,990'),
  Product(sl: 40, productId: 'P-1040', productName: 'Tecno Camon 30', category: 'Mobile', salePrice: '৳ 27,999'),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: CustomAppBar(title: "Product List"),
      body: Padding(
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
                  rows: products.map((product) {
                    return DataRow(
                      cells: [
                        DataCell(Text(product.sl.toString(),style: AllTextStyle.tableDataTextStyle)),
                        DataCell(Text(product.productId,style: AllTextStyle.tableDataTextStyle)),
                        DataCell(Text(product.productName,style: AllTextStyle.tableDataTextStyle)),
                        DataCell(Text(product.category,style: AllTextStyle.tableDataTextStyle)),
                        DataCell(Text(product.salePrice,style: AllTextStyle.tableDataTextStyle)),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 50.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}