import 'package:cg_core_defs/strategies/location/location_plugin.dart';
import 'package:flutter/material.dart';

part 'parts/bars.dart';
part 'parts/buttons.dart';
part 'parts/components.dart';
part 'parts/inputs.dart';
part 'parts/scaffold.dart';

abstract final class AppConstants {
  //$ Default Radius
  static const double defaultRadius = 12;

  //$ Default Elevation
  static const double defaultElevation = 8;

  static const scaffold = _Scaffold();
  static const inputs = _Inputs._();
  static const buttons = _Buttons._();
  static const drawer = _Drawer._();
  static final topBar = _TopBar._();
  static final bottomBar = _BottomBar._();
  static const cards = _Cards._();
  static const listTiles = _ListTiles._();
  static const progressIndicators = _ProgressIndicators._();
  static final filePicking = _FilePicking._();

  // Jewel CHERIAA
  // LinkedIn  https://www.linkedin.com/in/jewel-cheriaa/
  // Email     jewelcheriaa@gmail.com
  // Mobile    +216 24 226 712
  // WhatsApp  +33 7 43 10 44 25
  // Address   https://maps.app.goo.gl/G7oxrxcf3pdeXkYA6

  static const mapDefaultCentralPoint = GeoCoordinates(35.501212354988134, 11.057053644177238);
}
