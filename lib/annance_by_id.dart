import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart'; // Import your constants file

class AnnanceById extends StatefulWidget {
  final String annanceId;

  AnnanceById({required this.annanceId});

  @override
  _AnnanceByIdState createState() => _AnnanceByIdState();
}

class _AnnanceByIdState extends State<AnnanceById> {
  late Annance _annance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnanceDetails();
  }

  Future<void> _fetchAnnanceDetails() async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/annances/${widget.annanceId}'));
      if (response.statusCode == 200) {
        setState(() {
          _annance = Annance.fromJson(json.decode(response.body));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load annance details');
      }
    } catch (e) {
      print('Error fetching annance details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load annance details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annance Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _annance.sujet,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _annance.information,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Etat: ${_annance.etat}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Model class for Annance
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
