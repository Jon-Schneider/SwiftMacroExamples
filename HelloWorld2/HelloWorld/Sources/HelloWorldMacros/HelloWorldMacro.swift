import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct HelloWorldMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Check that this macro is attached to a class
        guard let classDecl = declaration as? ClassDeclSyntax else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid type. @HelloWorlding can only be attached to a class")
            ))
            return []
        }

        let className = classDecl.name.text
        let sayHelloMethod = """
               func sayHello() {
                   print("Hello, \(className)!")
               }
               """

        return [DeclSyntax(stringLiteral: sayHelloMethod)]
    }
}

@main
struct HelloWorldPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HelloWorldMacro.self,
    ]
}
