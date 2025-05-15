import 'package:flutter/material.dart';
import 'package:part2_project/models/user_model.dart';
import 'package:part2_project/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _user;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _imageBytes = _user.profileImageBytes;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String username = prefs.getString('username') ?? "Guest";
      String email = prefs.getString('email') ?? "";
      String? profileImagePath = prefs.getString('profileImage');
      String? location = prefs.getString('location'); // Load location
      Uint8List? profileImageBytes;
      if (profileImagePath != null) {
        profileImageBytes = base64Decode(profileImagePath);
      }

      _user = UserModel(
        username: username,
        email: email,
        profileImageBytes: profileImageBytes,
        location: location,
      );
      _imageBytes = profileImageBytes;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _user = UserModel(
          username: _user.username,
          email: _user.email,
          profileImageBytes: bytes,
          location: _user.location,
        );
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String base64Image = base64Encode(bytes);
      await prefs.setString('profileImage', base64Image);
    }
  }

  Future<void> _editProfile() async {
    final usernameController = TextEditingController(text: _user.username);
    final emailController = TextEditingController(text: _user.email);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'username': usernameController.text,
                'email': emailController.text,
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _user = UserModel(
          username: result['username'] ?? _user.username,
          email: result['email'] ?? _user.email,
          profileImageBytes: _user.profileImageBytes,
          location: _user.location,
        );
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _user.username);
      await prefs.setString('email', _user.email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
    }
  }

  Future<void> _setLocation() async {
    final controller = TextEditingController();

    final location = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your location',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (location != null && location.isNotEmpty) {
      setState(() {
        _user = UserModel(
          username: _user.username,
          email: _user.email,
          profileImageBytes: _user.profileImageBytes,
          location: location,
        );
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('location', location);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated!')),
      );
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('You have no new notifications.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('For support, contact us !!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: const Text('App version 1.0.0\nDeveloped by Smart plan developer'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900] ?? Colors.deepOrange,
              Colors.orange[600] ?? Colors.orange,
              Colors.orange[300] ?? Colors.orangeAccent,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _imageBytes != null
                    ? ClipOval(
                  child: Image.memory(
                    _imageBytes!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _user.username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _user.email,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            if (_user.location != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _user.location!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
                    child: Column(
                      children: [
                        buildProfileOption(
                          icon: Icons.person_outline,
                          title: "Edit Profile",
                          onTap: _editProfile,
                        ),
                        const Divider(),
                        buildProfileOption(
                          icon: Icons.location_on_outlined,
                          title: "Set Location",
                          onTap: _setLocation,
                        ),
                        const Divider(),
                        buildProfileOption(
                          icon: Icons.notifications_outlined,
                          title: "Notifications",
                          onTap: _showNotifications,
                        ),
                        const Divider(),
                        buildProfileOption(
                          icon: Icons.help_outline,
                          title: "Help & Support",
                          onTap: _showHelpSupport,
                        ),
                        const Divider(),
                        buildProfileOption(
                          icon: Icons.info_outline,
                          title: "About",
                          onTap: _showAbout,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.remove('username');
                              prefs.remove('email');
                              prefs.remove('profileImage');
                              prefs.remove('location');

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyApp(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange[700]),
      title: Text(title),
      onTap: onTap,
    );
  }
}
