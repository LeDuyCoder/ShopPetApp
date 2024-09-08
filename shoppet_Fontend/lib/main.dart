import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:shoppet_fontend/Screen/LoginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ThreadDevice());
  }

  Widget ThreadDevice() {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return LoginScreen();
      } else if (Platform.isIOS) {
        return Container();
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
