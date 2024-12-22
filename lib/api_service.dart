import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_11/model/coffee.dart';
import 'package:practice_11/model/order.dart';
import 'package:practice_11/model/order_create.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.6:8080',
      connectTimeout: Duration(seconds: 50),
      receiveTimeout: Duration(seconds: 50),
    ),
  );

  Future<String?> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
  Future<List<Coffee>> getCoffees() async {
    try {
      final response = await _dio.get('http://192.168.1.6:8080/coffees');
      if (response.statusCode == 200) {
        List<Coffee> coffee = (response.data as List)
            .map((coffee) => Coffee.fromJson(coffee))
            .toList();
        return coffee;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
  Future<Coffee> createCoffee(Coffee coffee) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.6:8080/coffee/create',
        data: coffee.toJson(),
      );
      if (response.statusCode == 200) {
        return Coffee.fromJson(response.data);
      } else {
        throw Exception('Failed to create coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating coffee: $e');
    }
  }
  Future<Coffee> getCoffeeById(int id) async {
    try {
      final response = await _dio.get('http://192.168.1.6:8080/coffee/$id');
      if (response.statusCode == 200) {
        return Coffee.fromJson(response.data);
      } else {
        throw Exception('Failed to load coffee with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coffee by ID: $e');
    }
  }
  Future<Coffee> updateCoffee(int id, Coffee coffee) async {
    try {
      final response = await _dio.put(
        'http://192.168.1.6:8080/coffee/update/$id',
        data: coffee.toJson(),
      );
      if (response.statusCode == 200) {
        return Coffee.fromJson(response.data);
      } else {
        throw Exception('Failed to update coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating coffee: $e');
    }
  }
  Future<void> deleteCoffee(int id) async {
    try {
      final response = await _dio.delete('http://192.168.1.6:8080/coffee/delete/$id');
      if (response.statusCode == 204) {
        print("Coffee with ID $id deleted successfully.");
      } else {
        throw Exception('Failed to delete coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting coffee: $e');
    }
  }
  Future<Order> createOrder(OrderCreate orderCreate) async {
    try {
      final response = await _dio.post(
        'http://85.192.40.154:8000/orders/',
        data: orderCreate.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Не удалось создать заказ: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при создании заказа: $e');
    }
  }
  Future<List<Order>> getOrdersByUser(String userId) async {
    try {
      final response = await _dio.get('http://85.192.40.154:8000/orders/user/$userId');
      if (response.statusCode == 200) {
        List<Order> orders = (response.data as List)
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception('Не удалось загрузить заказы: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при получении заказов: $e');
    }
  }
}
