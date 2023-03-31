import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sofist_tsk/screen/map/map_page_controller.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final controller = MapPageController();

  locationColumn(Map<String, dynamic>? dropVal) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17.0),
            ),
            child: DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(17.0),
              hint: Row(
                children: const [
                  Icon(
                    Icons.location_on,
                    color: Color(0xffd22f27),
                  ),
                  SizedBox(width: 10.0),
                  Text("Current Location"),
                ],
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              underline: const SizedBox(),
              items: controller.locations
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xffd22f27),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            e["college_name"],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              value: dropVal,
              onChanged: (value) {
                ref.read(controller.dropValue.notifier).state = value;
                controller.currentLoc = CameraPosition(
                  target: value!["position"],
                  zoom: 13.0,
                );
                controller.marker = Marker(
                  markerId: const MarkerId('location'),
                  infoWindow: InfoWindow(title: value["college_name"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: value["position"],
                );
                controller.goToLocation();
              },
            ),
          ),
          const Spacer(),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(17.0),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 28.0,
              ),
              hintText: 'Search your drop location',
              hintStyle: const TextStyle(
                color: Color(0xff1d3a70),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(controller.bottomIndex);
    final Map<String, dynamic>? dropVal = ref.watch(controller.dropValue);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        elevation: 0.0,
        backgroundColor: const Color(0xff1dab87),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Ride Mode"),
            SizedBox(width: 8.0),
            Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            margin: const EdgeInsets.all(15.0),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Icon(Icons.notifications),
                Positioned(
                  top: 1.0,
                  left: 13.0,
                  child: Container(
                    height: 9.0,
                    width: 9.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xff1dab87),
                        width: 1.75,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.white54,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            markers: {controller.marker},
            zoomControlsEnabled: false,
            initialCameraPosition: controller.currentLoc,
            onMapCreated: (GoogleMapController gController) {
              controller.mapController.complete(gController);
            },
          ),
          locationColumn(dropVal),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        showUnselectedLabels: true,
        iconSize: 26.0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11.0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11.0,
        ),
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xff1d3a70),
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (value) =>
            ref.read(controller.bottomIndex.notifier).state = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_rounded),
            label: 'My Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
