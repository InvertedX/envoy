// SPDX-FileCopyrightText: 2023 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/business/account.dart';
import 'package:envoy/business/coin_tag.dart';
import 'package:envoy/business/exchange_rate.dart';
import 'package:envoy/business/settings.dart';
import 'package:envoy/ui/background.dart';
import 'package:envoy/ui/home/cards/accounts/detail/coins/coin_tag_details_screen.dart';
import 'package:envoy/ui/home/cards/accounts/detail/coins/coins_state.dart';
import 'package:envoy/ui/home/cards/accounts/detail/transaction/tx_note_dialog_widget.dart';
import 'package:envoy/ui/indicator_shield.dart';
import 'package:envoy/ui/loader_ghost.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/ui/state/hide_balance_state.dart';
import 'package:envoy/ui/state/transactions_note_state.dart';
import 'package:envoy/ui/theme/envoy_colors.dart';
import 'package:envoy/ui/theme/envoy_spacing.dart';
import 'package:envoy/ui/widgets/blur_dialog.dart';
import 'package:envoy/util/amount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wallet/wallet.dart';

class TransactionsDetailsWidget extends ConsumerStatefulWidget {
  final Account account;
  final Transaction tx;

  const TransactionsDetailsWidget(
      {super.key, required this.account, required this.tx});

  @override
  ConsumerState<TransactionsDetailsWidget> createState() =>
      _CoinDetailsWidgetState();
}

class _CoinDetailsWidgetState extends ConsumerState<TransactionsDetailsWidget> {
  bool showExpanded = false;

