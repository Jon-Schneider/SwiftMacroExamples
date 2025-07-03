import MemberwiseInitializer

typealias ArgumentWithCustomName = String

@MemberwiseInitializer([
        String.self,
        Int.self,
        ArgumentWithCustomName.self,
    ])
class MyClass { }

let myClass = MyClass(string: "String", int: 42, argumentWithCustomName: "typealias String")
