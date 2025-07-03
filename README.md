## Swift Macro Examples

As I conduct a deep dive into Swift Macros I have found there are very few examples of macros available (especially attached Macros), so I am publishing the Macros I write here.

For readability, each macro is implemented in a separate directory.



#### Examples

##### Member Macros

1. **Hello World**. A simple attached macro that adds the method `sayHello()` to the type it is applied to, which prints "Hello, World!" to the console.
2. **Hello World 2**. An extension to **Hello World 1** that limits the macro to being attached to only classes and changes the message to "Hello from {typeName}!"
3. **Hello World 3**. An extension to **Hello World 2** that allows `@HelloWorlding` to be applied to structs, actors, and enums.
4. **Hello Argument**. Macro that takes a string argument and adds the method `sayHello()` to the type its applied to, which prints "Hello {Arg}!" to the console.
5. **Hello Argument 2**. An extension to **Hello Argument 1** that takes an `Any.Type`  argument (such as `String.self`) and adds the method `sayHello()` to the type its applied to, which prints "Hello {type}!" to the console.
6. **Hello Argument 3**. An extension to **Hello Argument 2** that takes an array of strings and adds the method `sayHello()` to the type its applied to, which prints "Hello {comma-separated list of string arguments}!" to the console.
7. **Hello Argument 4**. An extension to **Hello Argument 3** that takes an array of strings and adds a separate hello method for each one named `sayHello{index}()` that prints "Hello {arg}". For example, `sayHello1()`.



#### Useful Resources

* [Swift AST Explorer](https://swift-ast-explorer.com/). Useful for looking at the Abstract Syntax Tree of nodes you are trying to generate or modify.
* [List of `names:` Argument Values](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes#attached)