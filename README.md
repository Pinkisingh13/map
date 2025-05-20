# Rider Route - Map Integration App

A Flutter application for riders to visualise pickup points, warehouse locations, and navigate through an optimised route using Google Maps integration.

## Features

- **Interactive Google Map**: Display current location, pickup points, and warehouse.
- **Route Visualization**: Polylines showing the route from rider's location → pickups → warehouse.
- **Navigation**: Launch Google Maps with pre-configured route for turn-by-turn navigation.
- **Dynamic Markers**: Tap markers to view details (pickup time slots, inventory, warehouse ETA).
- **Info Cards**: Display pickup instructions, warehouse distance/duration, and rider info.
- **Loading Animation**: Lottie animation while fetching location/data.
- **Current location detection**: fetch current location automatically.

## Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Google Maps API Key ([Get API Key](https://cloud.google.com/maps-platform))
- Android/iOS setup for Google Maps ([Setup Guide](https://pub.dev/packages/google_maps_flutter))

## Usage
 1. **View Map:**
      - The app starts by showing your current location (blue marker).
      - Pickup points are marked in red; warehouse in green.

 2. Interact with Markers:
      - Tap a pickup marker to see time slots, inventory, and instructions.
      - Tap the rider marker (blue) to view distance/duration to the warehouse.
      -  Close info cards using the X icon.

 3. Navigate:
      - Press the "Navigate" button to open Google Maps with the full route.

## ScreenShots
<div align = "center">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss1.jpg" width="45%" style="margin-right: 10px;">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss2.jpg" width="45%" style="margin-right: 10px;">
</div>
<div align = "center">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss3.jpg" width="45%" style="margin-right: 10px;">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss4.jpg" width="45%" style="margin-right: 10px;">
</div>
<div align = "center">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss5.jpg" width="45%" style="margin-right: 10px;">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss6.jpg" width="45%" style="margin-right: 10px;">
</div>
<div align = "center">
  <img src="https://github.com/Pinkisingh13/Pinkisingh13/blob/main/reuseall_task_ss7.jpg" width="45%" style="margin-right: 10px;">
</div>

