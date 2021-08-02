import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_and_tdd/core/presentation/util/input_converter.dart';
import 'package:flutter_clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia =
      MockGetConcreteNumberTrivia();
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia =
      MockGetRandomNumberTrivia();
  MockInputConverter mockInputConverter = MockInputConverter();
  NumberTriviaBloc bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter);

  test('initial state should be Empty', () async {
    expect(bloc.state, equals(Empty()));
  });
  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test', number: tNumberParsed);

    void setUpInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    void setUpMocksForSuccess() {
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMocksForSuccess();
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });
    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [
        // Empty(),
        Error(INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the Concrete Use Case', () async {
      setUpMocksForSuccess();

      // act

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert

      verify(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      setUpMocksForSuccess();

      // assert later
      final expected = [
        // Empty(),
        Loading(), Loaded(tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        // Empty(),
        Loading(), Error(SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with cache fail message when getting data from cache fails',
        () async {
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        // Empty(),
        Loading(), Error(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpMocksForSuccess() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    test('should get data from the random Use Case', () async {
      setUpMocksForSuccess();

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      setUpMocksForSuccess();

      // assert later
      final expected = [
        // Empty(),
        Loading(), Loaded(tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        // Empty(),
        Loading(), Error(SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with cache fail message when getting data from cache fails',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        // Empty(),
        Loading(), Error(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
