import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


import 'TodoList.dart';
import 'adHelper.dart';

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
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    _title = '';
    _description = '';
    _dateTime = DateTime.now();
    _time = TimeOfDay.now();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task',style: TextStyle( color: Colors.white),),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
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
                 const Text('At', style: TextStyle(fontSize: 18.0),),
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
                          final time =  await showTimePicker(
                            context : context,
                            initialTime: _time
                          );
                          if(time != null){
                            setState((){
                              _time = time;
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
                child: const Text('Add Item',style: TextStyle( color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: _bannerAd?.size.width.toDouble() ?? 0,
        height: _bannerAd?.size.height.toDouble() ?? 0,
        child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : const Placeholder()
      )
    );
  }
}
