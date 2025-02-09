import 'package:flutter/material.dart';

class ScrollUtils {
  static void scrollToPosition(ScrollController scrollController, double position, {Duration duration = const Duration(seconds: 1), Curve curve = Curves.easeInOut}) {
    scrollController.animateTo(
      position,
      duration: duration,
      curve: curve,
    );
  }

  static void scrollToBottomscrollToBottom(ScrollController scrollController, {Duration duration = const Duration(seconds: 1), Curve curve = Curves.easeInOut}){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }


  static void scrollToTop(ScrollController scrollController, {Duration duration = const Duration(seconds: 1), Curve curve = Curves.easeInOut}) {
    scrollController.animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }
}