import 'package:flutter/material.dart';
import 'package:practice_11/components/item_note.dart';
import 'package:practice_11/model/coffee.dart';
import 'package:practice_11/pages/catalog_page.dart';


class SecondPage extends StatelessWidget {
  final List<Coffee> favouriteCoffee;
  final Function(Coffee) onFavouriteToggle;
  final Function(Coffee) onAddToCart;
  final Function(Coffee) onTap;
  final Function(Coffee) onEdit;

  const SecondPage(
      {super.key,
      required this.favouriteCoffee,
      required this.onFavouriteToggle,
      required this.onAddToCart,
      required this.onEdit,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: favouriteCoffee.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: favouriteCoffee.length,
                itemBuilder: (BuildContext context, int index) {
                  final coffee = favouriteCoffee[index];
                  return ItemNote(
                    coffee: coffee,
                    isFavourite: true,
                    onFavouriteToggle: () {
                      onFavouriteToggle(coffee);
                    },
                    onAddToCart:() {
                      onAddToCart(coffee);
                    },
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatalogPage(coffee: coffee),
                        )
                      );
                    },
                    onEdit: (){
                      onEdit(coffee);
                    },
                  );
                },
              )
            : const Center(
                child: Text('Нет избранных напитков'),
              ),
      ),
    );
  }
}
