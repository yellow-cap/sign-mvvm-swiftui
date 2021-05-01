import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String ) -> Future<Bool, Never>
}

class AccountFetcherMock: IAccountFetcher {
    func validateUserName(userName: String) -> Future<Bool, Never> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                promise(.success(ServerMock.validateUserName(userName)))
            }
        }
    }
}
