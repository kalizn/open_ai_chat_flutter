import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../view_models/splash.view.model.dart';
import '../chat/chat.view.dart';
import 'components/splash_content.component.dart';

class SplashView extends StatefulWidget {
  static String routeName = '/splash';

  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  Widget build(BuildContext context) {
    final splashViewModel = Provider.of<SplashViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      splashViewModel.currentPage = value;
                    });
                  },
                  itemCount: splashViewModel.splashData.length,
                  itemBuilder: (context, index) {
                    return SplashContent(
                      image: splashViewModel.splashData[index]["image"]!,
                      text: splashViewModel.splashData[index]['text']! ,
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashViewModel.splashData.length,
                              (index) => AnimatedContainer(
                            duration: kAnimationDuration,
                            margin: const EdgeInsets.only(right: 5),
                            height: 6,
                            width: splashViewModel.currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: splashViewModel.currentPage == index
                                  ? kPrimaryColor
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ChatView.routeName);
                        },
                        child: const Text('Continuar'),
                      ),
                      const SizedBox(height: 2,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}