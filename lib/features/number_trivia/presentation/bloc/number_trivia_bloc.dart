import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_and_tdd/core/error/failures.dart';
import 'package:flutter_clean_architecture_and_tdd/core/presentation/util/input_converter.dart';
import 'package:flutter_clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      yield* concreteNumberEventToState(event.numberString);
    } else if (event is GetTriviaForRandomNumber) {
      yield* randomNumberEventToState();
    }
  }

  Stream<NumberTriviaState> concreteNumberEventToState(
      String numberString) async* {
    final inputEither = inputConverter.stringToUnsignedInteger(numberString);
    yield* inputEither.fold((failure) async* {
      yield Error(INVALID_INPUT_FAILURE_MESSAGE);
    }, (integer) async* {
      yield Loading();

      final failureOrTrivia = await getConcreteNumberTrivia(Params(integer));

      yield* eitherLoadedOrErrorState(failureOrTrivia);
    });
  }

  Stream<NumberTriviaState> randomNumberEventToState() async* {
    yield Loading();
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    yield* eitherLoadedOrErrorState(failureOrTrivia);
  }

  Stream<NumberTriviaState> eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(failure.toMessage()),
      (trivia) => Loaded(trivia),
    );
  }
}

extension FailureToMessage on Failure {
  String toMessage() {
    switch (this.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
