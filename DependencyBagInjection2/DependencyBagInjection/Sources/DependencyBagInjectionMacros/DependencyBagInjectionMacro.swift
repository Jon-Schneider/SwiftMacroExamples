import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DependencyBagInjectionMacro: MemberMacro, PeerMacro {

    private enum DependencyBagInjectionMacroError: Error {
        case invalidAttachedType
        case invalidArgumentType
    }

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

        let typeName = try getAttachedTypeName(from: declaration, context: context)

        var dependencyConvenienceAccessors = [DeclSyntax]()
        let argumentTypes = try getArgumentTypes(from: declaration, expression: expression, context: context)
        for argumentType in argumentTypes {
            let argumentName = name(for: argumentType)
            dependencyConvenienceAccessors += [DeclSyntax(stringLiteral: "var \(argumentName): \(argumentType) { return dependencies.\(argumentName) }")]
        }

        return [
            DeclSyntax(stringLiteral: "init(dependencies: \(typeName)Dependencies) { self.dependencies = dependencies }"),
            DeclSyntax(stringLiteral: "let dependencies: \(typeName)Dependencies"),
        ] + dependencyConvenienceAccessors
    }

    // MARK: Peer Macro Implementations

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
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

        let typeName = try getAttachedTypeName(from: declaration, context: context)
        let argumentTypes = try getArgumentTypes(from: declaration, expression: expression, context: context)

        // Input type is constrained to be Any.Type by a Macro declaration, but this input could take two forms:
        // 1. The 'Type.self' format (like 'String.self') to get the metatype for a class
        // 2. A reference to a metatype (like 'let myClassMetatype = MyClass.self')
        // However, we only need to handle the first case. Swift Macros don't provide access to the underlying types of variables, so it is not possible to handle case 2 and it should be treated as a failure


        var dependencyBagDeclarationLines = ["struct \(typeName)Dependencies {"]

        for argumentType in argumentTypes {
            // Lowercase the first letter of the argumentType to create the variable name
            dependencyBagDeclarationLines += ["let \(name(for: argumentType)): \(argumentType)"]
        }

        dependencyBagDeclarationLines += ["}"]

        return [DeclSyntax(stringLiteral: dependencyBagDeclarationLines.joined(separator: "\n"))]
    }

    // MARK: Private

    private static func getAttachedTypeName(from declaration: some SyntaxProtocol, context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> String {

        if let decl = declaration.as(ClassDeclSyntax.self) {
            return decl.name.text
        } else if let decl = declaration.as(StructDeclSyntax.self) {
            return decl.name.text
        } else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid target, can be applied only to Class or Struct")
            ))
            throw DependencyBagInjectionMacroError.invalidAttachedType
        }
    }

    private static func getArgumentTypes(from declaration: some SyntaxProtocol, expression: ExprSyntax, context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [String] {
        guard let arrayElements = expression.as(ArrayExprSyntax.self)?.elements else {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: MacroExpansionErrorMessage("Invalid argument, expected array.")
            ))
            throw DependencyBagInjectionMacroError.invalidArgumentType
        }

        var argumentTypes = [String]()

        for elementSyntax in arrayElements {
            guard let memberAccessReferenceBase = elementSyntax.expression.as(MemberAccessExprSyntax.self)?.base else {
                context.diagnose(Diagnostic(
                    node: Syntax(declaration),
                    message: MacroExpansionErrorMessage("Invalid arguments, input should be an array of metatype references such as \"[String.self, Array<Int>.self]\"")
                ))
                throw DependencyBagInjectionMacroError.invalidArgumentType
            }

            argumentTypes += [memberAccessReferenceBase.description.trimmingCharacters(in: .whitespacesAndNewlines)]
        }

        return argumentTypes
    }

    private static func name(for argumentType: String) -> String {
        return argumentType.prefix(1).lowercased() + argumentType.dropFirst()
    }
}

@main
struct DependencyBagInjectionPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DependencyBagInjectionMacro.self,
    ]
}
