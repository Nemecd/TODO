import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/TodoList.dart';

class ViewScreen extends StatelessWidget {
  final TodoItem item;

  ViewScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMEEEEd();
    final timeFormat = DateFormat.jm();
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              item.description,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Deadline: ${dateFormat.format(item.deadline)} at ${timeFormat.format(item.deadline)}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
