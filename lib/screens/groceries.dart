import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/add_new_item.dart';
import 'package:http/http.dart' as http;

class GroceryScreen extends StatefulWidget{
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems=[];
  bool _isLoading=true;
  String? _error;

  void _addItem()async {
    final item=await Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddNewItemScreen()));
    if(item is GroceryItem){
      setState(() {
        _groceryItems.add(item);
      });
    }
    else if(item is bool && item){
      _loadItems();
    }
  }

  void _loadItems(){
    http.get(
      Uri.https(dotenv.env['FIREBASE_RTD_URL']!,'/shopping-list.json'),
    ).then((response){
      if(response.body=='null'){
        return;
      }
      List<GroceryItem> loadedItems=[];
      final Map<String, dynamic> data=json.decode(response.body);
      if(response.statusCode==200){
          loadedItems=
            data.entries.map(
              (item)=>GroceryItem(
                id: item.key, 
                name: item.value["name"], 
                quantity: item.value["quantity"], 
                category: categories.values.firstWhere((category)=>category.name==item.value["category"])
              )
          ).toList();
      }
      setState(() {
        if(response.statusCode==200){
          _groceryItems=loadedItems;
        }
        else{
          _error=data["error"];
        }
      });
    }).catchError((error){
      setState(() {
        _error="Somethign went wrong!";
      });
    }).whenComplete((){
      setState(() {
        _isLoading=false;
      });
    });
  }

  void _deleteItem(GroceryItem item){
    final index=_groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    http.delete(
      Uri.https(dotenv.env['FIREBASE_RTD_URL']!,'/shopping-list/${item.id}.json')
    ).then((response){
      if(response.statusCode!=200){
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error deleting item"))
          );
          setState(() {
            _groceryItems.insert(index, item);
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(onPressed: _addItem, icon: Icon(Icons.add))
        ],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator(),) :
        _error!=null? Center(child: Text(_error!),):
      _groceryItems.isEmpty? Center(
        child: Text("No groceries right now"),
      ):ListView.builder(
      itemBuilder: (ctx,index)=>Dismissible(
        key: ValueKey(_groceryItems[index].id),
        onDismissed: (direction){
          _deleteItem(_groceryItems[index]);
        },
        child: ListTile(
          title: Text(_groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItems[index].category.color
          ),
          trailing: Text(_groceryItems[index].quantity.toString()),
        ),
      ),
      itemCount: _groceryItems.length,
    ),
    );
  }
}