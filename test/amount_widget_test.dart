// SPDX-FileCopyrightText: 2024 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/ui/amount_entry.dart';
import 'package:envoy/ui/components/amount_widget.dart';
import 'package:envoy/ui/theme/envoy_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'util/preload_fonts.dart';

void main() {
  testWidgets('AmountWidget', (tester) async {
    tester.view.physicalSize = Size(1200, 700);
    tester.view.devicePixelRatio = 1.0;

    await preloadFonts(tester);

    // WORKAROUND: pump the widget twice to load the icons
    // I have no idea why this works
    for (var i = 0; i < 2; i++) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AmountWidgetTestCases(),
              )),
        ),
      );
    }

    await expectLater(
        find.byType(Directionality), matchesGoldenFile('amount_widget.png'));
  });
}

class AmountWidgetTestCases extends StatelessWidget {
  const AmountWidgetTestCases({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(EnvoySpacing.large1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 200,
            child: Column(
              children: [
                AmountWidget(
                  amountSats: 421,
                  primaryUnit: AmountDisplayUnit.btc,
                  secondaryUnit: AmountDisplayUnit.fiat,
                  style: AmountWidgetStyle.normal,
                  decimalDot: true,
                  fxRateFiat: 2871.759259259,
                  symbolFiat: "\$",
                ),
                SizedBox(height: 10),
                AmountWidget(
                  amountSats: 421,
                  primaryUnit: AmountDisplayUnit.btc,
                  secondaryUnit: AmountDisplayUnit.fiat,
                  style: AmountWidgetStyle.singleLine,
                  decimalDot: true,
                  fxRateFiat: 2871.759259259,
                  symbolFiat: "\$",
                ),
              ],
            ),
          ),
          Column(
            //Column for BTC
            children: [
              AmountWidget(
                amountSats: 421,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 43421,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 2343421,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 122343421,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 523722343000,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 12523722300000,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 512523722000000,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
              AmountWidget(
                amountSats: 2012523720000000,
                primaryUnit: AmountDisplayUnit.btc,
                secondaryUnit: AmountDisplayUnit.fiat,
                style: AmountWidgetStyle.large,
                decimalDot: true,
                fxRateFiat: 2871.759259259,
                symbolFiat: "\$",
              ),
            ],
          ),
          SizedBox(width: 2),
          Column(//Column for sats
              children: [
            AmountWidget(
              amountSats: 421,
              primaryUnit: AmountDisplayUnit.sat,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 43421,
              primaryUnit: AmountDisplayUnit.sat,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 2343421,
              primaryUnit: AmountDisplayUnit.sat,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 22343421,
              primaryUnit: AmountDisplayUnit.sat,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            SizedBox(height: 100),
            // section for EU
            AmountWidget(
              amountSats: 512523722000,
              primaryUnit: AmountDisplayUnit.btc,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: false,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 2343421,
              primaryUnit: AmountDisplayUnit.sat,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: false,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 122343421,
              primaryUnit: AmountDisplayUnit.sat,
              secondaryUnit: AmountDisplayUnit.fiat,
              style: AmountWidgetStyle.large,
              decimalDot: false,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
          ]),
          SizedBox(width: 2),
          Column(// Column for fiat
              children: [
            AmountWidget(
              amountSats: 421,
              primaryUnit: AmountDisplayUnit.fiat,
              secondaryUnit: AmountDisplayUnit.btc,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 43421,
              primaryUnit: AmountDisplayUnit.fiat,
              secondaryUnit: AmountDisplayUnit.btc,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 22343421,
              primaryUnit: AmountDisplayUnit.fiat,
              secondaryUnit: AmountDisplayUnit.btc,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 698197340,
              primaryUnit: AmountDisplayUnit.fiat,
              secondaryUnit: AmountDisplayUnit.btc,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 523722343000,
              primaryUnit: AmountDisplayUnit.fiat,
              secondaryUnit: AmountDisplayUnit.btc,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
            AmountWidget(
              amountSats: 512523722000000,
              primaryUnit: AmountDisplayUnit.fiat,
              secondaryUnit: AmountDisplayUnit.btc,
              style: AmountWidgetStyle.large,
              decimalDot: true,
              fxRateFiat: 2871.759259259,
              symbolFiat: "\$",
            ),
          ]),
        ],
      ),
    );
  }
}