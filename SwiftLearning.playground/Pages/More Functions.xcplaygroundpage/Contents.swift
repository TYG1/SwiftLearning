/*:
 [Table of Contents](@first) | [Previous](@previous) | [Next](@next)
 - - -
 # More Functions
 * callout(Session Overview): In previous sessions, we learned that we can group related statements together, giving them a name with parameters and a return type, calling them functions. Functions are also data types, enabling us to assign a function to a constant or variable, return a function, and pass a function as an argument to another function. We can even nest functions inside other functions to change the visibility of the function from global to local only to the parent function. In this session we continue to explore the capabilities of functions as well as learn about a special functions called **Closures**.
*/
import Foundation
/*:
## Guarding
A good practice when creating functions is to test that the parameter values are valid. The `guard` statement is like an `if` statement except that a `guard` requires that you have an `else` for the false condition. If the `guard` statement evaluates to `false` the statements in the `else` are executed and *must* exit the function.
*/
func printGrade(grade: (Int, String)) {
    
    guard grade.0 >= 0 && grade.0 <= 100 else {
        print("Wrong Grade Number!")
        return
    }
    
    guard ["A", "B", "C", "D", "F"].contains(grade.1) else {
        print("Wrong Grade Letter!")
        return
    }
    
    print("Your grade is \(grade.0) or a \(grade.1)")
}
printGrade((101, "A"))
printGrade((55, "E"))
printGrade((94, "F"))
/*:
Above we validate the grade number and grade letter using a `guard` statement and only executing the correct print statement if the grade number and grade letter are in the correct range.
*/
/*:
## Error Handling
Something can always go wrong when making programs. These wrong things are called exceptions, like *exception to the rule*. Swift provides a way to handle exceptions when they occur and also cause exceptions to occur to indicate to the caller that an error condition was met.
*/
/*:
### Code with Errors in mind.
When throwing exceptions, the value that is thrown is an `ErrorType`. The most common way to create an `ErrorType` is by creating an *enumeration* conforming to a *protocol* of `ErrorType` ([Enumerations](Enumerations) and [Protocols](Protocols) will be explained in more detail in later sessions).
*/
enum GradeError: ErrorType {
    case MissingLetter
    case BadLetter(youPassed: String, shouldBe: String)
    case BadNumber
}
/*:
Above we create an enumeration `GradeError`, conforming to the *protocol* `ErrorType` with cases of `MissingLetter`, `BadLetter`, `BadNumber`
*/
/*:
### Throw it here
To indicate to the caller that an exception condition could be met is by using the `throws` keyword just before the arrrow and return type. Then within the function, when the exception condition is met you cause the exception to execute by using the `throw` keyword using the `ErrorType`.
*/
func createGrade(number: Int, letter: String) throws -> (Int, String) {
    
    guard number >= 0 && number <= 100 else {
        throw GradeError.BadNumber
    }
    guard !letter.isEmpty else {
        throw GradeError.MissingLetter
    }
    
    let gradeTuple = (number, letter);
    
    switch gradeTuple {
    case (90...100, let letter) where letter != "A":
        throw GradeError.BadLetter(youPassed: letter, shouldBe: "A")
    case (80...89, let letter) where letter != "B":
        throw GradeError.BadLetter(youPassed: letter, shouldBe: "B")
    case (70...79, let letter) where letter != "C":
        throw GradeError.BadLetter(youPassed: letter, shouldBe: "C")
    case (60...69, let letter) where letter != "D":
        throw GradeError.BadLetter(youPassed: letter, shouldBe: "D")
    case (0...59, let letter) where letter != "F":
        throw GradeError.BadLetter(youPassed: letter, shouldBe: "F")
    default:
        break;
    }
    
    return gradeTuple;
}
/*:
Above we test the valid values of the parameters, throwing exceptions if the values are not in the correct range.
*/
/*:
### Catch it there
When you are calling a function that `throws` exceptions you can `catch` the possible exceptions by wrapping the function call in `do{...} catch{...}` statement, with each catch representing each possible exception. Then use the keyword `try` before the call to the function.
*/
do {
//    let myGrade = try createGrade(93, letter: "B")
    let myGrade = try createGrade(100, letter: "")
//    let myGrade = try createGrade(101, letter: "A")
//    let myGrade = try createGrade(100, letter: "A")

    print("my grade is \(myGrade.0) or a \(myGrade.1)")

} catch GradeError.BadLetter(let passed, let shouldBe) {
    print("You passed a letter of \(passed), but it should be \(shouldBe)")
} catch GradeError.MissingLetter {
    print("You didn't passed in a letter")
} catch GradeError.BadNumber {
    print("You passed in a bad number")
}
/*:
Above we call `createGrade` inside a do/catch statement executing the function call with a try.
*/
/*:
## Clean up after yourself
There are occations that you want to force the execution of code to always happen when exiting a function. This can be accomplished by using the keyword `defer`. You can have as many `defer` statments with varying kinds of scope. `defer` statements are executed in reverse order.
*/
func createMyGrade(number: Int, letter: String) throws -> (Int, String)? {
    
    defer {
        print("4: order")
    }
    defer {
        print("3: in reverse")
    }
    
    do {
        defer {
            print("2: defer statements are executed")
        }

        let myGrade = try createGrade(number, letter: letter)

        print("1: my grade is \(myGrade.0) or a \(myGrade.1)")

        return myGrade

    } catch GradeError.BadLetter(let passed, let shouldBe) {

        print("You passed a letter of \(passed), but it should be \(shouldBe)")

        return nil
    }
}

