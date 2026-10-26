import 'package:auto_mall/api_services/api_service.dart';
import 'package:auto_mall/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  InvoiceModel? invoiceModel;
  Future<InvoiceModel?>getInvoice(context, String? salesId) async {
    invoiceModel = await ApiService.fetchInvoice(salesId);
    return invoiceModel;
  }
}