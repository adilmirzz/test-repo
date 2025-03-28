import 'package:flutter/material.dart';

class PCPartsScreen extends StatelessWidget {
  PCPartsScreen(VoidCallback toggleTheme);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select PC Parts")),
      body: Center(
        child: Text("PC Parts Selection Page"),
      ),
    );
  }
}//*
