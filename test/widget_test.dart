import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('WeatherApp builds and shows the search UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WeatherApp());
    await tester.pumpAndSettle();

    expect(find.text('Weather'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
