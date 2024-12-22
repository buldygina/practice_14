import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_11/model/cart_item.dart';
import 'package:practice_11/api_service.dart';
import '../model/order_create.dart';

class BasketPage extends StatefulWidget {
  final List<CartItem> cart;

  const BasketPage({super.key, required this.cart});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final ApiService apiService = ApiService();
  bool _isLoading = false;

  int calculateTotalPrice() {
    int total = 0;
    for (var item in widget.cart) {
      total += int.parse(item.coffee.cost) * item.quantity;
    }
    return total;
  }

  void increaseQuantity(int index) {
    setState(() {
      widget.cart[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (widget.cart[index].quantity > 1) {
        widget.cart[index].quantity--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.cart.removeAt(index); // Удаление элемента из корзины
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Товар удален из корзины')),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Удалить товар?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Отмена"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Удалить"),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('Пользователь не авторизован');
    }
  }
  @override
  Widget build(BuildContext context) {
    final totalPrice = calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: widget.cart.isNotEmpty
          ? Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cart[index];

                return Dismissible(
                  key: Key(cartItem.coffee.id.toString()),
                  direction: DismissDirection.endToStart, // Свайп только влево
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  confirmDismiss: (direction) async {
                    // Открыть диалог для подтверждения удаления
                    final confirm = await showDeleteConfirmationDialog(context);
                    if (confirm == true) {
                      removeItem(index); // Удалить товар
                      return true;
                    }
                    return false;
                  },
                  child: ListTile(
                    leading: Image.network(
                      cartItem.coffee.imageUrl,
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cartItem.coffee.title),
                    subtitle: Text('${cartItem.quantity} x ${cartItem.coffee.cost} руб.'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => decreaseQuantity(index),
                        ),
                        Text(cartItem.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => increaseQuantity(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      String userId = await _getUserId();
                      List<int> productIds = widget.cart.map((item) => item.coffee.id).toList();
                      List<int> quantities = widget.cart.map((item) => item.quantity).toList();


                      OrderCreate newOrder = OrderCreate(
                        customerId: userId,
                        productIds: productIds,
                        quantities: quantities,
                        totalPrice: totalPrice.toDouble(),
                      );


                      await apiService.createOrder(newOrder);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Покупка оформлена!')),
                      );

                      // Очистка корзины после успешной покупки
                      setState(() {
                        widget.cart.clear();
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка при оформлении покупки: $e')),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Купить',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Color.fromARGB(255, 187, 164, 132),
                  ),
                ),

              ],
            ),
          ),
        ],
      )
          : const Center(child: Text('Ваша корзина пуста')),
    );
  }
}
