import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tutorials/add_page.dart';

class Update extends StatefulWidget {
  String id;

  Update({Key? key, required this.id}) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController updatetask = TextEditingController();

  TextEditingController updatedesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Task")),
      body: ListView(
        children: [
          TextField(
            controller: updatetask,
            decoration: InputDecoration(labelText: "Enter The Task"),
          ),
          TextField(
            controller: updatedesc,
            decoration: InputDecoration(labelText: "Enter Description"),
          ),
          ElevatedButton(
            onPressed: () async {
              await updateTask(widget.id);
            },
            child: Text("Update Task"),
          )
        ],
      ),
    );
  }

  Future<void> updateTask(String id) async {
    var newtask = updatetask.text;
    var newdesc = updatedesc.text;
    final url = "https://api.nstack.in/v1/todos/$id";
    var body = {
      "title": newtask,
      "description": newdesc,
      "is_completed": false.toString(),
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successful update, provide feedback to the user
        print("Task updated successfully");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully Updated The task")));
      } else {
        // Handle update failure
        print("Failed to update task: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update task")),
        );
      }
    } catch (error) {
      // Handle other errors, such as network issues
      print("Error during update operation: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during update operation")),
      );
    }
  }
}
