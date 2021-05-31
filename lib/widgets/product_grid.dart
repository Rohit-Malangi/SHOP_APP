import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../provider/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool isFav;
  ProductGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final product = isFav ? productData.favoriteProduct : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: product.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: product[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
