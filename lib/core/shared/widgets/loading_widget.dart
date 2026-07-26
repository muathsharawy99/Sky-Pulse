import 'package:flutter/material.dart';

/// Loading indicator shown while a weather fetch is in flight.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
