import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/add_new_item.dart';

class GroceryScreen extends StatefulWidget{
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final List<GroceryItem> _groceryItems=[];
  void _addItem()async {
    final newItem=await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (ctx)=>AddNewItemScreen()));
    if(newItem!=null){
      setState(() {
        _groceryItems.add(newItem);
      });
    }
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
      body: _groceryItems.isEmpty? Center(
        child: Text("No groceries right now"),
      ):ListView.builder(
      itemBuilder: (ctx,index)=>Dismissible(
        key: ValueKey(_groceryItems[index].id),
        onDismissed: (direction){
          setState(() {
            _groceryItems.remove(_groceryItems[index]);
          });
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