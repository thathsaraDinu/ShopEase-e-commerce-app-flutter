import 'package:flutter/material.dart';

class BackgroundImageWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundImageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/Group 34041.jpg',
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
