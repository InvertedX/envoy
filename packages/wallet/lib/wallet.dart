// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/exceptions.dart';

// Generated
part 'wallet.g.dart';

enum Network { Mainnet, Testnet, Signet, Regtest }

@JsonSerializable()
class Transaction {
  final String memo;
  final String txId;
  final DateTime date;
  final int fee;
  final int sent;
  final int received;
  final int blockHeight;

  get isConfirmed => date.compareTo(DateTime(2008)) > 0;

  get amount => received - sent;

  Transaction(this.memo, this.txId, this.date, this.fee, this.received,
      this.sent, this.blockHeight);

  // Serialisation
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

class NativeTransactionList extends Struct {
  @Uint32()
  external int transactionsLen;
  external Pointer<NativeTransaction> transactions;
}

class NativeTransaction extends Struct {
  external Pointer<Uint8> txid;
  @Uint64()
  external int received;
  @Uint64()
  external int sent;
  @Uint64()
  external int fee;
  @Uint32()
  external int confirmationHeight;
  @Uint64()
  external int confirmationTime;
}

class NativeSeed extends Struct {
  external Pointer<Uint8> mnemonic;
  external Pointer<Uint8> xprv;
  external Pointer<Uint8> fingerprint;
}

class NativePsbt extends Struct {
  @Uint64()
  external int sent;
  @Uint64()
  external int received;
  @Uint64()
  external int fee;
  external Pointer<Uint8> base64;
  external Pointer<Uint8> txid;
  external Pointer<Uint8> rawtx;
}

class NativeServerFeatures extends Struct {
  external Pointer<Uint8> serverVersion;
  external Pointer<Uint8> protocolMin;
  external Pointer<Uint8> protocolMax;
  @Int64()
  external int pruning;
  external Pointer<Uint8> genesisHash;
}

typedef WalletInitRust = Pointer<Uint8> Function(
    Pointer<Utf8> name,
    Pointer<Utf8> externalDescriptor,
    Pointer<Utf8> internalDescriptor,
    Pointer<Utf8> dataDir,
    Uint16 network);

typedef WalletInitDart = Pointer<Uint8> Function(
    Pointer<Utf8> name,
    Pointer<Utf8> externalDescriptor,
    Pointer<Utf8> internalDescriptor,
    Pointer<Utf8> dataDir,
    int network);

typedef WalletDropRust = Pointer<Utf8> Function(Pointer<Uint8> wallet);
typedef WalletDropDart = Pointer<Utf8> Function(Pointer<Uint8> wallet);

typedef WalletGetAddressRust = Pointer<Utf8> Function(Pointer<Uint8> wallet);
typedef WalletGetAddressDart = Pointer<Utf8> Function(Pointer<Uint8> wallet);

typedef WalletSyncRust = Void Function(
    Pointer<Uint8> wallet, Pointer<Utf8> electrumAddress, Int32 torPort);
typedef WalletSyncDart = void Function(
    Pointer<Uint8> wallet, Pointer<Utf8> electrumAddress, int torPort);

typedef WalletGetBalanceRust = Uint64 Function(Pointer<Uint8> wallet);
typedef WalletGetBalanceDart = int Function(Pointer<Uint8> wallet);

typedef WalletGetFeeRateRust = Double Function(
    Pointer<Utf8> electrumAddress, Int32 torPort, Uint16 target);
typedef WalletGetFeeRateDart = double Function(
    Pointer<Utf8> electrumAddress, int torPort, int target);

typedef WalletGetServerFeaturesRust = NativeServerFeatures Function(
    Pointer<Utf8> electrumAddress, Int32 torPort);
typedef WalletGetServerFeaturesDart = NativeServerFeatures Function(
    Pointer<Utf8> electrumAddress, int torPort);

typedef WalletGetTransactionsRust = NativeTransactionList Function(
    Pointer<Uint8> wallet);
typedef WalletGetTransactionsDart = NativeTransactionList Function(
    Pointer<Uint8> wallet);

typedef WalletCreatePsbtRust = NativePsbt Function(
    Pointer<Uint8> wallet, Pointer<Utf8> sendTo, Uint64 amount, Double feeRate);
typedef WalletCreatePsbtDart = NativePsbt Function(
    Pointer<Uint8> wallet, Pointer<Utf8> sendTo, int amount, double feeRate);

typedef WalletBroadcastTxRust = Pointer<Utf8> Function(
    Pointer<Utf8> electrumAddress, Int32 torPort, Pointer<Utf8> tx);
typedef WalletBroadcastTxDart = Pointer<Utf8> Function(
    Pointer<Utf8> electrumAddress, int torPort, Pointer<Utf8> tx);

typedef WalletDecodePsbtRust = NativePsbt Function(
    Pointer<Uint8> wallet, Pointer<Utf8> psbt);
typedef WalletDecodePsbtDart = NativePsbt Function(
    Pointer<Uint8> wallet, Pointer<Utf8> psbt);

typedef WalletValidateAddressRust = Uint8 Function(
    Pointer<Uint8> wallet, Pointer<Utf8> address);
typedef WalletValidateAddressDart = int Function(
    Pointer<Uint8> wallet, Pointer<Utf8> address);

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

class Psbt {
  final int sent;
  final int received;
  final int fee;
  final String base64;
  final String txid;
  final String rawTx;

