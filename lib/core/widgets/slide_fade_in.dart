import 'package:flutter/material.dart';

class SlideFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;
  final int delayMilliseconds;

  const SlideFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.offsetY = 30,
    this.delayMilliseconds = 0,
  });

  @override
  State<SlideFadeIn> createState() => _SlideFadeInState();
}

class _SlideFadeInState extends State<SlideFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _played = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideAnimation = Tween<double>(begin: widget.offsetY, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (!_played) {
      Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
        if (mounted) {
          _controller.forward();
          _played = true;
        }
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
