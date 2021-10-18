import 'package:flipper_dashboard/utils.dart';
import 'package:flipper_map/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'mapbottompill.dart';
import 'mapuserbadge.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.744421, -71.1698939);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class MapView extends StatefulWidget {
  const MapView({Key? key, this.subCategory}) : super(key: key);
  final SubCategory? subCategory;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  final Set<Marker> _markers = <Marker>{};
  double pinPillPosition = PIN_VISIBLE_POSITION;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  bool userBadgeSelected = false;

  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();

    // set up initial locations
    setInitialLocation();
  }

  void setSourceAndDestinationMarkerIcons(BuildContext context) async {
    // String parentCat = widget.subCategory!.imgName!.split("_")[0];

    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/source_pin${Utils.deviceSuffix(context)}.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/destination_pin_ios${Utils.deviceSuffix(context)}.png');
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    // widget.subCategory = catSelection.selectedSubCategory;

    setSourceAndDestinationMarkerIcons(context);

    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            myLocationEnabled: true,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            polylines: _polylines,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onTap: (LatLng loc) {
              setState(() {
                pinPillPosition = PIN_INVISIBLE_POSITION;
                userBadgeSelected = false;
              });
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              showPinsOnMap();
              setPolylines();
            },
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: MapUserBadge(
            isSelected: userBadgeSelected,
          ),
        ),
        AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: pinPillPosition,
            child: MapBottomPill()),
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   right: 0,
        //   child: MainAppBar(
        //     showProfilePic: false,
        //   ),
        // )
      ],
    ));
  }

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          position: currentLocation,
          icon: sourceIcon,
          onTap: () {
            setState(() {
              userBadgeSelected = true;
            });
          }));

      _markers.add(Marker(
          markerId: const MarkerId('destinationPin'),
          position: destinationLocation,
          icon: destinationIcon,
          onTap: () {
            setState(() {
              pinPillPosition = PIN_VISIBLE_POSITION;
            });
          }));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBq1-prPYQu5MGZerFN2h7OaRYiteSg9e4",
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.status == 'OK') {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
            width: 10,
            polylineId: const PolylineId('polyLine'),
            color: const Color(0xFF08A5CB),
            points: polylineCoordinates));
      });
    }
  }
}
