import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class AddNewItemScreen extends StatefulWidget{
  const AddNewItemScreen({super.key});
  @override
  State<StatefulWidget> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen>{
  final _formKey=GlobalKey<FormState>();
  String _enteredName="";
  int _enteredQuantity=1;
  Category _selectedCategory=categories[Categories.vegetables]!;

  void _saveItem(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(id: DateTime.now().toString(), name: _enteredName, quantity: _enteredQuantity, category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text('Name')
                ),
                initialValue: _enteredName,
                validator: (value){
                  final trimmedValue=value?.trim();
                  if(trimmedValue==null || trimmedValue.isEmpty || trimmedValue.length<2 || trimmedValue.length>50){
                    return 'Name should be between 2 to 50 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  _enteredName=value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text("Quantity")
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (value){
                        final trimmedValue=value?.trim();
                        final intValue=int.tryParse(trimmedValue?? "");
                        if(intValue==null || intValue<=0){
                          return 'Quantity must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _enteredQuantity=int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for(final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color
                                ),
                                SizedBox(width: 6,),
                                Text(category.value.name)
                              ],
                            ),
                          )
                      ], onChanged: (value){
                        setState(() {
                          _selectedCategory=value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    _formKey.currentState!.reset();
                  }, child: Text('Reset')),
                  SizedBox(width: 16,),
                  ElevatedButton(onPressed: _saveItem, child: Text('Add Item'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}