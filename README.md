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
