import HelloWorld

@HelloWorlding
class MyClass { }

@HelloWorlding
struct MyStruct { }

@HelloWorlding
enum MyEnum { case `default` }

let myClass = MyClass()
myClass.sayHello()

let myStruct = MyStruct()
myStruct.sayHello()

let myEnum = MyEnum.default
myEnum.sayHello()
