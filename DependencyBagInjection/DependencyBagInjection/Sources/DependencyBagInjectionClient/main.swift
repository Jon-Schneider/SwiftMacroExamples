import DependencyBagInjection

typealias ArgumentWithCustomName = String

@Dependencies([
        String.self,
        Int.self,
        ArgumentWithCustomName.self,
    ])
class MyClass { }

let myClassDependencies = MyClassDependencies(string: "String", int: 42, argumentWithCustomName: "typealias String")
let myClass = MyClass(dependencies: myClassDependencies)
