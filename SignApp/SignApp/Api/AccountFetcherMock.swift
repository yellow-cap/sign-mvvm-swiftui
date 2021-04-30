import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String )
}

class AccountFetcherMock: IAccountFetcher {
    func validateUserName(userName: String) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
            
            print("<<<DEV>>> Server name valiadtion \(userName) \(Thread.current)")
        }
    }
}
