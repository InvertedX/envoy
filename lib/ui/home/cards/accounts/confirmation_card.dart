// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/ui/amount.dart';
import 'package:envoy/ui/home/cards/accounts/psbt_card.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:wallet/exceptions.dart';
import 'package:wallet/wallet.dart';
import 'package:envoy/ui/address_entry.dart';
import 'package:envoy/ui/home/cards/envoy_text_button.dart';
import 'package:envoy/ui/home/cards/navigation_card.dart';
import 'package:envoy/ui/home/cards/accounts/fee_toggle.dart';
import 'package:envoy/business/account.dart';
import 'package:envoy/business/fees.dart';

//ignore: must_be_immutable
class ConfirmationCard extends StatefulWidget with NavigationCard {
  @override
  bool get modal => true;

  final Account account;
  final bool sendMax;
  final int amount;

  final String initialAddress;

  ConfirmationCard(this.account, this.amount, this.initialAddress,
      {CardNavigator? pushCallback})
      : this.sendMax = amount == account.wallet.balance,
        super(key: UniqueKey()) {
    optionsWidget = null;
    modal = true;
    title = S().envoy_home_accounts.toUpperCase();
    navigator = pushCallback;
  }

  @override
  State<ConfirmationCard> createState() => _ConfirmationCardState();
}

class _ConfirmationCardState extends State<ConfirmationCard> {
  static Psbt _emptyPtsb = Psbt(0, 0, 0, "", "", "");

  Psbt _currentPsbt = _emptyPtsb;
  Psbt _currentPsbtBoost = _emptyPtsb;

  bool _boostEnabled = false;
  int _amount = 0;

  var address;

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;

    address = AddressEntry(
      initalAddress: widget.initialAddress,
      canEdit: false,
      wallet: widget.account.wallet,
    );

    _getPsbts();
  }

  Future<void> _getPsbts() async {
    _getPsbt(Fees().slowRate).then((psbt) {
      setState(() {
        _currentPsbt = psbt;
        if (widget.sendMax) {
          _amount = _currentPsbt.amount.abs();
        }
      });
    });
    _getPsbt(Fees().fastRate).then((psbt) {
      setState(() {
        _currentPsbtBoost = psbt;
      });
    });
  }

  Future<Psbt> _getPsbt(double feeRate) async {
    Psbt _returnPsbt = _emptyPtsb;

    try {
      await widget.account.wallet
          .createPsbt(address.text, widget.amount, feeRate)
          .then((psbt) {
        _returnPsbt = psbt;
      });
    } on InsufficientFunds catch (e) {
      // Get another one with correct amount
      var fee = widget.amount - e.available;
      try {
        await widget.account.wallet
            .createPsbt(address.text, e.available - fee, feeRate)
            .then((psbt) {
          _returnPsbt = psbt;
        });
      } on InsufficientFunds catch (e) {
        print("Something is seriously wrong! Available: " +
            e.available.toString() +
            " Needed: " +
            e.needed.toString());
      }
    }

    return _returnPsbt;
  }

  @override
  Widget build(BuildContext context) {
    var _feeToggle = FeeToggle(
      standardFee: _currentPsbt.fee,
      boostFee: _currentPsbtBoost.fee,
      key: UniqueKey(),
      initialIndex: _boostEnabled ? 1 : 0,
      onToggled: (int fee, bool usingBoost) {
        _boostEnabled = usingBoost;
        if (widget.sendMax) {
          setState(() {
            _amount = widget.amount - fee;
          });
        }
      },
    );

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: address,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: AmountDisplay.sats(
          _amount,
        ),
      ),
      _feeToggle,
      Padding(
          padding: const EdgeInsets.all(50.0),
          child: EnvoyTextButton(
              onTap: () {
                widget.navigator!.push(PsbtCard(
                  _boostEnabled ? _currentPsbtBoost : _currentPsbt,
                  widget.account,
                  navigationCallback: widget.navigator,
                ));
              },
              label: S().envoy_confirmation_confirm))
    ]);
  }
}
