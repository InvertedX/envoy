// SPDX-FileCopyrightText: 2023 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/business/coin_tag.dart';
import 'package:envoy/business/coins.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/envoy_button.dart';
import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/home/cards/accounts/detail/coins/coins_state.dart';
import 'package:envoy/ui/state/accounts_state.dart';
import 'package:envoy/ui/storage/coins_repository.dart';
import 'package:envoy/ui/theme/envoy_spacing.dart';
import 'package:envoy/util/haptics.dart';
import 'package:envoy/util/list_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCoinTag extends StatefulWidget {
  final String accountId;
  final Function onTagUpdate;

  const CreateCoinTag(
      {super.key, required this.onTagUpdate, required this.accountId});

  @override
  State<CreateCoinTag> createState() => _CreateCoinTagState();
}

List<String> tagSuggestions = [
  // TODO: FIGMA
  "Expenses",
  "Business",
  "Fuel",
  "Conferences",
  "Savings",
];

class _CreateCoinTagState extends State<CreateCoinTag> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: (MediaQuery.of(context).size.width * 0.7).clamp(300, 540),
          height: (MediaQuery.of(context).size.height * 0.5).clamp(300, 540),
          padding: EdgeInsets.all(EnvoySpacing.small),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Align(
                alignment: Alignment(1.00, -1.02),
                child: IconButton(
                  icon: Icon(Icons.close),
                  padding: EdgeInsets.all(12),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
                  Image.asset(
                    "assets/exclamation_icon.png",
                    height: 68,
                    width: 68,
                  ),
                  Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
                  Text(
                    "Create a tag", //TODO: FIGMA
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
                  _tagWidget(context),
                ],
              ),
            ],
          )),
    );
  }

  TextEditingController _tagController = TextEditingController();
  String value = '';

  _tagWidget(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final tags = ref.watch(coinsTagProvider(widget.accountId)).toList()
          ..sort((a, b) => b.coins.length.compareTo(a.coins.length))
          ..removeWhere((element) => element.untagged)
          ..take(5);

        List<String> suggestions =
            tags.isEmpty ? tagSuggestions : tags.map((e) => e.name).toList();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: EnvoySpacing.medium2),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.fade,
                        fontWeight: FontWeight.w500),
                    onChanged: (value) {
                      setState(() {
                        value = value;
                      });
                    },
                    controller: _tagController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      // Disable the borders
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                    )),
              ),
              Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
              tags.length != 0
                  ? Text(S().create_second_tag_modal_2_2_mostUsed)
                  : Text(S().create_first_tag_modal_2_2_suggest),
              Container(
                constraints: BoxConstraints(maxHeight: 100),
                child: Scrollbar(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Wrap(
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 12,
                      children: [
                        ...suggestions.where((element) {
                          //Show only the tags that match the search, search will only be active
                          // if there are existing tags, search wont be active for suggestions
                          if (tags.isNotEmpty &&
                              _tagController.text.isNotEmpty) {
                            return element
                                .toLowerCase()
                                .startsWith(_tagController.text.toLowerCase());
                          }
                          return true;
                        }).map((e) => InkWell(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      child: Text("${e}")),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: EnvoyColors.teal, width: 1),
                                  ),
                                  height: 28),
                              onTap: () {
                                _tagController.text = e;
                                setState(() {});
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(EnvoySpacing.small)),
              EnvoyButton(
                S().create_first_tag_modal_2_2_cta,
                enabled: _tagController.text.isNotEmpty,
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _tagController.text.isNotEmpty
                          ? Colors.white
                          : EnvoyColors.grey,
                    ),
                type: _tagController.text.isNotEmpty
                    ? EnvoyButtonTypes.primaryModal
                    : EnvoyButtonTypes.tertiary,
                onTap: () => tagSelected(context, ref),
              ),
              Padding(padding: EdgeInsets.all(EnvoySpacing.xs)),
            ],
          ),
        );
      },
    );
  }

  Future tagSelected(BuildContext context, WidgetRef ref) async {
    //get coins from the repository
    try {
      List<Coin> coins = [];
      ref
          .read(coinsTagProvider(widget.accountId))
          .map((e) => e.coins)
          .forEach((element) {
        coins.addAll(element);
      });
      final selections = ref.read(coinSelectionStateProvider);
      //pick all the coins that are selected in current tag
      final selectedCoins =
          coins.where((element) => selections.contains(element.id)).toList();

      //user selected from suggestions
      CoinTag? targetTag = ref
          .read(coinsTagProvider(widget.accountId))
          .firstWhereOrNull((element) =>
              element.name.toLowerCase() == _tagController.text.toLowerCase());

      final tags = ref.read(coinsTagProvider(widget.accountId));

      if (targetTag?.coins_id.containsAll(selections) == true) {
        widget.onTagUpdate();
        return;
      }

      //if the tag is not found, create a new tag
      if (targetTag == null) {
        targetTag = CoinTag(
          id: CoinTag.generateNewId(),
          name: _tagController.text,
          account: widget.accountId,
          untagged: false,
        );
        await CoinRepository().addCoinTag(targetTag);
      }

      targetTag.addCoins(selectedCoins);

      await CoinRepository().updateCoinTag(targetTag);

      Set<CoinTag> coinsRemovedTags = Set();

      tags.forEach((tag) {
        /// no need to remove coins to the tag that we just added
        if (tag.id != targetTag?.id) {
          selectedCoins.forEach((element) {
            if (tag.coins_id.contains(element.id)) {
              tag.removeCoin(element);
              coinsRemovedTags.add(tag);
            }
          });
        }
      });

      coinsRemovedTags.forEach((element) async {
        if (!element.untagged) {
          await Future.delayed(Duration(milliseconds: 10));
          await CoinRepository().updateCoinTag(element);
        }
      });
      final _ = ref.refresh(accountsProvider);
      //Wait for the refresh to propagate
      await Future.delayed(Duration(milliseconds: 180));

      //Reset the selection
      Haptics.lightImpact();
    } catch (e) {
      print(e);
    }

    widget.onTagUpdate();
  }
}

// _emptyTag(BuildContext context, CoinTag tag) {
//   showEnvoyDialog(
//     context: context,
//     useRootNavigator: true,
//     borderRadius: 20,
//     dialog: Builder(
//       builder: (context) {
//         return DeleteTagDialog(
//             dialogSubheading: S().empty_tag_modal_subheading(tag.name),
//             primaryButtonText: S().empty_tag_modal_cta1,
//             secondaryButtonText: S().empty_tag_modal_cta2,
//             onPrimaryButtonTap: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             onSecondaryButtonTap: () async {
//               await CoinRepository().deleteTag(tag);
//               Navigator.pop(context);
//               Navigator.pop(context);
//             });
//       },
//     ),
//   );
// }
