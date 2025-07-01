
/// A macro that adds the 'sayHello()' method to the annotated type.
@attached(member, names: named(sayHello))
public macro HelloWorlding() =
        #externalMacro(module: "HelloWorldMacros", type: "HelloWorldMacro")
