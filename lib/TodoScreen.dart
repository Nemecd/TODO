import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

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

          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                todoList.removeItem(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final newitem = 'Item ${todoList.items.length +1}';
          todoList.addItem(newitem as TodoItem);
        },
        child: const Icon(Icons.add)
        
      ),
    );
  }
}