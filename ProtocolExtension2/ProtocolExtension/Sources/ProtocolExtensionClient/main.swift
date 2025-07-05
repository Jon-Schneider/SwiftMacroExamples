import ProtocolExtension

public protocol Fluffy { }

@Pettable
public protocol Animal { }

class Alpaca: Animal, Fluffy { }
class FuzzyCacutus: Fluffy { }

let myAlpaca = Alpaca()
myAlpaca.pet()

let fuzzyCactus = FuzzyCacutus()
// fuzzyCactus.pet() // This does not work