  get amount => received - sent;

  Psbt(this.sent, this.received, this.fee, this.base64, this.txid, this.rawTx);

  factory Psbt.fromNative(NativePsbt psbt) {
    return Psbt(
        psbt.sent,
        psbt.received,
        psbt.fee,
        psbt.base64.cast<Utf8>().toDartString(),
        psbt.txid.cast<Utf8>().toDartString(),
        psbt.rawtx.cast<Utf8>().toDartString());
  }
}

class ElectrumServerFeatures {
  final String serverVersion;
  final String protocolMin;
  final String protocolMax;
  final int pruning;

  final List<int> genesisHash;

  ElectrumServerFeatures(this.serverVersion, this.protocolMin, this.protocolMax,
      this.pruning, this.genesisHash);

  factory ElectrumServerFeatures.fromNative(NativeServerFeatures features) {
    List<int> genesisHash = List.from(features.genesisHash.asTypedList(32));
    //malS().free(features.genesisHash);

    return ElectrumServerFeatures(
        features.serverVersion.cast<Utf8>().toDartString(),
        features.protocolMin.cast<Utf8>().toDartString(),
        features.protocolMax.cast<Utf8>().toDartString(),
        features.pruning,
        genesisHash);
  }
}

@JsonSerializable()
class Wallet {
  static late String _libName = "wallet_ffi";
  static late DynamicLibrary _lib;

  Pointer<Uint8> _self = nullptr;
  bool _currentlySyncing = false;

  final String name;
  final String externalDescriptor;
  final String internalDescriptor;

  @JsonKey(
      defaultValue:
          Network.Mainnet) // Migration from binary main/testnet approach
  final Network network;

  List<Transaction> transactions = [];
  int balance = 0;

  // BTC per kb
  double feeRateFast = 0;
  double feeRateSlow = 0;

  // Serialisation
  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  // This needs to be a top-level static function in order to sync wallet in separate thread
  static _sync(Map args) {
    // A workaround as we are not able to pass DynamicLibraries to isolates:
    // "Calling this function multiple times with the same [path], even across
    // different isolates, only loads the library into the DartVM process once."
    DynamicLibrary lib = load(_libName);

    int walletPtr = args["wallet_pointer"];
    String electrumAddress = args["electrum_address"];
    int torPort = args["tor_port"];

    final rustFunction =
        lib.lookup<NativeFunction<WalletSyncRust>>('wallet_sync');
    final dartFunction = rustFunction.asFunction<WalletSyncDart>();

    dartFunction(
      Pointer.fromAddress(walletPtr),
      electrumAddress.toNativeUtf8(),
      torPort,
    );

    var balance = _getBalance(walletPtr);

    var feeRateFast = _getFeeRate(electrumAddress, torPort, 1);
    var feeRateSlow = _getFeeRate(electrumAddress, torPort, 24);

    var transactions = _getTransactions(walletPtr);

    return {
      "balance": balance,
      "feeRateFast": feeRateFast,
      "feeRateSlow": feeRateSlow,
      "transactions": transactions
    };
  }

