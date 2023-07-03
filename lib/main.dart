import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:request_api/home.dart';

final appTheme = ThemeData(
  primarySwatch: const MaterialColor(0xff1e7efb, {
    50: Color.fromRGBO(30, 126, 251, .1),
    100: Color.fromRGBO(30, 126, 251, .2),
    200: Color.fromRGBO(30, 126, 251, .3),
    300: Color.fromRGBO(30, 126, 251, .4),
    400: Color.fromRGBO(30, 126, 251, .5),
    500: Color.fromRGBO(30, 126, 251, .6),
    600: Color.fromRGBO(30, 126, 251, .7),
    700: Color.fromRGBO(30, 126, 251, .8),
    800: Color.fromRGBO(30, 126, 251, .9),
    900: Color.fromRGBO(30, 126, 251, 1.0),
  }),
);

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
        home: const HomePage(),
      ),
    ),
  );
}
