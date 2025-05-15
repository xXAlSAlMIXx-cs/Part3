import 'package:flutter/material.dart';

class GridPage extends StatelessWidget {
  final List<GridFeature> features = [
    GridFeature(name: "Alarm", icon: Icons.access_alarms, description: "Manage your daily alarms and timers."),
    GridFeature(name: "Breakfast", icon: Icons.free_breakfast, description: "Start your day with a healthy breakfast."),
    GridFeature(name: "Car", icon: Icons.directions_car, description: "Book or rent a car for your trip."),
    GridFeature(name: "Flight", icon: Icons.flight, description: "View or manage your flight bookings."),
    GridFeature(name: "Birthday", icon: Icons.cake, description: "Organize birthday celebrations."),
    GridFeature(name: "Gift Card", icon: Icons.card_giftcard, description: "Redeem or buy gift cards."),
    GridFeature(name: "train", icon: Icons.train, description: "View the nearest metro to your location."),
    GridFeature(name: "Headphones", icon: Icons.headset_mic, description: "Access music and podcasts."),
    GridFeature(name: "Favorites", icon: Icons.star, description: "Save your favorite destinations."),
    GridFeature(name: "Support", icon: Icons.sentiment_satisfied, description: "Contact customer support."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your plan"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(12.0),
        children: List.generate(features.length, (index) {
          final feature = features[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(feature.icon, size: 36, color: Colors.blue),
                            SizedBox(width: 10),
                            Text(
                              feature.name,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(feature.description, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(feature.icon, size: 50.0, color: Colors.blue),
                  SizedBox(height: 12),
                  Text(
                    feature.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class GridFeature {
  final String name;
  final IconData icon;
  final String description;

  GridFeature({required this.name, required this.icon, required this.description});
}
