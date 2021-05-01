import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String ) -> Future<Bool, Never>
}

class AccountFetcherMock: IAccountFetcher {
    private let delay = 5
    
    func validateUserName(userName: String) -> Future<Bool, Never> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(delay)) {
                promise(.success(ServerMock.validateUserName(userName)))
            }
        }
    }
}
