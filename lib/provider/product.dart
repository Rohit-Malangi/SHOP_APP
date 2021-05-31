import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.title,
    this.isFavorite = false,
  });

  Future<void> toggle(bool isFav, String token, String userId) async {
    isFavorite = !isFav;
    notifyListeners();
    final url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
        '/favoriteProduct/$userId/$id.json', {'auth': '$token'});
    await http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );
  }
}
