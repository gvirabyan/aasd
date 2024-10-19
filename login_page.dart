import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart'; // Import the HomePage file

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // State variable for loading

  Future<void> _sendLoginData(String email, String password) async {
    final url = Uri.parse('https://drivetax-api.lt-coding.com/login'); // API endpoint

    // Create the request body
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'type': 1, // Always sending type as 1
    };

    setState(() {
      _isLoading = true; // Set loading to true when the request starts
    });

    try {
      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // Log the response status code and body to the console
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      // Check if login is successful (status code 200)
      if (response.statusCode == 200 || response.statusCode == 302) {
        // Navigate to HomePage on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Handle unsuccessful login here
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error'); // Log any errors
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false when the request completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, Colors.orange], // Gradient from yellow to orange
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String email = _loginController.text;
                  String password = _passwordController.text;
                  _sendLoginData(email, password); // Send POST request
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              // Show loading indicator if loading
              if (_isLoading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
