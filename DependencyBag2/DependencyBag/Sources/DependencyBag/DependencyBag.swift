@attached(peer, names: suffixed(Dependencies))
public macro Dependencies(_ to: [Any.Type]) =
        #externalMacro(module: "DependencyBagMacros", type: "DependencyBagMacro")
