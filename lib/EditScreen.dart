import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'TodoList.dart';

class EditScreen extends StatefulWidget {
  final TodoItem item;

  EditScreen({required this.item});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _category;
  late DateTime _dateTime;
  late TimeOfDay _time;


  @override
  void initState() {
    super.initState();
    _title = widget.item.title;
    _description = widget.item.description;
    _category = widget.item.category;
    _dateTime = widget.item.deadline;
    _time =TimeOfDay.fromDateTime(widget.item.deadline);
  }

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
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
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
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
              SizedBox(height: 16.0),
            TextFormField(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0,),
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
                          final time = await showTimePicker(
                            context : context,
                            initialTime: _time
                          );
                          if (time != null) {
                      setState(() {
                        _time = TimeOfDay.fromDateTime(DateTime(
                          _dateTime.year,
                          _dateTime.month,
                          _dateTime.day,
                          time.hour,
                          time.minute,
                        ));
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    todoList.editItem(
                      todoList.items.indexOf(widget.item),
                      _title,
                      _description,
                      _category,
                      _dateTime,
                      _time
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
