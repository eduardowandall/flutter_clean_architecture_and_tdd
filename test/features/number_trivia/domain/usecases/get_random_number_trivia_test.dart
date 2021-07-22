import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  GetRandomNumberTrivia usecase =
      GetRandomNumberTrivia(mockNumberTriviaRepository);

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for a random number from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await usecase(NoParams());

    //verify
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
