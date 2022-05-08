import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:geocoder2/geocoder2.dart';

import 'package:request_live_riverpods/controllers/controllers.dart';
import 'package:request_live_riverpods/models/models.dart';
import 'package:request_live_riverpods/widgets/scaffold_snackbar.dart';

class GoLiveVenueScreen extends StatefulHookConsumerWidget {
  final String entertainerId;
  final String entertainerUsername;
  const GoLiveVenueScreen(this.entertainerId, this.entertainerUsername,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoLiveVenueScreenState();
}

class _GoLiveVenueScreenState extends ConsumerState<GoLiveVenueScreen> {
  String _previewImageUrl = '';
  Location location = Location();

  Future<void> _getCurrentUserLocationFromCoordinates(
      {required String venueName}) async {
    var _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locData = await location.getLocation();

    if (_locData.latitude != null &&
        _locData.longitude != null &&
        venueName.trim() != '') {
      // GeoData data = await Geocoder2.getDataFromCoordinates(
      //     latitude: _locData.latitude!,
      //     longitude: _locData.longitude!,
      //     googleMapApiKey: GOOGLE_MAP_API_KEY);

      // final data = await Geocoder2.getDataFromCoordinates(
      //     latitude: 40.714224,
      //     longitude: -73.961452,
      //     googleMapApiKey: GOOGLE_MAP_API_KEY);
      // googleMapApiKey: 'AIzaSyCs2cEFujOr5NhF9hFJOA0QxPyB5lafcU2');

      final staticMapImageUrl =
          UserLocationController.generateLocationPreviewImageFromCoords(
              latitude: _locData.latitude!, longitude: _locData.longitude!);
      // final staticMapImageUrl =
      //     UserLocationController.generateLocationPreviewImageFromCoords(
      //         latitude: data.latitude, longitude: data.longitude);

      // print('staticMapImageUrl created from coordinates!');
      // print(data.address);
      // print(data.city);
      // print(data.state);
      // print(data.country);

      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });

      // UserLocation userLocation = UserLocation(
      //   venueName: venueName.trim(),
      //   street_number: data.street_number,
      //   address: data.address,
      //   city: data.city,
      //   state: data.state,
      //   postalCode: data.postalCode,
      //   country: data.country,
      //   latitude: data.latitude,
      //   longitude: data.longitude,
      // );
    }
  }

  Future<void> _getCurrentUserLocationFromAddress(
      {required String venueName, required String address}) async {
    if (address.isNotEmpty) {
      try {
        GeoData data = await Geocoder2.getDataFromAddress(
            address: address, googleMapApiKey: GOOGLE_MAP_API_KEY);

        // TODO see if this works!!
        UserLocation userLocation = UserLocation.fromDocument(data);
        userLocation = userLocation.copyWith(venueName: venueName.trim());

        final staticMapImageUrl =
            UserLocationController.generateLocationPreviewImageFromCoords(
                latitude: data.latitude, longitude: data.longitude);

        setState(() {
          _previewImageUrl = staticMapImageUrl;
        });
      } catch (e) {
        const errorMessage =
            'Unable to locate using current address. Please format like:\n277 Bedford Ave, Brooklyn, NY 11211, USA';
        showCustomSnackbar(ctx: context, message: errorMessage, success: false);
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _venueController = useTextEditingController();
    final user = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: user.when(
        loading: () => const CircularProgressIndicator(
          color: Colors.white,
        ),
        error: (error, stacktrace) => Text('Error: $error'),
        data: (userData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )),
                  child: _previewImageUrl == ''
                      ? const Text(
                          'No location chosen!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Image.network(
                          _previewImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Current Location
                    TextButton.icon(
                      onPressed: () async {
                        _getCurrentUserLocationFromCoordinates(
                            venueName: 'Hooch');
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text(
                        'Venue Mode',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Select Location
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.radio),
                      label: const Text(
                        'Podcast Mode',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
