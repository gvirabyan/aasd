import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data to display in the ListView
    final List<Map<String, String>> orders = [
      {'startDate': '2024-10-01', 'endDate': '2024-10-02', 'price': '\$30.00', 'status': 'Completed'},
      {'startDate': '2024-10-05', 'endDate': '2024-10-06', 'price': '\$45.00', 'status': 'Completed'},
      {'startDate': '2024-10-10', 'endDate': '2024-10-11', 'price': '\$20.00', 'status': 'Cancelled'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders available.'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Order from ${order['startDate']} to ${order['endDate']}'),
            subtitle: Text('Price: ${order['price']}, Status: ${order['status']}'),
          );
        },
      ),
    );
  }
}
