import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/screens/home/views/detail.dart';
import 'package:spendwise/screens/home/views/dialog-box.dart';
import 'package:spendwise/screens/home/views/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, double> _categoryExpenses = {
    'Food': 0.0,
    'Shopping': 0.0,
    'Health': 0.0,
    'Travel': 0.0,
    'Utility': 0.0,
  };

  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  void _addNewExpense(
      String name, double amount, DateTime date, String category) {
    setState(() {
      _categoryExpenses[category] = (_categoryExpenses[category] ?? 0) + amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          selectedItemColor: Colors.blue,
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 2,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home,
                  color: index == 0 ? selectedItem : unselectedItem),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_dash,
                  color: index == 1 ? selectedItem : unselectedItem),
              label: 'Detail',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => DialogBox(
              onAddExpense: _addNewExpense,
            ),
          );
        },
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      body: index == 0
          ? MainScreen(categoryExpenses: _categoryExpenses)
          : DetailScreen(),
    );
  }
}