  static String _getAddress(int walletAddress) {
    DynamicLibrary lib = load(_libName);

    final rustFunction =
        lib.lookup<NativeFunction<WalletGetAddressRust>>('wallet_get_address');
    final dartFunction = rustFunction.asFunction<WalletGetAddressDart>();

    return dartFunction(Pointer.fromAddress(walletAddress))
        .cast<Utf8>()
        .toDartString();
  }

  Wallet(this.name, this.network, this.externalDescriptor,
      this.internalDescriptor);

  init(String dir) {
    _lib = load(_libName);

    final rustFunction =
        _lib.lookup<NativeFunction<WalletInitRust>>('wallet_init');
    final dartFunction = rustFunction.asFunction<WalletInitDart>();

    _self = dartFunction(
        name.toNativeUtf8(),
        externalDescriptor.toNativeUtf8(),
        internalDescriptor.toNativeUtf8(),
        (dir + "/wallets/" + name).toNativeUtf8(),
        network.index);

    if (_self == nullptr) {
      throwRustException(_lib);
    }
  }

  drop() {
    final rustFunction =
        _lib.lookup<NativeFunction<WalletDropRust>>('wallet_drop');
    final dartFunction = rustFunction.asFunction<WalletDropDart>();

    dartFunction(_self);
  }

  Future<String> getAddress() async {
    return compute(_getAddress, _self.address);
  }

  // Returns true if there have been changes
  Future<bool?> sync(String electrumAddress, int torPort) async {
    if (_currentlySyncing) {
      return null;
    }

    _currentlySyncing = true;

    // Unfortunately we need to pass maps onto computes if there is more than one arg
    Map map = Map();
    map['wallet_pointer'] = _self.address;
    map['electrum_address'] = electrumAddress;
    map['tor_port'] = torPort;

    return compute(_sync, map).then((var walletState) {
      bool changed = false;

      if (balance != walletState["balance"]) {
        changed = true;
      }

      if (transactions.length != walletState["transactions"].length) {
        changed = true;
      }

      balance = walletState["balance"];
      transactions = walletState["transactions"];

      // Sort transactions by date
      transactions.sort((t1, t2) {
        // Mempool transactions go on top
        if (t1.date.isBefore(DateTime(2008)) &&
            t2.date.isBefore(DateTime(2008))) {
          return 0;
        }

        if (t2.date.isBefore(DateTime(2008))) {
          return 1;
        }

        if (t1.date.isBefore(DateTime(2008))) {
          return -1;
        }

        return t2.date.compareTo(t1.date);
      });

      // Don't update fees if they error out
      if (walletState["feeRateFast"] >= 0) {
        feeRateFast = walletState["feeRateFast"];
      }

      if (walletState["feeRateSlow"] >= 0) {
        feeRateSlow = walletState["feeRateSlow"];
      }

      _currentlySyncing = false;
      return changed;
    }).timeout(Duration(seconds: 30));
  }

  Future<Psbt> createPsbt(String sendTo, int amount, double feeRate) async {
    final rustFunction =
        _lib.lookup<NativeFunction<WalletCreatePsbtRust>>('wallet_create_psbt');
    final dartFunction = rustFunction.asFunction<WalletCreatePsbtDart>();

    return Future(() {
      NativePsbt psbt =
          dartFunction(_self, sendTo.toNativeUtf8(), amount, feeRate);
      if (psbt.base64 == nullptr) {
        throwRustException(_lib);
      }

      return Psbt.fromNative(psbt);
    });
  }

