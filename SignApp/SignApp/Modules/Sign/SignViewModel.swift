import Foundation
import Combine

class SignViewModel: ObservableObject {
    @Published var userName: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
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
        
        print("<<<DEV>>> \(userName)")
    }
}
