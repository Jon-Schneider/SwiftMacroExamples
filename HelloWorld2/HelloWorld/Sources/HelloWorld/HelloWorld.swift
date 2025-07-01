
@attached(member, names: named(sayHello))
public macro HelloWorlding() =
        #externalMacro(module: "HelloWorldMacros", type: "HelloWorldMacro")