  @override
  Widget build(BuildContext context) {
    final tx = widget.tx;
    final note = ref.watch(txNoteProvider(tx.txId)) ?? "";
    final hideBalance =
        ref.watch(balanceHideStateStatusProvider(widget.account.id));
    final List<CoinTag> tags = ref.watch(tagsFilteredByTxIdProvider(
        FilterTagPayload(widget.account.id, tx.txId)));
    final accountAccentColor = widget.account.color;
    final trailingTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: EnvoyColors.textPrimary,
          fontWeight: FontWeight.w600,
        );
    final localizationTag =
        Localizations.maybeLocaleOf(context)?.toLanguageTag();
    TextStyle _textStyleAmountSatBtc =
        Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: EnvoyColors.textPrimary,
              fontSize: 15,
            );
    //TODO:temporary: fix with proper address
    final address = tx.outputs?[0] ?? "";
    TextStyle _textStyleFiat = Theme.of(context).textTheme.titleSmall!.copyWith(
          color: EnvoyColors.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 100,
                child: IndicatorShield(),
              ),
              Text(
                "Transaction Details",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: AnimatedContainer(
            height: 340,
            duration: Duration(milliseconds: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              border: Border.all(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accountAccentColor,
                    Colors.black,
                  ]),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  border: Border.all(
                      color: accountAccentColor,
                      width: 2,
                      style: BorderStyle.solid)),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: StripesBackground(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 36,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment(0, 0),
                                    child: SizedBox.square(
                                        dimension: 12,
                                        child: SvgPicture.asset(
                                          Settings().displayUnit ==
                                                  DisplayUnit.btc
                                              ? "assets/icons/ic_bitcoin_straight.svg"
                                              : "assets/icons/ic_sats.svg",
                                          color: Color(0xff808080),
                                        )),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(
                                        left: Settings().displayUnit ==
                                                DisplayUnit.btc
                                            ? 4
                                            : 0,
                                        right: Settings().displayUnit ==
                                                DisplayUnit.btc
                                            ? 0
                                            : 8),
                                    child: hideBalance
                                        ? LoaderGhost(
                                            width: 110,
                                            height: 20,
                                            animate: false,
                                          )
                                        : Text(
                                            "${getFormattedAmount(tx.amount, trailingZeroes: true)}",
                                            textAlign: Settings().displayUnit ==
                                                    DisplayUnit.btc
                                                ? TextAlign.start
                                                : TextAlign.end,
                                            style: _textStyleAmountSatBtc,
                                          ),
                                  ),
                                ],
                              ),
                              Container(
                                constraints: BoxConstraints(minWidth: 80),
                                alignment: Alignment.centerRight,
                                child: hideBalance
                                    ? LoaderGhost(
                                        width: 64,
                                        height: 20,
                                        animate: false,
                                      )
                                    : Text(
                                        ExchangeRate()
                                            .getFormattedAmount(tx.amount),
                                        style: _textStyleFiat,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CoinTagListItem(
                                title: "Address",
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_spend.svg",
                                  color: Colors.black,
                                  height: 14,
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showExpanded = !showExpanded;
                                    });
                                  },
                                  child: SelectableText(
                                    "${truncateWithEllipsisInCenter(address, showExpanded ? address.length : 20)}",
                                    style: trailingTextStyle?.copyWith(
                                        color: EnvoyColors.accentPrimary),
                                    textAlign: TextAlign.end,
                                    onTap: () {
                                      setState(() {
                                        showExpanded = !showExpanded;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              CoinTagListItem(
                                title: "Transaction ID",
                                icon: Icon(
                                  CupertinoIcons.compass,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                trailing: LinkText(
                                    text:
                                        "${truncateWithEllipsisInCenter("${tx.txId}", 16)}",
                                    onTap: () {},
                                    textStyle: trailingTextStyle?.copyWith(
                                        color: EnvoyColors.accentPrimary)),
                              ),
                              CoinTagListItem(
                                title: "Date",
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                trailing: Text(
                                    "${DateFormat.yMd(localizationTag).format(tx.date)} at ${DateFormat.Hm(localizationTag).format(tx.date)}",
                                    style: trailingTextStyle),
                              ),
                              CoinTagListItem(
                                title: "Tags",
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_tag.svg",
                                  color: Colors.black,
                                  height: 16,
                                ),
                                trailing: RichText(
                                    text: TextSpan(
                                        children: tags.map((e) {
                                  return TextSpan(
                                      mouseCursor: SystemMouseCursors.click,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .push(BlurDialogRoute(
                                            cardColor: Colors.transparent,
                                            builder: Builder(
                                              builder: (context) =>
                                                  CoinTagDetailsScreen(
                                                coinTag: e,
                                                showCoins: true,
                                              ),
                                            ),
                                          ));
                                        },
                                      text:
                                          "${e.name}${tags.length > 1 ? ", " : ""}",
                                      style: trailingTextStyle?.copyWith(
                                          color: EnvoyColors.accentPrimary));
                                }).toList())),
                              ),
                              CoinTagListItem(
                                title: "Status",
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_status_icon.svg",
                                  color: Colors.black,
                                  height: 14,
                                ),
                                trailing: Text(
                                    "${tx.isConfirmed ? "Confirmed" : "Pending"} ",
                                    style: trailingTextStyle),
                              ),
                              CoinTagListItem(
                                title: "Fee",
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_bitcoin_straight_circle.svg",
                                  color: Colors.black,
                                  height: 14,
                                ),
                                trailing: hideBalance
                                    ? LoaderGhost(
                                        width: 74, animate: false, height: 16)
                                    : RichText(
                                        text: TextSpan(
                                            style: trailingTextStyle?.copyWith(
                                              color: EnvoyColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                            TextSpan(
                                              text:
                                                  "${getFormattedAmount(tx.fee, includeUnit: true)}",
                                            ),
                                            TextSpan(
                                                text:
                                                    "${Settings().selectedFiat != null ? "  " : ''}${ExchangeRate().getFormattedAmount(tx.fee)}",
                                                style:
                                                    trailingTextStyle?.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                )),
                                          ])),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showEnvoyDialog(
                                      context: context,
                                      dialog: TxNoteDialog(txId: tx.txId),
                                      alignment: Alignment(0.0, -0.8));
                                },
                                child: CoinTagListItem(
                                  title: "Notes",
                                  icon: SvgPicture.asset(
                                    "assets/icons/ic_notes.svg",
                                    color: Colors.black,
                                    height: 14,
                                  ),
                                  trailing: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text("$note",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: trailingTextStyle?.copyWith(
                                                fontSize: 12),
                                            textAlign: TextAlign.end),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.all(EnvoySpacing.xs)),
                                      SvgPicture.asset(
                                        "assets/icons/ic_edit_note.svg",
                                        color: EnvoyColors.accentPrimary,
                                        height: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget CoinTagListItem(
      {required String title, required Widget icon, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: icon,
                ),
                Padding(padding: EdgeInsets.all(4)),
                Text(
                  "$title",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: trailing,
          )),
        ],
      ),
    );
  }
}