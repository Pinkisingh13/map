import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),

      body: Consumer(
        builder: (context, value, child) {
          return Stack(
            children: [
              // MAP UI
              // NAVIGATION BUTTON
            ],
          );
        },
      ),
    );
  }
}
