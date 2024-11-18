import 'package:dio/dio.dart';
import 'package:practice_10/model/coffee.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.38:8080',
      connectTimeout: Duration(seconds: 50),
      receiveTimeout: Duration(seconds: 50),
    ),
  );

  Future<List<Coffee>> getCoffees() async {
    try {
      final response = await _dio.get('http://192.168.1.38:8080/coffees');
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
        'http://192.168.1.38:8080/coffee/create',
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
      final response = await _dio.get('http://192.168.1.38:8080/coffee/$id');
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
        'http://192.168.1.38:8080/coffee/update/$id',
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
      final response = await _dio.delete('http://192.168.1.38:8080/Coffee/delete/$id');
      if (response.statusCode == 204) {
        print("Coffee with ID $id deleted successfully.");
      } else {
        throw Exception('Failed to delete coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting coffee: $e');
    }
  }
}
