// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  ffi.Pointer<ffi.Char> wallet_last_error_message() {
    return _wallet_last_error_message();
  }

  late final _wallet_last_error_messagePtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>(
          'wallet_last_error_message');
  late final _wallet_last_error_message = _wallet_last_error_messagePtr
      .asFunction<ffi.Pointer<ffi.Char> Function()>();

  void wallet_drop(
    int arg0,
  ) {
    return _wallet_drop(
      arg0,
    );
  }

  late final _wallet_dropPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int)>>('wallet_drop');
  late final _wallet_drop = _wallet_dropPtr.asFunction<void Function(int)>();

  Wallet wallet_derive(
    ffi.Pointer<ffi.Char> seed_words,
    ffi.Pointer<ffi.Char> passphrase,
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> data_dir,
    int network,
    bool private_,
  ) {
    return _wallet_derive(
      seed_words,
      passphrase,
      path,
      data_dir,
      network,
      private_,
    );
  }

  late final _wallet_derivePtr = _lookup<
      ffi.NativeFunction<
          Wallet Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Int32,
              ffi.Bool)>>('wallet_derive');
  late final _wallet_derive = _wallet_derivePtr.asFunction<
      Wallet Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int, bool)>();

  ffi.Pointer<ffi.Char> wallet_get_address(
    int arg0,
  ) {
    return _wallet_get_address(
      arg0,
    );
  }

  late final _wallet_get_addressPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function(ffi.Int)>>(
          'wallet_get_address');
  late final _wallet_get_address =
      _wallet_get_addressPtr.asFunction<ffi.Pointer<ffi.Char> Function(int)>();

  bool wallet_sync(
    int arg0,
  ) {
    return _wallet_sync(
      arg0,
    );
  }

  late final _wallet_syncPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Int)>>('wallet_sync');
  late final _wallet_sync = _wallet_syncPtr.asFunction<bool Function(int)>();

  int wallet_get_balance(
    int arg0,
  ) {
    return _wallet_get_balance(
      arg0,
    );
  }

  late final _wallet_get_balancePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int)>>(
          'wallet_get_balance');
  late final _wallet_get_balance =
      _wallet_get_balancePtr.asFunction<int Function(int)>();

  double wallet_get_fee_rate(
    ffi.Pointer<ffi.Char> electrum_address,
    int tor_port,
    int target,
  ) {
    return _wallet_get_fee_rate(
      electrum_address,
      tor_port,
      target,
    );
  }

  late final _wallet_get_fee_ratePtr = _lookup<
      ffi.NativeFunction<
          ffi.Double Function(
              ffi.Pointer<ffi.Char>, ffi.Int, ffi.Int)>>('wallet_get_fee_rate');
  late final _wallet_get_fee_rate = _wallet_get_fee_ratePtr
      .asFunction<double Function(ffi.Pointer<ffi.Char>, int, int)>();

  ServerFeatures wallet_get_server_features(
    ffi.Pointer<ffi.Char> electrum_address,
    int tor_port,
  ) {
    return _wallet_get_server_features(
      electrum_address,
      tor_port,
    );
  }

  late final _wallet_get_server_featuresPtr = _lookup<
      ffi.NativeFunction<
          ServerFeatures Function(
              ffi.Pointer<ffi.Char>, ffi.Int)>>('wallet_get_server_features');
  late final _wallet_get_server_features = _wallet_get_server_featuresPtr
      .asFunction<ServerFeatures Function(ffi.Pointer<ffi.Char>, int)>();

  TransactionList wallet_get_transactions(
    int arg0,
  ) {
    return _wallet_get_transactions(
      arg0,
    );
  }

  late final _wallet_get_transactionsPtr =
      _lookup<ffi.NativeFunction<TransactionList Function(ffi.Int)>>(
          'wallet_get_transactions');
  late final _wallet_get_transactions =
      _wallet_get_transactionsPtr.asFunction<TransactionList Function(int)>();

  Psbt wallet_create_psbt(
    int arg0,
  ) {
    return _wallet_create_psbt(
      arg0,
    );
  }

  late final _wallet_create_psbtPtr =
      _lookup<ffi.NativeFunction<Psbt Function(ffi.Int)>>('wallet_create_psbt');
  late final _wallet_create_psbt =
      _wallet_create_psbtPtr.asFunction<Psbt Function(int)>();

  Psbt wallet_decode_psbt(
    int arg0,
  ) {
    return _wallet_decode_psbt(
      arg0,
    );
  }

  late final _wallet_decode_psbtPtr =
      _lookup<ffi.NativeFunction<Psbt Function(ffi.Int)>>('wallet_decode_psbt');
  late final _wallet_decode_psbt =
      _wallet_decode_psbtPtr.asFunction<Psbt Function(int)>();

  ffi.Pointer<ffi.Char> wallet_broadcast_tx(
    ffi.Pointer<ffi.Char> electrum_address,
    int tor_port,
    ffi.Pointer<ffi.Char> tx,
  ) {
    return _wallet_broadcast_tx(
      electrum_address,
      tor_port,
      tx,
    );
  }

  late final _wallet_broadcast_txPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>, ffi.Int,
              ffi.Pointer<ffi.Char>)>>('wallet_broadcast_tx');
  late final _wallet_broadcast_tx = _wallet_broadcast_txPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(
          ffi.Pointer<ffi.Char>, int, ffi.Pointer<ffi.Char>)>();

  bool wallet_validate_address(
    int arg0,
  ) {
    return _wallet_validate_address(
      arg0,
    );
  }

  late final _wallet_validate_addressPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Int)>>(
          'wallet_validate_address');
  late final _wallet_validate_address =
      _wallet_validate_addressPtr.asFunction<bool Function(int)>();

  Psbt wallet_sign_offline(
    ffi.Pointer<ffi.Char> psbt,
    ffi.Pointer<ffi.Char> external_descriptor,
    ffi.Pointer<ffi.Char> internal_descriptor,
    int network,
  ) {
    return _wallet_sign_offline(
      psbt,
      external_descriptor,
      internal_descriptor,
      network,
    );
  }

  late final _wallet_sign_offlinePtr = _lookup<
      ffi.NativeFunction<
          Psbt Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>, ffi.Int32)>>('wallet_sign_offline');
  late final _wallet_sign_offline = _wallet_sign_offlinePtr.asFunction<
      Psbt Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, int)>();

  Psbt wallet_sign_psbt(
    int arg0,
  ) {
    return _wallet_sign_psbt(
      arg0,
    );
  }

  late final _wallet_sign_psbtPtr =
      _lookup<ffi.NativeFunction<Psbt Function(ffi.Int)>>('wallet_sign_psbt');
  late final _wallet_sign_psbt =
      _wallet_sign_psbtPtr.asFunction<Psbt Function(int)>();

  Seed wallet_generate_seed(
    int network,
  ) {
    return _wallet_generate_seed(
      network,
    );
  }

  late final _wallet_generate_seedPtr =
      _lookup<ffi.NativeFunction<Seed Function(ffi.Int32)>>(
          'wallet_generate_seed');
  late final _wallet_generate_seed =
      _wallet_generate_seedPtr.asFunction<Seed Function(int)>();

  ffi.Pointer<ffi.Char> wallet_get_xpub_desc_key(
    ffi.Pointer<ffi.Char> xprv,
    ffi.Pointer<ffi.Char> path,
  ) {
    return _wallet_get_xpub_desc_key(
      xprv,
      path,
    );
  }

  late final _wallet_get_xpub_desc_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>)>>('wallet_get_xpub_desc_key');
  late final _wallet_get_xpub_desc_key =
      _wallet_get_xpub_desc_keyPtr.asFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>)>();

  ffi.Pointer<ffi.Char> wallet_generate_xkey_with_entropy(
    ffi.Pointer<ffi.Int> entropy,
  ) {
    return _wallet_generate_xkey_with_entropy(
      entropy,
    );
  }

  late final _wallet_generate_xkey_with_entropyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ffi.Int>)>>('wallet_generate_xkey_with_entropy');
  late final _wallet_generate_xkey_with_entropy =
      _wallet_generate_xkey_with_entropyPtr
          .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Int>)>();

  Seed wallet_get_seed_from_entropy(
    int network,
    ffi.Pointer<ffi.Int> entropy,
  ) {
    return _wallet_get_seed_from_entropy(
      network,
      entropy,
    );
  }

  late final _wallet_get_seed_from_entropyPtr = _lookup<
          ffi.NativeFunction<Seed Function(ffi.Int32, ffi.Pointer<ffi.Int>)>>(
      'wallet_get_seed_from_entropy');
  late final _wallet_get_seed_from_entropy = _wallet_get_seed_from_entropyPtr
      .asFunction<Seed Function(int, ffi.Pointer<ffi.Int>)>();

  void wallet_hello() {
    return _wallet_hello();
  }

  late final _wallet_helloPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('wallet_hello');
  late final _wallet_hello = _wallet_helloPtr.asFunction<void Function()>();
}

