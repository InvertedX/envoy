// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';
import 'package:tor/tor.dart';

DynamicLibrary load(name) {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$name.so');
  } else if (Platform.isLinux) {
    return DynamicLibrary.open('target/debug/lib$name.so');
  } else if (Platform.isIOS || Platform.isMacOS) {
    // iOS and MacOS are statically linked, so it is the same as the current process
    return DynamicLibrary.process();
  } else {
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  }
}

class NotSupportedPlatform implements Exception {
  NotSupportedPlatform(String s);
}

class Backup {
  static _goAhead(Tor tor) async {
    if (tor.enabled) {
      // Go right ahead if Tor is disabled
      await Future.doWhile(() => Future.delayed(Duration(seconds: 1)).then((_) {
            // We are waiting and making absolutely no request unless:
            // Tor is disabled
            if (!tor.enabled) {
              return false;
            }

            // ...or Tor circuit is established
            if (tor.circuitEstablished) {
              return false;
            }

            // This way we avoid making clearnet req's while Tor is initialising
            return true;
          }));
    }
  }

  static Future<bool> perform(Map<String, String> backupData, String seedWords,
      String serverUrl, Tor tor,
      {required String path, bool cloud = true}) async {
    if (backupData.isEmpty) {
      return true;
    }

    Pointer<BackupPayload> payload = getBackupPayloadPointer(backupData);

    var lib = NativeLibrary(load("backup_ffi"));

    // Always do offline backup
    lib.backup_perform_offline(
      payload.ref,
      seedWords.toNativeUtf8().cast<Char>(),
      path.toNativeUtf8().cast(),
    );

    if (!cloud) {
      return true;
    } else {
      await _goAhead(tor);

      int torPort = tor.port;
      return Isolate.run(() async {
        var lib = NativeLibrary(load("backup_ffi"));
        Pointer<BackupPayload> payload = getBackupPayloadPointer(backupData);

        return lib.backup_perform(
          payload.ref,
          seedWords.toNativeUtf8().cast<Char>(),
          serverUrl.toNativeUtf8().cast<Char>(),
          torPort,
        );
      });
    }
  }

  static Pointer<BackupPayload> getBackupPayloadPointer(
      Map<String, String> backupData) {
    Pointer<Pointer<Char>> nativeData = nullptr;

    nativeData = calloc(backupData.length * 2);

    int i = 0;
    for (var key in backupData.keys) {
      nativeData[i] = key.toNativeUtf8().cast<Char>();
      nativeData[i + 1] = backupData[key]!.toNativeUtf8().cast<Char>();
      i += 2;
    }

    final Pointer<BackupPayload> payload = calloc<BackupPayload>();
    payload.ref.keys_nr = backupData.length;
    payload.ref.data = nativeData;
    return payload;
  }

  static Map<String, String>? restoreOffline(
      String seedWords, String filePath) {
    var lib = NativeLibrary(load("backup_ffi"));
    var payload = lib.backup_get_offline(seedWords.toNativeUtf8().cast<Char>(),
        filePath.toNativeUtf8().cast<Char>());

    if (payload.keys_nr == 0) {
      throwRustException(lib);
    }

    return _extractDataFromPayload(payload);
  }

  static Map<String, String> _extractDataFromPayload(BackupPayload payload) {
    var data = payload.data;

    Map<String, String> backupData = {};
    for (var i = 0; i < payload.keys_nr * 2; i += 2) {
      var key = data.elementAt(i).value.cast<Utf8>().toDartString();
      var value = data.elementAt(i + 1).value.cast<Utf8>().toDartString();
      backupData[key] = value;
    }

    return backupData;
  }

  static Future<Map<String, String>?> restore(
      String seedWords, String serverUrl, Tor tor) async {
    await _goAhead(tor);

    int torPort = tor.port;
    return Isolate.run(() async {
      var lib = NativeLibrary(load("backup_ffi"));
      var payload = lib.backup_get(seedWords.toNativeUtf8().cast<Char>(),
          serverUrl.toNativeUtf8().cast<Char>(), torPort);

      if (payload.keys_nr == 0) {
        throwRustException(lib);
      }

      return _extractDataFromPayload(payload);
    });
  }

  static throwRustException(NativeLibrary lib) {
    String rustError =
        lib.backup_last_error_message().cast<Utf8>().toDartString();
    throw Exception(rustError);
  }
}
