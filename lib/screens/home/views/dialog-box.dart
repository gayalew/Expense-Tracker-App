import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DialogBox extends StatefulWidget {
  final Function(String, double, DateTime, String) onAddExpense;

  const DialogBox({super.key, required this.onAddExpense});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = [
    'Food',
    'Shopping',
    'Health',
    'Travel',
    'Utility'
  ];

  void _presentDateTimePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return; // If user cancels, do nothing

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return; // If user cancels, do nothing

    // Combine date and time into a single DateTime object
    DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDate = pickedDateTime;
    });
  }

  Future<void> _submitData() async {
    final enteredName = _nameController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredName.isEmpty ||
        enteredAmount == null ||
        _selectedDate == null ||
        _selectedCategory == null) {
      return;
    }

    //add
    Expense item = Expense(
        name: enteredName,
        amount: enteredAmount,
        category: _selectedCategory!,
        date: _selectedDate!);

    await FirebaseFirestore.instance.collection('items').add({
      'name': item.name,
      'amount': item.amount,
      'category': item.category,
      'date': item.date,
    });

    // widget.onAddExpense(
    //     enteredName, enteredAmount, _selectedDate!, _selectedCategory!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Expense Name'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                ),
              ),
              TextButton(
                onPressed: _presentDateTimePicker,
                child: const Text('Choose Date'),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitData,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
