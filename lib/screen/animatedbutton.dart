import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  final ScrollController scrollController; // Pass the ScrollController

  AnimatedIconButton({required this.scrollController});

  @override
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize the Tween Animation
    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent*.418, // Scroll to the bottom
      duration: const Duration(seconds: 1), // Duration for scrolling
      curve: Curves.easeInOut, // Smooth scrolling curve
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 78,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _animation.value),
            child: IconButton(
              onPressed: _scrollToBottom, // Scroll to top on button press
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 50,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
