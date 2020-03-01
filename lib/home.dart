import 'package:flutter/material.dart';
import 'package:save_json/models/bancoBD.dart';

import 'models/item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController newTaskCtrl = TextEditingController();
  List<Item> data;
  final banco = Banco.instance;

  _HomePageState() {
    data = new List<Item>();
    load();
  }

  // void transformaaListaemMapStringDynamic() {
  //   List<Map<String, dynamic>> lista = [];
  //   for (var i in data) {
  //     lista.add(i.toJson());
  //   }
  // }

  Future load() async {
    final listatemp = await banco.getall();
    setState(() {
      data = listatemp;
    });

    // transformaaListaemMapStringDynamic();
  }

  Future<void> add() async {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      Item item = Item(title: "${newTaskCtrl.text}");
      banco.insertItem(item.toJson());
      newTaskCtrl.clear();
    });
    await load();
  }

  Future<void> remove(id) async {
    await banco.deleteItem('$id');
    await load();
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
                  title: Text('${datas.title}'),
                  subtitle: Text('${datas.id}'),
                ),
                key: Key(datas.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    remove(datas.id);
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
              Divider(
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
