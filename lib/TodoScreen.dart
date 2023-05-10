
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/AddScreen.dart';
import 'package:todo/EditScreen.dart';
import 'package:todo/ViewScreen.dart';

import 'TodoList.dart';
import 'adHelper.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  BannerAd? _bannerAd;
  @override
  void initState(){
    super.initState();

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
          child: Column(
            children: [
              ListTile(
                title: Text(
                  item.title,
                  style: TextStyle(
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description,
                      style: TextStyle(
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                    ),
                      ),
                   const SizedBox(height: 4.0),
                   Text('Deadline: ${DateFormat.yMd().add_jm().format(item.deadline)}',
                   style: TextStyle(
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                    ),
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context){
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: const [
                            Icon(Icons.edit),
                            SizedBox(width: 8,),
                            Text('Edit')
                          ]
                        )
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(width: 8,),
                            Text('Delete')
                          ]
                        )
                      ),
                      PopupMenuItem(
                        value: 'done',
                        child: Row(
                          children: const [
                            Icon(Icons.done),
                            SizedBox(width: 8,),
                            Text('Done')
                          ]
                        )
                      )
                    ];
                  },
                  onSelected: (value){
                    switch(value){
                      case 'edit': Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScreen(item: item)
                        )
                      );
                      break;
                      case 'delete':
                      todoList.removeItem(index);
                      break;
                      case 'done':
                      todoList.updateItem(index, TodoItem(
                        title: item.title,
                        description: item.description,
                        deadline: item.deadline,
                        isDone: true, category: '',
                      ));
                      break;
                    }
                  },
                ),
              ),
              if(_bannerAd != null) 
                    Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )    
            ],
          ),
          );
        }    
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
