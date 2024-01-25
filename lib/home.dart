// ignore_for_file: sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutorials/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:tutorials/update_task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> lst = [];

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Call the fetchUsers method here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: lst.length,
          itemBuilder: (context, index) {
            final id = lst[index]['_id'] as String;
            return ListTile(
              leading: CircleAvatar(
                child: Text("${index + 1}"),
              ),
              title: Text(lst[index]['title']),
              subtitle: Text(lst[index]['description']),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text("Edit"),
                      value: 'edit',
                    ),
                    PopupMenuItem(child: Text("Delete"), value: 'delete')
                  ];
                },
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Update(id: id),
                      ),
                    );
                  } else if (value == 'delete') {
                    deleteUsers(id);
                  }
                },
              ),
              // Add other widgets based on your requirements
            );
          },
        ),
        onRefresh: fetchUsers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigatenextpage,
        label: Text("Add To Do"),
      ),
    );
  }

  void navigatenextpage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));
  }

  Future<void> fetchUsers() async {
    final url = "https://api.nstack.in/v1/todos?";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['items'];
      setState(() {
        lst = results;
      });
    } else {
      // Handle error
      print("Failed to fetch data: ${response.statusCode}");
    }
  }

  Future<void> deleteUsers(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully Deleted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete")),
      );
    }
  }
}
