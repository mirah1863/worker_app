import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? workerData;

  @override
  void initState() {
    super.initState();
    loadWorkerData();
  }

  Future<void> loadWorkerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('workerData');
    if (jsonString != null) {
      setState(() {
        workerData = json.decode(jsonString);
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (workerData == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Worker Profile"),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: logout)],
      ),
      body: Container(
        color: Color(0xFFECEFF1),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildInfoTile("Worker ID", workerData!['id'].toString()),
            buildInfoTile("Full Name", workerData!['full_name']),
            buildInfoTile("Email", workerData!['email']),
            buildInfoTile("Phone Number", workerData!['phone']),
            buildInfoTile("Address", workerData!['address']),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Card(child: ListTile(title: Text(title), subtitle: Text(value)));
  }
}
