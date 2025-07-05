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
8. **Dependency Bag**. Generates a dependency struct named `Dependencies` for a class or struct from a list of types passed as the macro argument, nested in its parent type.
9. **Memberwise Initalizer**. Generates a memberwise initializer for a class or structure from a list of types passed as the macro argument.

##### Peer Macros

1. **Make a Friend**. Creates a class named `{typeMacroWasAppliedTo}Friend`.
2. **Make a Friend 2**. Extension of **Make a Friend 1**. The protocol can only be generated for types that subclass a specific class.
3. **Make a Friend 3**. Extension of **Make a Friend 2**. The friend class can only be generated for types that conform to a specific protocol
4. **Dependency Bag 2**. Identical to **Dependency Bag** except the dependency struct is generated as a peer to the type the Macro extends instead of nested inside it, and named `{AttachedType}Dependencies`.

##### Extension Macros

1. **Class Extension**. Extends a class with a method.
2. **Class Extension 2**. Adds a protocol conformance to a class.
3. **Protocol Extension**. Adds a protocol extension with a default method implementation.
4. **Protocol Extension 2**. Adds a type-constrained protocol extension that adds a method implementation.

##### Composite Macros

Composite macros implement more than one role, such as both Peer + Member.

1. **Dependency Bag Injection**. An extension of **Dependency Bag 2** and **Memberwise Initializer**. Generates a dependency structure named `{Type}Dependencies` for a class or struct from a list of types passed as the macro argument, nested in its parent type and adds an custom initializer that takes the dependencies struct as an argument.
2. **Dependency Bag Injection 2**. An extension of **Dependency Bag Injection** that adds a convenience accessor var to get each dependency from the `Dependency` struct on the object the macro is attached to.

#### Useful Resources

* [Swift AST Explorer](https://swift-ast-explorer.com/). Useful for looking at the Abstract Syntax Tree of nodes you are trying to generate or modify.
* [List of `names:` Argument Values](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes#attached)