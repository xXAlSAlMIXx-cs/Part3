import 'package:flutter/material.dart';
import 'package:part2_project/pages/countryActivities.dart';

import 'GridPage.dart';
import 'ListPage.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CountryCard(countryName: 'Oman', imagePath: 'images/OM.jpg'),
                CountryCard(countryName: 'Georgia', imagePath: 'images/GE.jpg'),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CountryCard(countryName: 'Turkey', imagePath: 'images/TK.jpg'),
                CountryCard(countryName: 'Iran', imagePath: 'images/IR.jpg'),
              ],
            ),
            SizedBox(height: 30.0,),
            Text('Guiding to your travel:'),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPage()),
              ),
              child: Text("View activities list"),
            ),
            SizedBox(height: 10.0,),
            Text('adjust your plan:'),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GridPage()),
              ),
              child: Text("View grid list"),
            ),

          ],
        ),
      ),
    );
  }
}

class CountryCard extends StatelessWidget {
  final String countryName;
  final String imagePath;

  const CountryCard({super.key, required this.countryName, required this.imagePath,});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 170,
        height: 170,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(countryName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CountryActivities(),)
              );
            },
              child: Text("add activity"),
            ),
          ],
        ),
      ),
    );

  }
}
