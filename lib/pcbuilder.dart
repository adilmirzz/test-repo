import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'summary.dart';

class PcPartsPicker extends StatefulWidget {
  const PcPartsPicker({Key? key, required this.previousBuild})
      : super(key: key);

  final Map<String, dynamic> previousBuild;

  @override
  _PcPartsPickerState createState() => _PcPartsPickerState();
}

class _PcPartsPickerState extends State<PcPartsPicker> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref("pc_components");
  final Map<String, Map<String, dynamic>> selectedComponents = {};
  List<Map<String, dynamic>> availableComponents = [];
  int budget = 2500;
  int remainingBudget = 2500;

  @override
  void initState() {
    super.initState();
    _fetchComponents();
  }

  // Fetch components from Firebase
  void _fetchComponents() async {
    final snapshot = await _database.get();
    if (snapshot.exists) {
      setState(() {
        availableComponents = snapshot.children
            .map((child) => Map<String, dynamic>.from(child.value as Map))
            .toList();
      });
    }
  }

  void _selectComponent(Map<String, dynamic> component) {
    if (remainingBudget >= component['price']) {
      setState(() {
        selectedComponents[component['type']] = component;
        _calculateRemainingBudget();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough budget!")),
      );
    }
  }

  void _calculateRemainingBudget() {
    int totalCost = selectedComponents.values
        .fold(0, (sum, item) => sum + (item['price'] as int));
    setState(() {
      remainingBudget = budget - totalCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PC Parts Picker")),
      body: Column(
        children: [
          Text("Remaining Budget: \$${remainingBudget}",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: availableComponents.length,
              itemBuilder: (context, index) {
                final component = availableComponents[index];
                return ListTile(
                  title: Text(component['name']),
                  subtitle: Text("Price: \$${component['price']}"),
                  trailing: ElevatedButton(
                    onPressed: () => _selectComponent(component),
                    child: const Text("Select"),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryPage(selectedComponents),
                ),
              );
            },
            child: const Text("View Summary"),
          ),
        ],
      ),
    );
  }
}
