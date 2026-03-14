import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/core/cache/cache_helper.dart';
import 'package:maps_app/core/services/service_locator.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/map/presentation/views/main_map_screen.dart';
import 'package:maps_app/features/search/presentation/cubit/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<MapCubit>()),
        BlocProvider(create: (context) => sl<SearchCubit>()),
        BlocProvider(create: (context) => sl<DirectionsCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maps App',
        home: const MainMapScreen(),
      ),
    );
  }
}
