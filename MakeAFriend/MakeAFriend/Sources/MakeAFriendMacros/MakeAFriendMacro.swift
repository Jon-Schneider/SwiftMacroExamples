import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MakeAFriendMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        let typeName: String?
        if let decl = declaration.as(ClassDeclSyntax.self) {
            typeName = decl.name.text
        } else if let decl = declaration.as(StructDeclSyntax.self) {
            typeName = decl.name.text
        } else if let decl = declaration.as(EnumDeclSyntax.self) {
            typeName = decl.name.text
        } else if let decl = declaration.as(ActorDeclSyntax.self) {
            typeName = decl.name.text
        } else {
            typeName = nil
        }

        guard let typeName else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid type. @HelloWorlding can only be attached to a class, struct, enum, or actor.")
            ))
            return []
        }

        let friendClassDeclaration = """
               class \(typeName)Friend { }
               """

        return [DeclSyntax(stringLiteral: friendClassDeclaration)]
    }
}

@main
struct MakeAFriendPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MakeAFriendMacro.self,
    ]
}
