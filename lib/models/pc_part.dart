import 'package:cloud_firestore/cloud_firestore.dart';

class PCPart {
  final String name;
  final String category;
  final double price;
  final String brand;
  final String formFactor;
  final bool rgb;
  final String sidePanel;
  final String type;
  final Map<String, dynamic> additionalFields;
  final String? imageUrl; // Add imageUrl

  PCPart({
    required this.name,
    required this.category,
    required this.price,
    required this.brand,
    required this.formFactor,
    required this.rgb,
    required this.sidePanel,
    required this.type,
    required this.additionalFields,
    this.imageUrl, // Add imageUrl to constructor
  });

  factory PCPart.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Map<String, dynamic> filteredData = Map<String, dynamic>.from(data);
    filteredData.remove('name');
    filteredData.remove('category');
    filteredData.remove('price');
    filteredData.remove('brand');
    filteredData.remove('form_factor');
    filteredData.remove('rgb');
    filteredData.remove('side_panel');
    filteredData.remove('type');
    filteredData.remove('imageUrl'); // Remove imageUrl from filteredData

    return PCPart(
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      brand: data['brand'] ?? '',
      formFactor: data['form_factor'] ?? '',
      rgb: data['rgb'] ?? false,
      sidePanel: data['side_panel'] ?? '',
      type: data['type'] ?? '',
      additionalFields: filteredData,
      imageUrl: data['imageUrl'], // Add imageUrl from Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'brand': brand,
      'form_factor': formFactor,
      'rgb': rgb,
      'side_panel': sidePanel,
      'type': type,
      'additionalFields': additionalFields,
      'imageUrl': imageUrl, // Add imageUrl to toJson
    };
  }
}