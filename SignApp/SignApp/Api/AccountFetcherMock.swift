import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String ) -> Future<Bool, Never>
}

class AccountFetcherMock: IAccountFetcher {
    func validateUserName(userName: String) -> Future<Bool, Never> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                print("<<<DEV>>> Run validation in thread \(Thread.current)")
                promise(.success(ServerMock.validateUserName(userName)))
            }
        }
    }
}
