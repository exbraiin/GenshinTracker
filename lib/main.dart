import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/main_screen/main_screen.dart';
import 'package:tracker/theme/theme.dart';

// TODO:
// * Move owned and other saved settings to card details.
// * Missing card details, can be added???
//    - Spincrystals.
//    - Reputation.
//    - Characters and Weapons, may not be possible because of information amount.

void main() {
  GsDomain.testLabels();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
        scrollbars: false,
        physics: const BouncingScrollPhysics(),
      ),
      localizationsDelegates: [
        Lang.delegate,
      ],
      theme: theme,
      home: const MainScreen(),
    );
  }
}
