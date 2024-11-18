import 'package:flutter/material.dart';
import 'package:practice_10/model/coffee.dart';
import 'package:practice_10/pages/home_page.dart';
import 'package:practice_10/pages/second_page.dart';
import 'package:practice_10/pages/third_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  await Supabase.initialize(
    url: "https://rwonqkhzbjwsbxrronhr.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ3b25xa2h6Ymp3c2J4cnJvbmhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE4NjY5MDAsImV4cCI6MjA0NzQ0MjkwMH0.xxUTUBaLnWAD7Fz9R2VQuSkfxL_YyoUDPQ6WNfEeLgQ",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Coffee> _favouriteCoffee = [];

  void _toggleFavourite(Coffee coffee) {
    setState(() {
      if (_favouriteCoffee.contains(coffee)) {
        _favouriteCoffee.remove(coffee);
      } else {
        _favouriteCoffee.add(coffee);
      }
    });
  }

  void _addToCart(Coffee coffee) {
    print('Добавлено в корзину: ${coffee.title}');
  }
  void _onTap(Coffee coffee) {
    print('Показать детали для: ${coffee.title}');
  }


  void _onEdit(Coffee coffee) {
    print('Редактирование напитка: ${coffee.title}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomePage(
        onFavouriteToggle: _toggleFavourite,
        favouriteCoffee: _favouriteCoffee,
      ),
      SecondPage(
        favouriteCoffee: _favouriteCoffee,
        onFavouriteToggle: _toggleFavourite,
        onAddToCart: _addToCart,
        onTap: _onTap,
        onEdit: _onEdit,
      ),
      const ThirdPage(),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 187, 164, 132),
        onTap: _onItemTapped,
      ),
    );
  }
}
