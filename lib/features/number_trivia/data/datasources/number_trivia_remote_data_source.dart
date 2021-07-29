import 'dart:convert';

import 'package:flutter_clean_architecture_and_tdd/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUri(Uri(host: 'numbersapi.com', query: '/$number'));

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUri(Uri(host: 'numbersapi.com', query: '/random'));

  Future<NumberTriviaModel> _getTriviaFromUri(Uri uri) async {
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
