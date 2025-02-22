import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
  return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
}
