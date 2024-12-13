import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_11/firebase_options.dart';
import 'package:practice_11/model/coffee.dart';
import 'package:practice_11/pages/home_page.dart';
import 'package:practice_11/services/login_or_register.dart';
import 'package:practice_11/pages/second_page.dart';
import 'package:practice_11/pages/third_page.dart';
import 'package:practice_11/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
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
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);


    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const MyHomePage();
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
