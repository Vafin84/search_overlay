import 'package:flutter/material.dart';
import 'package:search_overlay/search_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example Search Overlay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Example Search Overlay'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  final _searchController = TextEditingController();
  final _users = [
    User(name: "Anton", age: 18),
    User(name: "Ivan", age: 20),
    User(name: "Boris", age: 25),
    User(name: "Marina", age: 17),
    User(name: "Isabella", age: 22),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchOverlay<User>(
          searchController: _searchController,
          elevation: 8,
          borderRadius: 10,
          offset: 5,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: const Icon(
              Icons.search,
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                splashRadius: 16,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: "Search",
          ),
          items: _users
              .where((e) => e.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList(),
          filterFn: (item) => "${item.name}${item.age}",
          displayItemFn: (item) {
            return ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              title: Text("${item.name}, ${item.age} age"),
              onTap: () {
                _displayUser(context, item);
                _searchController.clear();
              },
            );
          },
        ),
      ),
    );
  }

  void _displayUser(BuildContext context, User user) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${user.name}, ${user.age} age")));
  }
}

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}
