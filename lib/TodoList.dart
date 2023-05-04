import 'package:flutter/widgets.dart';

class TodoList extends ChangeNotifier {
  final List<TodoItem> _items = [];

  List<TodoItem> get items => _items;

  void addItem(TodoItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
  void editItem(int index, String newTile, String newDescription){
    _items[index].title = newTile;
    _items[index].description = newDescription;
    notifyListeners();
  }
  TodoItem getItem(int index){
    return _items[index];
  }     
}

class TodoItem {
  String title;
  String description;
  DateTime deadline;

  TodoItem({required this.title, required this.description, required this.deadline});
}

// This section defines our TodoList class, which will manage our to-do list items. We extend the ChangeNotifier class, which is a special class that allows us to notify the UI when the state changes. Our TodoList class has a private _items list, which stores the to-do list items. We also define two methods, addItem and removeItem, which add and remove items from the list, respectively. In each of these methods, we call notifyListeners(), which tells the UI to update when the state changes.