import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppet_fontend/API/Local/config.dart';
import 'package:shoppet_fontend/API/Server/rateAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/rateModel.dart';
import 'package:shoppet_fontend/Screen/LoginAndRegister.dart';
import 'package:shoppet_fontend/Screen/SlashSceen.dart';
import 'package:shoppet_fontend/Screen/homeScreen.dart';

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
      home: ThreadDevice()
    );
  }

  Widget ThreadDevice() {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return Slashsceen();
      } else if (Platform.isIOS) {
        return const Center(child: Text("iOS not supported yet"));
      } else {
        return const Center(child: Text("Unsupported platform"));
      }
    } else {
      return const Center(child: Text("Web not supported yet"));
    }
  }
}
