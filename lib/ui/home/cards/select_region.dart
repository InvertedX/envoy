// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:convert';
import 'dart:io';
import 'package:envoy/business/map_data.dart';
import 'package:envoy/ui/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/routes/accounts_router.dart';
import 'package:envoy/ui/theme/envoy_colors.dart';
import 'package:envoy/ui/theme/envoy_spacing.dart';
import 'package:envoy/ui/theme/envoy_typography.dart';
import 'package:envoy/ui/components/select_dropdown.dart';
import 'package:envoy/util/envoy_storage.dart';

GlobalKey<EnvoyDropdownState> dropdownDivisionKey =
    GlobalKey<EnvoyDropdownState>();

class SelectRegion extends StatefulWidget {
  const SelectRegion({super.key});

  @override
  State<SelectRegion> createState() => _SelectRegionState();
}

class _SelectRegionState extends State<SelectRegion> {
  Country? selectedCountry;
  List<Country> countries = [];
  bool _dataLoaded = false;
  int _initialCountryIndex = 0;
  bool _divisionSelected = false;
  String? selectedRegion;
  int _initialRegionIndex = 0;

  @override
  void initState() {
    super.initState();
    readJson().then((_) async {
      var region = await EnvoyStorage().getCountry();
      if (region != null) {
        selectedCountry = getCountryByCode(region.code);
        selectedRegion = region.division;
        _initialRegionIndex =
            getDivisionIndex(selectedCountry!.divisions, selectedRegion!);
        dropdownDivisionKey.currentState?.setSelectedIndex(_initialRegionIndex);
      }

      setState(() {
        _dataLoaded = true;
      });
    });
  }

  void _updateState(Country newCountry) {
    setState(() {
      selectedCountry = newCountry;
      _divisionSelected = false;
    });
    dropdownDivisionKey.currentState?.setSelectedIndex(0);
  }

  int getDivisionIndex(List<String> divisions, String divisionName) {
    try {
      return divisions.indexOf(divisionName);
    } catch (e) {
      return 0;
    }
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/iso-3166-2.json');
    Map<String, dynamic> countryData = jsonDecode(response);

    countryData.forEach((countryCode, countryInfo) {
      String countryName = countryInfo['name'];
      List<String> divisions = [];
      countryInfo['divisions'].forEach((code, divisionName) {
        divisions.add(divisionName);
      });

      countries.add(Country(countryCode, countryName, divisions));
    });
    setState(() {
      selectedCountry = getCountryByCode(Platform.localeName);
      _dataLoaded = true;
    });
  }

  Country getCountryByName(String countryName) {
    Country? foundCountry = countries.firstWhere(
      (country) => country.name == countryName,
      orElse: () => Country('', '', []),
    );
    return foundCountry;
  }

  Country getCountryByCode(String countryCode) {
    countryCode = countryCode.split('_').last;

    int foundIndex = countries.indexWhere(
      (country) => country.code == countryCode,
    );
    // 223 is the index of USA, set that if the country cannot be found from the locale
    foundIndex = foundIndex != -1 ? foundIndex : 223;
    Country foundCountry = countries[foundIndex];
    setState(() {
      _initialCountryIndex = foundIndex;
    });
    return foundCountry;
  }

  @override
  Widget build(BuildContext context) {
    return _dataLoaded
        ? buildWidget()
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildWidget() {
    List<EnvoyDropdownOption> dropdownCountryOptions =
        countries.map((country) => EnvoyDropdownOption(country.name)).toList();
    List<EnvoyDropdownOption> divisionDropdownOptions = [];
    divisionDropdownOptions
        .add(EnvoyDropdownOption('Select State')); // TODO:Figma
    divisionDropdownOptions.addAll(selectedCountry!.divisions
        .map((division) => EnvoyDropdownOption(division)));

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: EnvoySpacing.medium1, horizontal: EnvoySpacing.medium2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    S().buy_bitcoin_defineLocation_heading,
                    style: EnvoyTypography.subheading,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: EnvoySpacing.medium2,
                  ),
                  Text(
                    S().buy_bitcoin_defineLocation_subheading,
                    style: EnvoyTypography.body
                        .copyWith(color: EnvoyColors.textTertiary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: EnvoySpacing.medium2,
                  ),
                  EnvoyDropdown(
                    initialIndex: _initialCountryIndex,
                    options: [
                      ...dropdownCountryOptions,
                    ],
                    onOptionChanged: (selectedOption) {
                      _updateState(getCountryByName(selectedOption!.label));
                    },
                  ),
                  const SizedBox(
                    height: EnvoySpacing.medium2,
                  ),
                  EnvoyDropdown(
                    key: dropdownDivisionKey,
                    initialIndex:
                        selectedRegion != null ? _initialRegionIndex + 1 : 0,
                    options: [
                      ...divisionDropdownOptions,
                    ],
                    onOptionChanged: (selectedOption) {
                      setState(() {
                        selectedRegion = selectedOption!.label;
                        _divisionSelected =
                            selectedOption.label != "Select State"; //TODO:Figma
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: EnvoySpacing.large1),
            child: EnvoyButton(
                label: S().component_continue,
                type: ButtonType.primary,
                state: _divisionSelected
                    ? ButtonState.defaultState
                    : ButtonState.disabled,
                onTap: () async {
                  await EnvoyStorage().updateCountry(
                    selectedCountry!.code,
                    selectedCountry!.name,
                    selectedRegion!,
                  );
                  MapData().updateHomeLocation();

                  if (mounted) {
                    context.go(ROUTE_BUY_BITCOIN);
                  }
                }),
          )
        ],
      ),
    );
  }
}

class Country {
  final String code;
  final String name;
  final List<String> divisions;

  Country(this.code, this.name, this.divisions);
}
