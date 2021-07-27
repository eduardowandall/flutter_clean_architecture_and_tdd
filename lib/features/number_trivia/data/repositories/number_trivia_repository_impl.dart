import 'package:flutter_clean_architecture_and_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_and_tdd/core/platform/network_info.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> ConcreteOrRandom();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    ConcreteOrRandom getRandomOrConcrete,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getRandomOrConcrete();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
