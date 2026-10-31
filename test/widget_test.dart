import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:presensi/main.dart';

void main() {
  testWidgets('LookIn opens on sign in', (WidgetTester tester) async {
    await initializeDateFormatting('id_ID');
    await tester.pumpWidget(const LookInApp());
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is! Image) return false;
        final image = widget.image;
        return image is AssetImage &&
            image.assetName == 'assets/lookin_logo.png';
      }),
      findsOneWidget,
    );
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'MASUK'), findsOneWidget);
  });

  testWidgets('Demo sign in opens the attendance dashboard', (
    WidgetTester tester,
  ) async {
    await initializeDateFormatting('id_ID');
    await tester.pumpWidget(const LookInApp());
    await tester.enterText(
      find.byType(TextFormField).first,
      'papoi@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'MASUK'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Selamat pagi, Papoi'), findsOneWidget);
    expect(find.text('Kantor Yogyakarta'), findsOneWidget);
    await tester.tap(find.text('Profil').last);
    await tester.pump();
    expect(find.text('My Profile'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
