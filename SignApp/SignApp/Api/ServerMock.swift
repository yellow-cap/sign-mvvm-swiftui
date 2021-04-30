class ServerMock {
    static func validateUserName(_ userName: String) -> Bool {
        return userName.count > 5
    }
}
