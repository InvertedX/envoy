// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';
import 'package:envoy/business/btcpay_voucher.dart';
import 'package:flutter/material.dart';
import 'package:envoy/ui/home/cards/accounts/btcPay/btcpay_dialog.dart';

class BtcPayLoadingModal extends StatefulWidget {
  final BtcPayVoucher voucher;
  final PageController controller;

  BtcPayLoadingModal({
    Key? key,
    required this.voucher,
    required this.controller,
  }) : super(key: key);

  @override
  _BtcPayLoadingModalState createState() => _BtcPayLoadingModalState();
}

class _BtcPayLoadingModalState extends State<BtcPayLoadingModal> {
  @override
  void initState() {
    super.initState();
    _checkVoucher();
  }

  Future<void> _checkVoucher() async {
    BtcPayVoucherRedeemResult result = await widget.voucher.getinfo();
    print(result);

    if (result == BtcPayVoucherRedeemResult.success) {
      {
        widget.controller.jumpToPage(1);
      }
    } else
      widget.controller.jumpToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    return loadingSpinner(context);
  }
}
