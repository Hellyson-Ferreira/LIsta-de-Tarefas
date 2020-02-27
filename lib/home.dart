import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController newTaskCtrl = TextEditingController();
  List data;
   Future<String> loadJsonFile() async{
    var jsonFile = await rootBundle.loadString('assets/json/item.json');
    setState(() {
      data = json.decode(jsonFile);
    });
    
  }

  void add() {
    if(newTaskCtrl.text.isEmpty) return;
    print(data);
    setState(() {
      data.add({"title":"${newTaskCtrl.text}"});
      newTaskCtrl.clear();
    });
    print(data);
    
  }
 
  void remove(index) {
    setState(() {
      data.removeAt(index);
      
    });
    print(data);
  }

  @override
  void initState() {

    this.loadJsonFile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Tirar Text
        title: TextFormField(
          keyboardType: TextInputType.text,
          controller: newTaskCtrl,
          decoration: InputDecoration(
            labelText: "Adicionar perguntas",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final datas = data[index];

          return Column(
            children: <Widget>[
              Dismissible(
                child: ListTile(
                  title: Text(datas['title']),
                  subtitle: Text(datas.toString()),
                  
                  
                ),
                key: Key(datas.toString()),
                direction: DismissDirection.endToStart,
                
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart){
                    remove(index);
                  }                  
                },
                background: Container(
                  color: Colors.red.withOpacity(0.4),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Icon(Icons.close),
                   ),
                   alignment: Alignment.centerRight,
                ), 
              ),
              Divider(color: Colors.grey,),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}