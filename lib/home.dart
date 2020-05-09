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

  Future<void> add(String texto) async {
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

  showAlertDialog(BuildContext context) {
    AlertDialog alerta = AlertDialog(
      title: Text('Nova Tarefa'),
      content: TextField(
        controller: newTaskCtrl,
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Adicionar'),
          onPressed: () {
            add(newTaskCtrl.value.text);
            newTaskCtrl.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Tirar Text
        title: Text('Tarefas'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final datas = data[index];

          return Column(
            children: <Widget>[
              Dismissible(
                child: ListTile(
                  title: Text('${datas.id} - ${datas.title}'),
                  //subtitle: Text('${datas.id}'),
                ),
                key: Key(datas.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    remove(datas.id);
                  }
                },
                background: Container(
                  color: Colors.red.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.delete),
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
        onPressed: () => showAlertDialog(context),
        tooltip: 'Adicionar',
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
