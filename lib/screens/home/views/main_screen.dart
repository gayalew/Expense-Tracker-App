import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/data/data.dart';
import 'package:spendwise/helper/edit_dialog.dart';
import 'package:spendwise/screens/home/views/categoryDetail-screen.dart';

class MainScreen extends StatefulWidget {
  final Map<String, double> categoryExpenses;

  const MainScreen({super.key, required this.categoryExpenses});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<double> getTotalExpenseByCategory(String categoryName) async {
    double totalCategoryAmount = 0.0;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('category', isEqualTo: categoryName)
          .get();

      for (var doc in querySnapshot.docs) {
        double amount = (doc['amount'] as num).toDouble();
        totalCategoryAmount += amount;
      }
    } catch (e) {
      print("Error fetching total expense: $e");
    }

    return totalCategoryAmount;
  }

  // to fetch the total amount
  Future<double> getTotalExpense() async {
    double totalAmount = 0.0;

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('items').get();

      for (var doc in querySnapshot.docs) {
        double amount = (doc['amount'] as num).toDouble();
        totalAmount += amount;
      }
    } catch (e) {
      print("Error fetching total expense: $e");
    }

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          return SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellowAccent,
                            ),
                          ),
                          Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onSurface,
                          )
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome!",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              )),
                          Text("Hymn"),
                        ],
                      ),
                    ]),
                    IconButton(
                        onPressed: () => showAboutMeDialog(context),
                        icon: Icon(CupertinoIcons.settings))
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<double>(
                  future: getTotalExpense(),
                  builder: (context, snapshot) {
                    double totalExpense = snapshot.data ?? 0.0;
                    double income = 50000.00;
                    double totalBalance = income - totalExpense;

                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          transform: const GradientRotation(pi / 4),
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey.shade300,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total Balance",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          snapshot.connectionState == ConnectionState.waiting
                              ? CircularProgressIndicator(
                                  color: Colors
                                      .white) // Show loader while fetching
                              : Text(
                                  "${totalBalance.toStringAsFixed(2)} ETB",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                        const Text(
                                          "Income",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${income.toStringAsFixed(2)} ETB",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                        const Text(
                                          "Expense",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            "${totalExpense.toStringAsFixed(2)} ETB",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: Text("View All",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactionData.length,
                    itemBuilder: (context, int i) {
                      String categoryName = transactionData[i]["name"];

                      return FutureBuilder<double>(
                        future: getTotalExpenseByCategory(categoryName),
                        builder: (context, snapshot) {
                          double totalAmount = snapshot.data ?? 0.0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to category detail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryDetailScreen(
                                      categoryName: categoryName,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: transactionData[i]
                                                    ["color"],
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            transactionData[i]["icon"],
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          categoryName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? CircularProgressIndicator() // Show loader while fetching
                                              : Text(
                                                  "$totalAmount ETB",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                          Text(
                                            transactionData[i]["date"],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
        });
  }
}
