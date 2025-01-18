// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:todolist/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          useMaterial3: true,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  List<Item>? items;

  HomePage() {
    items = [];
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaksCrtl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void add() {
    setState(() {
      if (newTaksCrtl.text != '') {
        widget.items?.add(Item(title: newTaksCrtl.text, done: false));
        newTaksCrtl.clear();
        save();
      }
    });
  }

  void edit(int index) {
    setState(() {
      newTaksCrtl.clear();
      newTaksCrtl.text = widget.items![index].title!;
      remove(index);
      save();
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }

  void remove(int index) {
    setState(() {
      widget.items!.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          focusNode: _focusNode,
          controller: newTaksCrtl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            label: Text("Adicionar Nova Tarefa"),
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext ctxt, int index) {
            final item = widget.items?[index];
            return Dismissible(
              key: Key(item?.title ?? 'Sem Titulo'),
              child: CheckboxListTile(
                  title: Text(item?.title ?? 'Sem Titulo'),
                  value: item?.done,
                  onChanged: (value) {
                    setState(() {
                      item!.done = value!;
                      save();
                    });
                  }),
              background: Container(
                color: const Color.fromARGB(255, 255, 17, 0).withOpacity(0.8),
              ),
              secondaryBackground: Container(
                color: const Color.fromARGB(255, 55, 255, 0).withOpacity(0.8),
              ),
              onDismissed: (direction) => {
                if (direction == DismissDirection.startToEnd)
                  {remove(index)}
                else
                  {edit(index)}
              },
              direction: DismissDirection.horizontal,
            );
          },
          itemCount: widget.items?.length),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          add();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
      ),
    );
  }
}
