import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


import 'TodoList.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dateTime;
  late TimeOfDay _time;
  String _categoryValue = 'Personal';

  @override
  void initState() {
    super.initState();
    _title = '';
    _description = '';
    _dateTime = DateTime.now();
    _time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration:  const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  const Text(
                    'Category:',
                    style: TextStyle(fontSize: 18.0)
                  ),
                  SizedBox(
                    width: 250.0,
                    child: DropdownButtonFormField<String>(
                      value: _categoryValue,
                      onChanged: (newValue) {
                        setState(() {
                          _categoryValue = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'Personal',
                          child: Text('Personal'),
                        ),
                        DropdownMenuItem(
                          value: 'Work',
                          child: Text('Work'),
                        ),
                        DropdownMenuItem(
                          value: 'Shopping',
                          child: Text('Shopping'),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 16.0),
              Row(
                children:[
                 const Text('Deadline', style: TextStyle(fontSize: 18.0),),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context, 
                          initialDate: _dateTime, 
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)
                         );
                         if(date != null){
                          setState(() {
                            _dateTime = date;
                          });
                         }
                      },
                      child: Text(
                        'Date: ${DateFormat.yMd().format(_dateTime)}'
                      )
                      ),
                    ),
                    const SizedBox(width: 8.0,),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final time = showTimePicker(
                            context : context,
                            initialTime: _time
                          );
                          if(time != null){
                            setState((){
                              _time = time as TimeOfDay;
                            });
                          }
                        } ,
                        child: Text(
                          'Time: ${_time.format(context)}'
                        ),
                        )
                      )
                ]
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final dateTime = DateTime(
                      _dateTime.year,
                      _dateTime.month,
                      _dateTime.day,
                      _time.hour,
                      _time.minute,
                    );
                    todoList.addItem(
                      TodoItem(
                        title: _title, 
                        description: _description,
                        deadline: dateTime,
                        category: _categoryValue,
                        isDone: false
                        ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
