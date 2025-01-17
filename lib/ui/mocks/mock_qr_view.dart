// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';

class MockQrView extends StatelessWidget {
  final Function()? happyPath;
  final Function()? unhappyPath;

  MockQrView({this.happyPath, this.unhappyPath});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        TextButton(onPressed: happyPath, child: const Text('HAPPY')),
        TextButton(onPressed: unhappyPath, child: const Text('UNHAPPY'))
      ],
    );
  }
}
