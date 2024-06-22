import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/credit_division_notifier.dart';
import 'package:kreditindex_calculator/info_page.dart';
import 'package:kreditindex_calculator/settings_page.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalValues();
  runApp(const MyApp());
}

Future initLocalValues() async {
  int creditDivisionDefaultValue = 30;

  var prefs = await SharedPreferences.getInstance();

  //if creditDivisionNumber wasn't set before, we set it at 30 by default
  int? creditDivisionNumber = prefs.getInt('creditDivisionNumber');
  if(creditDivisionNumber == null) {
    await prefs.setInt('creditDivisionNumber', creditDivisionDefaultValue);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CreditDivisionNotifier()),
        ChangeNotifierProvider(create: (context) => SubjectList())
      ],
      child: MaterialApp(
        title: 'ÁtlagoSCH',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.green,
            onPrimary: Colors.white,
            secondary: Colors.greenAccent,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.green,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.green,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.green,
            onPrimary: Colors.black,
            secondary: Colors.greenAccent,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.black,
            background: Colors.black,
            onBackground: Colors.white,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.green,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.green,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MyHomePage(title: 'Kezdőlap'),
        routes: {
          '/settings': (context) => const SettingsPage(),
          '/info': (context) => InfoPage(),
        },
      ),
    );
  }
}
