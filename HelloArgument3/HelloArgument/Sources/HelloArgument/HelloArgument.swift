@attached(member, names: named(sayHello))
public macro HelloArgumenting(_ to: [String]) =
        #externalMacro(module: "HelloArgumentMacros", type: "HelloArgumentMacro")
