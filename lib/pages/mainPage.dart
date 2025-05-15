import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:part2_project/pages/ListPage.dart';
import 'package:part2_project/pages/LoginPage.dart';
import 'package:part2_project/pages/explore.dart';
import 'package:part2_project/pages/countryActivities.dart';
import 'package:part2_project/pages/profile_page.dart';
import 'package:part2_project/pages/about_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:part2_project/pages/TestPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  UserModel? _currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_tabChanged);
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? profileImageBase64 = prefs.getString('profileImage');

    if (username != null && email != null) {
      setState(() {
        _currentUser = UserModel(
          username: username,
          email: email,
          profileImageBytes: profileImageBase64 != null ? base64Decode(profileImageBase64) : null,
          location: null,
        );
      });
    }
  }

  void _tabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Image.asset("images/logo.png", height: 70),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.list_rounded),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.science),
            tooltip: 'Test Page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestPage()),
              );
            },
          ),
          if (_currentUser == null)
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    ).then((user) {
                      if (user != null) {
                        setState(() {
                          _currentUser = user as UserModel;
                        });
                      }
                    });
                  },
                  child: const Text("Login"),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_active_sharp),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: _currentUser?.profileImageBytes != null
                        ? MemoryImage(_currentUser!.profileImageBytes!)
                        : null,
                    child: _currentUser?.profileImageBytes == null
                        ? Icon(Icons.person, size: 40, color: Colors.deepOrange)
                        : null,
                  ),
                  SizedBox(height: 10),
                  Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(
                    _currentUser != null ? _currentUser!.username : "Guest",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 0;
              },
            ),
            ListTile(
              leading: Icon(Icons.public),
              title: Text('Explore'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 1;
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Activities'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 2;
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 3;
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 4;
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  "Welcome to your next adventure!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Explore smarter. Travel better.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('images/exploring.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.black.withOpacity(0.5),
                          child: const Text(
                            "Top activities",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Row(
                          children: [
                            Icon(Icons.explore, color: Colors.white, size: 28),
                            SizedBox(width: 8),
                            Text(
                              "Explore now",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search destinations, experiences...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.deepOrange),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildRoundedImageCard("images/Booking.jpg", "Booking"),
                        buildRoundedImageCard("images/itinarary.jpg", "Itinerary"),
                        buildRoundedImageCard("images/Dining.jpg", "Dining"),
                        buildRoundedImageCard("images/plane1.jpg", "Others more"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Featured Deals",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                buildActivity("images/activity5.jpg", "Santorini"),
                buildActivity("images/activity2.jpg", "Explorer tour"),
                buildActivity("images/activity3.jpg", "Adventures"),
                const SizedBox(height: 30),
                const Text(
                  "Additional top activities",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 20),
                buildActivity("images/activity1.jpg", "Camel safari - Dubai"),
                buildActivity("images/activity4.jpg", "Italian cuisine tour"),
              ],
            ),
          ),
          Explore(),
          CountryActivities(),
          AboutUsPage(),
          _currentUser != null ? ProfilePage(user: _currentUser!) : LoginPage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home_rounded)),
            Tab(icon: Icon(Icons.public)),
            Tab(icon: Icon(Icons.add)),
            Tab(icon: Icon(Icons.info_outline)),
            Tab(icon: Icon(Icons.person_outlined)),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget buildRoundedImageCard(String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        if (text == "Booking") {
          _tabController.index = 2; // Go to countryActivities.dart
        } else {
          _tabController.index = 1; // Go to explore.dart
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                imagePath,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
              Container(
                width: 150,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildActivity(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
