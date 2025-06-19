import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_submission_screen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  @override
  _SubmissionHistoryScreenState createState() =>
      _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List submissions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("📥 SubmissionHistoryScreen loaded");
    loadSubmissions();
  }

  Future<void> loadSubmissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? workerJson = prefs.getString('workerData');

    if (workerJson == null) return;

    var workerData = json.decode(workerJson);
    var workerId = workerData['id'];

    var url = Uri.parse("http://localhost/wtms_api/get_submissions.php");
    print("📡 Fetching submissions from: $url");
    var response = await http.post(
      url,
      body: {'worker_id': workerId.toString()},
    );

    print("🌐 Raw response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        submissions = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load submissions")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submission History")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : submissions.isEmpty
              ? Center(child: Text("No submissions found."))
              : ListView.builder(
                itemCount: submissions.length,
                itemBuilder: (context, index) {
                  final item = submissions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(item['title'] ?? 'No Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Submitted on: ${item['submitted_at'] ?? 'Unknown'}",
                          ),
                          SizedBox(height: 6),
                          Text(
                            item['submission_text'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onTap: () async {
                        bool? updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditSubmissionScreen(
                                  submissionId: item['id'],
                                  initialText: item['submission_text'],
                                ),
                          ),
                        );
                        if (updated == true) {
                          loadSubmissions(); // refresh
                        }
                      },
                    ),
                  );
                },
              ),
    );
  }
}
