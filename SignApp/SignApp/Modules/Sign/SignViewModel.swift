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
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] value in
                self.isUserNameValid = false
                self.validateUserName(value)
            })
            .store(in: &subscriptions)
        
        $password
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({ [unowned self] in
                // print("<<<DEV>>> isPasswordValid \(isPasswordValid($0))")
                return self.isPasswordValid($0)
            })
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &subscriptions)
        
        $confirmPassword.combineLatest($password)
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .map({ combinedValue in
                return combinedValue.0 == combinedValue.1
            })
            .removeDuplicates()
            .assign(to: \.arePasswordsEqual, on: self)
            .store(in: &subscriptions)
        
        $isUserNameValid.combineLatest($isPasswordValid, $arePasswordsEqual)
            .map({ combinedValue in
                // print("<<<DEV>>> isUserNameValid = \(combinedValue.0)")
                // print("<<<DEV>>> isPasswordValid = \(combinedValue.1)")
                // print("<<<DEV>>> arePasswordsEqual = \(combinedValue.2)")
                return combinedValue.0 && combinedValue.1 && combinedValue.2
                
            })
            .removeDuplicates()
            .assign(to: \.areUserCredentialsValid, on: self)
            .store(in: &subscriptions)
    }
    
    private func validateUserName(_ userName: String) {
        guard !userName.isEmpty else {
            self.isUserNameValid = false
            
            return
        }
        
        fetcher.validateUserName(userName: userName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                // print("<<<DEV>>> Receive validation result in thread \(Thread.current) \(value)")
                
                self.isUserNameValid = value
            })
            .store(in: &subscriptions)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count > 8
            // && password != "admin" TODO[ARTEM]: Remove unnecessary checks
            // && password != "password"
    }
}
