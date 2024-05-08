

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_live_location/screens/mapscreen_view_model.dart';
class SearchLocation extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function() onTap;
  
  const SearchLocation({required this.scrollController, required this.onTap ,super.key});
  
  @override
  ConsumerState<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends ConsumerState<SearchLocation> {
  TextEditingController sourceController=TextEditingController();
  TextEditingController desninationController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
          child: Column(
            children: [ 
              Text("${ref.watch(mapScreenViewModelProvider).distance} km",style: const TextStyle(fontSize: 20),),
              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(
                  label: Text("Source"),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: desninationController,
                decoration: const InputDecoration( 
                  label: Text("Destination"),
                ),
              ),

              ElevatedButton(onPressed: ()async{
               
                try {
                List<Location> sourceLocations = await locationFromAddress(sourceController.text);
                List<Location> destinationLocation=await locationFromAddress(desninationController.text);
                ref.read(mapScreenViewModelProvider).setSource(sourceLocations);
                ref.read(mapScreenViewModelProvider).setDestination(destinationLocation);
                widget.onTap();
            
              } catch (e) {
                setState(() {
                  ("loaction not found");
                });
               
              }
             }, child: const Text("Show Route"))
            ],
          ),
        ),
      ),
    );
  }
}