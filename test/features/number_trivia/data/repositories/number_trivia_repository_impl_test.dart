import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_and_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_and_tdd/core/network/network_info.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
main() {
  var remoteDataSource = MockNumberTriviaRemoteDataSource();
  var localDataSource = MockNumberTriviaLocalDataSource();
  var networkInfo = MockNetworkInfo();
  var repo = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo);

  setUp(() {
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    localDataSource = MockNumberTriviaLocalDataSource();
    networkInfo = MockNetworkInfo();
    repo = NumberTriviaRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      when(remoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      await repo.getConcreteNumberTrivia(tNumber);
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repo.getConcreteNumberTrivia(tNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repo.getConcreteNumberTrivia(tNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repo.getConcreteNumberTrivia(tNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repo.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
          expect(await networkInfo.isConnected, false);
        },
      );
      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repo.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(remoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      await repo.getRandomNumberTrivia();

      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repo.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repo.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repo.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repo.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
          expect(await networkInfo.isConnected, false);
        },
      );
      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repo.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
