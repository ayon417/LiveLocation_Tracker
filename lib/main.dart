

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map_live_location/screens/demo.dart';
import 'package:google_map_live_location/screens/mapscreen_view.dart';


void main() => runApp(const ProviderScope(
  child: MaterialApp(home:MapScreen())));

