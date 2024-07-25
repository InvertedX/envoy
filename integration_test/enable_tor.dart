// SPDX-FileCopyrightText: 2024 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/business/connectivity_manager.dart';
import 'package:envoy/main.dart';
import 'package:envoy/ui/components/big_tab.dart';
import 'package:envoy/util/console.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot/screenshot.dart';
import 'flow_to_map_and_p2p_test.dart';

void main() {
  testWidgets('enable tor and check top shield', (tester) async {
    final FlutterExceptionHandler? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      kPrint('FlutterError caught: ${details.exceptionAsString()}');
      if (originalOnError != null) {
        originalOnError(details);
      }
    };
    try {
      // Uncomment the line below if testing on local machine.
      //await resetEnvoyData();

      ScreenshotController envoyScreenshotController = ScreenshotController();
      await initSingletons();
      await tester.pumpWidget(Screenshot(
          controller: envoyScreenshotController, child: const EnvoyApp()));

      await setUpAppFromStart(tester);

      await goToPrivacy(tester);

      // enable "better performance" if it is not enabled
      await enablePerformance(tester);
      // Check the shield icon after enabling performance
      await checkShieldIcon(tester, isPrivacy: false);

      // Perform the required actions to change to privacy
      await enablePrivacy(tester);
      // Check the shield icon after enabling privacy
      await checkShieldIcon(tester, isPrivacy: true);
    } finally {
      FlutterError.onError = originalOnError;
    }
  });
}

Future<void> findAndTapBigTab(WidgetTester tester, String label) async {
  await tester.pump();

  // Find all BigTab widgets
  final bigTabFinder = find.byType(BigTab);

  // Collect all BigTab widgets
  final bigTabWidgets = tester.widgetList<BigTab>(bigTabFinder).toList();

  // Check each BigTab widget for the correct label
  for (var tab in bigTabWidgets) {
    final textFinder = find.descendant(
      of: find.byWidget(tab),
      matching: find.byType(Text),
    );

    // Verify that the Text widget is found and contains the label
    if (textFinder.evaluate().isNotEmpty) {
      final textWidget = tester.widget<Text>(textFinder);
      if (textWidget.data != null && textWidget.data!.contains(label)) {
        // Tap the BigTab widget containing the label
        await tester.tap(find.byWidget(tab));
        await tester.pumpAndSettle();
        return; // Exit after tap
      }
    }
  }
}

Future<void> enablePrivacy(WidgetTester tester) async {
  await findAndTapBigTab(tester, 'Improved');
}

Future<void> enablePerformance(WidgetTester tester) async {
  await findAndTapBigTab(tester, 'Better');
}

Future<void> goToPrivacy(WidgetTester tester) async {
  await tester.pump();
  final privacyButton = find.text('Privacy');
  expect(privacyButton, findsOneWidget);

  await tester.tap(privacyButton);
  await tester.pump(Durations.long2);
}

Future<void> checkShieldIcon(WidgetTester tester,
    {required bool isPrivacy}) async {
  await tester.pumpAndSettle(); // Ensure the screen updates after interactions

  // Find all Image widgets on the screen
  final imageFinder = find.byType(Image);

  // Collect all Image widgets
  final imageWidgets = tester.widgetList<Image>(imageFinder).toList();

  if (isPrivacy) {
    // Check the number of image widgets found
    expect(imageWidgets, hasLength(1),
        reason: 'Image should be visible when Privacy is enabled.');

    // Determine the path of the visible image
    final imageWidget = imageWidgets.first;
    final imageAssetPath = imageWidget.image is AssetImage
        ? (imageWidget.image as AssetImage).assetName
        : null;

    // Verify which image is displayed
    if (ConnectivityManager().torEnabled &&
        !ConnectivityManager().torTemporarilyDisabled) {
      // Expected image paths when tor is enabled
      if (ConnectivityManager().electrumConnected) {
        expect(imageAssetPath, 'assets/indicator_shield_teal.png');
      } else {
        expect(imageAssetPath, 'assets/indicator_shield_red.png');
      }
    } else {
      // Expect no image to be displayed
      expect(imageAssetPath, isNull);
    }
  } else {
    // When Performance is enabled, expect no shield image to be visible
    expect(imageWidgets, isEmpty,
        reason: 'No image should be visible when Performance is enabled.');
  }
}