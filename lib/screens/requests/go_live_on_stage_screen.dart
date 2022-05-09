import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:geocoder2/geocoder2.dart';

import 'package:request_live_riverpods/controllers/controllers.dart';
import 'package:request_live_riverpods/models/models.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/widgets/scaffold_snackbar.dart';

class GoLiveOnStageScreen extends StatefulHookConsumerWidget {
  final String entertainerId;
  final String entertainerUsername;
  const GoLiveOnStageScreen(this.entertainerId, this.entertainerUsername,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoLiveOnStageScreenState();
}

class _GoLiveOnStageScreenState extends ConsumerState<GoLiveOnStageScreen> {
  final _venueFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  String _previewImageUrl = '';
  Location location = Location();

  Future<void> _getCurrentUserLocationFromCoordinates(
      {required String venueName}) async {
    // Check location services enabled. Request if necessary
    var _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Verify requested location permissions. Request if necessary
    PermissionStatus _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Geo-locate user (latitude / longitude )
    final _locData = await location.getLocation();

    if (_locData.latitude != null &&
        _locData.longitude != null &&
        venueName.trim() != '') {
      // Geocode lat/long to physical address
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: _locData.latitude!,
          longitude: _locData.longitude!,
          googleMapApiKey: GOOGLE_MAP_API_KEY);

      // Generate map image.. No longer using this, but keeping code handy anyway
      // final staticMapImageUrl =
      //     UserLocationController.generateLocationPreviewImageFromCoords(
      //         latitude: data.latitude, longitude: data.longitude);

      // setState(() {
      //   _previewImageUrl = staticMapImageUrl;
      // });

      // Create userLocation from GeoData (Can this be optimized with a fromMap function?)
      UserLocation userLocation = UserLocation(
        venueName: venueName.trim(),
        street_number: data.street_number,
        address: data.address,
        city: data.city,
        state: data.state,
        postalCode: data.postalCode,
        country: data.country,
        latitude: data.latitude,
        longitude: data.longitude,
      );

      // Pass userLocation back to requests screen
      if (userLocation.venueName == venueName) {
        Navigator.of(context).pop(userLocation);
      }
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
          if (!userData.isEntertainer) {
            print('You\'re not an entertainer! How did you get here?');
            Navigator.of(context).pushReplacementNamed(Routes.welcome);
          }
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Form(
                    key: _venueFormKey,
                    child: TextFormField(
                      controller: _venueController,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => (value == null || value.isEmpty
                          ? 'Venue is required'
                          : null),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.speaker,
                          color: Colors.white,
                        ),
                        labelText: 'Venue Name',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Current Location
                    TextButton.icon(
                      onPressed: () async {
                        if (_venueFormKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          final venueName = _venueController.text.trim();

                          if (venueName.isNotEmpty) {
                            _getCurrentUserLocationFromCoordinates(
                                venueName: venueName);
                          }
                        }
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text(
                        'Use Current Location',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Select Location
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.radio),
                      label: const Text(
                        'Use Address',
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
