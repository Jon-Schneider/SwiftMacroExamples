@attached(member, names: named(init), named(dependencies), arbitrary)
@attached(peer, names: suffixed(Dependencies))
public macro Dependencies(_ to: [Any.Type]) =
        #externalMacro(module: "DependencyBagInjectionMacros", type: "DependencyBagInjectionMacro")
