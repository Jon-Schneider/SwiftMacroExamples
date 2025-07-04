import MakeAFriend

protocol NeedsFriend { }

@MakeAFriend
class MyClass: NeedsFriend { }

let myFriend = MyClassFriend()
