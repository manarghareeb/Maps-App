import 'package:flutter/material.dart';
import 'package:maps_app/features/map/presentation/widgets/search_input_field.dart';

class RouteSelector extends StatelessWidget {
  final String? startName;
  final String? destinationName;

  final VoidCallback onBack;
  final VoidCallback onStartTap;
  final VoidCallback onDestinationTap;

  const RouteSelector({
    super.key,
    required this.startName,
    required this.destinationName,
    required this.onBack,
    required this.onStartTap,
    required this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchInputField(
                  hint: "Choose start point",
                  value: startName ?? "Your Location",
                  icon: Icons.circle_outlined,
                  iconColor: Colors.blue,
                  onTap: onStartTap,
                ),
                const SizedBox(height: 10),
                SearchInputField(
                  hint: "Choose destination",
                  value: destinationName,
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  onTap: onDestinationTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}