import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../screens/userProductScreen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shop Now'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Main Page'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //     CustomRoute(builder: (ctx) => OrdersScreen()));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(UserProductScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logOut();
              }),
          Divider(),
        ],
      ),
    );
  }
}
