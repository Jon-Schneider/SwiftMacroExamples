import ClassExtension

public protocol Animal { }

@Pettable
class Alpaca: Animal { }
let myAlpaca = Alpaca()
myAlpaca.pet()
