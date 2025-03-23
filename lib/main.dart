import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'pcbuilder.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Ensure initialization
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAe_56sGhFX7R5z3-HQVIeWb8BN3Gs2dOY",
            authDomain: "pc-12311.firebaseapp.com",
            projectId: "pc-12311",
            storageBucket: "pc-12311.appspot.com",
            messagingSenderId: "976720855178",
            appId: "1:976720855178:web:6966b1614fb3efbec5ed73",
            measurementId: "G-L14DSR7GH8"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const PcBuilderApp());
}

class PcBuilderApp extends StatelessWidget {
  const PcBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasSavedBuild = false;

  @override
  void initState() {
    super.initState();
    _checkSavedBuild();
  }

  Future<void> _checkSavedBuild() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pc_build.json');
      setState(() {
        hasSavedBuild = file.existsSync();
      });
    } catch (e) {
      debugPrint("Error checking saved build: \$e");
    }
  }

  Future<Map<String, dynamic>?> _loadPreviousBuild() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pc_build.json');
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        return jsonDecode(jsonString);
      }
    } catch (e) {
      debugPrint("Error loading build: \$e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PC Builder")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to PC Builder!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.build, size: 50, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PcPartsPicker(
                              previousBuild: {},
                            )));
              },
            ),
            const SizedBox(height: 10),
            const Text("Click the icon to start a new build"),
            const SizedBox(height: 20),
            if (hasSavedBuild)
              ElevatedButton.icon(
                icon: const Icon(Icons.restore),
                label: const Text("Load Previous Build"),
                onPressed: () async {
                  Map<String, dynamic>? previousBuild =
                      await _loadPreviousBuild();
                  if (previousBuild != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PcPartsPicker(previousBuild: previousBuild)),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
