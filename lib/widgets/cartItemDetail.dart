import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartItemDetail extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemDetail(
      this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              size: 50,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text(
              'Do you want to remove the item from the card ?',
              softWrap: true,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('YES')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('NO')),
            ],
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(child: Text('Rs. $price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${(price * quantity)}'),
            trailing: Text('$quantity *'),
          ),
        ),
      ),
    );
  }
}
