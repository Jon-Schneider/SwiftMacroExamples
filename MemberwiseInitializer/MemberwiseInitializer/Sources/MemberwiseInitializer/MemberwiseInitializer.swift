@attached(member, names: named(init), arbitrary)
public macro MemberwiseInitializer(_ to: [Any.Type]) =
        #externalMacro(module: "MemberwiseInitializerMacros", type: "MemberwiseInitializerMacro")
