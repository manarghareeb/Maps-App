import 'package:flutter/material.dart';

class MapTopSearch extends StatelessWidget {
  final bool isRouting;
  final VoidCallback onSearchTap;
  final Widget routeSelector;

  const MapTopSearch({
    super.key,
    required this.isRouting,
    required this.onSearchTap,
    required this.routeSelector,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: isRouting
          ? routeSelector
          : GestureDetector(
              onTap: onSearchTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      "Search for a location",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}