import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MakeAFriendMacro: PeerMacro {
    enum MakeAFriendMacroError: Error {
        case invalidType
        case missingInheritance
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid type. @MakeAFriend can only be attached to a class")
            ))
            throw MakeAFriendMacroError.invalidType
        }
        let typeName = classDecl.name.text

        guard let inheritanceClause = classDecl.inheritanceClause else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("@MakeAFriend can only be applied to classes that inherit from LonelySuperclass.")
            ))
            throw MakeAFriendMacroError.missingInheritance
        }

        let inheritsFromLonelySuperclass = inheritanceClause.inheritedTypes.contains { inheritedType in
            inheritedType.type.trimmedDescription == "LonelySuperclass"
        }
        
        guard inheritsFromLonelySuperclass else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("@MakeAFriend can only be applied to subclasses of LonelySuperclass.")
            ))
            throw MakeAFriendMacroError.missingInheritance
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
