import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _todoList = [];
  final TextEditingController _todoController = TextEditingController();

  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPosition;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

  Widget buildItem(context, index) {
    return Dismissible(
      onDismissed: (direction) {
        _lastRemoved = Map.from(_todoList[index]);
        _lastRemovedPosition = index;

        setState(() {
          _todoList.removeAt(index);
        });

        _saveData();

        final snack = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('Tarefa "${_lastRemoved['title']}" removida'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                _todoList.insert(_lastRemovedPosition, _lastRemoved);
              });
              _saveData();
            },
          ),
        );

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: CheckboxListTile(
        onChanged: (checked) {
          setState(() {
            _todoList[index]["ok"] = checked;
          });

          _saveData();
        },
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["ok"],
        secondary: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(
            color: Colors.white,
            _todoList[index]["ok"] ? Icons.check : Icons.error,
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a['ok'] && b['ok']) return 0;
        if (a['ok'] && !b['ok']) return 1;

        return -1;
      });
    });

    _saveData();
  }

  void addToDo() {
    Map<String, dynamic> newToDo = {};
    newToDo["title"] = _todoController.text;
    _todoController.clear();

    newToDo["ok"] = false;
    setState(() {
      _todoList.add(newToDo);
    });
    _saveData();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return "[]";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de tarefas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      labelStyle: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: addToDo,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      )),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: _todoList.length,
                itemBuilder: buildItem,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
