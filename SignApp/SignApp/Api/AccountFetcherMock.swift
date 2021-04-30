import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String )
}

class AccountFetcherMock: IAccountFetcher {
    private let delay = 5
    
    func validateUserName(userName: String) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(delay)) {
            
            DispatchQueue.main.async {
                print("<<<DEV>>> Server name valiadtion \(userName)")
            }
        }
    }
}
