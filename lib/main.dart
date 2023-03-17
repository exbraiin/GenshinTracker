import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/main_screen/main_screen.dart';
import 'package:tracker/theme/theme.dart';

// TODO:
// * Missing card details, can be added ???
//    - Reputation.
//    - Add save materials again. Open material card form "everywhere".
//    - Change idsavemodel to have a "isEmpty" getter. Then add an update method to save collection to insert or delete item based on getter return. (maybe not a good ideia)
//    - Characters, may not be possible because of information amount.

void main() {
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
