import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to SmartTravel! We are dedicated to providing the best travel experiences for our users. '
              'Our mission is to make travel planning easy, efficient, and enjoyable. '
              'With our app, you can explore destinations, plan trips, and discover new adventures.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email: s133334@student.squ.edu.om \nEmail: s137205@student.squ.edu.om \nEmail: s134434@student.squ.edu.om',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Developers: Tariq Al-shekili \nYaseen Al-khaboori \nMohammed Al-salmi',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Follow Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                SizedBox(width: 8),
                Text('Facebook'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.twitter, color: Colors.lightBlue),
                SizedBox(width: 8),
                Text('X (Twitter)'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.instagram, color: Colors.pink),
                SizedBox(width: 8),
                Text('Instagram'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
