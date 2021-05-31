import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detatil';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final item = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(item.title),
        // ),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(item.title),
            background: Hero(
                tag: item.id,
                child: Image.network(item.imageUrl, fit: BoxFit.cover)),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              'Product Price : ${item.price}',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${item.description}',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ],
    ));
  }
}
