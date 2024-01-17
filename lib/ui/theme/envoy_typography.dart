// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:ui';

import 'package:envoy/ui/theme/envoy_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnvoyTypography {
  static TextStyle explainer =
      EnvoyTypography.label.copyWith(color: EnvoyColors.textTertiary);

  static TextStyle largeAmount = GoogleFonts.montserrat(
    fontSize: 40,
    fontWeight: FontWeight.w300,
    fontFeatures: [
      FontFeature.tabularFigures(),
    ],
  );
  static TextStyle heading = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle subheading = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle button = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static TextStyle body = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle info = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static TextStyle label = GoogleFonts.montserrat(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );
}
