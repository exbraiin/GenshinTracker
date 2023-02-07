import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/main_screen/main_screen.dart';

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
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(0),
        ),
        fontFamily: 'Bahnschrift',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: GsColors.mainColor1,
        splashColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: GsColors.mainColor1,
        ),
        colorScheme: const ColorScheme.light(
          background: GsColors.mainColor1,
        ),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(
            color: GsColors.mainColor0,
            borderRadius: kMainRadius,
          ),
          textStyle: TextStyle(
            fontSize: 12,
            color: GsColors.mainColor3,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withOpacity(0.2),
          selectionHandleColor: Colors.white,
        ),
        canvasColor: GsColors.mainColor1,
      ),
      home: const MainScreen(),
    );
  }
}
