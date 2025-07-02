@attached(member, names: arbitrary)
public macro HelloArgumenting(_ to: [String]) =
        #externalMacro(module: "HelloArgumentMacros", type: "HelloArgumentMacro")
