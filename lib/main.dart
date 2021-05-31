import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/loading_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/userProductScreen.dart';
import '../screens/cart_screen.dart';
import './provider/products_provider.dart';
import '../provider/auth.dart';
import 'provider/cart.dart';
import './helpers/custom_route.dart';

import '../screens/auth_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './provider/orders.dart';
import '../screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => null,
          update: (ctx, auth, priviousProductsProvider) => ProductsProvider(
            auth.token,
            auth.userId,
            priviousProductsProvider == null
                ? []
                : priviousProductsProvider.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => null, //(_) {
          //   return null;
          // },
          update: (ctx, auth, priviousOrders) => Orders(
            priviousOrders == null ? [] : priviousOrders.getOrder,
            auth.token,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'SHOP APP',
          theme: ThemeData(
              primarySwatch: Colors.cyan,
              // colorScheme.secondary : Colors.grey,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          //home: ProductOverviewScreen(),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
