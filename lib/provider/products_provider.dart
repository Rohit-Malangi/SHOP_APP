import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../provider/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteProduct {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> fetchData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
        '/products.json', {'auth': '$authToken&$filterString'});
    try {
      final response = await http.get(url);
      //print(response.body);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final urlfav = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
          '/favoriteProduct/$userId.json', {'auth': '$authToken'});
      final fetchfavData = await http.get(urlfav);
      final favData = json.decode(fetchfavData.body);
      final List<Product> latestData = [];
      extractData.forEach((prodId, prodData) {
        //print(prodData);
        latestData.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = latestData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product prodIndex) async {
    final url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
        '/products.json', {'auth': '$authToken'});
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': prodIndex.title,
            'description': prodIndex.description,
            'imageUrl': prodIndex.imageUrl,
            'price': prodIndex.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
        title: prodIndex.title,
        imageUrl: prodIndex.imageUrl,
        description: prodIndex.description,
        price: prodIndex.price,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
          '/products/$id.json', {'auth': '$authToken'});
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final url = Uri.https('shop-app-aef4a-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': '$authToken'});
    http.delete(url);
  }
}
