import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePostingan extends StatefulWidget {
  const HomePostingan({super.key});

  @override
  State<HomePostingan> createState() => _HomePostinganState();
}

class _HomePostinganState extends State<HomePostingan> {
  List hasilPostingan = [];
  bool isLoading = false;
  // fungsi untuk mengambil semua postingan
  void getSemuaPostingan() async {
    setState(() {
      isLoading = true;
    });
    // String baseUrl = "https://jsonplaceholder.typicode.com";
    //http.get(Uri.parse("$baseUrl/post"));

    final response =
        await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    setState(() {
      final jsonData = jsonDecode(response.body);
      hasilPostingan = jsonData['data'];
      isLoading = false;
    });
  }

  void postSemuaPostingan(
      String email, String firstName, String lastName) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse("https://reqres.in/api/users");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"email": email, "first_name": firstName, "last_name": lastName}),
    );

    if (response.statusCode == 201) {
      setState(() {
        final jsonData = jsonDecode(response.body);
        hasilPostingan = jsonData['data']; // Access the 'data' key
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getSemuaPostingan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("postingan"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getSemuaPostingan();
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: hasilPostingan.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Text(hasilPostingan[index]['id'].toString()),
                      title: Text(hasilPostingan[index]['email']),
                      subtitle: Text(hasilPostingan[index]['first_name'] +
                          ' ' +
                          hasilPostingan[index]['last_name']),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postSemuaPostingan("test@example.com", "Test", "User");
        },
        tooltip: 'Post User',
        child: Icon(Icons.add),
      ),
    );
  }
}
