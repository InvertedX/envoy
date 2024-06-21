// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

library envoy.server;

import 'dart:convert';
import 'package:envoy/business/settings.dart';
import 'package:http_tor/http_tor.dart';
import 'package:tor/tor.dart';
import 'package:envoy/business/scheduler.dart';

class Server {
  HttpTor? http;
  final String _serverAddress = Settings().envoyServerAddress;

  Server({this.http}) {
    http ??= HttpTor(Tor.instance, EnvoyScheduler().parallel);
  }

  Future<FirmwareUpdate> fetchFirmwareUpdateInfo(int deviceId) async {
    final response =
        await http!.get('$_serverAddress/firmware/device?id=$deviceId');

    if (response.statusCode == 202) {
      var fw = FirmwareUpdate.fromJson(jsonDecode(response.body));
      return fw;
    } else {
      throw Exception('Failed to find firmware');
    }
  }

  Future<ApiKeys> fetchApiKeys() async {
    final response = await http!.get('$_serverAddress/keys');

    if (response.statusCode == 202) {
      return ApiKeys.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch API keys');
    }
  }
}

class ApiKeys {
  final String mapsKey;
  final String rampKey;

  ApiKeys({
    required this.mapsKey,
    required this.rampKey,
  });

  factory ApiKeys.fromJson(Map<String, dynamic> json) {
    final keys = json['keys'];
    return ApiKeys(mapsKey: keys['maps_api'], rampKey: keys['ramp_api']);
  }

  Map<String, dynamic> toJson() {
    return {
      'keys': {
        'maps_api': mapsKey,
        'ramp_api': rampKey,
      }
    };
  }
}

class FirmwareUpdate {
  final String version;
  final String url;
  final String sha256;
  final String reproducibleHash;
  final String md5;
  final String changeLog;
  final DateTime releaseDate;
  final int deviceId;

  FirmwareUpdate(
      {required this.version,
      required this.url,
      required this.sha256,
      required this.reproducibleHash,
      required this.md5,
      required this.changeLog,
      required this.releaseDate,
      required this.deviceId});

  factory FirmwareUpdate.fromJson(Map<String, dynamic> json) {
    final fw = json['firmware'];
    return FirmwareUpdate(
        deviceId: fw['device_id'],
        sha256: fw['sha256'],
        md5: fw['md5'],
        url: fw['url'],
        changeLog: fw['changelog'],
        reproducibleHash: fw['reproducible_hash'],
        releaseDate: DateTime.fromMillisecondsSinceEpoch(
            (fw['release_date']['secs_since_epoch']) * 1000),
        version: fw['version']);
  }
}
