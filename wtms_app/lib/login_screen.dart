import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> loginWorker() async {
    setState(() => _isLoading = true);

    var url = Uri.parse("http://localhost/wtms_api/login_worker.php");

    var response = await http.post(
      url,
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    var data = json.decode(response.body);
    setState(() => _isLoading = false);

    if (data['success']) {
      // Save session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('workerData', json.encode(data['worker']));

      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    if (loggedIn == true) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Worker Login")),
      body: Container(
        color: Color(0xFFECEFF1),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 12.0,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16), // Space between fields
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 12.0,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: loginWorker, child: Text("Login")),
            TextButton(
              onPressed:
                  () => Navigator.pushReplacementNamed(context, '/register'),
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
