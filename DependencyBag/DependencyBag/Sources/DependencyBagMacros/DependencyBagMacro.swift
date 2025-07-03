import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DependencyBagMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard case .argumentList(let args) = node.arguments,
              args.count == 1,
              let expression = args.first?.expression
        else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid arguments, expected array of Any.Type.")
            ))
            return []
        }

        guard declaration.as(ClassDeclSyntax.self) != nil || declaration.as(StructDeclSyntax.self) != nil else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid target, can be applied only to Class or Struct")
            ))
            return []
        }

        guard let arrayElements = expression.as(ArrayExprSyntax.self)?.elements else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid argument, expected array.")
            ))
            return []
        }

        var argumentTypes = [String]()

        // Input type is constrained to be Any.Type by a Macro declaration, but this input could take two forms:
        // 1. The 'Type.self' format (like 'String.self') to get the metatype for a class
        // 2. A reference to a metatype (like 'let myClassMetatype = MyClass.self')
        // However, we only need to handle the first case. Swift Macros don't provide access to the underlying types of variables, so it is not possible to handle case 2 and it should be treated as a failure

        for elementSyntax in arrayElements {
            guard let memberAccessReferenceBase = elementSyntax.expression.as(MemberAccessExprSyntax.self)?.base else {
                context.diagnose(Diagnostic(
                    node: Syntax(declaration),
                    message: MacroExpansionErrorMessage("Invalid arguments, input should be an array of metatype references such as \"[String.self, Array<Int>.self]\"")
                ))
                return []
            }

            argumentTypes += [memberAccessReferenceBase.description]
        }

        var dependencyBagDeclarationLines = ["struct Dependencies {"]

        for argumentType in argumentTypes {
            // Lowercase the first letter of the argumentType to create the variable name
            let argumentType = argumentType.trimmingCharacters(in: .whitespacesAndNewlines)
            let argumentName = argumentType.prefix(1).lowercased() + argumentType.dropFirst()
            dependencyBagDeclarationLines += ["let \(argumentName): \(argumentType)"]
        }

        dependencyBagDeclarationLines += ["}"]

        return [DeclSyntax(stringLiteral: dependencyBagDeclarationLines.joined(separator: "\n"))]
    }
}

@main
struct DependencyBagPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DependencyBagMacro.self,
    ]
}
