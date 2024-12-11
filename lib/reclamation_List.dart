import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';  // Import the constants file

class ReclamationList extends StatefulWidget {
  @override
  _ReclamationListState createState() => _ReclamationListState();
}

class _ReclamationListState extends State<ReclamationList> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final List<Reclamation> _reclamations = [];

  @override
  void initState() {
    super.initState();
    _fetchReclamations();
  }

  Future<void> _fetchReclamations() async {
    try {
      // Retrieve the user ID from secure storage
      String? id = await _storage.read(key: 'id');

      if (id == null || id.isEmpty) {
        throw Exception('User ID not found in secure storage. Please sign in again.');
      }

      // Fetch reclamations using the ID from secure storage
      final response = await http.get(Uri.parse('$baseUrl/reclamations/my/$id'));
      if (response.statusCode == 200) {
        final List<dynamic> reclamationJson = json.decode(response.body);
        setState(() {
          _reclamations.clear();
          _reclamations.addAll(
            reclamationJson.map((json) => Reclamation.fromJson(json)).toList(),
          );
        });
      } else {
        throw Exception('Failed to load reclamations');
      }
    } catch (e) {
      print('Error fetching reclamations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reclamations: $e')),
      );
    }
  }

  Future<void> _deleteReclamation(String reclamationId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/reclamations/$reclamationId'));
      if (response.statusCode == 200) {
        setState(() {
          _reclamations.removeWhere((reclamation) => reclamation.id == reclamationId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reclamation deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete reclamation');
      }
    } catch (e) {
      print('Error deleting reclamation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reclamation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamations List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _reclamations.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _reclamations.length,
        itemBuilder: (context, index) {
          final reclamation = _reclamations[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                reclamation.sujet,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reclamation.information,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Etat: ${reclamation.etat}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Students: ${reclamation.etudiantConserne.map((e) => e.username).join(", ")}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(reclamation.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(String reclamationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Reclamation'),
          content: Text('Are you sure you want to delete this reclamation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReclamation(reclamationId);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// Model class for Reclamation
class Reclamation {
  final String id;
  final String sujet;
  final String information;
  final String etat;
  final List<EtudiantConserne> etudiantConserne;

  Reclamation({
    required this.id,
    required this.sujet,
    required this.information,
    required this.etat,
    required this.etudiantConserne,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      id: json['_id'],
      sujet: json['sujet'],
      information: json['information'],
      etat: json['etat'],
      etudiantConserne: (json['etudiantConserne'] as List)
          .map((e) => EtudiantConserne.fromJson(e))
          .toList(),
    );
  }
}

// Model class for EtudiantConserne
class EtudiantConserne {
  final String id;
  final String username;

  EtudiantConserne({required this.id, required this.username});

  factory EtudiantConserne.fromJson(Map<String, dynamic> json) {
    return EtudiantConserne(
      id: json['_id'],
      username: json['username'],
    );
  }
}
