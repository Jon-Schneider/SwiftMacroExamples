import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MakeAFriendMacro: PeerMacro {
    enum MakeAFriendMacroError: Error {
        case invalidType
        case missingConformance
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declInfo: (typeName: String, inheritanceClause: InheritanceClauseSyntax?)? = {
            if let decl = declaration.as(ClassDeclSyntax.self) {
                return (decl.name.text, decl.inheritanceClause)
            } else if let decl = declaration.as(StructDeclSyntax.self) {
                return (decl.name.text, decl.inheritanceClause)
            } else if let decl = declaration.as(EnumDeclSyntax.self) {
                return (decl.name.text, decl.inheritanceClause)
            } else {
                return nil
            }
        }()

        guard let declInfo else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("@MakeAFriend can only be used on a class, struct, or enum.")
            ))
            throw MakeAFriendMacroError.invalidType
        }

        guard let inheritanceClause = declInfo.inheritanceClause else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("@MakeAFriend can only be used on types that conform to NeedsFriend.")
            ))
            throw MakeAFriendMacroError.missingConformance
        }

        let conformsToNeedsFriend = inheritanceClause.inheritedTypes.contains { inheritedType in
            inheritedType.type.trimmedDescription == "NeedsFriend"
        }

        guard conformsToNeedsFriend else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("@MakeAFriend can only be used on types that conform to NeedsFriend.")
            ))
            return []
        }

        let friendClassDeclaration = """
               class \(declInfo.typeName)Friend { }
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
