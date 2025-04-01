import 'package:flutter/material.dart';
import '../pc_parts_screen.dart'; // Corrected import

class BudgetModeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const BudgetModeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Build Mode')),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Add padding here
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity, // Make buttons take full width
                height: 60.0, // Increase button height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PCPartsScreen(
                              toggleTheme: toggleTheme, budgetMode: 'low')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.blue, // Customize button color
                  ),
                  child: const Text('Budget Friendly',
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20.0), // Add space between buttons
              SizedBox(
                width: double.infinity,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PCPartsScreen(
                              toggleTheme: toggleTheme, budgetMode: 'mid')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.green, // Customize button color
                  ),
                  child: const Text('Mid-Range',
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PCPartsScreen(
                              toggleTheme: toggleTheme, budgetMode: 'high')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.orange, // Customize button color
                  ),
                  child: const Text('High-End',
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PCPartsScreen(
                              toggleTheme: toggleTheme, budgetMode: 'all')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.purple, // Customize button color
                  ),
                  child: const Text('Custom Build',
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}