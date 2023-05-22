import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'cubit/states.dart';

import 'cubit/cubite.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccidentCubit, AccidentStats>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("Accident Detection"),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        AccidentCubit.get(context).reset();
                      },
                      icon: Icon(Icons.restore_page))
                ],
              ),
              body: Center(
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage("assets/images/help.jpg"),
                      fit: BoxFit.fill,
                    ),
                    AccidentCubit.get(context).isAccident
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "I have an accident at a time = ${AccidentCubit.get(context).outButDate}  ",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.deepOrange),
                            ),
                          )
                        : Text(
                            "Status Normal",
                            style: TextStyle(
                                fontSize: 21, color: Colors.deepOrange),
                          ),
                  ],
                ),
              ),
              floatingActionButton: AccidentCubit.get(context).isAccident
                  ? FloatingActionButton(
                      onPressed: () {
                        print(
                            "${AccidentCubit.get(context).locationData!.latitude!}");
                        print(
                            "${AccidentCubit.get(context).locationData!.longitude!}");
                        showDialog(
                          context: context,
                          builder: (context) => FlutterMap(
                            options: MapOptions(
                              center: LatLng(29.307652, 30.846704),
                              bounds: LatLngBounds(LatLng(29.30000, 30.829999),
                                  LatLng(29.347652, 30.836704)),
                            ),
                            children: [
                              TileLayer(
                                tileProvider: AssetTileProvider(),
                                urlTemplate: 'assets/map/Fayom/{z}/{x}/{y}.png',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 30.0,
                                    height: 30.0,
                                    point: LatLng(
                                        AccidentCubit.get(context)
                                            .locationData!
                                            .latitude!,
                                        AccidentCubit.get(context)
                                            .locationData!
                                            .longitude!),
                                    builder: (ctx) => const Icon(
                                        Icons.location_on,
                                        size: 35,
                                        color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.maps_ugc))
                  : null);
        });
  }
}
