import 'package:admin_app/providers/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/models/report.dart';
import 'package:admin_app/pages/settings/services/report.dart';

class ReportPage extends ConsumerStatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();

    // Set default date range to today
    DateTime today = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: DateTime(today.year, today.month, today.day), // Start of today
      end: DateTime(today.year, today.month, today.day), // End of today
    );

    // Fetch the report immediately after initializing the state
    ref.read(reportNotifierProvider.notifier).fetchReport(_selectedDateRange);
  }

  // Function to open date range picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      ref.read(reportNotifierProvider.notifier).fetchReport(_selectedDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: reportState.isLoading
                ? Center(child: CircularProgressIndicator())
                : reportState.report != null
                    ? _buildReportTables(reportState.report!)
                    : Center(
                        child: Text(reportState.errorMessage ??
                            'Select a date range to see the report'),
                      ),
          ),
          _buildBottomSheetButton(context), // Bottom sheet trigger
        ],
      ),
    );
  }

  // Bottom sheet button
  Widget _buildBottomSheetButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _selectDateRange(),
        child: Text('Select Date'),
      ),
    );
  }

  // Build the report tables
  Widget _buildReportTables(Report report) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            child: Column(
              children: [
                Text(
                  "Order Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  // textAlign: TextAlign.center,
                ),
                _buildOrderSummaryTable(report),
              ],
            ),
          ),
          SizedBox(height: 10),
        Card(
            child: Column(
              children: [
            Text(
            "Summary by Payment Mode",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            // textAlign: TextAlign.center,
          ),
          _buildPaymentModeTable(report)
              ],
            ),
          ),
          SizedBox(height: 10),
        Card(
            child: Column(
              children: [
            Text(
            "Summary by Delivery Type",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            // textAlign: TextAlign.center,
          ),
          _buildDeliveryTypeTable(report),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Table for Order Summary
  Widget _buildOrderSummaryTable(Report report) {
    return DataTable(columns: [
      DataColumn(label: Text('Order Type')),
      DataColumn(label: Text('Orders')),
      DataColumn(label: Text('Amount')),
    ], rows: [
      DataRow(cells: [
        DataCell(Text('Success Orders')),
        DataCell(Text('${report.successOrders.totalOrders}')),
        DataCell(
            Text('\$${report.successOrders.totalAmount.toStringAsFixed(2)}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Bonus Orders')),
        DataCell(Text('${report.bonusOrders.totalOrders}')),
        DataCell(Text('\$${report.bonusOrders.totalBonus.toStringAsFixed(2)}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Discounted Orders')),
        DataCell(Text('${report.discountedOrders.totalOrders}')),
        DataCell(Text(
            '\$${report.discountedOrders.totalDiscount.toStringAsFixed(2)}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Coupon Orders')),
        DataCell(Text('${report.couponOrders.totalOrders}')),
        DataCell(Text(
            '\$${report.couponOrders.totalCouponDiscount.toStringAsFixed(2)}')),
      ]),
    ]);
  }

  // Table for Payment Mode Summary
  Widget _buildPaymentModeTable(Report report) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Payment Mode')),
          DataColumn(label: Text('Orders')),
          DataColumn(label: Text('Amount')),
        ],
        rows: report.ordersByPaymentMode.map((paymentModeOrder) {
          return DataRow(cells: [
            DataCell(Text(paymentModeOrder.paymentMode)),
            DataCell(Text('${paymentModeOrder.totalOrders}')),
            DataCell(
                Text('\$${paymentModeOrder.totalAmount.toStringAsFixed(2)}')),
          ]);
        }).toList());
  }

  // Table for Delivery Type Summary
  Widget _buildDeliveryTypeTable(Report report) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Delivery Type')),
          DataColumn(label: Text('Total Orders')),
          DataColumn(label: Text('Total Amount')),
        ],
        rows: report.ordersByDeliveryType.map((deliveryTypeOrder) {
          return DataRow(cells: [
            DataCell(Text(deliveryTypeOrder.deliveryType)),
            DataCell(Text('${deliveryTypeOrder.totalOrders}')),
            DataCell(
                Text('\$${deliveryTypeOrder.totalAmount.toStringAsFixed(2)}')),
          ]);
        }).toList());
  }
}
