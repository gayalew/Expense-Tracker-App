import 'package:flutter/material.dart';

List<Map<String, dynamic>> transactionData = [
  {
    'icon': Icon(Icons.food_bank, color: Colors.white, size: 32),
    'color': Colors.yellow[700],
    'name': 'Food',
    'totalAmount': '-\$00.00',
    'date': 'total',
  },
  {
    'icon': Icon(Icons.shopping_bag, color: Colors.white, size: 32),
    'color': Colors.blue[300],
    'name': 'Shopping',
    'totalAmount': '-\$00.00',
    'date': 'total',
  },
  {
    'icon':
        Icon(Icons.health_and_safety_outlined, color: Colors.white, size: 32),
    'color': Colors.green[400],
    'name': 'Health',
    'totalAmount': '-\$00.00',
    'date': 'total',
  },
  {
    'icon': Icon(Icons.emoji_transportation, color: Colors.white, size: 32),
    'color': Colors.pinkAccent[400],
    'name': 'Travel',
    'totalAmount': '-\$00.00',
    'date': 'total',
  },
  {
    'icon': Icon(Icons.settings_accessibility, color: Colors.white, size: 32),
    'color': const Color.fromARGB(255, 188, 38, 238),
    'name': 'Utility',
    'totalAmount': '-\$00.00',
    'date': 'total',
  },
];
