// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:math';

import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/theme/envoy_colors.dart';
import 'package:envoy/ui/envoy_icons.dart';
import 'package:envoy/ui/onboard/manual/widgets/mnemonic_grid_widget.dart';
import 'package:envoy/ui/onboard/manual/widgets/wordlist.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/ui/theme/envoy_typography.dart';
import 'package:envoy/util/haptics.dart';
import 'package:flutter/material.dart';
import 'package:envoy/ui/theme/envoy_spacing.dart';

class VerifySeedPuzzleWidget extends StatefulWidget {
  final List<String> seed;
  final Function(bool verified) onVerificationFinished;

  const VerifySeedPuzzleWidget(
      {super.key, required this.seed, required this.onVerificationFinished});

  @override
  State<VerifySeedPuzzleWidget> createState() => _VerifySeedPuzzleWidgetState();
}

class _VerifySeedPuzzleWidgetState extends State<VerifySeedPuzzleWidget>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  List<List<String>> _puzzleOptions = [];
  List<String> answers = [];
  bool _finishedAnswers = false;

  List<int> _seedIndexes = [];

  int _puzzlePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (answers.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: EnvoySpacing.medium2),
          child: CustomScrollView(
            //shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                    S().manual_setup_generate_seed_verify_seed_quiz_1_4_heading,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center),
              ),
              const SliverPadding(padding: EdgeInsets.all(EnvoySpacing.small)),
              SliverToBoxAdapter(
                child: Text(
                    "${S().manual_setup_generate_seed_verify_seed_quiz_question} ${_seedIndexes[_puzzlePageIndex] + 1}?",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center),
              ),
              const SliverPadding(padding: EdgeInsets.all(EnvoySpacing.small)),
              SliverFillRemaining(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: _puzzleOptions.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: EnvoySpacing.medium1),
                            child: PuzzleWidget(
                              puzzle: e,
                              seedIndex: _seedIndexes[_puzzlePageIndex],
                              correctAnswer: answers[_puzzleOptions.indexOf(e)],
                              onCorrectAnswer: (answers) async {
                                bool isLastQuestion =
                                    (_puzzleOptions.indexOf(e) + 1) ==
                                        _puzzleOptions.length;
                                if (isLastQuestion) {
                                  setState(() {
                                    _finishedAnswers = true;
                                  });
                                  return;
                                }
                                await Future.delayed(
                                    const Duration(milliseconds: 600));
                                _pageController.animateToPage(
                                    _puzzleOptions.indexOf(e) + 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              },
                              onWrongAnswer: (answers) {
                                widget.onVerificationFinished(false);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: EnvoySpacing.small),
                        child: DotsIndicator(
                            pageController: _pageController,
                            totalPages: _puzzleOptions.length)),
                    const Padding(padding: EdgeInsets.all(EnvoySpacing.xs)),
                    !_finishedAnswers
                        ? Text(
                            S().manual_setup_generate_seed_verify_seed_again_quiz_infotext,
                            style: EnvoyTypography.button.copyWith(
                              color: EnvoyColors.textInactive,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: EnvoySpacing.xs),
                            child: OnboardingButton(
                                label: S().component_continue,
                                onTap: () {
                                  widget.onVerificationFinished(true);
                                })),
                    const Padding(padding: EdgeInsets.all(EnvoySpacing.xs)),
                  ],
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createPuzzles();
      _pageController.addListener(() {
        int page = _pageController.page?.toInt() ?? 0;
        if (_puzzlePageIndex != page) {
          setState(() {
            _puzzlePageIndex = page;
          });
        }
      });
    });
  }

  createPuzzles() {
    Random random = Random();
    List<String> filteredSeed =
        seedEn.where((element) => !widget.seed.contains(element)).toList();
    setState(() {
      Set<int> randomIndexes = {};
      while (randomIndexes.length < 4) {
        randomIndexes.add(random.nextInt(widget.seed.length));
      }
      _seedIndexes = randomIndexes.toList();
      _puzzleOptions = List.generate(4, (index) {
        List<String> options = List.generate(3,
            (index) => filteredSeed[random.nextInt(filteredSeed.length - 1)]);
        options.add(widget.seed[_seedIndexes[index]]);
        answers.add(widget.seed[_seedIndexes[index]]);
        options.shuffle();
        return options;
      });
    });
  }
}

class PuzzleWidget extends StatefulWidget {
  final List<String> puzzle;
  final String correctAnswer;
  final int seedIndex;
  final Function(String) onCorrectAnswer;
  final Function(String) onWrongAnswer;

  const PuzzleWidget(
      {super.key,
      required this.puzzle,
      required this.correctAnswer,
      required this.seedIndex,
      required this.onCorrectAnswer,
      required this.onWrongAnswer});

  @override
  State<PuzzleWidget> createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget> {
  String? chosenAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _answerField(context),
              if (chosenAnswer != null)
                _buildAnswerStatus(chosenAnswer == widget.correctAnswer),
            ],
          ),
        ),
        Flexible(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 20.0,
              ),
              itemBuilder: (context, index) {
                const TextStyle textTheme = TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      chosenAnswer = widget.puzzle[index];
                    });
                    if (chosenAnswer == widget.correctAnswer) {
                      widget.onCorrectAnswer(widget.puzzle[index]);
                      Haptics.lightImpact();
                    } else {
                      widget.onWrongAnswer(widget.puzzle[index]);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        alignment: Alignment.center,
                        constraints:
                            const BoxConstraints(maxWidth: 200, maxHeight: 40),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(widget.puzzle[index],
                            style: textTheme, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                );
              },
              itemCount: widget.puzzle.length),
        ),
      ],
    );
  }

  Widget _buildAnswerStatus(bool? correctSelection) {
    if (correctSelection == null) {
      return const SizedBox.shrink();
    }
    return correctSelection
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check,
                size: 14,
                color: EnvoyColors.accentPrimary,
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Text(
                S().manual_setup_generate_seed_verify_seed_quiz_success_correct,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: EnvoyColors.accentPrimary),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(EnvoyIcons.exclamationWarning,
                  color: EnvoyColors.accentSecondary, size: 14),
              const Padding(padding: EdgeInsets.all(4)),
              Text(
                S().manual_setup_generate_seed_verify_seed_quiz_fail_invalid,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: EnvoyColors.accentSecondary),
              )
            ],
          );
  }

  Widget _answerField(BuildContext context) {
    Color textColor = Colors.black;
    Color borderColor = Colors.transparent;
    if (chosenAnswer == null) {
      borderColor = Colors.transparent;
    } else {
      if (chosenAnswer != widget.correctAnswer) {
        borderColor = EnvoyColors.accentSecondary;
      } else {
        borderColor = EnvoyColors.textTertiary;
      }
    }

    final TextStyle textTheme = TextStyle(color: textColor, fontSize: 16);
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(maxWidth: 140, maxHeight: 38),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(" ${widget.seedIndex + 1}. ", style: textTheme),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(chosenAnswer ?? "", style: textTheme),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  child: Divider(
                    thickness: 1,
                    color: chosenAnswer == null
                        ? Colors.black54
                        : Colors.transparent,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
