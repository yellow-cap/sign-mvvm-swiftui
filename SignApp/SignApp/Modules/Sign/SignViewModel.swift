import Foundation
import Combine

class SignViewModel: ObservableObject {
    @Published var userName: String = ""
    private let fetcher: IAccountFetcher
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(accountFetcher: IAccountFetcher) {
        fetcher = accountFetcher
        
        $userName
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] userName in
                self.validateUserName(userName)
            })
            .store(in: &subscriptions)
    }
    
    private func validateUserName(_ userName: String) {
        guard !userName.isEmpty else { return }
        
        fetcher.validateUserName(userName: userName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                print("<<<DEV>>> Receive validation result in thread \(Thread.current) \(value)")
            })
            .store(in: &subscriptions)
    }
}
