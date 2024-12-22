import 'package:flutter/material.dart';
import 'package:practice_11/api_service.dart';
import 'package:practice_11/model/order.dart';
import 'package:practice_11/model/coffee.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final ApiService apiService = ApiService();
  late Future<List<Coffee>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    _productsFuture = Future.wait(widget.order.productIds.map((id) => apiService.getCoffeeById(id)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Детали заказа',
          style: TextStyle(color: Colors.white),
        ),
          backgroundColor: Color.fromARGB(255, 187, 164, 132)
      ),
      body: FutureBuilder<List<Coffee>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет данных о товарах'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final quantity = widget.order.quantities.length > index
                    ? widget.order.quantities[index]
                    : 1;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                    title: Text(product.title),
                    subtitle: Text('Цена: ${product.cost} руб.\nКоличество: $quantity'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}