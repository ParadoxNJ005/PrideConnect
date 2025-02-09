import 'package:flutter/material.dart';

class LogoAnimationWidget extends StatefulWidget {
  const LogoAnimationWidget({Key? key}) : super(key: key);

  @override
  State<LogoAnimationWidget> createState() => _LogoAnimationWidgetState();
}

class _LogoAnimationWidgetState extends State<LogoAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // Initialize the rotation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Rotates indefinitely
  }

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RotationTransition(
        turns: _rotationController,
        child: Container(
          width: 45.0,
          height: 45.0,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}