let myGrade = try createMyGrade(93, letter: "A")
/*:
Above we use the `defer` statement to force the execution of statements when the function exits.
*/
/*:
# Closures
Closures are self contained functions that are able to reference other constants or variables that are defined in the same context. Global and nested functions are actually closures, but have different rules for what constants and variables they can reference. Unnamed closures have a terse syntax that can reference values from their surrounding context.
*/
/*:
## Passing Closures
Just like normal functions, closures are data types themselves, allowing you to assign them to constants or variables as well as arguments to other functions.
*/
let family = [(name: "Luke",    role: "child",          age: 3),
            (name: "Anakin",    role: "father",         age: 24),
            (name: "Rey",       role: "grand_child",    age: 17),
            (name: "Leia",      role: "child",          age: 3),
            (name: "Padme",     role: "mother",         age: 37)]

func sortFamily(element1: (String, String, Int), element2: (String, String, Int)) -> Bool {

    return element1.2 < element2.2
}

let orderedByAge = family.sort(sortFamily)

print(orderedByAge)
//: Above we are calling the sort method of an Array passing in a closure. The Closure is defined with two parameters, both being of the same type, in this case a tuple of `(String, String, Int)`.
/*:
### The Syntax
Notice above that the syntax for a closure is just like the function syntax. There are parameters, a return type and a group of statements, the function body. We could have also used the closure expression syntax described below.
*/
/*:
`{ (parameters) -> return type} in ... }`
*/
/*:
Using the closure expression syntax allows us to be more expressive when dealing with closures.
*/
/*:
### Inferring Types
The above function `sortFamily` is a closure that is later passed in as an argument to the sort method of an array. But leveraging the closure expression syntax our code is more consise.
*/
let inferring = family.sort({ element1, element2 in return element1.name < element2.name })

print(inferring)






//: Above we don't need to include the definition of `element1` and `element2` because they are inferred from of the context, `family` consisting of data types of `(String, String, Int)`
/*:
### Returning without writing it
When a closure body is a single expression, the `return` keyword can be omitted, inferring that the return is satisfied from `element1.name < element2.name`
*/
let noreturn = family.sort({ element1, element2 in element1.name < element2.name })

print(noreturn)
//: Above we omit the `return` keyword, continuing to reduce the code to satisfied the closure definition.
/*:
### Shorthand
For inline closures using the closure expression syntax, Swift automatically provides access to the arguments using the index of the argument prefixed with `$`.
*/
let shorthand = family.sort({ $0.name < $1.name })

print(shorthand)




//: Above we use the shorthand argument names, such as `$0` and `$1` to access the argument values, allowing us to omit the argument list from the definition.
/*:
### Even more terse... Operator Functions
One last way to write a closure for the sort method is to leverage the data types implementation of the greater-than operator. `Int` overloads the greater-than operator for the purpose of only having to deal with the `Int` data type.
*/
var ages: [Int] = []
for member in family {
    ages.append(member.age)
}

