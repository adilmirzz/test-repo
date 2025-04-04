import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_selection.dart';
import '../models/pc_part.dart';

class SelectionSummaryScreen extends StatelessWidget {
  const SelectionSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSelection = Provider.of<UserSelection>(context);
    final totalCost = userSelection.getTotalCost(); // Get total cost

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selection Summary'),
      ),
      body: Column( // Wrap ListView in a Column
        children: [
          Expanded( // Expand ListView to take available space
            child: userSelection.selectedParts.values.every((part) => part == null)
                ? const Center(child: Text('No parts selected.'))
                : ListView(
                    children: userSelection.selectedParts.entries.map((entry) {
                      final part = entry.value;
                      return part == null
                          ? ListTile(
                              title: Text('${entry.key}: Not Selected'),
                            )
                          : Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(part.name,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${part.category} - ₹${part.price.toStringAsFixed(2)}'),
                                    Text('Brand: ${part.brand}'),
                                    if (part.formFactor.isNotEmpty)
                                      Text('Form Factor: ${part.formFactor}'),
                                    if (part.rgb) const Text('RGB: Yes'),
                                    if (part.sidePanel.isNotEmpty)
                                      Text('Side Panel: ${part.sidePanel}'),
                                    if (part.type.isNotEmpty)
                                      Text('Type: ${part.type}'),
                                  ],
                                ),
                              ),
                            );
                    }).toList(),
                  ),
          ),
          Padding( // Add padding for total cost
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Cost: ₹${totalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}