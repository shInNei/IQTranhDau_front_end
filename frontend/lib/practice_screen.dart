import 'package:flutter/material.dart';
import 'practice_match_screen.dart';

class PracticeScreen extends StatelessWidget {
  final VoidCallback? onBack;

  PracticeScreen({this.onBack});

  final List<Map<String, dynamic>> topics = [
    {"name": "Học tập", "icon": Icons.school},
    {"name": "Vật lý", "icon": Icons.science},
    {"name": "Toán học", "icon": Icons.calculate},
    {"name": "Tin học", "icon": Icons.computer},
    {"name": "Động vật", "icon": Icons.pets},
    {"name": "Thực vật", "icon": Icons.local_florist},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Các bộ câu hỏi'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onBack, // use the callback to notify HomeScreen
        ),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                topics[index]["name"],
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                topics[index]["icon"],
                size: 40,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      topicID: index,
                      playerIDs: ["0", "1", "2"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
