import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:geocoder2/geocoder2.dart';

import 'package:request_live_riverpods/controllers/controllers.dart';
import 'package:request_live_riverpods/models/models.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/screens.dart';
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
  Location location = Location();
  // ignore: prefer_final_fields
  bool _useAddress = false;

  Future<void> _getCurrentUserLocationFromCoordinates(
      {required String venueName}) async {
    try {
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
    } catch (e) {
      const errorMessage =
          'Unable to locate you at this time. Please check network connection, enable location services or input your current address.\nFormat address like:\n277 Bedford Ave, Brooklyn, NY 11211, USA';
      showCustomSnackbar(ctx: context, message: errorMessage, success: false);
      print(e);
    }
  }

  Future<void> _getCurrentUserLocationFromAddress(
      {required String venueName, required String address}) async {
    if (venueName.isNotEmpty && address.isNotEmpty) {
      try {
        // Geocode physical address to lat/long
        GeoData data = await Geocoder2.getDataFromAddress(
            address: address, googleMapApiKey: GOOGLE_MAP_API_KEY);

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
    final args = ModalRoute.of(context)!.settings.arguments as GoLiveScreenArgs;
    final _venueController = useTextEditingController();
    final _addressController = useTextEditingController();
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
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    _useAddress
                        ? 'Go Live at Address'
                        : 'Go Live at Current Location',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Switch.adaptive(
                  activeColor: Colors.indigo,
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.red,
                  value: _useAddress,
                  onChanged: (value) async {
                    setState(() {
                      _useAddress = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  // height: 170,
                  // width: double.infinity,
                  // alignment: Alignment.center,
                  // Current Location Form
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _venueFormKey,
                        child: TextFormField(
                          controller: _venueController,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) => (value == null || value.isEmpty
                              ? 'Venue is required'
                              : null),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Studio 54',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
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
                      _useAddress
                          ? Form(
                              key: _addressFormKey,
                              child: Column(
                                children: [
                                  // Address
                                  TextFormField(
                                    controller: _addressController,
                                    autocorrect: false,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (value) => (value == null ||
                                            value.isEmpty
                                        ? 'Address Required. Format: 277 Bedford Ave, Brooklyn, NY 11211, USA'
                                        : null),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    decoration: const InputDecoration(
                                      hintText:
                                          '254 W 54th St, New York, NY 10019, USA',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.speaker,
                                        color: Colors.white,
                                      ),
                                      labelText: 'Address',
                                      labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(
                // width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Use Current Location
                    if (!_useAddress)
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
                        icon: const Icon(Icons.gps_fixed),
                        label: const Text(
                          'Use GPS Location',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    // Use Address
                    if (_useAddress)
                      TextButton.icon(
                        onPressed: () async {
                          if (_venueFormKey.currentState!.validate()) {
                            if (_addressFormKey.currentState!.validate()) {
                              final venueName = _venueController.text.trim();
                              final address = _addressController.text.trim();

                              if (venueName.isNotEmpty && address.isNotEmpty) {
                                _getCurrentUserLocationFromAddress(
                                    venueName: venueName, address: address);
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text(
                          'Use Venue Address',
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
