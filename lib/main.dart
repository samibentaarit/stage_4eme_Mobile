import 'package:flutter/material.dart';
import 'reclamation_List.dart';
import 'sign_in_page.dart';
import 'annance_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheckScreen(),
      routes: {
        '/signIn': (context) => SignInPage(),
        '/annanceList': (context) => AnnanceList(),
        '/reclamationList': (context) => ReclamationList(),

      },
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Check if the access token exists
    String? accessToken = await _storage.read(key: 'accessToken');

    // Logic to determine if the user is authenticated
    if (accessToken != null) {
      // Here, you can add additional checks, such as validating the token or expiration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isCheckingAuth
            ? CircularProgressIndicator()
            : Text('Redirecting...'),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    WelcomeScreen(),
    AnnanceList(), // Assuming AnnanceList is the second page you want
    ReclamationList(), // Add this page or replace it with your desired page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Annance List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Warnings',
          ),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Annance App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signIn');
              },
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/annanceList');
              },
              child: Text('View Annances'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Warning Page, replace with actual implementation if needed
class WarningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warning Page'),
      ),
      body: Center(
        child: Icon(
          Icons.warning,
          size: 100,
          color: Colors.red,
        ),
      ),
    );
  }
}
