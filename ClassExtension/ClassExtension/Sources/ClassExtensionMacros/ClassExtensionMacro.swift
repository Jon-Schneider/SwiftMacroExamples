import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ClassExtensionMacro: ExtensionMacro {
    enum ClassExtensionMacroError: Error {
        case missingProtocol
    }

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        let typeName = type.trimmed
        let equatableExtension = try ExtensionDeclSyntax(
            """
            extension \(typeName) {
                func pet() {
                    print("The \(typeName) is happy")
                }
            }
            """
        )
            return [equatableExtension]
    }
}

@main
struct ClassExtensionPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ClassExtensionMacro.self,
    ]
}
