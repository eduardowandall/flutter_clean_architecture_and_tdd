import 'dart:convert';

import 'package:flutter_clean_architecture_and_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
main() {
  var mockSharedPreferences = MockSharedPreferences();
  var dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);

  group('getLastNumberTrivia', () {
    var jsonCached = fixture('trivia_cached.json');
    var tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(jsonCached));
    test(
        'should NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(jsonCached);

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });
    test('should throw CacheException when there is not a cached value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    var tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);

      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, json.encode(tNumberTriviaModel.toJson())));
    });
  });
}
