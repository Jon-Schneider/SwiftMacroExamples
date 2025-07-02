@attached(member, names: named(sayHello))
public macro HelloArgumenting(_ to: Any.Type) =
        #externalMacro(module: "HelloArgumentMacros", type: "HelloArgumentMacro")
