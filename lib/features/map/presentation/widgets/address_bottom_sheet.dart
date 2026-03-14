import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/map_state.dart';

class AddressBottomSheet extends StatelessWidget {
  final LatLng point;
  final Function(LatLng) onStartDirection;

  const AddressBottomSheet({
    super.key,
    required this.point,
    required this.onStartDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (state is MapLoading) {
                return const CircularProgressIndicator();
              }
              if (state is MapAddressSuccess) {
                return Text(
                  state.address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return const Text("Loading Address...");
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              onStartDirection(point);
              Navigator.pop(context);
            },
            child: const Text(
              "Start Direction",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}