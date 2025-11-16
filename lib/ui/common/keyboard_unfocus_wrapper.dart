import 'package:flutter/material.dart';

/// This widget wraps any child and unfocuses the keyboard when tapping

class KeyboardUnfocusWrapper extends StatelessWidget {
  final Widget child;
  final HitTestBehavior behavior;

  const KeyboardUnfocusWrapper({
    super.key,
    required this.child,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
