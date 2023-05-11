import 'package:maps_launcher/maps_launcher.dart';

Future<void> getAddress(String location) async {
  MapsLauncher.launchQuery(location);
}
