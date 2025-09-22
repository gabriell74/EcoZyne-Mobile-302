import 'dart:ui';

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [
                  Color(0xFFFFCDD2),
                  Color(0xFFC8E6C9),
                  Color(0xFFBBDEFB),
                  Colors.white
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
          ),
        ),

        BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child
      ],
    );
  }
}
