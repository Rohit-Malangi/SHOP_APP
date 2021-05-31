import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../provider/cart.dart';
import './cart_screen.dart';
import '../widgets/app_Drawer.dart';

enum FilterValue {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isfavorite = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SHOP APP"),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterValue selectedValue) {
              setState(() {
                if (selectedValue == FilterValue.Favorite)
                  _isfavorite = true;
                else
                  _isfavorite = false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorite'),
                value: FilterValue.Favorite,
              ),
              PopupMenuItem(
                child: Text('All Item'),
                value: FilterValue.All,
              ),
            ],
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        color: Colors.grey,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductGrid(_isfavorite),
      ),
    );
  }
}
