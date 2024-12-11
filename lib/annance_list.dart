import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart'; // Import the constants file
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'annance_by_id.dart'; // Import the new detailed page

class Annance {
  final String id;
  final String sujet;
  final String information;
  final String etat;

  Annance({
    required this.id,
    required this.sujet,
    required this.information,
    required this.etat,
  });

  factory Annance.fromJson(Map<String, dynamic> json) {
    return Annance(
      id: json['_id'],
      sujet: json['sujet'],
      information: json['information'],
      etat: json['etat'],
    );
  }
}

class AnnanceList extends StatefulWidget {
  @override
  _AnnanceListState createState() => _AnnanceListState();
}

class _AnnanceListState extends State<AnnanceList> {
  final List<Annance> _annances = [];
  late WebSocketChannel _channel;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    _initializeNotifications();
    _fetchAnnances();
    _connectWebSocket();
  }

  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _showNotification(notification.title!, notification.body!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the user taps on the notification
    });

    messaging.subscribeToTopic('annance');
  }

  Future<void> _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _fetchAnnances() async {
    // Retrieve the user ID from secure storage
    String? id = await _storage.read(key: 'id');
    if (id == null) {
      throw Exception('User ID not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/annancess/$id'));
    print('id: $id');

    if (response.statusCode == 200) {
      final List<dynamic> annanceJson = json.decode(response.body);
      setState(() {
        _annances.clear();
        _annances.addAll(
            annanceJson.map((json) => Annance.fromJson(json)).toList());
      });
    } else {
      throw Exception('Failed to load annances');
    }
  }

  void _connectWebSocket() {
    _channel = IOWebSocketChannel.connect(wsUrl);

    _channel.stream.listen((message) {
      final annance = Annance.fromJson(json.decode(message));
      setState(() {
        _annances.add(annance);
      });
      _showNotification('New Annance: ${annance.sujet}', annance.information);
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> _deleteAnnance(String annanceId) async {
    try {
      final response =
      await http.delete(Uri.parse('$baseUrl/annances/$annanceId'));
      if (response.statusCode == 200) {
        setState(() {
          _annances.removeWhere((annance) => annance.id == annanceId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Annance deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete annance');
      }
    } catch (e) {
      print('Error deleting annance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete annance')),
      );
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annances'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _annances.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _annances.length,
        itemBuilder: (context, index) {
          final annance = _annances[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                annance.sujet,
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                annance.information,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(annance.id);
                },
              ),
              onTap: () {
                // Navigate to the detailed Annance page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnnanceById(annanceId: annance.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(String annanceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Annance'),
          content: Text('Are you sure you want to delete this annance?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAnnance(annanceId);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
