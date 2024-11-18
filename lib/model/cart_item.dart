import 'package:practice_10/model/coffee.dart';
class CartItem {
  final Coffee coffee;
  int quantity;

  CartItem({required this.coffee, this.quantity = 1});
}
