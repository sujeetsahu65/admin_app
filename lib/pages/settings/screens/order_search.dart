import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderSearch extends ConsumerWidget {
  final String page = 'order-details';

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderSearchProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48, // Adjust height here
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        hintText: 'Enter Order Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 48, // Same height as TextField
                  child: ElevatedButton(
                    onPressed: () {
                      final searchQuery = _searchController.text.trim();
                      if (searchQuery.isNotEmpty) {
                        ref
                            .read(orderSearchProvider.notifier)
                            .searchOrder(searchQuery);
                      } else {
                        // Show error or alert that either ID or Order Number is required
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter an Order Number')),
                        );
                      }
                    },
                    child: Text('Search'),
                  ),
                ),


                
              ],
            ),
          ),
          Expanded(
            child: orderState.isLoading
                ? Center(child: CircularProgressIndicator())
                : orderState.order == null
                    ? Center(child: Text('Order not found'))
                    : OrderCard(order: orderState.order!, page: page),
          ),
        ],
      ),
      // Loader while fetching data
      bottomSheet: orderState.isLoading ? GlobalLoader() : null,
    );
  }
}
