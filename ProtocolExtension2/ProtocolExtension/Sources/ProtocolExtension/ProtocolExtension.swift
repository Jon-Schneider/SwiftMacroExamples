public protocol Fluffy { }

@attached(extension, conformances: Fluffy, names: named(pet))
public macro Pettable() = #externalMacro(module: "ProtocolExtensionMacros", type: "ProtocolExtensionMacro")
