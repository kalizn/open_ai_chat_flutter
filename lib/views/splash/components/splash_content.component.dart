import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        const Text(
          "K4LIZN",
          style: TextStyle(
            fontSize: 32,
            color: kIconsShare,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.text!,
          style: const TextStyle(color: kIconsShare),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          widget.image!,
          height: 235,
          width: 205,
        ),
      ],
    );
  }
}