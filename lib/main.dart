import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'models/user_selection.dart';
import 'models/pc_part.dart';
import 'screens/selection_summary_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'screens/saved_builds_screen.dart'; 
import 'screens/budget_mode_screen.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserSelection(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: HomePage(toggleTheme: toggleTheme),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCBuilder',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.folder_shared), // Add the saved builds icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedBuildsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/pc_background.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // In main.dart
ElevatedButton(
    onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BudgetModeScreen(toggleTheme: toggleTheme)),
        );
    },
    child: const Text('Choose PC Parts'),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class PCPartsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const PCPartsScreen({super.key, required this.toggleTheme});

  @override
  _PCPartsScreenState createState() => _PCPartsScreenState();
}

class _PCPartsScreenState extends State<PCPartsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String selectedCategory;

  List<String> categories = [
    'processors',
    'motherboards',
    'ram',
    'gpu',
    'cpu_cooler',
    'case',
    'case_fan',
    'powersupply',
    'storage',
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Parts Picker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          DropdownButton<String>(
            value: selectedCategory,
            dropdownColor: Colors.grey[900],
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.checklist, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectionSummaryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder_shared),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedBuildsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection(selectedCategory).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent));
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('❗ Error fetching data',
                    style: TextStyle(color: Colors.redAccent)));
          }

          final parts = snapshot.data?.docs
                  .map((doc) => PCPart.fromFirestore(doc))
                  .toList() ??
              [];
          if (parts.isEmpty) {
            return const Center(
                child: Text('🛑 No parts available',
                    style: TextStyle(fontSize: 18)));
          }

          return ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];
              return Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(part.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(
                      '${part.category} - ₹${part.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16)),
                  trailing: IconButton(
                    icon: const Icon(Icons.info, color: Colors.blueAccent),
                    onPressed: () => showPartDetails(context, part),
                  ),
                  onTap: () => selectPart(context, part),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSaveAndShareDialog(context);
        },
        child: const Icon(Icons.save_alt),
      ),
    );
  }

  void selectPart(BuildContext context, PCPart part) {
    final userSelection = Provider.of<UserSelection>(context, listen: false);
    userSelection.selectPart(selectedCategory, part);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${part.name} selected for $selectedCategory'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showPartDetails(BuildContext context, PCPart part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(part.name),
        content: Text(
            'Category: ${part.category}\nPrice: ₹${part.price.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSaveAndShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save & Share Build'),
          content: const Text('Do you want to save or share your build?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _saveBuild(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _shareBuild(context);
              },
              child: const Text('Share'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

void _saveBuild(BuildContext context) async {
  final userSelection = Provider.of<UserSelection>(context, listen: false);
  final totalCost = userSelection.getTotalCost();

  print("UserSelection.selectedParts: ${userSelection.selectedParts}");
  print("Total Cost: $totalCost");

  // Function to recursively convert maps to have string keys
  Map<String, dynamic> convertMapKeysToString(Map<String, dynamic> inputMap) {
    Map<String, dynamic> convertedMap = {};
    inputMap.forEach((key, value) {
      if (value is Map) {
        convertedMap[key] = convertMapKeysToString(Map<String, dynamic>.from(value));
      } else {
        convertedMap[key] = value;
      }
    });
    return convertedMap;
  }

  // Prepare the build data
  Map<String, dynamic> buildData = {};
  userSelection.selectedParts.forEach((category, part) {
    if (part != null) {
      // Ensure all maps have string keys
      buildData[category] = convertMapKeysToString(part.toJson());
    }
  });

  // Add the total cost to the build data
  buildData['totalCost'] = totalCost;

  try {
    print("buildData: $buildData");

    // Save the build data to Firestore
    await FirebaseFirestore.instance.collection('pc_builds').add(buildData).then(
        (value) {
      print("Build saved successfully");
    }).onError((error, stackTrace) {
      print("Error saving build: $error");
      if (stackTrace != null) {
        print("StackTrace: $stackTrace");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save build: $error')),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Build saved successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save build: $e')),
    );
  }
}

// In PCPartsScreen's _PCPartsScreenState class:
void _shareBuild(BuildContext context) {
  final userSelection = Provider.of<UserSelection>(context, listen: false);
  final totalCost = userSelection.getTotalCost(); // Get the total cost

  String shareText = 'My PC Build:\n';
  userSelection.selectedParts.forEach((category, part) {
    if (part != null) {
      shareText += '$category: ${part?.name ?? 'Unknown'} (₹${part?.price.toStringAsFixed(2) ?? '0.00'})\n';
    }
  });

  // Add the total cost to the share text
  shareText += '\nTotal Cost: ₹${totalCost.toStringAsFixed(2)}';

  Share.share(shareText);
}
}
