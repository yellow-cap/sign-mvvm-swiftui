import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String)
}

class AccountFetcherMock: IAccountFetcher {
    func validateUserName(userName: String) {
        var result: Bool = false
        
        DispatchQueue.global().sync {
            sleep(5)
            result = ServerMock.validateUserName(userName)
        }
        
        
        print("<<<DEV>>> result \(result)")
    }
}
