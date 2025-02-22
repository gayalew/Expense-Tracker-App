import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/helper/edit_dialog.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _selectedSortOrder = 'Descending';
  // Default to show all expenses
  final List<String> _categories = [
    'All',
    'Food',
    'Shopping',
    'Health',
    'Travel',
    'Utility'
  ];

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
  }

  // Function to toggle the sort order between Ascending and Descending
  void _toggleSortOrder() {
    setState(() {
      _selectedSortOrder =
          _selectedSortOrder == 'Descending' ? 'Ascending' : 'Descending';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          TextButton(
              onPressed: _toggleSortOrder,
              child: Row(
                children: [
                  Text("time | "),
                  Icon(
                    _selectedSortOrder == 'Descending'
                        ? Icons.arrow_downward // Down arrow for descending
                        : Icons.arrow_upward, // Up arrow for ascending
                  ),
                ],
              )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          // StreamBuilder to fetch and display data
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .orderBy('date',
                      descending: _selectedSortOrder ==
                          'Descending') // Dynamically set descending based on the sort order
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No expenses found.'));
                }

                final items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];

                    return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (context) async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(item.id) // Get the document ID
                                    .delete();
                              } catch (e) {
                                print("Error deleting expense: $e");
                              }
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5), // Reduce padding
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 1, // Reduce the size of this action
                            onPressed: (context) {
                              showEditDialog(context, item);
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 183, 232, 143),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,

                            label: 'Edit',
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5), // Reduce padding
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 4, // Adds slight shadow for depth
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              12.0), // Add padding inside the card
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon with a background
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(
                                      0.2), // Light green background
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.attach_money,
                                    color: Colors.blue, size: 28),
                              ),

                              const SizedBox(
                                  width: 12), // Spacing between icon and text

                              // Expense Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${formatTimestamp(item['date'])}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Expense Amount
                              Text(
                                '\$${item['amount']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .redAccent, // Expense amount in red for emphasis
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    /////
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
