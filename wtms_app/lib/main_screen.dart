import 'package:flutter/material.dart';
import 'worker_task_list_page.dart';
import 'submission_history_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  int? workerId;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // ✅ start from the requested tab
    loadWorker();
  }

  Future<void> loadWorker() async {
    print("📦 Loading worker from SharedPreferences...");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('workerData');

    if (jsonString != null) {
      print("✅ workerData found: $jsonString");

      final data = json.decode(jsonString);
      setState(() {
        workerId = int.parse(data['id'].toString());
        _pages.clear();
        _pages.addAll([
          WorkerTaskListPage(workerId: workerId!), // index 0
          SubmissionHistoryScreen(), // index 1
          ProfileScreen(), // index 2
        ]);
      });

      print("✅ Pages initialized with workerId: $workerId");
    } else {
      print("❌ No worker data found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty || workerId == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading")),
        body: Center(child: Text("Loading user data...")),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
