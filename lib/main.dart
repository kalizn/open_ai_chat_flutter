import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/routes.dart';
import 'utils/theme.dart';
import 'view_models/splash.view.model.dart';
import 'views/splash/splash.view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel())
      ],
      child:  const MyApp()),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Open Ai Bot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashView.routeName,
      routes: routes,
    );
  }
}
