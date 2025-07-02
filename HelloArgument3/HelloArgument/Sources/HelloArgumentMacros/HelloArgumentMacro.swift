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
                message: MacroExpansionErrorMessage("Invalid arguments, expected array of Strings.")
            ))
            return []
        }


        guard let arrayElements = expression.as(ArrayExprSyntax.self)?.elements else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid arguments, expected array of Strings.")
            ))
            return []
        }

        var argumentStrings = [String]()

        for elementSyntax in arrayElements {
            guard let stringLiteralSyntax = elementSyntax.expression.as(StringLiteralExprSyntax.self) else {
                context.diagnose(Diagnostic(
                    node: Syntax(declaration),
                    message: MacroExpansionErrorMessage("Invalid arguments, expected array of Strings.")
                ))
                return []
            }

            if let firstSegment = stringLiteralSyntax.segments.first?.cast(StringSegmentSyntax.self) {
                argumentStrings.append(firstSegment.content.text)
            }
        }

        let sayHelloMethod = """
               func sayHello() {
                   print("Hello \(argumentStrings.joined(separator: ", "))!")
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
