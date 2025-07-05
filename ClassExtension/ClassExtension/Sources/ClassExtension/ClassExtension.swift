@attached(extension, names: named(pet))
public macro Pettable() = #externalMacro(module: "ClassExtensionMacros", type: "ClassExtensionMacro")
