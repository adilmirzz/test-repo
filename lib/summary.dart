import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>> selectedComponents;

  const SummaryPage(this.selectedComponents, {super.key});

  Future<void> saveBuildToFile(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pc_build.json');
      String jsonString = jsonEncode(selectedComponents);
      await file.writeAsString(jsonString);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Build saved to ${file.path}")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving build!")));
    }
  }

  Future<void> shareBuild(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pc_build.json');

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)],
            text: "Check out my PC build!");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No saved build to share!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error sharing build!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = selectedComponents.values
        .fold(0, (sum, item) => sum + (item['price'] as int));

    return Scaffold(
      appBar: AppBar(title: const Text("PC Build Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: selectedComponents.keys.map((type) {
                  return ListTile(
                    title: Text(type,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "${selectedComponents[type]!['name']} (\$${selectedComponents[type]!['price']})"),
                  );
                }).toList(),
              ),
            ),
            Text("Total Cost: \$$totalPrice",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => saveBuildToFile(context),
              icon: const Icon(Icons.save),
              label: const Text("Save Build"),
            ),
            ElevatedButton.icon(
              onPressed: () => shareBuild(context),
              icon: const Icon(Icons.share),
              label: const Text("Share Build"),
            ),
          ],
        ),
      ),
    );
  }
}
