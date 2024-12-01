import 'package:flutter/material.dart';
import 'package:practice_11/api_service.dart';
import 'package:practice_11/components/item_note.dart';
import 'package:practice_11/model/coffee.dart';
import 'package:practice_11/pages/basket_page.dart';
import 'package:practice_11/model/cart_item.dart';


class HomePage extends StatefulWidget {
  final Function(Coffee) onFavouriteToggle;
  final List<Coffee> favouriteCoffee;

  const HomePage(
      {super.key,
      required this.onFavouriteToggle,
      required this.favouriteCoffee});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CartItem> cart = [];
  List<Coffee> coffee = [];
  List<Coffee> searchResult = [];
  final ApiService apiService = ApiService();
  String searchQuery = "";

  void addToCart(Coffee coffee) {
    setState(() {
      final cartItemIndex =
          cart.indexWhere((item) => item.coffee.id == coffee.id);
      if (cartItemIndex != -1) {
        cart[cartItemIndex].quantity++;
      } else {
        cart.add(CartItem(coffee: coffee, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${coffee.title} добавлен в корзину'),
    ));
  }

  Future<void> _addNewNoteDialog(BuildContext context) async {
    String title = '';
    String description = '';
    String imageUrl = '';
    String cost = '';
    String article = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить новый напиток'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Название'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Описание'),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                  decoration: const InputDecoration(labelText: 'Картинка'),
                  onChanged: (value) {
                    imageUrl = value;
                  }),
              TextField(
                decoration: const InputDecoration(labelText: 'Цена'),
                onChanged: (value) {
                  cost = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Артикул'),
                onChanged: (value) {
                  article = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Добавить'),
              onPressed: () async {
                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    cost.isNotEmpty &&
                    article.isNotEmpty) {
                  Coffee newCoffee = Coffee(
                    coffee.length,
                    title,
                    description,
                    imageUrl,
                    cost,
                    article,
                  );
                  try {
                    Coffee createdCoffee =
                        await apiService.createCoffee(newCoffee);
                    setState(() {
                      coffee.add(createdCoffee);
                    });
                    Navigator.of(context).pop();
                  } catch (error) {
                    print('Ошибка при добавлении кофе: $error');
                  }
                } else {
                  print('Пожалуйста, заполните все поля.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchCoffees() async {
    final response = await apiService.getCoffees();
    if (response.isNotEmpty) {
      setState(() {
        coffee = response;
        searchResult = response;
      });
    }
  }
  void filterSearchResults(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchResult = coffee;
      } else {
        searchResult = coffee.where((item) {
          final title = item.title.toLowerCase();
          final description = item.description.toLowerCase();
          return title.contains(query.toLowerCase()) || description.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCoffees();
  }

  Future<void> fetchCoffeeById(int id) async {
    try {
      Coffee coffeeItem = await apiService.getCoffeeById(id);
      _showCoffeeDetailsDialog(coffeeItem);
    } catch (e) {
      print('Ошибка получения кофе: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка получения кофе: $e')),
      );
    }
  }

  Future<void> deleteCoffee(int coffeeId, int index) async {
    try {
      await apiService.deleteCoffee(coffeeId);
      setState(() {
        coffee.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Кофе с ID $coffeeId был удален')),
      );
    } catch (error) {
      print('Ошибка при удалении кофе: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении кофе: $error')),
      );
    }
  }

  void _showCoffeeDetailsDialog(Coffee coffeeItem) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(coffeeItem.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(coffeeItem.imageUrl),
              Text('Описание: ${coffeeItem.description}'),
              Text('Цена: ${coffeeItem.cost}'),
              Text('Артикул: ${coffeeItem.article}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Кофе',
                  style: TextStyle(fontSize: 24),
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BasketPage(cart: cart)),
                        );
                      },
                    ),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.fold<int>(0, (previousValue, item) => previousValue + item.quantity)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: filterSearchResults,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: searchResult.isNotEmpty
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: searchResult.length,
          itemBuilder: (BuildContext context, int index) {
            final Coffee coffeeItem = searchResult[index];
            final isFavourite =
            widget.favouriteCoffee.contains(coffeeItem);
            final DismissDirection dismissDirection = index % 2 == 0
                ? DismissDirection.endToStart
                : DismissDirection.startToEnd;

            return Dismissible(
              key: Key(coffeeItem.id.toString()),
              direction: dismissDirection,
              onDismissed: (direction) {
                setState(() {
                  coffee.removeAt(index);
                  searchResult = List.from(coffee);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${coffeeItem.title} был удален')),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () async {
                        await deleteCoffee(coffeeItem.id, index);
                      },
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              child: ItemNote(
                coffee: coffeeItem,
                isFavourite: isFavourite,
                onFavouriteToggle: () =>
                    widget.onFavouriteToggle(coffeeItem),
                onAddToCart: () => addToCart(coffeeItem),
                onTap: () => fetchCoffeeById(coffeeItem.id),
                onEdit: () => _editNoteDialog(context, coffeeItem),
              ),
            );
          },
        )
            : const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editNoteDialog(BuildContext context, Coffee coffeeItem) async {
    String title = coffeeItem.title;
    String description = coffeeItem.description;
    String imageUrl = coffeeItem.imageUrl;
    String cost = coffeeItem.cost;
    String article = coffeeItem.article;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать напиток'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Название'),
                controller: TextEditingController(text: title),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Описание'),
                controller: TextEditingController(text: description),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Картинка'),
                controller: TextEditingController(text: imageUrl),
                onChanged: (value) {
                  imageUrl = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Цена'),
                controller: TextEditingController(text: cost),
                onChanged: (value) {
                  cost = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Артикул'),
                controller: TextEditingController(text: article),
                onChanged: (value) {
                  article = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () async {
                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    cost.isNotEmpty &&
                    article.isNotEmpty) {
                  Coffee updatedCoffee = Coffee(
                    coffeeItem.id,
                    title,
                    description,
                    imageUrl,
                    cost,
                    article,
                  );
                  try {
                    Coffee result = await apiService.updateCoffee(
                        coffeeItem.id, updatedCoffee);
                    setState(() {
                      int index =
                          coffee.indexWhere((c) => c.id == coffeeItem.id);
                      if (index != -1) {
                        coffee[index] = result;
                      }
                    });
                    Navigator.of(context).pop();
                  } catch (error) {
                    print('Ошибка при обновлении кофе: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Ошибка при обновлении кофе: $error')),
                    );
                  }
                } else {
                  print('Пожалуйста, заполните все поля.');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
