import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailPage extends StatefulWidget {
  final int id;

  UserDetailPage({required this.id});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  Map<String, dynamic>? hasilPostingan;
  bool isLoading = false;

  void getDetailUser(int id) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse("https://reqres.in/api/users/$id"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          hasilPostingan = jsonData['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailUser(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasilPostingan != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${hasilPostingan!['id']}'),
                      Text(
                          'Name: ${hasilPostingan!['first_name']} ${hasilPostingan!['last_name']}'),
                      Text('Email: ${hasilPostingan!['email']}'),
                      Image.network(hasilPostingan!['avatar']),
                    ],
                  ),
                )
              : Center(child: Text('No user data found')),
    );
  }
}
