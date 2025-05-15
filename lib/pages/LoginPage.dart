import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:part2_project/pages/profile_page.dart';
import 'package:part2_project/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> saveUserData(String username, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
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
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login", style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10),
                  Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        buildInputField(
                          controller: _usernameController,
                          labelText: 'Username or email',
                          isPassword: false,
                        ),
                        const SizedBox(height: 20),
                        buildInputField(
                          controller: _passwordController,
                          labelText: 'Password',
                          isPassword: true,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () async {
                              String input = _usernameController.text.trim();
                              String password = _passwordController.text.trim();

                              if (input.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill in all fields.')),
                                );
                                return;
                              }

                              // Query Firestore for user by username or email
                              final query = await FirebaseFirestore.instance
                                  .collection('User')
                                  .where('UserName', isEqualTo: input)
                                  .get();

                              final emailQuery = await FirebaseFirestore.instance
                                  .collection('User')
                                  .where('Email', isEqualTo: input)
                                  .get();

                              // Combine results
                              final docs = [...query.docs, ...emailQuery.docs];

                              if (docs.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User not found.')),
                                );
                                return;
                              }

                              // Check password
                              final matchingDocs = docs.where((doc) => doc['Password'] == password).toList();

                              if (matchingDocs.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Incorrect password.')),
                                );
                                return;
                              }

                              final userDoc = matchingDocs.first;

                              // Login successful
                              final userData = userDoc.data();
                              await saveUserData(userData['UserName'], userData['Email']);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    user: UserModel(
                                      username: userData['UserName'],
                                      email: userData['Email'],
                                      profileImageBytes: null,
                                      location: null,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w500),
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

  Widget buildInputField({
    required TextEditingController controller,
    required String labelText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[100],
          prefixIcon: Icon(
            isPassword ? Icons.lock_outline : Icons.person_outline,
            color: Colors.orange[700],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange[700]!, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
