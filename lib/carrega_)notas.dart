import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'item.dart';

Future<String> _carregaItensJson() async {
  return await rootBundle.loadString('assets/json/notas.json');
}

Future carregaItens() async {
  String jsonString = await _carregaItensJson();
  final jsonResponse = json.decode(jsonString);
  Item  nota = new Item.fromJson(jsonResponse);
  print(nota.title);
}
