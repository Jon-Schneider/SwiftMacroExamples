@attached(peer, names: suffixed(Friend))
public macro MakeAFriend() =
        #externalMacro(module: "MakeAFriendMacros", type: "MakeAFriendMacro")
