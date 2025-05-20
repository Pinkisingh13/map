import 'package:flutter/material.dart';
import 'package:map/view/pickup_info_card.dart';
import 'package:map/view/warehouse_info_card.dart';
import 'package:map/viewmodel/homescreen_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => HomeScreenProvider()..initialize(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Rider Route')),
          body: Consumer<HomeScreenProvider>(
            builder: (context, controller, child) {
              if (controller.currentLocation == null) {
                return Center(child: Lottie.asset('assets/lottie/loading.json'));
              }
      
              return Stack(
                children: [
                  GoogleMap(
                    compassEnabled: true,
                    // indoorViewEnabled: true,
                    
                    initialCameraPosition: CameraPosition(
                      target: controller.currentLocation!,
                      zoom: 14,
                    ),
                    markers: controller.markers,
                    polylines: controller.polylines,
                    myLocationEnabled: true,
                    // trafficEnabled: true,
                    zoomControlsEnabled: true,
                    // buildingsEnabled: true,
                    mapToolbarEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    scrollGesturesEnabled: true,
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                0,
                                111,
                                131,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => controller.launchNavigation(),
                            child: const Text(
                              "Navigate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
      
                  if (controller.selectedPickup != null)
                    Positioned(
                      bottom: 80, // Above navigation button
                      left: 0,
                      right: 0,
                      child: PickupInfoCard(pickup: controller.selectedPickup!),
                    )
                  else if (controller.selectedRider != null)
                    Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: WarehouseInfoCard(
                        info: controller.selectedRider!
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
