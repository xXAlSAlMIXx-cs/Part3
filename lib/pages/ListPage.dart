import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Aquarium',
      'icon': Icons.travel_explore,
      'description': 'Enjoy an underwater adventure with various sea creatures every day from 9am to 9pm.'
    },
    {
      'title': 'Teleferik',
      'icon': Icons.cable,
      'description': 'Ride the cable car and enjoy scenic mountain views at any time.'
    },
    {
      'title': 'Mall shopping',
      'icon': Icons.shopping_bag,
      'description': 'Shop the top brands and enjoy food courts and entertainment.'
    },
    {
      'title': 'Cultural festival',
      'icon': Icons.festival,
      'description': 'Experience local traditions of different activities.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities page"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(item['icon'], color: Colors.teal, size: 28),
              title: Text(
                item['title'],
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(item['icon'], color: Colors.teal),
                        SizedBox(width: 10),
                        Text(item['title']),
                      ],
                    ),
                    content: Text(item['description']),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
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
