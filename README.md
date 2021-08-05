# flutter_clean_architecture_and_tdd
# Fora Bolsonaro

A Flutter project created following the amazing content of Reso Coder:
https://www.youtube.com/playlist?list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech

This is a simple app that receives a number and returns a fun trivia about it.

My purpose on taking this course and creating this project is to have a deeper understanding of Clean Architecture, TDD and Flutter itself.
I will try to do one lesson a day, trying to keep notes here so I can go back to and see it. Also, taking notes helps me think about what I am seeing and learn better.

THIS PROJECT IS ONLY FOR MY SAKE AND LEARNING

One of the things I am struggling on Flutter is to keep my code simple and readable. So lets see where this course takes me.

All of this to create the best code I can for my current project: Wikly


Lesson #1

Explaining how the Clean architecture works, as proposed by Uncle Bob.
As I understand, it consists of a circle, with the entities layer at the center, followed by the uses cases, then controllers(not sure yet what goes here, but when I read the book I will know), and at last UI, DB, External services and all of that stuff.

The direction of dependencies only go one way, inner.

The model proposed by ResoCoder, looks like this:
{Put that image}

In this lesson we created the project and created the folders for each division.

As of now, this course is my single source of truth for Clean Architecture, so I am not an expert. But I agree with this approach, and it is easy to understand.


One thing I found a little hard to understand is dividing it into 'feature' folders. As of now, I am not sure how this separation works, and most importantly, what is considered a feature. 


Lesson #2

"Testability and separation of concerns goes extremely well together" Just writing it down to remember better.

The beggining of This lesson focus on the domain layer, the innermost one.
The domain layer is responsible for having the entities (the definition of the objects), the repositories(in domain layer, only the interfaces, not concrete code) and use cases (our bussiness logic).

First starting with the entities, we can work our way out to the outer layers.
If I get it right, starting with the entities forces us to think about what kind of data are we manipulating on the use cases part as well as defining the basic object in which our whole application depends on.

Now we created our first abstract class for repository, and we are using Either from dartz, to return either(wow) an error class, or a success class (both entities of the application).
I am not seeing the reason for this yet, to be honest. Since you can just throw an exception and handle it on Use Cases. Also, Future already has a onError promise to deal with that.

TDD part of the lesson:
Remember YAGNI
Red -> Green -> Refactor
First write a test, it does not work (Red)
Write the implementation to make that test pass (Green)
Try to make your code better and keeping your test passing (Refactor)

This course was made before Flutter implemented that Null-Safety stuff. That led me to some weird configuration to use Mockito.
Just so I do not forget: When I write a test, to use a Mock of something, I have to place @GenerateMocks([array containing classes I want to be mocked]) and add a import to a file with the same name of my test file plus .mocks.dart in it. This will basically generate a file containing Mocks for every class. It is really cool, but I am not completely used to it.


Lesson #3

Flutter has Callable Classes. Wtf is this?
Just name your method 'call', so you can call it without specifying the name.

We created a interface for the Usecases, that uses generics to return types and stuff. Also uses some kind of generic parameters, which I can set on the usage of the interface, that seems a little weird to me as of now.

Additionally, we have made some class just for the parameters, containing the actual parameter used on the method. I do not see the reason for this right now. It just adds complexity for no reason.
It seems that the Params class was necessary because the interface needs to comply also with not having parameters, and with this separate class, it is possible to implement NoParams class.

I will check if there is another way

In this lesson we completed our Domain layer, creating also the getRandomNumber, together with its test.


Lesson #4

watch out for the edge cases. most of the times they will be the ones you most need to test.
What are edge cases? For example in this project, when the API returns some number that does not fit on Int32 object, like 1e+40.
Stuff that is not always happening, but could break your application.
It seems that when it comes to test, you should do the exact opposite of YAGNI, because actually you will use every test you write.
God, I love testing. Implementing some feature, knowing for sure you did not break anything.


Lesson #5

Now the reason for Failure class appears. Which is basically to make the repository implementation deal with outside world exceptions.
So, in this case, the responsibility for handling exceptions are in the repository implementation.

Handling repository problems should be on repository. 

Core folder is everything that is agnostic of feature, like everything that you could use outside of a feature folder.

As of now, we created the interfaces for the data layer, as well as a test class for the repository implementation.


Lesson #6, Lesson #7, Lesson #8, Lesson #9

Just plain old testing and implementation



Lesson #10

BLoCs
Bloc stands for Business Logic Component.
But on this example it should be Presentation Logic Component.
This happens because following Clean Architecture, the business logic is contained in the domain layer, which makes bloc not being used for business logic.
Bloc is a reactive state managment pattern, that sends information into one direction.
Flow:
Events -> BLoC -> State
Events comes from Flutter, goes inside BLoC, do something(in this case, only calls a usecase), then adds to a state.
It seems similar to Redux on React. I do not know.

I think I can use BLoC as the domain layer in simpler applications, and it seems fluent for using Flutter event queue. Like having a stream.

Events should not convert data. That violates S from SOLID.
BLoC states are being used for a state for the whole widget. Basically by creating a state for empty, for loading, etc.. we can have a much more separated logic to the widgets.

It is really cool. I can see much value in this. specially to reduce complexity on flutter widgets code, which is my biggest problem with it, as of now.

Remember when I said that this would be great with streams? BOOM, he just said that. Im on fire. 


Lesson #11

Lesson #12


Lesson #13
Implementation of Dependency Injection

Lesson #14
Implementation of Widgets.
I found the usage of Bloc really nice. Simply dispatch a event, fires an state that changes something in the screen.