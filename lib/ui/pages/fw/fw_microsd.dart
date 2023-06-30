// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/business/fw_uploader.dart';
import 'package:envoy/business/updates_manager.dart';
import 'package:envoy/ui/pages/fw/fw_android_instructions.dart';
import 'package:envoy/ui/pages/fw/fw_ios_instructions.dart';
import 'package:envoy/ui/pages/fw/fw_passport.dart';
import 'package:envoy/ui/pages/fw/fw_progress.dart';
import 'package:envoy/util/envoy_storage.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/generated/l10n.dart';
import 'dart:io';
import 'package:envoy/business/devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FwMicrosdPage extends ConsumerWidget {
  final bool onboarding;
  final int deviceId;

  FwMicrosdPage({this.onboarding = true, this.deviceId = 1});

  @override
  Widget build(context, ref) {
    final fwInfo = ref.watch(firmwareStreamProvider(deviceId));

    return OnboardingPage(
      key: Key("fw_microsd"),
      clipArt: Image.asset("assets/fw_microsd.png"),
      text: [
        OnboardingText(
          header: S().envoy_fw_microsd_heading,
          text: S().envoy_fw_microsd_subheading,
        )
      ],
      navigationDots: 6,
      navigationDotsIndex: 1,
      buttons: [
        OnboardingButton(
            enabled: fwInfo.hasValue,
            label: S().envoy_fw_microsd_cta,
            onTap: () async {
              try {
                if (Platform.isAndroid) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return FwProgressPage(onboarding: onboarding);
                  }));
                }

                UpdatesManager().getStoredFw(deviceId).then((File file) {
                  FwUploader(file, onUploaded: () {
                    if (Platform.isIOS) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FwPassportPage(
                          onboarding: onboarding,
                        );
                      }));
                    }
                  }).upload();
                });

                // Here we assume user has updated  his devices

                Devices()
                    .markDeviceUpdated(deviceId, fwInfo.value!.storedVersion);
              } catch (e) {
                print("SD: error " + e.toString());
                if (Platform.isIOS) // TODO: this needs to be smarter
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return FwIosInstructionsPage(
                      onboarding: onboarding,
                      deviceId: deviceId,
                    );
                  }));

                if (Platform.isAndroid)
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return FwAndroidInstructionsPage(
                        onboarding: onboarding, deviceId: deviceId);
                  }));
              }
            }),
      ],
    );
  }
}
