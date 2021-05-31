import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart' show Cart;
import '../provider/orders.dart';
import '../widgets/cartItemDetail.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 8,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text('TOTAL'),
                  Spacer(),
                  Chip(
                      label: Text('Rs. ${cart.totalPrice.toStringAsFixed(2)}')),
                  MyTextButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) => CartItemDetail(
                cart.getItem.values.toList()[index].id,
                cart.getItem.keys.toList()[index],
                cart.getItem.values.toList()[index].title,
                cart.getItem.values.toList()[index].price,
                cart.getItem.values.toList()[index].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyTextButton extends StatefulWidget {
  const MyTextButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _MyTextButtonState createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.getItem.values.toList(),
                    widget.cart.totalPrice);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearCart();
              },
        child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'));
  }
}
