import Foundation
import Combine

class SignViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var isValid = false
    private let fetcher: IAccountFetcher
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(accountFetcher: IAccountFetcher) {
        fetcher = accountFetcher
        
        $userName
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .filter({ !$0.isEmpty })
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] value in
                self.validateUserName(value)
            })
            .store(in: &subscriptions)
    }
    
    private func validateUserName(_ userName: String) {        
        fetcher.validateUserName(userName: userName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                print("<<<DEV>>> Receive validation result in thread \(Thread.current) \(value)")
                
                self.isValid = value
            })
            .store(in: &subscriptions)
    }
}
