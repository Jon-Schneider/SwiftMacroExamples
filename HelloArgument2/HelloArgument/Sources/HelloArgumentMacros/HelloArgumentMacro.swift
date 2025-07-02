import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct HelloArgumentMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard case .argumentList(let args) = node.arguments,
              args.count == 1,
              let expression = args.first?.expression
        else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid arguments, only one argument should be passed.")
            ))
            return []
        }

        // Input type is constrained to be Any.Type by a Macro declaration, but this input could take two forms:
        // 1. The 'Type.self' format (like 'String.self') to get the metatype for a class
        // 2. A reference to a metatype (like 'let myClassMetatype = MyClass.self')
        // However, we only need to handle the first case. Swift Macros don't provide access to the underlying types of variables, so it is not possible to handle case 2 and it should be treated as a failure

        guard let memberAccessReferenceBase = expression.as(MemberAccessExprSyntax.self)?.base else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid arguments, input should be a direct metatype reference such as \"String.self\"")
            ))
            return []
        }

        let sayHelloMethod = """
               func sayHello() {
                   print("Hello, \(memberAccessReferenceBase.description)!")
               }
               """

        return [DeclSyntax(stringLiteral: sayHelloMethod)]
    }
}

@main
struct HelloArgumentPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HelloArgumentMacro.self,
    ]
}