  Future<Psbt> decodePsbt(String base64Psbt) async {
    final rustFunction =
        _lib.lookup<NativeFunction<WalletDecodePsbtRust>>('wallet_decode_psbt');
    final dartFunction = rustFunction.asFunction<WalletDecodePsbtDart>();

    return Future(() {
      NativePsbt psbt = dartFunction(_self, base64Psbt.toNativeUtf8());

      if (psbt.base64 == nullptr) {
        throwRustException(_lib);
      }

      return Psbt.fromNative(psbt);
    });
  }

  static int _getBalance(int walletAddress) {
    DynamicLibrary lib = load(_libName);

    final rustFunction =
        lib.lookup<NativeFunction<WalletGetBalanceRust>>('wallet_get_balance');
    final dartFunction = rustFunction.asFunction<WalletGetBalanceDart>();

    return dartFunction(Pointer.fromAddress(walletAddress));
  }

  static double _getFeeRate(String electrumAddress, int torPort, int target) {
    DynamicLibrary lib = load(_libName);

    final rustFunction =
        lib.lookup<NativeFunction<WalletGetFeeRateRust>>('wallet_get_fee_rate');
    final dartFunction = rustFunction.asFunction<WalletGetFeeRateDart>();

    return dartFunction(electrumAddress.toNativeUtf8(), torPort, target);
  }

  static Future<ElectrumServerFeatures> getServerFeatures(
      String electrumAddress, int torPort) async {
    Map map = Map();
    map['electrum_address'] = electrumAddress;
    map['tor_port'] = torPort;

    return compute(_getServerFeatures, map).then((var features) => features,
        onError: (e) {
      throw getIsolateException(e.message);
    });
  }

  static Future<ElectrumServerFeatures> _getServerFeatures(Map args) async {
    DynamicLibrary lib = load(_libName);

    String electrumAddress = args["electrum_address"];
    int torPort = args["tor_port"];

    final rustFunction =
        lib.lookup<NativeFunction<WalletGetServerFeaturesRust>>(
            'wallet_get_server_features');
    final dartFunction = rustFunction.asFunction<WalletGetServerFeaturesDart>();

    NativeServerFeatures features =
        dartFunction(electrumAddress.toNativeUtf8(), torPort);

    if (features.serverVersion == nullptr) {
      throwRustException(lib);
    }

    return ElectrumServerFeatures.fromNative(features);
  }

  static List<Transaction> _getTransactions(int walletAddress) {
    DynamicLibrary lib = load(_libName);

    final rustFunction = lib.lookup<NativeFunction<WalletGetTransactionsRust>>(
        'wallet_get_transactions');
    final dartFunction = rustFunction.asFunction<WalletGetTransactionsDart>();

    NativeTransactionList txList =
        dartFunction(Pointer.fromAddress(walletAddress));

    List<Transaction> transactions = [];
    for (var i = 0; i < txList.transactionsLen; i++) {
      var tx = txList.transactions.elementAt(i).ref;
      transactions.add(Transaction(
          "",
          tx.txid.cast<Utf8>().toDartString(),
          DateTime.fromMillisecondsSinceEpoch(tx.confirmationTime * 1000),
          tx.fee,
          tx.received,
          tx.sent,
          tx.confirmationHeight));
    }

    return transactions;
  }

  Future<String> broadcastTx(
      String electrumAddress, int torPort, String tx) async {
    final rustFunction = _lib
        .lookup<NativeFunction<WalletBroadcastTxRust>>('wallet_broadcast_tx');
    final dartFunction = rustFunction.asFunction<WalletBroadcastTxDart>();

    return Future(() {
      var txid = dartFunction(
              electrumAddress.toNativeUtf8(), torPort, tx.toNativeUtf8())
          .cast<Utf8>()
          .toDartString();

      if (txid.isEmpty) {
        throwRustException(_lib);
      }

      return txid;
    });
  }

  bool validateAddress(String address) {
    final rustFunction = _lib.lookup<NativeFunction<WalletValidateAddressRust>>(
        'wallet_validate_address');
    final dartFunction = rustFunction.asFunction<WalletValidateAddressDart>();

    return dartFunction(
                Pointer.fromAddress(_self.address), address.toNativeUtf8()) ==
            1
        ? true
        : false;
  }
}
