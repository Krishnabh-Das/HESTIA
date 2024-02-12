// Time Stamp Format 11:15 AM, 12 Sept, 2023
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedTime = DateFormat.jm().format(dateTime); // Format: 11:15 AM
  String formattedDate =
      DateFormat('d MMM, y').format(dateTime); // Format: 12 Sept, 2023

  return '$formattedTime, $formattedDate';
}
