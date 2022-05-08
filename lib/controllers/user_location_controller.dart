// ignore: constant_identifier_names
const GOOGLE_MAP_API_KEY = 'AIzaSyCs2cEFujOr5NhF9hFJOA0QxPyB5lafcUc';
// const GOOGLE_MAP_SECRET = 'eGDLs2DIMTdMrAAZbV8gyCwG1G4=';

class UserLocationController {
  static String generateLocationPreviewImageFromCoords(
      {required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=12&size=400x400&key=$GOOGLE_MAP_API_KEY';
  }
}
