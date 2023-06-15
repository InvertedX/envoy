// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:math';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/envoy_button.dart';
import 'package:envoy/ui/onboard/onboard_welcome.dart';
import 'package:envoy/ui/pages/import_pp/single_import_pp_scan.dart';
import 'package:envoy/ui/shield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleImportPpIntroPage extends StatelessWidget {
  const SingleImportPpIntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _shieldBottom = MediaQuery.of(context).padding.bottom + 6.0;
    return EnvoyPatternScaffold(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: kToolbarHeight,
          backgroundColor: Colors.transparent,
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: EnvoyButton(
                S().passport_welcome_screen_skip,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
                type: EnvoyButtonTypes.tertiary,
                onTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
              ),
            )
          ],
        ),
        //using floating action button + offset for clamping the passport image to bottom nav
        //this is better than using a stack
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Transform.translate(
          offset: Offset(0, 110),
          child: Image.asset(
            "assets/pp_setup_intro.png",
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.2,
          ),
        ),
        bottomNavigationBar: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              padding: EdgeInsets.only(bottom: _shieldBottom),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0x0),
                Color(0xff686868),
                Color(0xffFFFFFF),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Shield(
                child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15, left: 15, top: 50, bottom: 50),
                    child: SizedBox.expand(
                        child: Container(
                      height:
                          max(MediaQuery.of(context).size.height * 0.38, 300),
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      padding: EdgeInsets.only(top: 44),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              width: 380,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    S().pair_existing_device_intro_heading,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Padding(padding: EdgeInsets.all(6)),
                                  Text(
                                    S().pair_existing_device_intro_subheading,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: DotsIndicator(
                                    decorator: DotsDecorator(
                                        size: Size.square(5.0),
                                        activeSize: Size.square(5.0),
                                        spacing: EdgeInsets.symmetric(
                                            horizontal: 5)),
                                    dotsCount: 2,
                                    position: 0.toDouble(),
                                  ),
                                ),
                                EnvoyButton(
                                  S().pair_existing_device_intro_CTA,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return SingleImportPpScanPage();
                                    }));
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
