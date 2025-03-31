import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SavedBuildsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Builds'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pc_builds').snapshots(),
        builder: (context, snapshot) {
          // ... (your Firestore data fetching and display logic here) ...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No saved builds.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var buildData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('Build ${index + 1}'),
                  subtitle: Text(buildData.toString()), // Display the build data
                  // You can format the data more nicely here
                ),
              );
            },
          );
        },
      ),
    );
  }
}