var terse = ages.sort()
terse = ages.sort(>)

print(terse)
//: Above we collect all the ages into the `ages` variable and sort only using the greater-than operator. We could have also used the less-then operator, since the `Int` data type provides it's own implementation.
/*:
### Trailing Closures
When the final argument or only argument to a function is a closure, you can write what is called a *trailing closure*. A trailing closure uses the closure expression syntax that is written outside and after the parentheses, helping reduce the amout of code to satisfy the function call.
*/
func printAttribute(member: (name: String, role: String, age: Int), closure: ((name: String, role: String, age: Int) -> String)) {
    
    print(closure(member))
}

for member in family.sort({ $0.age > $1.age }) {
    
    // closure expression within parentheses
    
    printAttribute(member, closure: { (name, role, age) -> String in
        
        return name
    })
    
    // trailing closure outside and after parentheses
    
    printAttribute(member){ (name, role, age) -> String in
        
        return role
    }
}
//: Above we call the `printAttribute` function using both ways to pass a closure. The first way is the longer form of specifying the arguments of `member` and `closure` and the second shorter form using the trailing closure syntax.
/*:
## Referring to Closures
Closures, just like functions can be stored in constants and variables. When storing closures, you are actually storing a reference to the closure.
*/
var names: [String] = []
for member in family {
    names.append(member.name)
}

let sortedName = names.sort(<)

print(sortedName)

let sortTheNames = names.sort

print(sortTheNames())
//: Above we sort the names of each member by calling sort method passing the operator function and then store the sort method in a constant to be called at a later time.
/*:
## Access to outer variables
Closures have a special ability to have their scope (the area of code on which the closure can access constants or varaibles) limited to where it is defined. Functions on the other hand have their scope limited to where the function is executed.
*/
func counter(closure: (counter: Int) -> Void) -> () -> Void {
    
    var counter = 0;
    
    func call() {
        
        closure(counter: counter);
        counter += 1
    }
    
    return call
}

let call = counter { print("called \($0) times") }

for times in 0..<10 { call() }
//: Above is a function `counter` with only one parameter, a closure of type `(Int) -> Void`, and returns a closure of type `() -> Void`. Within the body of the function, a `counter` variable is declared as well as a function `call()`. Since `counter` and `call` are defined in the context, the `call` function is able to access the `counter` variable, even when execution of code passes.
/*:
## Creating Closures
Creating a closure is just like creating a function. The only difference being what constants and variables the closure can access.
*/
//Use these functions for the Exercise 5
//look to underscore js, ruby, etc for examples of how to create the functions to access the data structures.

func each(items: [String], closure: (item: String, index: Int) -> Void) {

    func iterator(items: [String], closure: (item: String) -> Void) {

        for var index = 0; index < items.count; ++index {

            closure(item: items[index])
        }
    }

    var index = 0;

    iterator(items) { closure(item: $0, index: index++) }
}

each(sortTheNames()) { print("item \($1) is \($0)") }
//: Above we have declared a function 'each' accepting arguments of `[String]` and a closure of type `(String, Int) -> Void`. Within the body of the function we create another function, in this context a closure called `iterator`. The `iterator` function has access to the `index` variable. Inside the `each` function we call the `iterator` passing it the `items` and using the trailing closure syntx, the closure to accept a single `item` and the `index`.
/*:
### Autoclosures
Autoclosures, using the '@autoclosure' attribute when declared with the function closure parameter, let you only pass the closure body. The '@autoclosure' attribute automatically wraps the expression in a closure.
*/

// parameter talk as a normal closure

func sayHello(talk: () -> Void) {
    
    talk()
}

// called with the normal trailing closure syntax

sayHello({ print("Hello!") })

// parameter talk as a autoclosure

func sayGoodbye(@autoclosure talk: () -> Void) {
    
    talk()
}

// called with out the bracket, the @autoclosure supplies them for us

sayGoodbye(print("Goodbye!"))

// store an array of closures

var talking: [() -> Void] = []


// the escaping attribute allows talk to live outside the function

