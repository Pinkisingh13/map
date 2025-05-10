import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/viewmodel/homescreen_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenProvider()..initialize(),
      child: Scaffold(
        appBar: AppBar(title: Text("Home Screen")),

        body: Consumer<HomeScreenProvider>(
          builder: (context, controller, child) {
            if (controller.currentLocation == null) {
              return Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            return Stack(
              children: [
                // MAP UI
                GoogleMap(
                  trafficEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: controller.currentLocation!,
                  ),
                ),
                // NAVIGATION BUTTON
              ],
            );
          },
        ),
      ),
    );
  }
}
