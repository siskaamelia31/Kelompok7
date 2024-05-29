import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kelompok7/detail_user.dart';
import 'package:kelompok7/add_user.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  List hasilPostingan = [];
  bool isLoading = false;
  void getSemuaPostingan() async {
    setState(() {
      isLoading = true;
    });

    final response =
        await http.get(Uri.parse("https://reqres.in/api/users?page=1"));
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
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserDetailPage(id: hasilPostingan[index]['id']),
                          ),
                        );
                      },
                      child: Card(
                        child: Row(
                          children: [
                            // Text(hasilPostingan[index]['id'].toString()),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the radius as needed
                                  child: Image.network(
                                    hasilPostingan[index]['avatar'],
                                    height: 90,
                                    width:
                                        90, // Optional: Specify width if needed
                                    fit: BoxFit
                                        .cover, // Optional: Specify how the image should be inscribed into the box
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(hasilPostingan[index]['email'].toString()),
                                Text(hasilPostingan[index]['first_name']),
                              ],
                            ),
                          ],
                        ),
                      ));
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUserPage(), // <-- SEE HERE
            ),
          );
        },
        tooltip: 'Post User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
