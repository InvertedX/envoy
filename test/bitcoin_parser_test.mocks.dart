// Mocks generated by Mockito 5.4.2 from annotations
// in envoy/test/bitcoin_parser_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:wallet/wallet.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakePsbt_0 extends _i1.SmartFake implements _i2.Psbt {
  _FakePsbt_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Wallet].
///
/// See the documentation for Mockito's code generation for more information.
class MockWallet extends _i1.Mock implements _i2.Wallet {
  MockWallet() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: '',
      ) as String);
  @override
  set externalDescriptor(String? _externalDescriptor) => super.noSuchMethod(
        Invocation.setter(
          #externalDescriptor,
          _externalDescriptor,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set internalDescriptor(String? _internalDescriptor) => super.noSuchMethod(
        Invocation.setter(
          #internalDescriptor,
          _internalDescriptor,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set publicExternalDescriptor(String? _publicExternalDescriptor) =>
      super.noSuchMethod(
        Invocation.setter(
          #publicExternalDescriptor,
          _publicExternalDescriptor,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set publicInternalDescriptor(String? _publicInternalDescriptor) =>
      super.noSuchMethod(
        Invocation.setter(
          #publicInternalDescriptor,
          _publicInternalDescriptor,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i2.Network get network => (super.noSuchMethod(
        Invocation.getter(#network),
        returnValue: _i2.Network.Mainnet,
      ) as _i2.Network);
  @override
  bool get hot => (super.noSuchMethod(
        Invocation.getter(#hot),
        returnValue: false,
      ) as bool);
  @override
  bool get hasPassphrase => (super.noSuchMethod(
        Invocation.getter(#hasPassphrase),
        returnValue: false,
      ) as bool);
  @override
  List<_i2.Transaction> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue: <_i2.Transaction>[],
      ) as List<_i2.Transaction>);
  @override
  set transactions(List<_i2.Transaction>? _transactions) => super.noSuchMethod(
        Invocation.setter(
          #transactions,
          _transactions,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<_i2.Utxo> get utxos => (super.noSuchMethod(
        Invocation.getter(#utxos),
        returnValue: <_i2.Utxo>[],
      ) as List<_i2.Utxo>);
  @override
  set utxos(List<_i2.Utxo>? _utxos) => super.noSuchMethod(
        Invocation.setter(
          #utxos,
          _utxos,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: 0,
      ) as int);
  @override
  set balance(int? _balance) => super.noSuchMethod(
        Invocation.setter(
          #balance,
          _balance,
        ),
        returnValueForMissingStub: null,
      );
  @override
  double get feeRateFast => (super.noSuchMethod(
        Invocation.getter(#feeRateFast),
        returnValue: 0.0,
      ) as double);
  @override
  set feeRateFast(double? _feeRateFast) => super.noSuchMethod(
        Invocation.setter(
          #feeRateFast,
          _feeRateFast,
        ),
        returnValueForMissingStub: null,
      );
  @override
  double get feeRateSlow => (super.noSuchMethod(
        Invocation.getter(#feeRateSlow),
        returnValue: 0.0,
      ) as double);
  @override
  set feeRateSlow(double? _feeRateSlow) => super.noSuchMethod(
        Invocation.setter(
          #feeRateSlow,
          _feeRateSlow,
        ),
        returnValueForMissingStub: null,
      );
  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  dynamic init(String? walletsDirectory) =>
      super.noSuchMethod(Invocation.method(
        #init,
        [walletsDirectory],
      ));
  @override
  _i3.Future<String> getAddress() => (super.noSuchMethod(
        Invocation.method(
          #getAddress,
          [],
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as _i3.Future<String>);
  @override
  _i3.Future<String> getChangeAddress() => (super.noSuchMethod(
        Invocation.method(
          #getChangeAddress,
          [],
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as _i3.Future<String>);
  @override
  _i3.Future<bool?> sync(
    String? electrumAddress,
    int? torPort,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sync,
          [
            electrumAddress,
            torPort,
          ],
        ),
        returnValue: _i3.Future<bool?>.value(),
      ) as _i3.Future<bool?>);
  @override
  _i3.Future<int> getMaxFeeRate(
    String? sendTo,
    int? amount, {
    List<_i2.Utxo>? utxos,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMaxFeeRate,
          [
            sendTo,
            amount,
          ],
          {#utxos: utxos},
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i3.Future<_i2.Psbt> createPsbt(
    String? sendTo,
    int? amount,
    double? feeRate, {
    List<_i2.Utxo>? utxos,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createPsbt,
          [
            sendTo,
            amount,
            feeRate,
          ],
          {#utxos: utxos},
        ),
        returnValue: _i3.Future<_i2.Psbt>.value(_FakePsbt_0(
          this,
          Invocation.method(
            #createPsbt,
            [
              sendTo,
              amount,
              feeRate,
            ],
            {#utxos: utxos},
          ),
        )),
      ) as _i3.Future<_i2.Psbt>);
  @override
  _i3.Future<_i2.Psbt> decodePsbt(String? base64Psbt) => (super.noSuchMethod(
        Invocation.method(
          #decodePsbt,
          [base64Psbt],
        ),
        returnValue: _i3.Future<_i2.Psbt>.value(_FakePsbt_0(
          this,
          Invocation.method(
            #decodePsbt,
            [base64Psbt],
          ),
        )),
      ) as _i3.Future<_i2.Psbt>);
  @override
  _i3.Future<String> broadcastTx(
    String? electrumAddress,
    int? torPort,
    String? tx,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #broadcastTx,
          [
            electrumAddress,
            torPort,
            tx,
          ],
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as _i3.Future<String>);
  @override
  _i3.Future<bool> validateAddress(String? address) => (super.noSuchMethod(
        Invocation.method(
          #validateAddress,
          [address],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  _i3.Future<String> signPsbt(String? psbt) => (super.noSuchMethod(
        Invocation.method(
          #signPsbt,
          [psbt],
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as _i3.Future<String>);
}
