import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/helper/time_format.dart';
import 'package:url_launcher/url_launcher.dart';

void showEditDialog(BuildContext context, QueryDocumentSnapshot item) {
  TextEditingController nameController =
      TextEditingController(text: item['name']);
  TextEditingController amountController =
      TextEditingController(text: item['amount'].toString());
  DateTime selectedDate =
      (item['date'] as Timestamp).toDate(); // Convert Firebase Timestamp

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edit Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Expense Name"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${formatTimestamp(Timestamp.fromDate(selectedDate))}",
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('items')
                    .doc(item.id)
                    .update({
                  'name': nameController.text,
                  'amount': double.parse(amountController.text),
                  'date': Timestamp.fromDate(selectedDate),
                });

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Expense updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                print("Error updating expense: $e");
              }
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}

// about dialog

void showAboutMeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Developers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'Bemnet Ayalew - Web and Mobile App Developer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  final Uri url =
                      Uri.parse("https://bemnet-ayalew.vercel.app/");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  "https://bemnet-ayalew.vercel.app/",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("Expense tracker App V-1"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
