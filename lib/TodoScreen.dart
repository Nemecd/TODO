import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/AddScreen.dart';
import 'package:todo/EditScreen.dart';
import 'package:todo/ViewScreen.dart';

import 'TodoList.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO-DO LIST'),
      ),
      body: ListView.builder(
        itemCount: todoList.items.length,
        itemBuilder: (context, index) {
          final item = todoList.items[index];
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewScreen(item: item)
                )
              );
            },
          child: ListTile(
            title: Text(item.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description),
               const SizedBox(height: 4.0),
               Text('Deadline: ${DateFormat.yMd().add_jm().format(item.deadline)}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditScreen(item: item),
                          ));
                    }),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    todoList.removeItem(index);
                  },
                ),
              ],
            ),
          ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}