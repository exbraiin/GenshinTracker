import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/main_screen/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
        scrollbars: false,
        physics: BouncingScrollPhysics(),
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
        backgroundColor: GsColors.mainColor1,
        scaffoldBackgroundColor: GsColors.mainColor1,
        splashColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: GsColors.mainColor1,
        ),
        tooltipTheme: TooltipThemeData(
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
      ),
      home: MainScreen(),
    );
  }
}
