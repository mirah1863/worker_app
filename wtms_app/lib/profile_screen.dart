import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:wtms_app/main_screen.dart';
// ignore: unused_import
import 'package:wtms_app/worker_task_list_page.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? workerData;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

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
        fullNameController.text = workerData!['full_name'] ?? '';
        emailController.text = workerData!['email'] ?? '';
        phoneController.text = workerData!['phone'] ?? '';
        addressController.text = workerData!['address'] ?? '';
      });
    }
  }

  Future<void> updateProfile() async {
    print("Sending update request...");
    var url = Uri.parse("http://localhost/wtms_api/update_profile.php");

    var response = await http
        .post(
          url,
          body: {
            'worker_id': workerData!['id'].toString(),
            'full_name': fullNameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'address': addressController.text,
          },
        )
        .timeout(Duration(seconds: 5));

    print("Response received: ${response.body}");

    try {
      var result = json.decode(response.body);
      print("Decoded result: $result");

      if (result['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile updated!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update failed")));
      }
    } catch (e) {
      print("ERROR during update: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error. Check server or internet.")),
      );
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
            TextFormField(
              enabled: false,
              decoration: InputDecoration(labelText: "Username"),
              initialValue: workerData!['username'] ?? 'N/A',
            ),
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Address"),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save Changes"),
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.task_alt),
              label: const Text("My Tasks"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(initialIndex: 0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
