public protocol Pettable {
    func pet()
}

@attached(extension, conformances: Pettable, names: named(pet))
public macro Pettable() = #externalMacro(module: "ClassExtensionMacros", type: "ClassExtensionMacro")
