class ServerMock {
    private static let minimumUserNameLengh = 5
    static func validateUserName(_ userName: String) -> Bool {
        return userName.count >= minimumUserNameLengh
    }
}
