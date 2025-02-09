import 'package:flutter/material.dart';

class AnimatedButtonn extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double animationRange; // Range of the animation (e.g., 20 for up and down)

  const AnimatedButtonn({super.key,
    required this.onPressed,
    required this.child,
    this.animationRange = 1000,
  });

  @override
  _AnimatedButtonnState createState() => _AnimatedButtonnState();
}

class _AnimatedButtonnState extends State<AnimatedButtonn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 500,
      end: widget.animationRange,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}