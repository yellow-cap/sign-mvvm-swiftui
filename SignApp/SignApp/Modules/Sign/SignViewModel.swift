import Foundation
import Combine

class SignViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var areUserCredentialsValid = false
    
    @Published private var isUserNameValid = false
    @Published private var isPasswordValid = false
    @Published private var arePasswordsEqual = false
    
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
        
        $password
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .filter({ !$0.isEmpty })
            .map({ [unowned self] in
                print("<<<DEV>>> isPasswordValid \(isPasswordValid($0))")
                return self.isPasswordValid($0)
            })
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &subscriptions)
        
        $confirmPassword
            
            .filter({ !$0.isEmpty })
            .map({ [unowned self] in
                print("<<<DEV>>> arePasswordsEqual \(arePasswordsEqual($0))")
                
                return self.arePasswordsEqual($0)
            })
            .assign(to: \.arePasswordsEqual, on: self)
            .store(in: &subscriptions)
    }
    
    private func validateUserName(_ userName: String) {        
        fetcher.validateUserName(userName: userName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                print("<<<DEV>>> Receive validation result in thread \(Thread.current) \(value)")
                
                self.isUserNameValid = value
            })
            .store(in: &subscriptions)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count > 8
            // && password != "admin" TODO[ARTEM]: Remove unnecessary checks
            // && password != "password"
    }
    
    private func arePasswordsEqual(_ password: String) -> Bool {
        return password == self.password
    }
}
