## Swift Macro Examples

As I conduct a deep dive into Swift Macros I have found there are very few examples of macros available (especially attached Macros), so I am publishing the Macros I write here.

For readability, each macro is implemented in a separate directory.

#### Examples

1. **Hello World**. A simple attached macro that adds the method `sayHello()` to the type it is applied to, which prints "Hello, World!" to the console.
2. **Hello World 2**. A simple attached macro that adds the method `sayHello()` to a class, which prints "Hello from {typeName}!" to the console.

#### Useful Resources

* [Swift AST Explorer](https://swift-ast-explorer.com/). Useful for looking at the Abstract Syntax Tree of nodes you are trying to generate or modify.