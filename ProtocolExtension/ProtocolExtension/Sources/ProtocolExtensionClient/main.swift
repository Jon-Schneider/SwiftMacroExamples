import ProtocolExtension

public protocol Animal { }

@Pettable
public protocol Fluffy: Animal {
    func pet()
}

class Alpaca: Fluffy { }

let myAlpaca = Alpaca()
myAlpaca.pet()
