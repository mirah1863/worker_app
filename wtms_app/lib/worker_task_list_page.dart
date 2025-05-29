import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wtms_app/submit_work_page.dart';

class WorkerTaskListPage extends StatefulWidget {
  final int workerId; // Pass this in from login or session

  const WorkerTaskListPage({super.key, required this.workerId});

  @override
  _WorkerTaskListPageState createState() => _WorkerTaskListPageState();
}

class _WorkerTaskListPageState extends State<WorkerTaskListPage> {
  List tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    print("📡 Fetching tasks for worker_id: ${widget.workerId}");
    final url = Uri.parse('http://10.138.130.55/wtms_api/get_works.php');
    print("🌐 API URL: $url");

    try {
      final response = await http.post(
        url,
        body: {'worker_id': widget.workerId.toString()},
      );

      print("✅ Status Code: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tasks = data;
          isLoading = false;
        });
      } else {
        print("❌ Failed to fetch tasks");
        setState(() {
          tasks = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("🔥 Exception during fetch: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void goToSubmitPage(Map task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SubmitWorkPage(
              taskId: task['id'],
              taskTitle: task['title'],
              workerId: widget.workerId,
            ),
      ),
    );

    // 🔄 Refresh task list when coming back
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        task['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(task['description']),
                          const SizedBox(height: 8),
                          Text("📅 Assigned: ${task['date_assigned']}"),
                          Text("⏳ Due: ${task['due_date']}"),
                        ],
                      ),
                      trailing: Text(
                        task['status'].toUpperCase(),
                        style: TextStyle(
                          color:
                              task['status'] == 'completed'
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => goToSubmitPage(task),
                    ),
                  );
                },
              ),
    );
  }
}
