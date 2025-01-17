// Mocks generated by Mockito 5.2.0 from annotations
// in envoy/test/server_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:http_tor/http_tor.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:tor/tor.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeTor_0 extends _i1.Fake implements _i2.Tor {}

class _FakeResponse_1 extends _i1.Fake implements _i3.Response {}

class _FakeDownload_2 extends _i1.Fake implements _i3.Download {}

/// A class which mocks [HttpTor].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpTor extends _i1.Mock implements _i3.HttpTor {
  MockHttpTor() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Tor get tor =>
      (super.noSuchMethod(Invocation.getter(#tor), returnValue: _FakeTor_0())
          as _i2.Tor);
  @override
  _i4.Future<_i3.Response> get(String? uri,
          {String? body, Map<String, String>? headers}) =>
      (super.noSuchMethod(
              Invocation.method(#get, [uri], {#body: body, #headers: headers}),
              returnValue: Future<_i3.Response>.value(_FakeResponse_1()))
          as _i4.Future<_i3.Response>);
  @override
  _i4.Future<_i3.Response> post(String? uri,
          {String? body, Map<String, String>? headers}) =>
      (super.noSuchMethod(
              Invocation.method(#post, [uri], {#body: body, #headers: headers}),
              returnValue: Future<_i3.Response>.value(_FakeResponse_1()))
          as _i4.Future<_i3.Response>);
  @override
  _i4.Future<String> getIp() =>
      (super.noSuchMethod(Invocation.method(#getIp, []),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
  @override
  _i4.Future<_i3.Download> getFile(String? path, String? uri) =>
      (super.noSuchMethod(Invocation.method(#getFile, [path, uri]),
              returnValue: Future<_i3.Download>.value(_FakeDownload_2()))
          as _i4.Future<_i3.Download>);
}
