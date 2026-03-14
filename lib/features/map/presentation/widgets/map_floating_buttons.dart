import 'package:flutter/material.dart';

class MapFloatingButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRoutePressed;
  final VoidCallback onLocationPressed;

  const MapFloatingButtons({
    super.key,
    required this.isLoading,
    required this.onRoutePressed,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "route_btn",
          backgroundColor: Colors.blue,
          onPressed: onRoutePressed,
          child: const Icon(Icons.directions, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "loc_btn",
          backgroundColor: Colors.white,
          onPressed: onLocationPressed,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.blue)
              : const Icon(Icons.my_location, color: Colors.blue),
        ),
      ],
    );
  }
}