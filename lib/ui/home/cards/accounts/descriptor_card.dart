// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/business/account.dart';
import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/home/cards/accounts/qr_tab.dart';
import 'package:envoy/ui/home/cards/envoy_text_button.dart';
import 'package:flutter/material.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:envoy/ui/home/cards/navigation_card.dart';

//ignore: must_be_immutable
class DescriptorCard extends StatelessWidget with NavigationCard {
  final Account account;

  DescriptorCard(this.account, this.navigator) : super(key: UniqueKey()) {}
  @override
  IconData? rightFunctionIcon = null;

  @override
  bool modal = true;

  @override
  CardNavigator? navigator;

  @override
  Function()? onPop;

  @override
  Widget? optionsWidget = null;

  @override
  Function()? rightFunction;

  @override
  String? title = S().manage_account_address_heading.toUpperCase();

  @override
  Widget build(BuildContext context) {
    String descriptor = account.descriptor;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: QrTab(
                title: account.name,
                subtitle: S().envoy_descriptor_explainer,
                account: account,
                qr: QrImage(
                  data: descriptor,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0, bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: descriptor));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(S().envoy_descriptor_copied_clipboard),
                      ));
                    },
                    icon: Icon(
                      Icons.copy,
                      size: 20,
                      color: EnvoyColors.darkTeal,
                    )),
                EnvoyTextButton(
                  onTap: () {
                    navigator!.pop();
                  },
                  label: S().component_ok,
                ),
                IconButton(
                    onPressed: () {
                      Share.share(descriptor);
                    },
                    icon: Icon(
                      Icons.share,
                      size: 20,
                      color: EnvoyColors.darkTeal,
                    )),
              ],
            ),
          ),
        ]);
  }
}
