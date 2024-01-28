import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier{
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Faça bom uso do Chat AI",
      "image": "assets/images/logo-nobg.png"
    },
  ];
}