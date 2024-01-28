import 'package:flutter/material.dart';

import '../views/chat/chat.view.dart';
import '../views/splash/splash.view.dart';

final Map<String, WidgetBuilder> routes = {
  SplashView.routeName: (context) => const SplashView(),
  ChatView.routeName: (context) => const ChatView()
};