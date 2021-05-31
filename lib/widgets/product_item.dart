import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/cart.dart';
import '../screens/product_detail_screen.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        header: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
        footer: GridTileBar(
          title: Container(
            width: double.infinity,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () =>
                  product.toggle(product.isFavorite, auth.token, auth.userId),
            ),
          ),
          trailing: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Item added to Cart',
                    softWrap: true,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              }),
        ),
      ),
    );
  }
}
