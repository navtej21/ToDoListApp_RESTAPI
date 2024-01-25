import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController task = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Todo"),
        ),
        body: ListView(
          children: [
            TextField(
              controller: task,
              decoration: InputDecoration(hintText: "Enter task"),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 8,
            ),
            TextField(
                controller: description,
                decoration: InputDecoration(hintText: "Enter Description"),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 8),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
                onPressed: () {
                  submittasks();
                },
                child: Text("Submit"))
          ],
        ));
  }

  void dispose() {
    super.dispose();
    task.dispose();
    description.dispose();
  }

  Future<void> submittasks() async {
    var tasks = task.text;
    var descriptions = description.text;
    var body = {
      "title": tasks,
      "description": descriptions,
      "is_completed": false
    };
    try {
      final url = "https://api.nstack.in/v1/todos";
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {'content-type': 'application/json'});
      if (response.statusCode == 201) {
        showmessage("Successfully Added");
      } else {
        showmessage("Failed in Adding");
      }
    } catch (error) {
      throw error;
    }
  }

  void showmessage(String msg) {
    final snackbar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
