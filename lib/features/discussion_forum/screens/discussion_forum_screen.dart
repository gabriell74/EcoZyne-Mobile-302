import 'package:flutter/material.dart';

class DiscussionForumScreen extends StatelessWidget {
  const DiscussionForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum Diskusi"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF55C173),
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
