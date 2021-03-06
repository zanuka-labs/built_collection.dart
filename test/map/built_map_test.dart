// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.map.built_map_test;

import 'dart:collection' show SplayTreeMap;
import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:test/test.dart';

import '../performance.dart';

void main() {
  group('BuiltMap', () {
    test('instantiates empty by default', () {
      final map = new BuiltMap<int, String>();
      expect(map.isEmpty, isTrue);
      expect(map.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltMap<dynamic, dynamic>', () {
      expect(() => new BuiltMap(), throwsA(anything));
    });

    test('throws on attempt to create BuiltMap<String, dynamic>', () {
      expect(() => new BuiltMap<String, dynamic>(), throwsA(anything));
    });

    test('throws on attempt to create BuiltMap<dynamic, String>', () {
      expect(() => new BuiltMap<dynamic, String>(), throwsA(anything));
    });

    test(
        'of constructor throws on attempt to create BuiltMap<dynamic, dynamic>',
        () {
      expect(() => new BuiltMap.of({}), throwsA(anything));
    });

    test('of constructor throws on attempt to create BuiltMap<String, dynamic>',
        () {
      expect(() => new BuiltMap.of(<String, dynamic>{}), throwsA(anything));
    });

    test('of constructor throws on attempt to create BuiltMap<dynamic, String>',
        () {
      expect(() => new BuiltMap.of(<dynamic, String>{}), throwsA(anything));
    });

    test('allows BuiltMap<Object, Object>', () {
      new BuiltMap<Object, Object>();
    });

    test('can be instantiated from Map', () {
      new BuiltMap<int, String>({});
    });

    test('from constructor takes Map', () {
      new BuiltMap<int, String>.from({});
    });

    test('of constructor takes inferred type', () {
      expect(new BuiltMap.of({1: '1'}),
          const TypeMatcher<BuiltMap<int, String>>());
    });

    test('reports non-emptiness', () {
      final map = new BuiltMap<int, String>({1: '1'});
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
    });

    test('can be instantiated from Map then converted back to equal Map', () {
      final mutableMap = {1: '1'};
      final map = new BuiltMap<int, String>(mutableMap);
      expect(map.toMap(), mutableMap);
    });

    test('throws on wrong type key', () {
      expect(() => new BuiltMap<int, String>({'1': '1'}), throwsA(anything));
    });

    test('throws on wrong type value', () {
      expect(() => new BuiltMap<int, String>({1: 1}), throwsA(anything));
    });

    test('does not keep a mutable Map', () {
      final mutableMap = {1: '1'};
      final map = new BuiltMap<int, String>(mutableMap);
      mutableMap.clear();
      expect(map.toMap(), {1: '1'});
    });

    test('copies from BuiltMap instances of different type', () {
      final map1 = new BuiltMap<Object, Object>();
      final map2 = new BuiltMap<int, String>(map1);
      expect(map1, isNot(same(map2)));
    });

    test('can be converted to Map<K, V>', () {
      expect(new BuiltMap<int, String>().toMap() is Map<int, String>, isTrue);
      expect(new BuiltMap<int, String>().toMap() is Map<int, int>, isFalse);
      expect(
          new BuiltMap<int, String>().toMap() is Map<String, String>, isFalse);
    });

    test('uses same base when converted with toMap', () {
      final built = new BuiltMap<int, String>.build((b) => b
        ..withBase(() => new SplayTreeMap<int, String>())
        ..addAll({1: '1', 3: '3'}));
      final map = built.toMap()..addAll({2: '2', 4: '4'});
      expect(map.keys, [1, 2, 3, 4]);
    });

    test('can be converted to an UnmodifiableMapView', () {
      final immutableMap = new BuiltMap<int, String>().asMap();
      expect(immutableMap is Map<int, String>, isTrue);
      expect(() => immutableMap[1] = 'Hello', throwsUnsupportedError);
      expect(immutableMap, isEmpty);
    });

    test('can be converted to MapBuilder<K, V>', () {
      expect(new BuiltMap<int, String>().toBuilder() is MapBuilder<int, String>,
          isTrue);
      expect(new BuiltMap<int, String>().toBuilder() is MapBuilder<int, int>,
          isFalse);
      expect(
          new BuiltMap<int, String>().toBuilder() is MapBuilder<String, String>,
          isFalse);
    });

    test('can be converted to MapBuilder<K, V> and back to Map<K, V>', () {
      expect(
          new BuiltMap<int, String>().toBuilder().build()
              is BuiltMap<int, String>,
          isTrue);
      expect(
          new BuiltMap<int, String>().toBuilder().build() is BuiltMap<int, int>,
          isFalse);
      expect(
          new BuiltMap<int, String>().toBuilder().build()
              is BuiltMap<String, String>,
          isFalse);
    });

    test('passes along its base when converted to SetBuilder', () {
      final map = new BuiltMap<int, String>.build((b) => b
        ..withBase(() => new SplayTreeMap<int, String>())
        ..addAll({10: '10', 15: '15', 5: '5'}));
      final builder = map.toBuilder()..addAll({2: '2', 12: '12'});
      expect(builder.build().keys, orderedEquals([2, 5, 10, 12, 15]));
    });

    test('throws on null keys', () {
      expect(() => new BuiltMap<int, String>({null: '1'}), throwsA(anything));
    });

    test('throws on null values', () {
      expect(() => new BuiltMap<int, String>({1: null}), throwsA(anything));
    });

    test('of constructor throws on null keys', () {
      expect(
          () => new BuiltMap<int, String>.of({null: '1'}), throwsA(anything));
    });

    test('of constructor throws on null values', () {
      expect(() => new BuiltMap<int, String>.of({1: null}), throwsA(anything));
    });

    test('hashes to same value for same contents', () {
      final map1 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      final map2 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});

      expect(map1.hashCode, map2.hashCode);
    });

    test('hashes to different value for different keys', () {
      final map1 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      final map2 = new BuiltMap<int, String>({1: '1', 2: '2', 4: '3'});

      expect(map1.hashCode, isNot(map2.hashCode));
    });

    test('hashes to different value for different values', () {
      final map1 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      final map2 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '4'});

      expect(map1.hashCode, isNot(map2.hashCode));
    });

    test('caches hash', () {
      final map = new BuiltMap<Object, Object>({1: new _HashcodeOnlyOnce()});

      map.hashCode;
      map.hashCode;
    });

    test('compares equal to same instance', () {
      final map = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      expect(map == map, isTrue);
    });

    test('compares equal to same contents', () {
      final map1 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      final map2 = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      expect(map1 == map2, isTrue);
    });

    test('compares not equal to different type', () {
      expect(
          // ignore: unrelated_type_equality_checks
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}) == '',
          isFalse);
    });

    test('compares not equal to different length BuiltMap', () {
      expect(
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}) ==
              new BuiltMap<int, String>({1: '1', 2: '2'}),
          isFalse);
    });

    test('compares not equal to different hashcode BuiltMap', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltMap(
                  {1: '1', 2: '2', 3: '3'}, 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltMap(
                  {1: '1', 2: '2', 3: '3'}, 1),
          isFalse);
    });

    test('compares not equal to different content BuiltMap', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltMap(
                  {1: '1', 2: '2', 3: '3'}, 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltMap(
                  {1: '1', 2: '2', 4: '4'}, 0),
          isFalse);
    });

    test('compares without throwing for same hashcode different key type', () {
      expect(
          // ignore: unrelated_type_equality_checks
          BuiltCollectionTestHelpers.overridenHashcodeBuiltMap({1: '1'}, 0) ==
              BuiltCollectionTestHelpers
                  .overridenHashcodeBuiltMapWithStringKeys({'1': '1'}, 0),
          false);
    });

    test('provides toString() for debugging', () {
      expect(new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).toString(),
          '{1: 1, 2: 2, 3: 3}');
    });

    test('preserves key order', () {
      expect(
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).keys, [1, 2, 3]);
      expect(
          new BuiltMap<int, String>({3: '3', 2: '2', 1: '1'}).keys, [3, 2, 1]);
    });

    // Lazy copies.

    test('reuses BuiltMap instances of the same type', () {
      final map1 = new BuiltMap<int, String>();
      final map2 = new BuiltMap<int, String>(map1);
      expect(map1, same(map2));
    });

    test('does not reuse BuiltMap instances with subtype key type', () {
      final map1 = new BuiltMap<_ExtendsA, String>();
      final map2 = new BuiltMap<_A, String>(map1);
      expect(map1, isNot(same(map2)));
    });

    test('does not reuse BuiltMap instances with subtype value type', () {
      final map1 = new BuiltMap<String, _ExtendsA>();
      final map2 = new BuiltMap<String, _A>(map1);
      expect(map1, isNot(same(map2)));
    });

    test('can be reused via MapBuilder if there are no changes', () {
      final map1 = new BuiltMap<Object, Object>();
      final map2 = map1.toBuilder().build();
      expect(map1, same(map2));
    });

    test('converts to MapBuilder from correct type without copying', () {
      final makeLongMap = () => new BuiltMap<int, int>(
          new Map<int, int>.fromIterable(
              new List<int>.generate(100000, (x) => x)));
      final longMap = makeLongMap();
      final longMapToMapBuilder = longMap.toBuilder;

      expectMuchFaster(longMapToMapBuilder, makeLongMap);
    });

    test('converts to MapBuilder from wrong type by copying', () {
      final makeLongMap = () => new BuiltMap<Object, Object>(
          new Map<int, int>.fromIterable(
              new List<int>.generate(100000, (x) => x)));
      final longMap = makeLongMap();
      final longMapToMapBuilder = () => new MapBuilder<int, int>(longMap);

      expectNotMuchFaster(longMapToMapBuilder, makeLongMap);
    });

    test('has fast toMap', () {
      final makeLongMap = () => new BuiltMap<Object, Object>(
          new Map<int, int>.fromIterable(
              new List<int>.generate(100000, (x) => x)));
      final longMap = makeLongMap();
      final longMapToMap = () => longMap.toMap();

      expectMuchFaster(longMapToMap, makeLongMap);
    });

    test('checks for reference identity', () {
      final makeLongMap = () => new BuiltMap<Object, Object>(
          new Map<int, int>.fromIterable(
              new List<int>.generate(100000, (x) => x)));
      final longMap = makeLongMap();
      final otherLongMap = makeLongMap();

      expectMuchFaster(() => longMap == longMap, () => longMap == otherLongMap);
    });

    test('is not mutated when Map from toMap is mutated', () {
      final map = new BuiltMap<int, String>();
      map.toMap()[1] = '1';
      expect(map.isEmpty, isTrue);
    });

    test('has build constructor', () {
      expect(
          new BuiltMap<int, String>.build((b) => b[0] = '0').toMap(), {0: '0'});
    });

    test('has rebuild method', () {
      expect(
          new BuiltMap<int, String>({0: '0'})
              .rebuild((b) => b[1] = '1')
              .toMap(),
          {0: '0', 1: '1'});
    });

    test('returns identical BuiltMap on repeated build', () {
      final mapBuilder = new MapBuilder<int, String>({1: '1', 2: '2', 3: '3'});
      expect(mapBuilder.build(), same(mapBuilder.build()));
    });

    // Map.

    test('does not implement Map', () {
      expect(new BuiltMap<int, String>() is Map, isFalse);
    });

    test('has a method like Map[]', () {
      expect(new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'})[2], '2');
    });

    test('has a method like Map.length', () {
      expect(new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).length, 3);
    });

    test('has a method like Map.containsKey', () {
      expect(new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).containsKey(3),
          isTrue);
      expect(new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).containsKey(4),
          isFalse);
    });

    test('has a method like Map.containsValue', () {
      expect(
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'})
              .containsValue('3'),
          isTrue);
      expect(
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'})
              .containsValue('4'),
          isFalse);
    });

    test('has a method like Map.forEach', () {
      var totalKeys = 0;
      var concatenatedValues = '';
      new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).forEach((key, value) {
        totalKeys += key;
        concatenatedValues += value;
      });

      expect(totalKeys, 6);
      expect(concatenatedValues, '123');
    });

    test('has a method like Map.keys', () {
      expect(
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).keys, [1, 2, 3]);
    });

    test('has a method like Map.values', () {
      expect(new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'}).values,
          ['1', '2', '3']);
    });

    test('has a method like Map.entries', () {
      final map = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      expect(new BuiltMap<int, String>(new Map.fromEntries(map.entries)), map);
    });

    test('has a method like Map.map', () {
      expect(
          new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'})
              .map((key, value) => new MapEntry(value, key))
              .asMap(),
          {'1': 1, '2': 2, '3': 3});
    });

    test('has stable keys', () {
      final map = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      expect(map.keys, same(map.keys));
    });

    test('has stable values', () {
      final map = new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'});
      expect(map.values, same(map.values));
    });
  });
}

class _A {}

class _ExtendsA extends _A {}

class _HashcodeOnlyOnce {
  bool hashCodeAllowed = true;

  @override
  // ignore: hash_and_equals
  int get hashCode {
    expect(hashCodeAllowed, isTrue);
    hashCodeAllowed = false;
    return 0;
  }
}
