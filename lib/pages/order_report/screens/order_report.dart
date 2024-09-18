import 'package:admin_app/providers/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/models/report.dart';
import 'package:admin_app/pages/settings/services/report.dart';

class OrderReport extends ConsumerStatefulWidget {
  @override
  _OrderReportState createState() => _OrderReportState();
}

class _OrderReportState extends ConsumerState<OrderReport> {
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

  // Function to handle report printing
  void _printReport(Report report) {
    // Logic to print the report (or pass it to another service)
    print("Report printed: ${report.successOrders.totalOrders} orders");
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
          _buildBottomSheetButtons(context, reportState), // Bottom sheet trigger with both buttons
        ],
      ),
    );
  }

  // Bottom sheet buttons: Select Date & Print Report
  Widget _buildBottomSheetButtons(BuildContext context, reportState) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _selectDateRange(),
              child: Text('Select Date'),
            ),
          ),
           SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: null,
              // onPressed: reportState.report != null && reportState.report.successOrders.totalOrders >0
              //     ? () => _printReport(reportState.report!)
              //     : null, // Disable button if no report data
              child: Text('Print Report'),
              style: ElevatedButton.styleFrom(
                primary: reportState.report != null && reportState.report.successOrders.totalOrders >0
                    ? Colors.blue // Enabled color
                    : Colors.grey, // Disabled color
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the report tables
  Widget _buildReportTables(Report report) {
    // Check if there are no orders in the summary
    final bool noOrdersFound = report.successOrders.totalOrders == 0;

    return noOrdersFound
        ? Center(
            child: Text(
              'No orders found for the selected date range',
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Order Summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        _buildOrderSummaryTable(report),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Summary by Payment Mode",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        _buildPaymentModeTable(report),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Summary by Delivery Type",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        _buildDeliveryTypeTable(report),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // Table for Order Summary
  Widget _buildOrderSummaryTable(Report report) {
    return DataTable(
      
      columns: [
      DataColumn(label: Text('Order Type')),
      DataColumn(label: Text('Orders')),
      DataColumn(label: Text('Amount')),
    ], rows: [
      DataRow(cells: [
        DataCell(Text('Success Orders')),
        DataCell(Text('${report.successOrders.totalOrders}')),
        DataCell(
            Text('${report.successOrders.totalAmount.toStringAsFixed(2)}€')),
      ]),
      DataRow(cells: [
        DataCell(Text('Bonus Orders')),
        DataCell(Text('${report.bonusOrders.totalOrders}')),
        DataCell(Text('${report.bonusOrders.totalBonus.toStringAsFixed(2)}€')),
      ]),
      DataRow(cells: [
        DataCell(Text('Discounted Orders')),
        DataCell(Text('${report.discountedOrders.totalOrders}')),
        DataCell(Text(
            '${report.discountedOrders.totalDiscount.toStringAsFixed(2)}€')),
      ]),
      DataRow(cells: [
        DataCell(Text('Coupon Orders')),
        DataCell(Text('${report.couponOrders.totalOrders}')),
        DataCell(Text(
            '${report.couponOrders.totalCouponDiscount.toStringAsFixed(2)}€')),
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
                Text('${paymentModeOrder.totalAmount.toStringAsFixed(2)}€')),
          ]);
        }).toList());
  }

  // Table for Delivery Type Summary
  Widget _buildDeliveryTypeTable(Report report) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Delivery Type')),
          DataColumn(label: Text('Orders')),
          DataColumn(label: Text('Amount')),
        ],
        rows: report.ordersByDeliveryType.map((deliveryTypeOrder) {
          return DataRow(cells: [
            DataCell(Text(deliveryTypeOrder.deliveryType)),
            DataCell(Text('${deliveryTypeOrder.totalOrders}')),
            DataCell(
                Text('${deliveryTypeOrder.totalAmount.toStringAsFixed(2)}€')),
          ]);
        }).toList());
  }
}
