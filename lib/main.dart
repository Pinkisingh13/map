import 'package:flutter/material.dart';
import 'package:map/view/homescreen.dart';
import 'package:map/viewmodel/homescreen_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenProvider(),)
      ],
      child: MaterialApp(
        title: "Map Integration",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      home: HomeScreen(),
      ),
    );
  }
}
