import DependencyBag

typealias ArgumentWithCustomName = String

@Dependencies([
        String.self,
        Int.self,
        ArgumentWithCustomName.self,
    ])
class MyClass { }

let myClassDependencies = MyClass.Dependencies(
    string: "String",
    int: 1,
    argumentWithCustomName: "String 2"
)
