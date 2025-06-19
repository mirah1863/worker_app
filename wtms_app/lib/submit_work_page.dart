import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmitWorkPage extends StatefulWidget {
  final int taskId;
  final String taskTitle;
  final int workerId;

  const SubmitWorkPage({
    super.key,
    required this.taskId,
    required this.taskTitle,
    required this.workerId,
  });

  @override
  State<SubmitWorkPage> createState() => _SubmitWorkPageState();
}

class _SubmitWorkPageState extends State<SubmitWorkPage> {
  final TextEditingController _submissionController = TextEditingController();
  bool isSubmitting = false;

  Future<void> submitWork() async {
    final text = _submissionController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter what you completed.")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final url = Uri.parse('http://localhost/wtms_api/submit_work.php');

    try {
      final response = await http.post(
        url,
        body: {
          'work_id': widget.taskId.toString(),
          'worker_id': widget.workerId.toString(),
          'submission_text': text,
        },
      );

      setState(() => isSubmitting = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Submission successful!")));
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context); // Go back to task list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission failed. Try again.")),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("🔥 Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Work")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task: ${widget.taskTitle}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "What did you complete?",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _submissionController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter details of your work here...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSubmitting ? null : submitWork,
              child:
                  isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
