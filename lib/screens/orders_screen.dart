import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/orderItem.dart';
import '../provider/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  // @override
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchSetOrder().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchSetOrder(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.getOrder.length,
                  itemBuilder: (_, index) =>
                      OrderItem(orderData.getOrder[index]),
                );
              },
            );
          }
        },
      ),
      // ? Center(child: CircularProgressIndicator())
      // : ListView.builder(
      //     itemCount: orderData.getOrder.length,
      //     itemBuilder: (_, index) => OrderItem(orderData.getOrder[index]),
      //   ),
    );
  }
}
