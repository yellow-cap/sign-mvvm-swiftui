import Foundation
import Combine

protocol IAccountFetcher {
    func validateUserName(userName: String ) -> Future<Bool, Never>
}

class AccountFetcherMock: IAccountFetcher {
    private let networkDelayInSeconds = 1
    
    func validateUserName(userName: String) -> Future<Bool, Never> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(self.networkDelayInSeconds)) {
                promise(.success(ServerMock.validateUserName(userName)))
            }
        }
    }
}
