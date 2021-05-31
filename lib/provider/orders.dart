import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './cartItem.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CardItem> products;
  final DateTime date;

  OrderItem({
    @required this.amount,
    @required this.date,
    @required this.id,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrder {
    return [..._orders];
  }

  final String _token;
  final String _userId;

  Orders(this._orders, this._token, this._userId);

  Future<void> fetchSetOrder() async {
    final url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
        '/orders/$_userId.json', {'auth': '$_token'});
    final responce = await http.get(url);
    final List<OrderItem> feachedOrder = [];
    final extractData = json.decode(responce.body) as Map<String, dynamic>;
    if (extractData == null) return;
    extractData.forEach((orderId, orderData) {
      feachedOrder.insert(
          0,
          OrderItem(
            amount: orderData['amount'],
            date: DateTime.parse(orderData['date']),
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CardItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ));
    });
    _orders = feachedOrder;
    notifyListeners();
  }

  Future<void> addOrder(List<CardItem> cartProduct, double total) async {
    final url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
        '/orders/$_userId.json', {'auth': '$_token'});
    final time = DateTime.now();
    final responce = await http.post(url,
        body: json.encode({
          'amount': total,
          'date': time.toIso8601String(),
          'products': cartProduct
              .map((item) => {
                    'quantity': item.quantity,
                    'price': item.price,
                    'title': item.title,
                    'id': item.id,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        date: time,
        id: json.decode(responce.body)['name'],
        products: cartProduct,
      ),
    );
    notifyListeners();
  }
}
