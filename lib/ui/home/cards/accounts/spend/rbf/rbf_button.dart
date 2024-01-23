// SPDX-FileCopyrightText: 2024 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';

import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/components/button.dart';
import 'package:envoy/ui/components/envoy_checkbox.dart';
import 'package:envoy/ui/envoy_dialog.dart';
import 'package:envoy/ui/home/cards/accounts/accounts_state.dart';
import 'package:envoy/ui/home/cards/accounts/spend/rbf/rbf_spend_screen.dart';
import 'package:envoy/ui/home/cards/accounts/spend/spend_fee_state.dart';
import 'package:envoy/ui/home/cards/accounts/spend/spend_state.dart';
import 'package:envoy/ui/state/home_page_state.dart';
import 'package:envoy/ui/state/transactions_state.dart';
import 'package:envoy/ui/theme/envoy_colors.dart';
import 'package:envoy/ui/theme/envoy_icons.dart';
import 'package:envoy/ui/theme/envoy_spacing.dart';
import 'package:envoy/ui/widgets/blur_dialog.dart';
import 'package:envoy/ui/widgets/toast/envoy_toast.dart';
import 'package:envoy/util/envoy_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/generated_bindings.dart' as rust;
import 'package:wallet/wallet.dart';

class RBFSpendState {
  Psbt psbt;
  rust.RBFfeeRates rbfFeeRates;
  String receiveAddress;
  num receiveAmount;
  int feeRate;
  Transaction originalTx;

  RBFSpendState(
      {required this.psbt,
      required this.rbfFeeRates,
      required this.receiveAddress,
      required this.receiveAmount,
      required this.feeRate,
      required this.originalTx});
}

class TxRBFButton extends ConsumerStatefulWidget {
  final Transaction tx;

  const TxRBFButton({super.key, required this.tx});

  @override
  ConsumerState<TxRBFButton> createState() => _TxRBFButtonState();
}

class _TxRBFButtonState extends ConsumerState<TxRBFButton> {
  bool _isPressed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future _checkRBF(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (ref.read(getTransactionProvider(widget.tx.txId))?.isConfirmed == true) {
      EnvoyToast(
        backgroundColor: EnvoyColors.danger,
        replaceExisting: true,
        duration: Duration(seconds: 4),
        message: "Error: Transaction Confirmed",
        icon: Icon(
          Icons.info_outline,
          color: EnvoyColors.solidWhite,
        ),
      ).show(context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final account = ref.read(selectedAccountProvider);
      rust.RBFfeeRates? rates =
          await account?.wallet.getBumpedPSBTMaxFeeRate(widget.tx.txId);
      if (rates != null && rates.min_fee_rate > 0) {
        double minFeeRate = rates.min_fee_rate.ceil().toDouble();
        Psbt? psbt = await account?.wallet
            .getBumpedPSBT(widget.tx.txId, convertToFeeRate(minFeeRate));
        final rawTxx = await account!.wallet
            .decodeWalletRawTx(psbt!.rawTx, account.wallet.network);

        RawTransactionOutput receiveOutPut =
            rawTxx.outputs.firstWhere((element) {
          return (element.path == TxOutputPath.NotMine ||
              element.path == TxOutputPath.External);
        }, orElse: () => rawTxx.outputs.first);

        RBFSpendState rbfSpendState = RBFSpendState(
            psbt: psbt,
            rbfFeeRates: rates,
            receiveAddress: receiveOutPut.address,
            receiveAmount: 0,
            feeRate: minFeeRate.toInt(),
            originalTx: widget.tx);

        ref.read(spendAddressProvider.notifier).state = receiveOutPut.address;
        ref.read(spendAmountProvider.notifier).state = receiveOutPut.amount;

        ref.read(feeChooserStateProvider.notifier).state = FeeChooserState(
          standardFeeRate: minFeeRate,

          ///TODO: this is a hack to make sure the faster fee rate is always higher than the standard fee rate
          fasterFeeRate: (minFeeRate + 1)
              .clamp(minFeeRate.toInt(), rates.max_fee_rate.toInt())
              .toInt(),
          minFeeRate: rates.min_fee_rate.ceil().toInt(),
          maxFeeRate: rates.max_fee_rate.floor().toInt(),
        );
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return RBFSpendScreen(
              rbfSpendState: rbfSpendState,
            );
          },
        ));
        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      EnvoyToast(
        backgroundColor: EnvoyColors.danger,
        replaceExisting: true,
        duration: Duration(seconds: 4),
        message: "Error: ${e.toString()}",
        icon: Icon(
          Icons.info_outline,
          color: EnvoyColors.solidWhite,
        ),
      ).show(context);
      setState(() {
        _isLoading = false;
      });
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTap: () {
        _showRBFDialog(context);
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: _buildButtonContainer(
          active: !_isLoading,
          child: _isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox.square(
                      dimension: 12,
                      child: CircularProgressIndicator(
                        color: EnvoyColors.solidWhite,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.fast_forward_outlined,
                      color: Colors.white,
                    ),
                    Padding(padding: EdgeInsets.all(EnvoySpacing.xs)),
                    Text(
                      "Boost",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )),
    );
  }

  Widget _buildButtonContainer({
    required Widget child,
    bool active = true,
  }) {
    Color buttonColor =
        _isPressed ? EnvoyColors.teal500.withOpacity(0.8) : EnvoyColors.teal500;
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 28,
        width: 90,
        padding: EdgeInsets.symmetric(horizontal: EnvoySpacing.small),
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(EnvoySpacing.small)),
        child: child);
  }

  void _showRBFDialog(BuildContext context) async {
    if (!(await EnvoyStorage()
        .checkPromptDismissed(DismissiblePrompt.rbfWarning))) {
      showEnvoyDialog(
        context: context,
        dialog: EnvoyDialog(
          paddingBottom: 0,
          content: RBFWarning(
            onConfirm: () {
              Navigator.pop(context);
              _checkRBF(context);
            },
          ),
        ),
      );
    } else {
      _checkRBF(context);
    }
  }
}

class RBFWarning extends StatefulWidget {
  final GestureTapCallback onConfirm;

  const RBFWarning({super.key, required this.onConfirm});

  @override
  State<RBFWarning> createState() => _RBFWarningState();
}

class _RBFWarningState extends State<RBFWarning> {
  bool dismissed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: EnvoySpacing.medium1),
            child: EnvoyIcon(
              EnvoyIcons.info,
              size: EnvoyIconSize.big,
              color: EnvoyColors.accentPrimary,
            ),
          ),
          Text(
            S().replaceByFee_coindetails_overlay_modal_heading,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
          Text(
            S().replaceByFee_coindetails_overlay_modal_subheading,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
          Text(
            S().component_learnMore,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: EnvoyColors.accentPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
          Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
          GestureDetector(
            onTap: () {
              setState(() {
                dismissed = !dismissed;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: EnvoyCheckbox(
                    value: dismissed,
                    onChanged: (value) {
                      if (value != null)
                        setState(() {
                          dismissed = value;
                        });
                    },
                  ),
                ),
                Text(
                  S().component_dontShowAgain,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: dismissed ? Colors.black : Color(0xff808080),
                      ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
          EnvoyButton(
              label: S().component_continue,
              onTap: () {
                if (dismissed) {
                  EnvoyStorage().addPromptState(DismissiblePrompt.rbfWarning);
                }
                widget.onConfirm();
              },
              type: ButtonType.primary,
              state: ButtonState.default_state),
        ],
      ),
    );
  }
}