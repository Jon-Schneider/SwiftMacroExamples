import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct HelloWorldMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            DeclSyntax(stringLiteral: "func sayHello() { print(\"Hello, world!\") }")
        ]
    }
}

@main
struct HelloWorldPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HelloWorldMacro.self,
    ]
}
