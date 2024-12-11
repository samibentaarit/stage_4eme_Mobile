import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'constants.dart';  // Import the constants file
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  @override
  void initState() {
    super.initState();
    // Attach cookie manager to Dio
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await _dio.post(
          '$baseUrl/auth/api/auth/signin',
          data: {
            'username': _username,
            'password': _password,
          },
        );

        if (response.statusCode == 200) {
          // Store the cookies using cookie_jar
          List<Cookie> cookies = await _cookieJar.loadForRequest(Uri.parse('$baseUrl/auth/api/auth/signin'));

          // Securely store cookies using FlutterSecureStorage
          const storage = FlutterSecureStorage();

          for (var cookie in cookies) {
            // Store only the cookies you need
            await storage.write(key: cookie.name, value: cookie.value);
          }

          // Extract additional data from the response if needed
          final String id = response.data['id'];
          final String username = response.data['username'];
          final String email = response.data['email'];
          final List<dynamic> roles = response.data['roles'];

          await storage.write(key: 'id', value: id);
          await storage.write(key: 'username', value: username);
          await storage.write(key: 'email', value: email);
          await storage.write(key: 'roles', value: jsonEncode(roles));

          // Print tokens and user information to console
          print('Id: $id');
          print('Username: $username');
          print('Email: $email');
          print('Roles: $roles');
          // Navigate to the next screen
          Navigator.pushReplacementNamed(context, '/annanceList');
        } else {
          // Handle sign in failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign in: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error during sign in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during sign in.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signIn,
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
