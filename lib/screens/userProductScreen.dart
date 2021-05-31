import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../widgets/user_product_item.dart';
import '../provider/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProduct';
  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .fetchData(true),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () =>
                        Provider.of<ProductsProvider>(context, listen: false)
                            .fetchData(true),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemBuilder: (ctx, index) => Column(
                                  children: [
                                    UserProductItem(
                                      productData.items[index].id,
                                      productData.items[index].title,
                                      productData.items[index].imageUrl,
                                    ),
                                    Divider(),
                                  ],
                                ),
                            itemCount: productData.items.length),
                      ),
                    ),
                  ),
      ),
    );
  }
}
