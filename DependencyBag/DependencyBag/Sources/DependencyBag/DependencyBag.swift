@attached(member, names: named(Dependencies))
public macro Dependencies(_ to: [Any.Type]) =
        #externalMacro(module: "DependencyBagMacros", type: "DependencyBagMacro")
