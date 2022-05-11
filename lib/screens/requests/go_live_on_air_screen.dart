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

class GoLiveOnAirScreen extends StatefulHookConsumerWidget {
  final String entertainerId;
  final String entertainerUsername;
  const GoLiveOnAirScreen(this.entertainerId, this.entertainerUsername,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoLiveOnAirScreenState();
}

class _GoLiveOnAirScreenState extends ConsumerState<GoLiveOnAirScreen> {
  final _podcastTitleFormKey = GlobalKey<FormState>();
  final _webAddressFormKey = GlobalKey<FormState>();
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

  Future<void> _goLiveOnAirWithTitleAndWebAddress(
      {required String podcastTitle, required String webAddress}) async {
    if (podcastTitle.isNotEmpty && webAddress.isNotEmpty) {
      try {
        // Create new UserLocation.copyWith(venue = )

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
    final _podcastTitleController = useTextEditingController();
    final _webAddressController = useTextEditingController();
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
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _podcastTitleFormKey,
                        child: TextFormField(
                          controller: _podcastTitleController,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) => (value == null || value.isEmpty
                              ? 'What do you call your show?'
                              : null),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Behind The Decks',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.speaker,
                              color: Colors.white,
                            ),
                            labelText: 'Podcast Title or Station Call Sign',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Form(
                        key: _webAddressFormKey,
                        child: Column(
                          children: [
                            // Address
                            TextFormField(
                              controller: _webAddressController,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                                  (value == null || value.isEmpty
                                      ? 'Please provide a link to your show!'
                                      : null),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'https://www.twitch.tv/grandpoobear',
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.speaker,
                                  color: Colors.white,
                                ),
                                labelText: 'Web Address',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
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
                    TextButton.icon(
                      onPressed: () async {
                        if (_podcastTitleFormKey.currentState!.validate()) {
                          if (_webAddressFormKey.currentState!.validate()) {
                            final podcastTitle =
                                _podcastTitleController.text.trim();
                            final webAddress =
                                _webAddressController.text.trim();

                            // TODO set up legit url validation
                            if (podcastTitle.isNotEmpty &&
                                webAddress.isNotEmpty) {
                              _goLiveOnAirWithTitleAndWebAddress(
                                  podcastTitle: podcastTitle,
                                  webAddress: webAddress);
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.podcasts),
                      label: const Text(
                        'Go Live On The Air!',
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
