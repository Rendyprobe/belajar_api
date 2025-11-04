// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:belajar_api/main.dart';

void main() {
  testWidgets('Splash screen then overview appears', (tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('dibuat oleh rendy'), findsOneWidget);
    expect(find.byIcon(Icons.local_movies_rounded), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Studio Ghibli'), findsWidgets);
  });
}
