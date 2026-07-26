import 'package:flutter/material.dart';

/// Dismisses the keyboard/focus whenever the user taps anywhere outside of
/// the currently focused widget (e.g. a [TextField]).
class Unfocus extends StatelessWidget {
  const Unfocus({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
