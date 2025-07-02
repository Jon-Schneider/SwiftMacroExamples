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
        switch node.arguments {
        case .argumentList(let labeledExprListSyntax):
            guard labeledExprListSyntax.count == 1, let firstArgumentExprListSyntax = labeledExprListSyntax.first else {
                context.diagnose(Diagnostic(
                    node: Syntax(declaration),
                    message: MacroExpansionErrorMessage("Invalid arguments, only one argument should be passed.")
                ))
                return []
            }

            guard let stringLiteralSegmentListSyntax = firstArgumentExprListSyntax.expression.as(StringLiteralExprSyntax.self) else {
                context.diagnose(Diagnostic(
                    node: Syntax(declaration),
                    message: MacroExpansionErrorMessage("Unexpected argument type, expected String argument")
                ))
                return []
            }

            guard let firstSegment = stringLiteralSegmentListSyntax.segments.first?.cast(StringSegmentSyntax.self) else {
                context.diagnose(Diagnostic(
                    node: Syntax(declaration),
                    message: MacroExpansionErrorMessage("Unexpected argument type, expected String argument")
                ))
                return []
            }

            let sayHelloMethod = """
                   func sayHello() {
                       print("Hello, \(firstSegment.content.text)!")
                   }
                   """

            return [DeclSyntax(stringLiteral: sayHelloMethod)]
        case .none:
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Missing arguments")
            ))

            return []
        default:
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid argument(s)")
            ))

            return []
        }
    }
}

@main
struct HelloArgumentPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HelloArgumentMacro.self,
    ]
}