abstract class NetworkType {
  static const int Mainnet = 0;
  static const int Testnet = 1;
  static const int Signet = 2;
  static const int Regtest = 3;
}

class Wallet extends ffi.Struct {
  external ffi.Pointer<ffi.Char> name;

  @ffi.Int32()
  external int network;

  external ffi.Pointer<ffi.Char> external_pub_descriptor;

  external ffi.Pointer<ffi.Char> internal_pub_descriptor;

  external ffi.Pointer<ffi.Char> external_prv_descriptor;

  external ffi.Pointer<ffi.Char> internal_prv_descriptor;

  external ffi.Pointer<ffi.Int> bkd_wallet_ptr;
}

class ServerFeatures extends ffi.Struct {
  external ffi.Pointer<ffi.Char> server_version;

  external ffi.Pointer<ffi.Char> protocol_min;

  external ffi.Pointer<ffi.Char> protocol_max;

  @ffi.Int()
  external int pruning;

  external ffi.Pointer<ffi.Int> genesis_hash;
}

class Transaction extends ffi.Struct {
  external ffi.Pointer<ffi.Char> txid;

  @ffi.Int()
  external int received;

  @ffi.Int()
  external int sent;

  @ffi.Int()
  external int fee;

  @ffi.Int()
  external int confirmation_height;

  @ffi.Int()
  external int confirmation_time;
}

class TransactionList extends ffi.Struct {
  @ffi.Int()
  external int transactions_len;

  external ffi.Pointer<Transaction> transactions;
}

class Psbt extends ffi.Struct {
  @ffi.Int()
  external int sent;

  @ffi.Int()
  external int received;

  @ffi.Int()
  external int fee;

  external ffi.Pointer<ffi.Char> base64;

  external ffi.Pointer<ffi.Char> txid;

  external ffi.Pointer<ffi.Char> raw_tx;
}

class Seed extends ffi.Struct {
  external ffi.Pointer<ffi.Char> mnemonic;

  external ffi.Pointer<ffi.Char> xprv;

  external ffi.Pointer<ffi.Char> fingerprint;
}
