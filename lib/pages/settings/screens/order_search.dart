import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
// import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderSearch extends ConsumerWidget {
  final String page = 'order-details';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the order search provider
    final orderAsyncValue = ref.watch(orderSearchProvider);

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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
          // Handling different states of AsyncValue
          Expanded(
            child: orderAsyncValue.when(
              data: (orderState) {
                if (orderState.order != null) {
                  // Display the order details if the order exists
                  return OrderCard(order: orderState.order!, page: page);
                } else if (orderState.errorMessage != null) {
                  // Display the error message if provided
                  return Center(child: Text(orderState.errorMessage!));
                } else {
                  // Display a message when no order is found
                  return Center(child: Text('Order not found'));
                }
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                // Display a general error message
                return Center(child: Text('Something went wrong: $error'));
              },
            ),
          ),
        ],
      ),
      // Loader while fetching data
      bottomSheet: GlobalLoader(),
    );
  }
}
