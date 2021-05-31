import 'package:flutter/cupertino.dart';
import 'cartItem.dart';

class Cart with ChangeNotifier {
  Map<String, CardItem> _items = {};

  Map<String, CardItem> get getItem {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    double sum = 0.0;
    _items.forEach((key, value) {
      sum += value.price * value.quantity;
    });
    return sum;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (exitingCardItem) => CardItem(
          id: exitingCardItem.id,
          price: exitingCardItem.price,
          title: exitingCardItem.title,
          quantity: exitingCardItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CardItem(
          id: productId,
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String key) {
    if (!_items.containsKey(key)) return;
    if (_items[key].quantity > 1) {
      _items.update(
        key,
        (value) => CardItem(
            id: value.id,
            price: value.price,
            quantity: value.quantity - 1,
            title: value.title),
      );
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
