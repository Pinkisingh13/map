import 'package:flutter/material.dart';
import 'package:map/model/pickup_point_model.dart';
import 'package:map/viewmodel/homescreen_provider.dart';
import 'package:provider/provider.dart';


class PickupInfoCard extends StatelessWidget {
  final PickupPointModel pickup;

  const PickupInfoCard({super.key, required this.pickup});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Header
          buildHeader(context),

          
          // Information
          buildInfoRow(Icons.access_time, pickup.timeSlot),
          buildInfoRow(Icons.inventory, '${pickup.inventory} Items'),
          
          // Address and Special Instruction
          if (pickup.address.isNotEmpty)
            buildInfoRow(Icons.location_on, pickup.address),
          if (pickup.specialInstructions.isNotEmpty)
            buildInfoRow(Icons.info, pickup.specialInstructions),


        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Pickup #${pickup.id}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.read<HomeScreenProvider>().selectPickup(null),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}