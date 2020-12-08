import 'package:flutter/material.dart';

class NewItemPage extends StatefulWidget {
  final String newTitle;

  const NewItemPage({Key key, this.newTitle}) : super(key: key);

  @override
  _NewItemPageState createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  TextEditingController textFieldController;

  @override
  void initState() {
    textFieldController = TextEditingController(text: widget.newTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
        centerTitle: true,
        elevation: 0.0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: () => save())],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: textFieldController,
              onEditingComplete: () => save(),
            ),
          ],
        ),
      ),
    );
  }

  void save() {
    if (textFieldController.text.isNotEmpty) {
      Navigator.of(context).pop(textFieldController.text);
    }
  }
}
