import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSubmissionScreen extends StatefulWidget {
  final int submissionId;
  final String initialText;

  EditSubmissionScreen({required this.submissionId, required this.initialText});

  @override
  _EditSubmissionScreenState createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  Future<void> saveChanges() async {
    var url = Uri.parse("http://localhost/wtms_api/edit_submission.php");
    var response = await http.post(
      url,
      body: {
        'submission_id': widget.submissionId.toString(),
        'updated_text': _controller.text,
      },
    );

    var result = json.decode(response.body);
    if (result['success']) {
      Navigator.pop(context, true); // return success
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Submission")),
      body: Container(
        color: Color(0xFFECEFF1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(labelText: "Submission Text"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
              onPressed: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Confirm Update"),
                        content: Text(
                          "Are you sure you want to save changes to this submission?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("Save"),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  saveChanges();
                }
              },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
