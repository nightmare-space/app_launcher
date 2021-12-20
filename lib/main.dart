import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';

import 'app_launcher.dart';

void main() {
  runApp(const MyApp());
  RuntimeEnvir.initEnvirWithPackageName('com.nightmare.app_launcher');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Color(0xfff5f5f7),
          body: SafeArea(
            child: AppLauncher(),
          ),
        ),
      ),
    );
  }
}
