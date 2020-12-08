import 'dart:convert';

import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:share_pref/todo_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'new_item_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> list = List<Todo>();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreference();
    super.initState();
  }

  initSharedPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo APP"),
        centerTitle: true,
      ),
      body: list.isNotEmpty ? buildBody() : emptyBody(),
      floatingActionButton: AnimatedButton(
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
        color: Colors.grey,
        onPressed: () => goToNextPage(),
        enabled: true,
        width: 60,
        height: 60,
        shape: BoxShape.circle,
        shadowDegree: ShadowDegree.light,
      ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildItem(list[index]);
      },
    );
  }

  Widget buildItem(Todo item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => removeItem(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red[400],
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 12.0),
      ),
      child: editItem(item),
    );
  }

  Widget editItem(Todo item) {
    return ListTile(
      title: Text(item.title),
      trailing: Checkbox(
        value: item.complete,
        onChanged: null,
      ),
      onTap: () => editAlreadyCreatedItems(item),
      onLongPress: () => setCompleteness(item),
    );
  }

  Widget emptyBody() {
    return Center(
      child: Text(
        "No task available",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
      ),
    );
  }

  void goToNextPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return NewItemPage();
      },
    )).then((title) {
      if (title != null) {
        setState(() {
          addTodo(Todo(title: title));
        });
      }
    });
  }

  void editAlreadyCreatedItems(Todo item) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return NewItemPage(
          newTitle: item.title,
        );
      },
    )).then((title) {
      if (title != null) {
        setState(() {
          editTodo(item, title);
        });
      }
    });
  }

  void addTodo(Todo item) {
    list.add(item);
    saveData();
  }

  void editTodo(Todo item, String title) {
    item.title = title;
    saveData();
  }

  void removeItem(Todo item) {
    list.remove(item);
    if (list.isEmpty) setState(() {});

    saveData();
  }

  void setCompleteness(Todo item) {
    setState(() {
      item.complete = !item.complete;
    });
    saveData();
  }

  void saveData() {
    List<String> spList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', spList);
  }

  void loadData() {
    List<String> spList = sharedPreferences.getStringList('list');
    list = spList.map((item) => Todo.fromMap(json.decode(item))).toList();
    setState(() {});
  }
}
