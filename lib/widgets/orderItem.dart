import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart' as Ord;

class OrderItem extends StatefulWidget {
  final Ord.OrderItem orderData;
  OrderItem(this.orderData);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
      height: _expanded
          ? min(widget.orderData.products.length * 20.0 + 110, 200)
          : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('Rs. ${widget.orderData.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.orderData.date)),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              height: _expanded
                  ? min(widget.orderData.products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.orderData.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(prod.title),
                            Text('${prod.quantity} * ${prod.price}'),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