func chatter(@autoclosure(escaping) talk: () -> Void) {

    talking.append(talk)
}

// each call to chatter stores a closures

chatter(print("Hello!"))
chatter(print("Goodbye!"))
chatter(print("Hello!"))
chatter(print("Goodbye!"))
chatter(print("Hello!"))

// iterater over all the `talking`

for talk in talking {

    talk()
}
//: Above, since the reference to each `talk` closure is used, we need to declare the closure as `escaping` or allowed to exist outside `chatter`
/*:
 - - -
 * callout(Exercise): Leveraging the `each` and `iterator` functions above, and using the students constant below, create the following functions passing in a closure to satisfy the function requirement.
 */
    let students = [
        ["first" : "Obi-Wan",   "last" : "Kenobi",      "age" : "55", "class" : "Math"],
        ["first" : "Darth",     "last" : "Vader",		"age" : "76", "class" : "Engligh"],
        ["first" : "Anakin",    "last" : "Skywalker",	"age" : "17", "class" : "History"],
        ["first" : "Darth",     "last" : "Sidious",		"age" : "88", "class" : "Science"],
        ["first" : "Padme",     "last" : "Amidala",		"age" : "25", "class" : "Math"],
        ["first" : "Mace",      "last" : "Windu",		"age" : "56", "class" : "Science"],
        ["first" : "Count",     "last" : "Dooku",		"age" : "67", "class" : "History"],
        ["first" : "Luke",      "last" : "Skywalker",	"age" : "21", "class" : "Math"],
        ["first" : "Han",       "last" : "Solo",		"age" : "35", "class" : "Science"],
        ["first" : "Leia",      "last" : "Organa",		"age" : "21", "class" : "Engligh"],
        ["first" : "Chew",      "last" : "Bacca",		"age" : "33", "class" : "Science"],
        ["first" : "Boba",      "last" : "Fett",		"age" : "32", "class" : "History"],
        ["first" : "Lando",     "last" : "Calrissian",	"age" : "55", "class" : "Engligh"],
        ["first" : "Kylo",      "last" : "Ren",			"age" : "21", "class" : "Math"],
        ["first" : "Poe",       "last" : "Dameron",		"age" : "25", "class" : "History"],
        ["first" : "Finn",      "last" : "FN-2187",		"age" : "23", "class" : "Science"],
        ["first" : "Rey",       "last" : "Rey",			"age" : "16", "class" : "Engligh"]
    ]
/*:
 **Functions:**
 - `each` = Iterate over each element in the array
 - `all` = Returns true if all of the elements is not false
 - `any` = Returns true if at least one of the elements is not false
 - `contains` = Returns true if the element is present
 - `indexOf` = Returns the index at which element can be found
 - `filter` = Returns an array of all the elements that pass a truth test
 - `reject` = Returns the elements in the array without the elements that pass a truth test
 - `pluck` = Returns an array of a specific value from all the elements

 **Constraints:**
 Use the above functions to query your students.

 **Example Output:**
 -  Last names of math and sciense students where age > 25 and age < 80
    - `["Kenobi", "Windu", "Solo", "Bacca"]`
 * callout(Checkpoint): At this point, you should be able validate the parameter values using the guard statment as well as throw exceptions from a function and catch exceptions from throwing functions. We also learned about a special function called a **closure** which is able to gain access to constants and variables defined in the same context as the closure is defined.
 
 **Keywords to remember:**
 - `guard` = used to test conditions and if false, short circuit the function
 - `do` = indicate a block of code that handles exceptions
 - `try` = execute a statement that could throw an exception
 - `throw` = to make an exception happen
 - `throws` = used on a function declarations to tell the caller that an exception could happen
 - `catch` = block of code to execute for a specific exception
 - `defer` = block of code to execute after the function exits either by completing, returning or catching
 - `in` = indicates that the next set of statements are for the closure
 * callout(Supporting Materials): Chapters and sections from the Guide and Vidoes from WWDC
 - [Guide: Control Flow](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html)
 - [Guide: Error Handling](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html)
 - [Guide: Closures](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html)
 - - -
 [Table of Contents](@first) | [Previous](@previous) | [Next](@next)
 */
