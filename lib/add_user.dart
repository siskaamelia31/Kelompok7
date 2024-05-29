import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  List hasilPostingan = [];
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  Future<void> addUserData(String username, String job) async {
    print(username);
    print(job);
    var url = "https://reqres.in/api/users";
    final response = await http.post(Uri.parse(url), body: {
      "name": username,
      "job": job,
    });
    print(response.statusCode);
    isLoading = true;
    if (response.statusCode == 201) {
      print('mantap');
      Navigator.pop(context, '/list_user');
    }
  }

  void getSemuaPostingan() async {
    var url = "https://reqres.in/api/users";
    final response = await http.post(Uri.parse(url));
    setState(() {
      final jsonData = jsonDecode(response.body);
      hasilPostingan = jsonData["data"];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Add User",
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "user",
                    hintText: "Masukan User"),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Job",
                    hintText: "Pekerjaan"),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      await addUserData(
                          _nameController.text, _jobController.text);
                      print(addUserData);
                    },
                    child: const Text("Kirim")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
