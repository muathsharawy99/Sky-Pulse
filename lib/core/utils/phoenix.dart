import 'package:flutter/material.dart';

/// Wrap the app (or any subtree) with [Phoenix] to be able to force a full
/// rebuild of everything below it via [Phoenix.rebirth].
class Phoenix extends StatefulWidget {
  const Phoenix({super.key, required this.child});

  final Widget child;

  static void rebirth(BuildContext context) {
    context.findAncestorStateOfType<_PhoenixState>()?.restartApp();
  }

  @override
  State<Phoenix> createState() => _PhoenixState();
}

class _PhoenixState extends State<Phoenix> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
