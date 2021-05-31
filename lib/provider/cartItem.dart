import 'package:flutter/material.dart';

class CardItem with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CardItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}
