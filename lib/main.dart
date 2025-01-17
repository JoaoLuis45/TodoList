// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:curso/models/item.dart';
import 'package:flutter/material.dart';

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
    items?.add(Item(title: 'Item 1', done: false));
    items?.add(Item(title: 'Item 2', done: true));
    items?.add(Item(title: 'Item 3', done: false));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaksCrtl = TextEditingController();
  void add() {
    setState(() {
      if (newTaksCrtl.text != '') {
        widget.items?.add(Item(title: newTaksCrtl.text, done: false));
        newTaksCrtl.clear();
      }
    });
  }

  void remove(int index) {
    setState(() {
      widget.items!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaksCrtl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            label: Text("Nova Tarefa"),
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
                    });
                  }),
              background: Container(
                color: const Color.fromARGB(255, 255, 17, 0).withOpacity(0.8),
              ),
              onDismissed: (direction) => {print(direction)},
              direction: DismissDirection.startToEnd,
            );
          },
          itemCount: widget.items?.length),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        onPressed: add,
      ),
    );
  }
}
