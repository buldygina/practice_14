import 'package:practice_8/model/coffee.dart';
class CartItem {
  final Coffee coffee;
  int quantity;

  CartItem({required this.coffee, this.quantity = 1});
}